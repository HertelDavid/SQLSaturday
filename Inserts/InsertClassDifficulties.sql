
CREATE PROCEDURE insertClassDifficulties
  AS
  BEGIN

    INSERT INTO ClassDifficulty VALUES ('Non-Technical');
    INSERT INTO ClassDifficulty VALUES ('Beginner');
    INSERT INTO ClassDifficulty VALUES ('Intermediate');
    INSERT INTO ClassDifficulty VALUES ('Advanced');
  END