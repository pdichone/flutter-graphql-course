const mongoose = require("mongoose");
const MSchema = mongoose.Schema;

const userSchema = MSchema({
  name: String,
  age: Number,
  profession: String,
});
module.exports = mongoose.model("User", userSchema);
