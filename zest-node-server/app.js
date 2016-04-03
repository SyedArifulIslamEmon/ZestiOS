/**
 * Module dependencies.
 */

var express = require('express'),
    // bodyParser = require('body-parser'),
    mongoose = require('mongoose'),
    http = require('http'),
    path = require('path'),
    todoModel = require('./models/todo'),
    todoRoute = require('./routes/todo');

var app = express();
app.get('/', function(req, res) {
    res.send('hello world');
})

var request = require('request');
var moltin = require('moltin')({
    publicId: 'aqA2mV2YKWpmu4daVS7Fh2WbWLH0xe1f2i9hHrkR',
    secretKey: 'pTpw0mvDSyOpCw4HyZbPUFqxA441xRC5gYrSRbfj',
});

moltin.Authenticate(function() {
    console.log("Authenticated");
    moltin.Customer.Find({ "email": "andy.roddick@gmail.com" }, function (customer) {
        console.log("Found Customer:", customer);
    }, function (err) {
        console.log("Error:", err);
    });
});


app.configure(function() {
    app.set('port', process.env.PORT || 3000);
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
});

app.configure('development', function() {
    app.use(express.errorHandler());
});

var uriString =
    process.env.MONGOLAB_URI ||
    process.env.MONGOHQ_URL ||
    'mongodb://localhost/HelloMongoose';

mongoose.connect('mongodb://kelin:winter2016@ds057954.mongolab.com:57954/alamofire-datab');

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function callback() {
    console.log('Successfully mongodb is connected');
});

app.get('/todo', todoRoute.index);
app.get('/todo/:id', todoRoute.findById);
app.put('/todo/:id', todoRoute.update);
app.delete('/todo/:id', todoRoute.delete)
app.post('/todo', todoRoute.newTodo);


http.createServer(app).listen(app.get('port'), function() {
    console.log("Express server listening on port " + app.get('port'));
});