# WebSocket.coffee
#

ws = require 'ws'

WebSocket = (Bridge,Url) =>
	self = this
	[ proto, host, port] = Url.match(///([^:]+)://([^:]+):(\d+)///)[1...]
	self.server = new ws.Server port: port, host: host
	self.server.on 'connection', (socket) ->
		url = socket.upgradeReq.url
		[ domain, exchange, key, queue, dest, path ] = url.replace("%23","#").replace("%2a","*").
			match(////([^\/]*)/([^\/]*)/([^\/]*)/([^\/]*)/([^\/]*)/([^\/]*)///)[1...]
		dest ?= exchange
		path ?= key
		socket.on "message", (message) ->
			try
				json = JSON.parse(message)
				self[json[0]]?.apply(self,[socket].concat(json[1...]))
				if not self[json[0]]	# handle does not understand case
					self["*"]?.apply(self,[socket].concat(json))
			catch error
				console.log error
		socket.on "close", () ->
			Bridge.unsubscribe queue, socket
		Bridge.connect domain, () ->
			if exchange and key and queue
				Bridge.route exchange, key, queue
				Bridge.subscribe queue, socket, (data) ->
					socket.send data
		self["*"] = (socket,message...) ->
			Bridge.send dest, path, JSON.stringify(message)
	self

module.exports = WebSocket
