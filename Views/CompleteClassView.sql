
CREATE VIEW CompleteClassView
  AS select distinct eventSchedule, Person.firstName, Person.lastName, Presentation.title, Presentation.location, Room.roomNumber, TimeSlot.timeStart
    FROM PersonPresentationTimeMapping
    inner join Person on Person.idPerson=PersonPresentationTimeMapping.idPerson
    inner join Presentation on Presentation.idPresentation=PersonPresentationTimeMapping.idPresentation
    inner join TimeSlot on TimeSlot.idTimeSlot=PersonPresentationTimeMapping.idTimeSlot
    inner join Room on Room.idRoom=PersonPresentationTimeMapping.idRoom;