const { MeetingPayloadEnum } = require("./meeting-payload.enum");
const meetingServices = require("../services/meeting.service");
const { meetingUser } = require("../models/meeting-user.model");

async function joinMeeting(meetingId, socket, meetingServer, payload) {
  const { userId, name } = payload.data;
  await meetingServices.isMeetingPresent(meetingId, async (err, results) => {
    if (err && !results) {
      sendMessage(socket, { type: MeetingPayloadEnum.NOT_FOUND });
    }
    if (results) {
      addUser(socket, { meetingId, userId, name }).then(
        (results) => {
          if (results) {
            sendMessage(socket, {
              type: MeetingPayloadEnum.JOINED_MEETING,
              data: {
                userId,
              },
            });
            // nOt
            broadcastUsers(meetingId, socket, meetingServer, {
              type: MeetingPayloadEnum.USER_JOINED,
              data: {
                userId,
                name,
                ...payload.data,
              },
            });
          }
        },
        (err) => {
          console.log(err);
        }
      );
    }
  });
}

function forwardConnectionRequest(meetingId, socket, meetingServer, payload) {
  const { userId, otherUserId, name } = payload.data;

  var model = {
    meetingId: meetingId,
    userId: otherUserId,
  };

  meetingServices.getMeetingUsers(model, (err, results) => {
    if (results) {
      var sendPayload = JSON.stringify({
        type: MeetingPayloadEnum.CONNECTION_REQUEST,
        data: {
          userId,
          name,
          ...payload.data,
        },
      });
      meetingServer.to(results.socketId).emit("message", sendPayload);
    }
  });
}

function forwardIceCandidate(meetingId, socket, meetingServer, payload) {
  const { userId, otherUserId, candidate } = payload.data;

  var model = {
    meetingId: meetingId,
    userId: otherUserId,
  };

  meetingServices.getMeetingUsers(model, (err, results) => {
    if (results) {
      var sendPayload = JSON.stringify({
        type: MeetingPayloadEnum.ICECANDIDATE,
        data: {
          userId,
          candidate,
        },
      });
      meetingServer.to(results.socketId).emit("message", sendPayload);
    }
  });
}

function forwardOfferSDP(meetingId, socket, meetingServer, payload) {
  const { userId, otherUserId, sdp } = payload.data;

  var model = {
    meetingId: meetingId,
    userId: otherUserId,
  };

  meetingServices.getMeetingUsers(model, (err, results) => {
    if (results) {
      var sendPayload = JSON.stringify({
        type: MeetingPayloadEnum.ICECANDIDATE,
        data: {
          userId,
         sdp
        },
      });
      meetingServer.to(results.socketId).emit("message", sendPayload);
    }
  });
}


function forwardAnswerSDP(meetingId, socket, meetingServer, payload) {
  const { userId, otherUserId, sdp } = payload.data;

  var model = {
    meetingId: meetingId,
    userId: otherUserId,
  };

  meetingServices.getMeetingUsers(model, (err, results) => {
    if (results) {
      var sendPayload = JSON.stringify({
        type: MeetingPayloadEnum.ANSWER_SDP,
        data: {
          userId,
         sdp
        },
      });
      meetingServer.to(results.socketId).emit("message", sendPayload);
    }
  });
}

function userLeft(meetingId, socket, meetingServer, payload) {
  const { userId } = payload.data;
  broadcastUsers(meetingId, socket, meetingServer, {
    type: MeetingPayloadEnum.USER_LEFT,
    data: {
      userId,
    },
  })
}

function endMeeting(meetingId, socket, meetingServer, payload) {
  const { userId } = payload.data;
  broadcastUsers(meetingId, socket, meetingServer, {
    type: MeetingPayloadEnum.END_MEETING,
    data: {
      userId : userId,
    },
  })
  meetingServices.getAllMeetingUsers(meetingId, (err, results) => {
    for (let i = 0; i < results.length; i++) {
      const meetingUser = results[i];
      meetingServer.sockets.connected[meetingUser.socketId].disconnect();
    }
  })
}

function forwardEvent(meetingId, socket, meetingServer, payload) {
  const { userId } = payload.data;
  broadcastUsers(meetingId, socket, meetingServer, {
    type: payload.type,
    data: {
      userId: userId,
      ...payload.data
    },
  })

}

function addUser(socket, { meetingId, userId, name }) {
  let promise = new Promise((resolve, reject) => {
    meetingServices.getMeetingUsers(
      { meetingId, userId },
      async (err, results) => {
        if (!results) {
          var model = {
            socketId: socket.id,
            meetingId,
            userId: userId,
            joined: true,
            name: name,
            isAlive: true,
          };

          meetingServices.joinMeeting(model, async (err, results) => {
            if (results) {
              resolve(results);
            }
            if (err) {
              reject(err);
            }
          });
        } else {
          meetingServices.updateMeetingUsers(
            {
              userId: userId,
              socketId: socket.id,
            },
            (err, results) => {
              if (results) {
                resolve(results);
              }
              if (err) {
                reject(err);
              }
            }
          );
        }
      }
    );
  });
  return promise;
}

function sendMessage(socket, payload) {
  socket.send(JSON.stringify(payload));
}

function broadcastUsers(meetingId, socket, meetingServer, payload) {
  socket.broadcast.emit("message", JSON.stringify(payload));
}



module.exports = {
  joinMeeting,
  forwardConnectionRequest,
  forwardIceCandidate,
  forwardOfferSDP,
  forwardAnswerSDP,
  forwardEvent,
  userLeft,
    endMeeting,
};