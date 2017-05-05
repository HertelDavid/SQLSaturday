
ALTER PROC insertPresentation @speaker VARCHAR(255), @presentation VARCHAR(255)
  AS
  BEGIN
    BEGIN TRY

      DECLARE @count integer = 1,
              @name varchar(255) = (SELECT RTRIM(@speaker)),
              @firstName varchar(255) = '',
              @lastName varchar(255) = '',
              @valid bit = 0;


      WHILE @count <= (SELECT LEN(@name))
      BEGIN

        IF (SELECT SUBSTRING(@name, @count, 1)) = ' '
          BEGIN

            SET @firstName = (SELECT SUBSTRING(@name, 0, @count));
            SET @lastName = (SELECT SUBSTRING(@name, @count + 1, (SELECT LEN(@name))));
            SET @valid = 1;
          END

        SET @count = @count + 1;
      END

      IF @valid = 0
          RAISERROR('ERROR (insertPresentation): Speaker needs a first name and last name.', 1, 1);
      ELSE
        BEGIN

          -- If there is a first name and last name

          select @firstName;
          select @lastName;

          IF EXISTS (SELECT * FROM Person WHERE firstName=@firstName AND lastName=@lastName)
            BEGIN

              -- If the person exists.

              DECLARE @idPerson integer = (SELECT idPerson FROM Person WHERE firstName=@firstName AND lastName=@lastName);

              IF EXISTS (SELECT idRole FROM PersonRolesMapping WHERE idPerson=@idPerson AND idRole=(SELECT idRole FROM Roles WHERE title='Presenter'))
                BEGIN

                  -- If the person is a presenter.

                  IF EXISTS (SELECT idPresentation FROM Presentation WHERE title=@presentation)
                    BEGIN

                      -- If the presentation exists.

                      DECLARE @idPresentation integer = (SELECT idPresentation FROM Presentation WHERE title=@presentation
                                                        intersect
                                                        SELECT idPresentation FROM PresenterPresentationMapping WHERE idPresenter = (SELECT idPerson FROM Person WHERE firstName=@firstName AND lastName=@lastName));

                      EXEC insertPresentationIntoSchedule @idPerson, @idPresentation;

                    END
                END
              ELSE
                RAISERROR('ERROR (insertPresentation): The person specified is not a presenter', 1, 1);
            END
          ELSE
            RAISERROR('ERROR (insertPresentation): Speaker has not been inserted into the Persons table', 1, 1);
        END
    END TRY
    BEGIN CATCH
      SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
  END