'use strict';

var mongoose = require('bluebird').promisifyAll(require('mongoose'));
var Schema = mongoose.Schema;

var BeerSchema = new Schema({
  name: String,
  movies: Array,
  active: Boolean,
  beerId: String,
  img: String,
  desc: String
});

module.exports = mongoose.model('Beer', BeerSchema);