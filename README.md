pontifex.ws
===========

A WebSocket to AMQP Bridge

Getting Started
---------------

To run the websocket bridge:

	./bin/pontifex 'ws://localhost:8888/' 'amqp://guest:guest@localhost:5672/'

You can then issue commands:

	$ wscat --connect ws://localhost:8888/
	connected (press CTRL+C to quit)
	> [ "post", "/redis-out/#/ws" ]
	< ["ok","/redis-out/#/ws"]
	> [ "get", "/ws" ]
	< ["ok","/ws"]
	< ["ok","Hi Dave!"]
	> [ "put", "/redis-in/test", "set", "hello", "hello from websockets" ]
	< ["ok","/redis-in/test"]
	< ["ok","OK"]
	> [ "put", "/redis-in/test", "get", "hello" ]
	< ["ok","/redis-in/test"]
	< ["ok","hello from websockets"]

The commands take the format of

	post /exchange/key/queue	-> bind a queue to an exchange with routing key
	put /exchange/key message...	-> send the message to an exchange with routing key
	get /queue			-> subscribe to a queue
	delete /queue			-> destroy the queue and any pending messages

