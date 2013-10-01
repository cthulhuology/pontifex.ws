# Pontifex.WebSocket.coffee
#

ws = require 'ws'

PontifexWebSocket = (Bridge,Url) =>
	self = this
	[ proto, host, port ] = Url.match(///([^:]+)://([^:]+):(\d+)///)[1...]
	self.server = new ws.Server port: port, host: host
	self.server.on 'connection', (socket) ->
		socket.on "message", (message) ->
			try
				json = JSON.parse(message)
				self[json[0]]?.apply(self,[socket].concat(json[1...]))
			catch error
				console.log error
	self.post = (socket,resource) ->
		[ exchange, key, queue ] = resource.match(////([^\/]+)/([^\/]+)/([^\/]+)///)[1...]
		console.log "Creating #{exchange}/#{key} -> #{queue }"
		self.exchange = exchange
		self.key = key
		Bridge.create exchange, key, queue
		socket.send JSON.stringify([ "ok", resource ])
	self.get = (socket,resource) ->
		[ queue ] = resource.match(////([^\/]+)///)[1...]
		console.log "Subscribing #{queue }"
		self.queue = queue
		Bridge.subscribe queue, (data) ->
			console.log "Got #{data}"
			socket.send(data)
		socket.send JSON.stringify([ "ok", resource ])
	self.put = (socket,resource, message...) ->
		[ exchange, key ] = resource.match(////([^\/]+)/([^\/]+)///)[1...]
		console.log "Sending #{message} to #{exchange}/#{key}"
		Bridge.update exchange, key, JSON.stringify(message)
		socket.send JSON.stringify([ "ok", resource ])
	self.delete = (socket,resource) ->
		[ queue ] = resource.match(////([^\/]+)///)[1...]
		console.log "Deleting #{queue}"
		Bridge.delete queue
		socket.send JSON.stringify([ "ok", resource ])
	self["*"] = (socket,message...) ->
		Bridge.update self.exchange, self.key, JSON.stringify(message)
	self

module.exports = PontifexWebSocket
