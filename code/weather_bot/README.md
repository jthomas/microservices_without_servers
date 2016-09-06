# Weather Bot Demo

This demonstration creates a bot for Slack that can help notify users with weather forecasts. Users can ask the bot for the forecast for a specific location by sending a chat message. The bot can also be configured to send the forecast for a location at regular intervals, e.g. everyday at 8am. 

This bot needs to perform a few functions, e.g. convert addresses to locations, retrieve weather forecasts for locations and integrate with Slack. Rather than implementing the bot as a monolithic application, containing logic for all these features, I want to go deploy it as seperate services. 

Later on, we'll look at using a neat feature of the platform (sequences) to bind them together to create our bot with writing any code. 

## Address To Locations Service

This service handles retrieving latitude and longitude coordinates for addresses using an external Geocoding API. 

```
$ cat location_to_latlong.js
var request = require('request');

function main(params) {
  var options = {
    url: "https://maps.googleapis.com/maps/api/geocode/json",
    qs: {address: params.address},
    json: true
  };

  return new Promise(function (resolve, reject) {
    request(options, function (err, resp) {
      if (err) {
       	console.log(err);
        return reject({err: err})
      }
      if (resp.body.status !== "OK") {
       	console.log(resp.body.status);
        return reject({err: resp.body.status})
      }

      resolve(resp.body.results[0].geometry.location);
    });
  });
};
```

This microservice implements the application logic within a single function (_main_) which is the interface used by OpenWhisk. Parameters are passed in as an object argument (_params_) to the function call. This service makes an API call to the Google Geocoding API, returning the results from API response for the first address match. 

Returning a Promise from the function means we can return the service response asychronously. 

Let's deploy this service and invoke it to verify it's working… 

```
$ wsk action create location_to_latlong location_to_latlong.js
ok: created action location_to_latlong
$ wsk action invoke location_to_latlong -b -r -p address "London"
{
    "lat": 51.5073509,
    "lng": -0.1277583
}
```

*The -r flag tells the command-line utility to only return the service result rather than the entire invocation JSON response. The -b flag blocks waiting for the service to finish rather than returning after the invocation starts.*

Great, that's working. We've deployed our first microservice without a server anywhere… 

Let's try the next one for finding forecasts for locations. 

## Forecast From Location Service

This service uses an external API to retrieve weather forecasts for locations, returning the text description for weather in the next twenty fours hours. 

_Provision a new instance for the [Weather Insights](https://new-console.ng.bluemix.net/catalog/services/weather-company-data/) service in IBM Bluemix to access these API credentials._

```
$ cat forecast_from_latlong.js
var request = require('request');

function main(params) {
  if (!params.lat) return Promise.reject("Missing latitude");
  if (!params.lng) return Promise.reject("Missing longitude");
  if (!params.username || !params.password) return Promise.reject("Missing credentials");

  var url = "https://twcservice.mybluemix.net/api/weather/v1/geocode/"+params.lat+"/"+params.lng+"/forecast/daily/3day.json";
  var options = {
    url: url,
    json: true,
    auth: {
      user: params.username,
      password: params.password
    }
  };

  return new Promise(function (resolve, reject) {
    request(options, function (err, resp) {
      if (err) {
        return reject({err: err})
      }

      resolve({text: resp.body.forecasts[0].narrative});
    });
  });
}
```

This service expects four parameters, latitude and longitude coordinates along with the API credentials. Passing in API credentials as parameters mean don't have to embed them within code and can change them dynamically at runtime. 

Let's deploy this service and verify it's working…

```
$ wsk action create forecast_from_latlong forecast_from_latlong.js
ok: created action forecast_from_latlong
$ wsk action invoke forecast_from_latlong -p lat "51.50" -p lng "-0.12" -p username $WEATHER_USER -p password $WEATHER_PASS -b -r
{
    "text": "Partly cloudy. Lows overnight in the low 60s."
}
```

Yep, looks good. 

We don't want to pass in the API credentials with every request, so let's bind them as default parameters to the action. This means we only need to invoke the service with the latitude and longitude parameters, which matches the output from the previous service. 

```
$ wsk action update forecast_from_latlong -p username $WEATHER_USER -p password $WEATHER_PASS
ok: updated action forecast_from_latlong
$ wsk action invoke forecast_from_latlong -p lat "51.50" -p lng "-0.12"  -b -r
{
    "text": "Partly cloudy. Lows overnight in the low 60s."
}
```

Okay, great, that's the first two services working. 

## Sending Messages To Slack

Once we have a forecast, we need to send it to Slack as a message from our bot. Slack provides an easy method for writing simple bots using their webhook integration. [Incoming Webhooks](https://api.slack.com/incoming-webhooks) provide applications with URLs to send data to using normal HTTP requests. The contents of the JSON request body will be posted into the channel as a bot message. 

Create a new [Incoming Webhook Integration](https://my.slack.com/services/new/incoming-webhook/) for your channel and copy the URL provided by Slack to use with our bot. 

We could now write another microservice to handle sending these HTTP requests but OpenWhisk comes with integrations for a number of third-party systems meaning we don't have to! 

These integrations are available as _packages_, which bundle Actions and Trigger Feeds and make them available to all users in the system. We can see what packages are available using the following command...

```
$ wsk package list /whisk.system
packages
/whisk.system/cloudant                                            shared
/whisk.system/alarms                                              shared
/whisk.system/samples                                             shared
/whisk.system/websocket                                           shared
/whisk.system/slack                                               shared
/whisk.system/github                                              shared
/whisk.system/system                                              shared
/whisk.system/util                                                shared
/whisk.system/watson                                              shared
/whisk.system/weather                                             shared
/whisk.system/pushnotifications                                   shared
```

Looks like there's a Slack integration already. Retrieving the package summary will tell us more. 

```
$ wsk package get --summary /whisk.system/slack
package /whisk.system/slack: This package interacts with the Slack messaging service
   (params: username url channel token)
 action /whisk.system/slack/post: Post a message to Slack
```

We can then invoke this Action to post messages to Slack without writing any code. 

```
$ wsk action invoke /whisk.system/slack/post -p text "Hello" -p url $WEBHOOK_URL
ok: invoked /whisk.system/slack/post with id 78070fe2acb54c70ae49c0fa047aee51
```

Seeing the message pop-up in our Slack channel verifies this works. 

I'd like to bind default parameters for the Action but this isn't supported without copying global packages to your local namespace first. Let's do this now...

```
$ wsk action create --copy webhook /whisk.system/slack/post -p url $WEBHOOK -p username "Weather Bot" -p icon_emoji ":sun_with_face:"

ok: created action webhook
```

This customised Slack service can be invoked with just the _text_ parameter and gives us a friendly bot message in the #weather channel. 

## Creating Weather Bot Using Sequences

Right, we have the three microservices to handle the logic in our bot. How can we join them together to create our application? 

OpenWhisk comes with a feature to help with this, called _Sequences_. 

Sequences allow you to define Actions that are composed by executing other Actions in order, passing the output from one service as the input to the next. This is a bit like Unix pipes, where a single command executes multiple commands and pipes the output through the commands. 

Let's define a new sequence for our bot to join these services together. 

```
$ wsk action create location_forecast --sequence /james.thomas@uk.ibm.com_dev/location_to_latlong,/james.thomas@uk.ibm.com_dev/forecast_from_latlong,/james.thomas@uk.ibm.com_dev/webhook
ok: created action location_forecast
```

With this meta-service defined, we can invoke _location_forecast_ with the input parameter for the first service (_address_) and the forecast for that location should appear in Slack. 

```
$ wsk action invoke location_forecast -p address "London" -b
ok: invoked location_forecast with id d63b40bb36c54cfbaf8262b6f7e5c2e9
{
    "activationId": "d63b40bb36c54cfbaf8262b6f7e5c2e9",
    "annotations": [],
    "end": 1473179750086,
    "logs": [],
    "name": "location_forecast",
    "namespace": "james.thomas@uk.ibm.com",
    "publish": false,
    "response": {
        "result": {},
        "status": "success",
        "success": true
    },
    "start": 1473179746914,
    "subject": "james.thomas@uk.ibm.com",
    "version": "0.0.1"
}
```

Excellent! It worked. 

## Bot Forecasts 

How can users ask the bot for forecasts about a location? 

Slack provides Outgoing Webhooks that will post JSON messages to external URLs when keywords appear in channel messages. Setting up a new outgoing webhook for our channel will allow users to say "weather london" and have the bot respond. 

OpenWhisk comes with a comprehensive REST API for the platform, including invoking Actions by sending an authenticated HTTP POST to the Action endpoint. We can use Slack's webhook integration to directly invoke Actions as outgoing webhook request doesn't match the request format expected by OpenWhisk's API.

One solution for this issue is to use an external [API gateway](http://microservices.io/patterns/apigateway.html) to expose a public endpoint, which handles the incoming HTTP request generated by Slack, which invokes the authenticated OpenWhisk API endpoint to invoke the Action. I've used IBM's [API Connect](https://developer.ibm.com/apiconnect/) to create a new endpoint for this.

Pasting this new endpoint URL into Slack's Outgoing Webhook integration page means users can now invoke the bot on-demand.

## Connecting To Triggers

Triggers are used to represent event streams from the external world into OpenWhisk. They can be invoked manually, through the REST API, or automatically, after connecting to trigger feeds. 

Actions can be bound to Triggers using Rules. When a Trigger is fired, the Action is invoked with the request parameters. Multiple Actions can listen to the same Trigger. 

Let's look at binding the bot service to a sample trigger and invoke it indirectly by firing that trigger…

```
$ wsk trigger create forecast
ok: created trigger forecast
$ wsk rule create forecast_rule forecast location_forecast
$ wsk trigger fire forecast -p address "london"
ok: triggered forecast with id 49914a20416d416d8c90282d59eebee3
```

Once we fired the trigger, passing in the _address_ parameter, the bot was automatically invoked and posted the forecast for London to the channel. 

Now we understand triggers and rules, let's look at invoking the bot every morning to tell us the forecast before we set off for work. 

## Morning Forecasts

Triggers can be registered to listen to exteral event sources, like messages on a queue or updates to a database. 

Whenever a new external event occurs, the trigger will be fired automatically. If we have Actions bound via Rules to those Triggers, they will also be invoked. 

Triggers bind to external event sources during creation by passing in a reference to the external trigger feed to connect to. OpenWhisk's public packages contain a number of trigger feeds that we can use for external event sources. 

One of those public trigger feeds is in the Alarm package. This alarm feed executes triggers at pre-specified intervals. Using this feed with our weather bot trigger, we could set it up to execute every morning for a particular address and tell us the forecast every for London before we set off for work. 

Let's do that now...

```
$ wsk package get /whisk.system/alarms --summary
package /whisk.system/alarms: Alarms and periodic utility
   (params: cron trigger_payload)
 feed   /whisk.system/alarms/alarm: Fire trigger when alarm occurs
$ wsk trigger create regular_forecast --feed /whisk.system/alarms/alarm -p cron '*/10 * * * * *' -p trigger_payload '{"address":"London"}'
ok: created trigger feed regular_forecast
$ wsk rule create regular_forecast_rule regular_forecast location_forecast
ok: created rule regular_forecast_rule
```

The trigger schedule is provided by the _cron_ parameter, which we've set up to run every ten seconds to test it out. Binding this new trigger to our bot service, the forecast for London starts to appear in the channel! 

Okay, that's great but let's turn off this alarm before it drives us mad. 

```
$ wsk rule disable regular_forecast_rule
ok: rule regular_forecast_rule is inactive
```

