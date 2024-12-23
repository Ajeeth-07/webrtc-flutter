const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const meeting = mongoose.model(
  "Meeting",
  mongoose.Schema(
    {
      hostId: {
        type: String,
        required: false,
      },
      hostName: {
        type: String,
        required: false,
      },
      startTime: {
        type: Date,
        required: true,
      },
      meetingUsers: [
        {
          type: mongoose.Schema.Types.ObjectId,
          ref: "MeetingUser",
        },
      ],
    },
    {
      toJSON: {
        transform: function (doc, ret) {
          ret.id = ret._id;
          delete ret._id;
          delete ret.__v;
        },
      },
    },
    {
      timestamps: true,
    }
  )
);

module.exports = { meeting };
