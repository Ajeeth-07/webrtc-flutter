const MONGO_DB_CONFIG =  {
  DB: process.env.MONGO_DB || 'mongodb://localhost:27017/express-mongo',
}


module.exports = {
  MONGO_DB_CONFIG
};