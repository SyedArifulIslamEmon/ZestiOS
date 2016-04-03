var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var TodoSchema = new Schema({
    first_name: String,
    last_name: String,
    email: String,
    password: String
});

mongoose.model('employees', TodoSchema);