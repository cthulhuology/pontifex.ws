pontifex.ws
===========

A WebSocket to AMQP Bridge

Getting Started
---------------

To run the websocket bridge:

	pontifex 'ws://localhost:8888/domain/exchange/key/queue/destination/path' 'amqp://guest:guest@localhost:5672/'

You can then issue commands:

	$ wscat --connect ws://localhost:8888/
	connected (press CTRL+C to quit)
	> [ "say", "I like cheese!" ]
	< ["say","I like cheese!"]
	



