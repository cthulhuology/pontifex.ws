# Pontifex.WebSocket.coffee
#

ws = require 'ws'

PontifexWebSocket = (Bridge,Url) =>
	self = this
	[ proto, host, port ] = Url.match(///([^:]+)://([^:]+):(\d+)///)[1...]
	self.server = new ws.Server port: port, host: host
	self.server.on 'connection', (socket) ->
		socket.on "message", (message) ->
			json = JSON.parse(message)
			self[json[0]]?.apply(self,[socket].concat(json[1...]))
	self.post = (socket,resource) ->
		[ exchange, key, queue ] = resource.match(////([^\/]+)/([^\/]+)/([^\/]+)///)[1...]
		Bridge.create exchange, key, queue
		socket.send JSON.stringify([ "ok", resource ])
	self.get = (socket,resource) ->
		[ queue ] = resource.match(////([^\/]+)///)[1...]
		Bridge.subscribe queue, (data) ->
			console.log "Got #{data}"
			socket.send(data)
		socket.send JSON.stringify([ "ok", resource ])
	self.put = (socket,resource, message...) ->
		[ exchange, key ] = resource.match(////([^\/]+)/([^\/]+)///)[1...]
		Bridge.update exchange, key, JSON.stringify(message)
		socket.send JSON.stringify([ "ok", resource ])
	self.delete = (socket,resource) ->
		[ queue ] = resource.match(////([^\/]+)///)[1...]
		Bridge.delete queue
		socket.send JSON.stringify([ "ok", resource ])
	self

module.exports = PontifexWebSocket
