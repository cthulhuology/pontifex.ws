pontifex.ws
===========

A WebSocket to AMQP Bridge

Getting Started
---------------

To run the websocket bridge:

	pontifex 'ws://localhost:8888/' 'amqp://guest:guest@localhost:5672/'

This will map a websocket port to a amqp server in a 1-to-1 fashion.

You can then issue commands:

	wscat --connect ws://localhost:8888//pipe-out/%23/ws/pipe-in/ws
	connected (press CTRL+C to quit)
	> [ "say", "I like cheese!" ]
	< ["say","I like cheese!"]
	
Where the websocket connection's path defines a resource in the form:

	/<domain>/<source exchange>/<source key>/<source queue>/<destination exchange>/<destination key>

You can subscribe to just a queue, (creating the necessary binding

	/<domain>/<source exchange>/<source key>/<source queue>

And you can create a publish only websocket connection:

	/<exchange>/<key>


