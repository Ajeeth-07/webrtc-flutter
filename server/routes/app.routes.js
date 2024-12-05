const meetingController = require('../controllers/meeting.controller');
const router = require('express').Router();


router.post("/meeting/start", meetingController.startMeeting);
router.get("/meeting/join", meetingController.checkMeetingExists);
router.get("/meeting/get", meetingController.getAllMeetingUsers);


module.exports = router;