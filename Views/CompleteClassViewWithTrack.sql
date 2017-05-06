
CREATE VIEW CompleteClassViewWithTrack
  AS select Person.firstName, Person.lastName, Presentation.title, Presentation.location, Track.name, Room.roomNumber, TimeSlot.timeStart
            from (select PresenterPresentationMapping.idPresenter, idTrack, PresentationTrackMapping.idPresentation, idTimeSlot, eventSchedule, idRoom
                  from PresentationTrackMapping
                  inner join PersonPresentationTimeMapping on PersonPresentationTimeMapping.idPresentation = PresentationTrackMapping.idPresentation
                  inner join PresenterPresentationMapping on PresenterPresentationMapping.idPresentation = PersonPresentationTimeMapping.idPresentation) as Target
            inner join Person on Person.idPerson = Target.idPresenter
            inner join Presentation on Presentation.idPresentation = Target.idPresentation
            inner join Track on Track.idTrack = Target.idTrack
            inner join TimeSlot on TimeSlot.idTimeSlot = Target.idTimeSlot
            inner join Room on Room.idRoom = Target.idRoom;