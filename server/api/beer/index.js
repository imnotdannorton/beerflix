'use strict';

var express = require('express');
var BreweryDb = require('brewerydb-node');
var brewDb = new BreweryDb('5e877b7c53006f4976912686ee66e023');
var router = express.Router();
var controller = require('./beer.controller');


router.get('/:q', function(req, res){
	console.log(req.params.q);
	var query = '"'+req.params.q+'"'
	brewDb.search.beers({q:query}, function(err, data){
		res.status(200).json(data);
	});
});

router.post('/', controller.create);
router.post('/update', controller.update);
router.post('/delete', controller.destroy);

router.get('/', controller.index);
router.get('/find/:q', controller.findBeerByName);
router.get('/findbyid/:q', controller.findBeerById);
router.get('/fetchpair/:q', controller.findPairById);


function handleError(res, statusCode) {
  statusCode = statusCode || 500;
  return function(err) {
    res.status(statusCode).send(err);
  };
}

module.exports = router;
