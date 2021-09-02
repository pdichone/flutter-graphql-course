const mongoose = require("mongoose");
const MSchema = mongoose.Schema;

const postSchema = MSchema({
  comment: String,
  userId: String,
});

module.exports = mongoose.model("Post", postSchema);
