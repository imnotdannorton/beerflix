'use strict';

var _ = require('lodash');
var Beer = require('./beer.model');


function handleError(res, statusCode) {
  statusCode = statusCode || 500;
  return function(err) {
    res.status(statusCode).send(err);
  };
}
function responseWithResult(res, statusCode) {
  statusCode = statusCode || 200;
  return function(entity) {
    if (entity) {
      res.status(statusCode).json(entity);
    }
  };
}

function handleEntityNotFound(res) {
  return function(entity) {
    if (!entity) {
      res.status(404).end();
      return null;
    }
    return entity;
  };
}

function saveUpdates(updates) {
  return function(entity) {
    var updated = _.merge(entity, updates);
    return updated.saveAsync()
      .spread(function(updated) {
        return updated;
      });
  };
}

function removeEntity(res) {
  return function(entity) {
    if (entity) {
      return entity.removeAsync()
        .then(function() {
          res.status(204).end();
        });
    }
  };
}

exports.index = function(req, res){
	Beer.findAsync()
		.then(responseWithResult(res))
		.catch(handleError(res));
}
exports.create = function(req, res){
	Beer.createAsync(req.body)
		.then(responseWithResult(res, 201))
		.catch(handleError(res));
}
exports.findBeerByName = function(req, res){
	//Searches beer by name
	Beer.find({'name':new RegExp(req.params.q, 'i')})
	.then(responseWithResult(res))
		.catch(handleError(res));
}
exports.findBeerById = function(req, res){
	//Searches beer by name
	Beer.find({'beerId':new RegExp(req.params.q, 'i')})
	.then(responseWithResult(res))
		.catch(handleError(res));
}
exports.findPairById = function(req, res){
  //Searches beer by name
  Beer.find({'_id':req.params.q})
  .then(responseWithResult(res))
    .catch(handleError(res));
}
exports.update = function(req, res){
  console.log(req.body)
  Beer.findByIdAsync(req.body.id)
    .then(handleEntityNotFound(res))
    .then(saveUpdates(req.body))
    .then(responseWithResult(res))
    .catch(handleError(res));
}
exports.destroy = function(req, res){
	Beer.findByIdAsync(req.body.id)
		.then(handleEntityNotFound(res))
		.then(removeEntity(res))
		.catch(handleError(res));
}