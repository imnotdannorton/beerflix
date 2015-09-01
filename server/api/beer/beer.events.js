/**
 * Beer model events
 */

'use strict';

var EventEmitter = require('events').EventEmitter;
var Beer = require('./beer.model');
var BeerEvents = new EventEmitter();

// Set max event listeners (0 == unlimited)
BeerEvents.setMaxListeners(0);

// Model events
var events = {
  'save': 'save',
  'remove': 'remove'
};

// Register the event emitter to the model events
for (var e in events) {
  var event = events[e];
  Beer.schema.post(e, emitEvent(event));
}

function emitEvent(event) {
  return function(doc) {
    BeerEvents.emit(event + ':' + doc._id, doc);
    BeerEvents.emit(event, doc);
  }
}

module.exports = BeerEvents;
