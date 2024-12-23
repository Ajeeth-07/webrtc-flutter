const { meeting } = require("../models/meeting.model");
const { meetingUser } = require("../models/meeting-user.model");

async function getAllMeetingUsers(meetId, callback) {
  meetingUser
    .find({ meetingId: meetId })
    .then((response) => {
      return callback(null, response);
    })
    .catch((err) => {
      return callback(err, null);
    });
}

async function startMeeting(params, callback) {
  const meetingSchema = new meeting(params);
  meetingSchema
    .save()
    .then((response) => {
      return callback(null, response);
    })
    .catch((error) => {
      return callback(error);
    });
}

async function joinMeeting(params, callback) {
  const meetingUserModel = new meetingUser(params);
  meetingUserModel
    .save()
    .then(async (response) => {
      await meeting.findOneAndUpdate(
        { id: params.meetingId },
        { $addToSet: { meetingUsers: meetingUserModel } }
      );
      return callback(null, response);
    })
    .catch((err) => {
      return callback(err, null);
    });
}

async function isMeetingPresent(meetingId, callback) {
  meeting
    .findById(meetingId)
    .populate("meetingUsers", "MeetingUser")
    .then((response) => {
      if (!response) callback("Invalid Meeting Id");
      else callback(null, true);
    })
    .catch((errог) => {
      return callback(error, false);
    });
}

async function checkMeetingExists(meetingId, callback) {
  meeting
    .findById(meetingId,) // Space-separated string
    .populate("meetingUsers", "MeetingUser")
    .then((response) => {
      if (!response) callback("Invalid Meeting Id");
      else callback(null, response);
    })
    .catch((error) => {
      // Fixed typo from 'errог' to 'error'
      return callback(error, false);
    });
}

async function getMeetingUsers(params, callback) {
  const { meetingId, userId } = params;

  meetingUser
    .find({ meetingId, userId })
    .then((response) => {
      return callback(null, response[0]);
    })
    .catch((err) => {
      return callback(err, null);
    });
}

async function updateMeetingUsers(params, callback) {
  meetingUser
    .updateOne({ userId: params.userId }, { $set: params }, { new: true })
    .then((response) => {
      return callback(null, response);
    })
    .catch((err) => {
      return callback(err, null);
    });
}

async function getUserBySocketId(params, callback) {
  const { meetingId, socketId } = params;

  meetingUser
    .findOne({ meetingId, socketId })
    .limit(1)
    .then((response) => {
      return callback(null, response);
    })
    .catch((err) => {
      return callback(err, null);
    });
}

module.exports = {
  startMeeting,
  joinMeeting,
  isMeetingPresent,
  checkMeetingExists,
  getMeetingUsers,
  updateMeetingUsers,
  getUserBySocketId,
  getAllMeetingUsers,
};
