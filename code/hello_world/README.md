# Hello World Demo

These samples were used to demonstrate deploying and invoking sample _Hello World_ microservices on the OpenWhisk platform.  

The same services have been implemented in both Java and Node.js.

Having followed the instructions in the parent directory for registering with the OpenWhisk platform and installing the CLI tool, follow the steps below...

## Node.js "Hello World"

This sample Node.js microservice, _hello_name.js_, returns a greeting to the user when invoked. If the invocation includes the request parameter, _user_, it will be included in the response string.

I'm calling it the WORLD'S SMALLEST MICROSERVICE ™.

```
$ cat hello_name.js
function main (params) {
  var user = params.user || "unknown";
  return { message: "Hello " +  user + "!" };
}
```

Using the _wsk_ CLI, I'm going to deploy this as an OpenWhisk action.

```
$ wsk action create hello hello_name.js
ok: created action hello
```

Looking at the deployed service list, we can see it has been registered...

```javascript
$ wsk action list
actions
/james.thomas@uk.ibm.com_dev/hello                       private    
```

…and now it can be invoked on-demand. 

```
$ wsk action invoke hello -b
ok: invoked hello with id 01b0a69fa2764a779d85be88693a8e21
{
    "activationId": "01b0a69fa2764a779d85be88693a8e21",
    "annotations": [],
    "end": 1473149719378,
    "logs": [],
    "name": "hello",
    "namespace": "james.thomas@uk.ibm.com",
    "publish": false,
    "response": {
        "result": {
            "message": "Hello unknown!"
        },
        "status": "success",
        "success": true
    },
    "start": 1473149718731,
    "subject": "james.thomas@uk.ibm.com",
    "version": "0.0.1"
}
```

Within the response JSON, we can see the service output under the _response/result_ path. Hurrah, it works! 

Parameters passed through the command-line tool will be sent in the request body, let's try this out to set the _user_ value in the response. 

```
$ wsk action invoke hello -b -p user "James"
ok: invoked hello with id be8ec9a0d07e4bc38865d18a6f270785
{
    "activationId": "be8ec9a0d07e4bc38865d18a6f270785",
    "annotations": [],
    "end": 1473149849346,
    "logs": [],
    "name": "hello",
    "namespace": "james.thomas@uk.ibm.com",
    "publish": false,
    "response": {
        "result": {
            "message": "Hello James!"
        },
        "status": "success",
        "success": true
    },
    "start": 1473149849340,
    "subject": "james.thomas@uk.ibm.com",
    "version": "0.0.1"
}
```

Great, it's now returning my name.

Using parameters is often how we pass in service credentials to a service. However, we don't want to have to include them with every invocation. OpenWhisk provides a mechanism to bind default parameters to a service, so that if the parameters are missing in the request, it uses these default values.

Let's look at doing this for the _user_ parameter to provide a sample name when it's not set.

```
$ wsk action update hello -p name "James"
ok: updated action hello
$ wsk action invoke hello -b
ok: invoked hello with id fb3134986fb2451f830b0b7135a28836
{
    "activationId": "fb3134986fb2451f830b0b7135a28836",
    "annotations": [],
    "end": 1473150102885,
    "logs": [],
    "name": "hello",
    "namespace": "james.thomas@uk.ibm.com",
    "publish": false,
    "response": {
        "result": {
            "message": "Hello unknown!"
        },
        "status": "success",
        "success": true
    },
    "start": 1473150102234,
    "subject": "james.thomas@uk.ibm.com",
    "version": "0.0.2"
}
```

Great, it works. 

After updating the action with my default user parameter, I can invoke the service without passing in this value. 

Default parameters provide a mechanism to bind service credentials to Actions without embedding them within the code. 

OpenWhisk supports multiple runtimes, so let's look at doing the same example with a Java microservice. 

## Java "Hello World"

Here's the sample example service written in Java. 

```
$ cat Hello.java
import com.google.gson.JsonObject;
public class Hello {
    public static JsonObject main(JsonObject args) {
        String name = "stranger";
        if (args.has("name"))
            name = args.getAsJsonPrimitive("name").getAsString();
        JsonObject response = new JsonObject();
        response.addProperty("greeting", "Hello " + name + "!");
        return response;
    }
}
```

It's implemented the small interface needed by the runtime, a static main that takes and returns a JSON object.

Running Java code on OpenWhisk comes with a few more steps. We have to compile source classes locally and bundle those class file into a JAR for deployment. 

Let's do this now… 

```
$ javac Hello.java
$ jar cvf hello.jar Hello.class
added manifest
adding: Hello.class(in = 913) (out= 511)(deflated 44%)
$ wsk action create helloJava hello.jar
ok: create action helloJava
$ wsk action list
actions
/james.thomas@uk.ibm.com_dev/hello                       private
/james.thomas@uk.ibm.com_dev/helloJava                   private
```

Great, it's been registered on the platform and waiting to execute on-demand. Let's try that now… 

```
$ wsk action invoke helloJava -b -p name "James"
ok: invoked helloJava with id 307a2b0e18a0459bb2b48605b8652389
{
    "activationId": "307a2b0e18a0459bb2b48605b8652389",
    "annotations": [],
    "end": 1473150651871,
    "logs": [],
    "name": "helloJava",
    "namespace": "james.thomas@uk.ibm.com",
    "publish": false,
    "response": {
        "result": {
            "greeting": "Hello James!"
        },
        "status": "success",
        "success": true
    },
    "start": 1473150651866,
    "subject": "james.thomas@uk.ibm.com",
    "version": "0.0.1"
}
```

We now have a Java microservice being executed for each request, without having to set up or manage any JVM runtime environments.

So, that was easy, right? 

Just implement the interface for runtime you want to use, deploy your services using the command-line utility and you can register serverless functions with the platform. 