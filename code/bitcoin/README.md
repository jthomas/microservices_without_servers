# Bitcoin API Demo

This folder contains samples for creating an API which converts currency prices into Bitcoin.

The API uses event parameters to provide the amount and currency to convert into Bitcoin. An external JSON API is used to retrieve current Bitcoin conversion rates. This API can be exposed as a Web Action or using the API gateway integration.

The same serverless function has been implemented in both Node.js and Swift.

*There's a video recording for this demonstration available [here](https://youtu.be/QImNMGvD5xc).*

## Create Action

Create a new action called `bitcoin` using the `wsk` command-line tool. 

This action can use either the node.js (`conversion.js`) or swift (`conversion.swift`) source files. Both implementations use the same parameters and return identical responses. 

```
// node.js
$ wsk action create bitcoin conversion.js
ok: created action bitcoin
// swift
$ wsk action create bitcoin conversion.swift
ok: created action bitcoin
```

Looking at the deployed service list, we can see it has been registered.

```
$ wsk action list
actions
/user@email.com_dev/bitcoin                                   private <runtime>
```

## Invoke Action

The `bitcoin` action must be invoked with two parameters.

- `amount` - amount of currency to convert, e.g. *100, 10.25, 0.99*
- `currency` - three letter currency code for amount, e.g. *USD, EUR, GBP*

Using the `wsk` command-line tool, we can invoke the action with parameters using `-p` flags.

```
$ wsk action invoke bitcoin -r -p amount 1000 -p currency USD
{
    "amount": "0.233108",
    "label": "1000 USD is worth 0.233108 bitcoins."
}
```

*Using the `-r` flag ensures only the "result" of the execution, rather than the full activation record, is returned in the response.* 

## Create Web Action

Web actions are OpenWhisk actions that can be invoked using an **unauthenticated** HTTP request. This differs from the normal API for invoking actions, which requires authentication credentials. 

Setting a custom attribute (`web-export`) on the action will enable web action support.

Let's update the `bitcoin` action to turn it into a web action.

```
$ wsk action update bitcoin --web true
ok: updated action bitcoin
```

Using the command-line tool, we can now retrieve the public endpoint for our web action.

```
$ wsk action get bitcoin --url
ok: got action bitcoin
https://openwhisk.ng.bluemix.net/api/v1/web/user%40email.com_dev/default/bitcoin
```

Sending a HTTP request to this endpoint will invoke the action and return the response serialised to JSON. 

## Invoke Web Action

Let's test our new web action.

The httpie tool makes it easy to send HTTP requests from the command-line.

 ```
$ http get "https://openwhisk.ng.bluemix.net/api/v1/web/user%40email.com_dev/default/bitcoin.json?amount=1000&currency=USD"
HTTP/1.1 200 OK
...
{
    "amount": "0.235368",
    "label": "1000 USD is worth 0.235368 bitcoins."
}
 ```

*The `.json` extension is used on the web action endpoint to enforce JSON serialisation. Invocation parameters are provided as URL query parameters (`amount` & `currency`).*

Web actions are a great way to expose serverless functions as public HTTP endpoints. They are great for simple use-cases, e.g. listening to web hooks. 

Building more complex serverless APIs, you will need support for other features like rate limiting, custom authentication, CORS headers, etc. **Web actions do not support these features without the developer manually handling it in the code. **

However, no need to panic!

**OpenWhisk has an integrated API gateway to support these features…**

## API Gateway

The API Gateway can create public HTTP endpoints for your OpenWhisk actions. HTTP requests can be routed to different actions based upon the method and path of the request. Rate limiting, authentication, CORS and other API features are handled by the gateway, rather than the action code.

Let's turn on a sample API Gateway endpoint for the Bitcoin API…

**IMPORTANT: The API Gateway ONLY supports creating APIs for web actions. This attribute must be enabled on actions being exposed as APIs through the gateway.** 

The `wsk api` command is used to create, manage and remove APIs registered with the gateway. 

```
$ wsk api
work with APIs
Usage:
  wsk api [command]

Available Commands:
  create      create a new API
  get         get API details
  delete      delete an API
  list        list APIs

Flags:
  -h, --help   help for api

Global Flags:
      --apihost HOST         whisk API HOST
      --apiversion VERSION   whisk API VERSION
  -u, --auth KEY             authorization KEY
  -d, --debug                debug level output
  -i, --insecure             bypass certificate checking
  -v, --verbose              verbose output

Use "wsk api [command] --help" for more information about a command.
```

Creating a new API requires us to provide the HTTP operation, API path and web action name.

```
$ wsk api create /api/bitcoin GET bitcoin
ok: created API /api/bitcoin GET for action /_/bitcoin
https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/<uuid>/api/bitcoin
```

URLs returned refer to the public endpoint on the API Gateway.

```
$ http get "https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/<uuid>/api/bitcoin?currency=USD&amount=1000"
HTTP/1.1 200 OK
...
{
    "amount": "0.235033",
    "label": "1000 USD is worth 0.235033 bitcoins."
}
```

*JSON serialisation is automatic and does not require the path extension. Invocation parameters are provided as URL query parameters (`amount` & `currency`).*