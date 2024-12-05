const meetingServices = require("../services/meeting.service");

exports.startMeeting = (req, res, next) => {
  const { hostId, hostName } = req.body;

  var model = {
    hostId: hostId,
    hostName: hostName,
    startTime: Date.now(),
  };

  meetingServices.startMeeting(model, (err, results) => {
    if (err) {
      return next(err);
    }
    return res.status(200).send({ message: "success", data: results.id });
  });
};

exports.checkMeetingExists = (req, res, next) => {
  const { meetingId } = req.query;

  meetingServices.checkMeetingExists(meetingId, (err, results) => {
    if (err) {
      return next(err);
    }
    return res.status(200).send({ message: "success", data: results });
  });
};

exports.getAllMeetingUsers = (req, res, next) => {
  const { meetingId } = req.query;

  meetingServices.getAllMeetingUsers(meetingId, (err, results) => {
    if (err) {
      return next(err);
    }
    return res.status(200).send({ message: "success", data: results });
  });
};

