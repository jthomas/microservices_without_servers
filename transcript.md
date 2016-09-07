# Presentation Transcript

## Slide 1: Microservices Without Servers

Hello I'm James Thomas, a Developer advocate working for IBM in our cloud division. 

Today I want to talk about building and running microservices in the cloud without having to set up any servers. 

No having to provision virtual machines, no ssh'ing into a linux terminal to set up the environment, no installing middleware and database servers.

Now, this might sound impractical or even impossible? If I have some microservices, some code, I need a server to run it on and therefore I have to setup and manage that environment, right? 

Well, I'm going to show you a new approach, using serverless cloud platforms, to do just that. 

In the second half of this talk, I'll be live coding a sample application using one of these serverless platforms to show you the tools and techniques to do the same. 

Now, you might be thinking as well as this sounding impossible isn't it unnecessary? You might think, I like my servers! I've got them all set up just how I need them, I can SSH in to copy over my WAR file and deploy my application. Why do you want to talk my servers away from me?! 

Well, the reason is this…

## Slide 2: Servers Are Killing Your Productivity

Servers are killing your productivity. 

You might not realise it, but trust me it's true and by the end of this talk, you're going to want to run back to your office, gather up all your servers, set them on fire and BE FREE OF THE TYRANNY OF LOOKING AFTER INFRASTRUCTURE! 

I think servers are the worst thing that's ever happened to software developers. They are directly responsible for you being a worse engineer. Delivering less code, making worse products and generating less revenue for your company. 

But how is this possible? How is that little Ubuntu machine that sits warming your feet in the office responsible for all the evils I've just mentioned? 

Well, let me tell you a story to justify why I feel so strongly about this issue…

## Slide 3: Idea -> ? -> Profit

You wake up one morning and you realised you've had an amazing idea for the next billion dollar unicorn startup. 

You understand the problem, the customers, there's a product-market-fit and you have the skills to turn this idea into reality. So you think, this is it, I'm going to be the next Mark Zuckerberg.

So you spend the next couple of months furiously coding away in your spare time to get to version one of your app, the MVP for your idea. So you have your app and you also have some clients who want to try it out. If you can just get them your application, you can get feedback, iterate and go through the whole lean product development lifecycle, maybe pivoting a few times on the way.  

So you have the app and the users all ready to go, what's next? 

You need a server to run your code. 

So you get a server, set it up for your application, put the code on there and email the link to your application out to the users. 

Job done, right? Wait for the feedback to roll in? You're on the way to building the next Uber, Amazon, Netflix.. 

Except, what happens the first weekend your application is live?

## Slides 4 - 10: Infrastructure Issues

The hard drive fails in your server. Cue mad panic. 

Now, rather than users testing our your application, they are staring at a blank page. 

So you scramble round to find a replacement hard drive on a Sunday, install it in your server and set up the environment all over again. So your hard drive issue is fixed but then you get an email….

There's new vulnerability in the Linux kernel you're running and you don't want hackers stealing all your customer data so you need to fix this as well. So you take your application down (again), patch the kernel and bring everything back up. Whilst you're doing this, you realise there's an update version of the middleware available. Since the application is already down, no harm in upgrading this, right? Except when you install the new middleware it requires you to upgrade some dependency that another service relies on and everything breaks. What should have taken ten minutes turns into hours and all this time your application is not running, you're not getting feedback, you're not iterating. 

All this time you're dealing with server issues is time you're not spending building a better product. 

You're being held hostage by your servers. You want to be writing code but you're patching kernel vulnerabilities and upgrading hardware. 

## Slide 11: Wasn't the cloud supposed to fix this? 

Wasn't the cloud supposed to fix this? 

We're always being told that we have to be "in the cloud" and "build cloud native apps" and shown all these companies like Netflix, Etsy and Uber who used cloud infrastructure to grow their startups. 

We're sold this utopian vision that cloud computing platforms allow you to treat computing infrastructure as a utility…

## Slide 12: Computing As A Utility

Like electricity, gas or water, that can be turned on or off on-demand. No worrying about infrastructure!

Yet for many of us, what the cloud turned out to be was running virtual machines in someone else's data centre. 

Sure, we didn't have to manage the physical hardware but everything from the operating system up was still our responsibility. We still had to patch those kernel vulnerabilities and keep the middleware updated. 

If this was supposed to be a utility like electricity or gas, this was like building a house, ringing up the power company to get connected to the grid and being told, "Well, we can't connect you directly but what we can do is build you a power sub-station in your back yard".

## Slide 13: Power Sub-Station

…and we'll bring round all the parts so you don't have to produce them but once it's running you'll have to look after it. It'll be running twenty four hours a day, whether you're using it or not, and you need to predict how much electricity you need in three years time so we can build the sub-station big enough.

This is ridiculous. This isn't like the utility model I have for electricity at home!

## Slide 14: No Escape

So, it seems there's no escape. 

Whatever we do, whether that's running your own data centres or renting them in the cloud, there's still servers to configure and maintain. 

But it's not just time you're wasting looking after infrastructure, it's money too. 

## Slide 15: Average Server Utilisation

Google released a study in July 2013, looking at average utilisation rates for some of their larger clusters over a period of three months. These clusters had up to twenty thousand machines in. 

What they found was that the average utilisation across these servers was just twenty to forty percent. That means sixty to eight percent of the time, the servers and their applications were doing absolutely nothing, sat there waiting for requests to come in. 

If you're renting VMs in the cloud, you probably have similar utilisation rates which means you're spending the significant portions of your money renting infrastructure for no return. You might as well set it on fire! 

That's money that could be used employing more developers, advertising, talking to customers, anything to improve your business and you're wasting it on servers you don't use. 

If cloud computing is this utility model, this is like having a water tap in your house you have running twenty fours a day in case you need a glass of water in the middle of the night.

## Slide 16: What Can We Do?

So, what can we do? 

Well, the first step to recovery is admitting you have a problem and I think the problem developers have is servers. 

But it seems like we're in an impossible situation, if we have code for our application, surely we need servers to run it on and then we have to setup and manage those computers, right? We're trapped…

That was until 2014 when I think something very exciting happened, that might offer a solution.

## Slide 17: AWS Lambda

AWS launched a new cloud computing service, called Lambda, back in 2014. This is Werner Vogels, their CTO introducing in on-stage at one of their big conferences. 

Lambda was billed as a "next-generation cloud computing service", that really treated "computing resource as a utility". 

But you wouldn't necessary get that from reading their press release.

## Slide 18: Why Is This Different?

It said things like "Lambda runs code in response to events, managing the computing resources for developers, allowing them to build event-driven applications". Which just sounds like every other cloud system? 

So, was this really any different? 

Well, I think Lambda was radically different and it was different a number of reasons.

## Slide 19: Functions-as-a-Service

Lambda, and platforms like it, shrank the unit of deployment. Rather than having to deploy an entire VM with your application and services, or even a monolithic deployment package, you could deploy exactly those functions that you wanted to execute in response to external events. The microservices would be literally just hundreds of lines long. 

Lambda was dynamically evaluate your code on-demand each time a new request came in. You didn't have instances of your services running waiting for requests to occur. 

You didn't even have to think about servers or environments, just implement a small interface in your code and let the platform do the rest. 

## Slide 20: Scaling

So, what happens if you service is processing a request and another request comes in? Well, the platform would just instantiate and execute another instance of your code in parallel, scaling horizontally to cope with as much requests as needed. 

Suddenly, we don't have to try and predict how much traffic we can cope with on a particular server, the platform can cope with almost infinite load by scaling like this. Scaling comes for free.

But it's not just scaling up. Since your code is only running when processing requests, most of the time you're aren't processing requests and so your services aren't running. 

Which is important when we think about the pricing implications…

## Slide 21: Pay-As-You-Go

Like all cloud services, Lambda was pay-as-you-go, you only pay for the resources that are being used. But since most of the time you code isn't running, you don't have to pay anything! You're not renting VMs by the hour that are sat round waiting for events, doing nothing but still costing you. 

This can lead to some extreme cost savings. 

## Slide 22: 80% Cost Reduction

For example, in this Business Insider article about AWS Lambda, they profiled a cybersecurity firm who had an application for processing customer logs from their service. 

This had been running on a couple of VMs in the cloud, which most of the time were idle waiting for logs to be generated. Re-architecturing this to move to Lambda, the company discovered they were saving nearly 80% off their monthly cloud bills because now they were only paying for resources when their application was running. 

This was a significant amount of money. 

## Slide 23: Isn't this just Paas? 

Now, some of you may be thinking, this doesn't sound that new to me, isn't this just PaaS? I use Heroku or App Engine or Cloud Foundry and I can scale elastically to cope with demand and I don't have to think about server environments… 

And this is true, there are some similarities between PaaS and what I consider Serverless platforms, but there's some key differences. I think the best response to this question comes from Adrian Cockcroft, who was the CTO at Netflix and considered one of the most influential people in cloud computing today. 

## Slide 24: Adrian Cockcroft 🔥

Adrian was having this debate on Twitter about whether Serverless was just a new form of PaaS and sent a great tweet about this topic. 

*"If your PaaS can start up new instances in 20ms, that run for 500ms and then get destroyed for each request, then you can call it serverless, otherwise it's not."*

This is a key difference between Platform-as-a-Service and Serverless platforms. With PaaS, you sit think about logical instances of your application, which sit idle waiting for requests, rather than being spun up on demand and then be killed afterwards. It's not a true utility model of computing.

## Slides 25 - 26: Google Trends

Lambda launched at the end of 2014 and has been steadily growing in popularity every since, with developers realising the benefits of building cloud applications using this model. 

This year we saw another trend emerging, the term "serverless" to refer to the whole ecosystem that's emerging to allow developers to build and deploy microservices with managing infrastructure.

## Slide 27: Providers

In 2016, all the major cloud providers launched serverless platforms. 

IBM have one called OpenWhisk, which we'll look at later, there's Google Cloud Functions, Azure Functions and independent vendors like Webtask and Iron.io

Developers now have a huge range of platforms to choose from, which all follow the same serverless design patterns for cloud applications.

## Slide 28: Conferences

But the true measure of popularity and hype around a developer technology is conferences.

This year saw the first serverless conference in New York this May. It was sold-out, with all the major vendors, developers and communities attending. The conference was so popular the organisers are hosting two more events in London and Tokyo later this year. We've also seen dozens of serverless meet ups taking place this year around the world. 

## Slide 29: There's Still Servers

So before I go any further, I want to drop a spoiler in… 

However you are running your code in the cloud, it's still going to be running in some virtualised Linux environment on some server in a remote data centre (probably in Virginia). Even if you're using this new fangled "serverless" thing… 

The term "serverless" refers to the developer's experience. They don't have to even think about setting up or running the infrastructure or environments for their microservices. Their code might as well be running on an actual cloud in the sky for all the interaction they have with the underlying infrastructure. 

Anyway, with that out of the way…

## Slide 30: Bring On The Code.

BRING ON THE CODE. 

Enough talking about serverless platforms, let me show you how to use one to develop a sample application and give you the tools and techniques to do it yourself. 

Before I can building something I need an idea, my next billion dollar startup, right? 

Well, a couple of weeks ago I woke up and I had a wonderful idea. This was going to be the next unicorn startup, I was going to be the next Zuckerberg for sure. It was all about the weather. 

## Slide 31: Weather Bot

One thing you might not realise about British people is that we're obsessed by the weather. We love to talk about with our friends, watch the forecast on television and worry about whether it'll affect our holiday next month. Mostly because the weather is so bad in the United Kingdom and rains a lot. 

Working in technology, I know one of the hot trends this year is bots. Facebook launched their bot platform, Microsoft have a framework for building them, bots are everywhere. 

So my idea was this… could I build a bot to help me with the weather? What about a bot that could tell me the forecast for locations on-demand and warn me when there's bad weather approaching? 

For a British person who worries about the weather this is the killer bot app. 

## Slide 32: Slack Bots

As well as being a British person who worries about the weather, I'm a software developer. So I love using Slack to collaborate with my colleagues at work. Slack also provides a great platform for building bots. So let's try integration our new Weather Bot with the service. 

So, I've got my idea and I've heard about this serverless thing for building applications really quickly so I'd like to try out building a forecast bot for Slack this way. 

The next thing I need is a serverless platform to use.

## Slide 33: IBM OpenWhisk

In this demonstration I'm going to be using IBM OpenWhisk. This is our serverless platform we announced back in February, running on our cloud platform called Bluemix. 

You can go and sign up for a free account and get access to a fully provisioned serverless platform to play with. Everything I'm going to show you today is possible within that free account limit and the platform's still in beta so there's no charge at the moment for using it. 

Now, I want to point out that the patterns, architectures and techniques I'm showing you today for building serverless applications are relevant for any serverless platform. If you decide to build your application using IBM OpenWhisk or AWS Lambda or Google Cloud Functions, the high-level concepts for building serverless applications are the same across all providers.

But if you are evaluating serverless platforms, I think there's a number of good reasons to look at OpenWhisk…

## Slide 34: Open Source

OpenWhisk is open-source. When we announced the platform back in February, we also open-sourced the code for the entire project at the same time. 

Lots of developers concern about developing for cloud platforms is "vendor-lockin". Having their applications tied to some proprietary cloud platform that they can easily leave if the vendor changes the pricing model, changes the T&Cs or decides to deprecate it. IBM's committed to use open-source cloud platforms as one method for reducing this challenge and OpenWhisk is no different. 

If you visit github.com/openwhisk you can get access to the entire platform. 

If uses standard cloud-scale open-source components like Apache Kafka, Consul, Docker under the covers, there's no secret IBM components in there. 

One of the best things about OpenWhisk is that the team continues to develop in the open. You can read the milestones in Github and see what they are working on, raise issues to report bugs and even submit pull-requests to add features to the project. We're trying to build a really vibrant open-source community around OpenWhisk. 

This is something this is different from many of the other platforms, almost none are open-source.

## Slide 35: Local Dev Env

So with these three commands you can have a fully functioning serverless platform running in your local development environment to play around with. Check-out the code, change directory and use vagrant to start the VM. 

Easy.

## Slide 36: OpenWhisk on Bluemix

But for most developers, I think the easiest way to get started with OpenWhisk is on IBM Bluemix, our cloud platform. Developers can sign up for a free account and get a fully provisioned serverless platform to try out. 

It's currently in beta so there aren't any charges for OpenWhisk on Bluemix at the moment, it's a great time to try it out. 

Using OpenWhisk on Bluemix comes with additional tools that make it easier to use, like a monitoring dashboard and an browser-based code development environment.

## Slide 37: Runtimes

OpenWhisk supports all the standard runtimes you expect from a modern serverless platform. Node.js v0.12 and v6, Python 2.7 and Java 8. These language runtimes are supported across most of the major serverless providers.

One of the additional runtimes supported by OpenWhisk is Swift, the language originally developed by Apple for mobile applications on iOS. IBM's been a firm supporter of this language and involved in helping to build out the runtime support and tooling efforts.

IBM decided to support Swift as a first-class runtime in OpenWhisk because we believe a major use case for serverless platforms is building backend services and APIs for mobile applications. This means a developer who is comfortable building mobile applications using Swift can easily create backend services in the same language. Swift is not supported by another other providers at the moment.

But the best feature of runtime support in OpenWhisk is that its extensible. So if you want to write your microservices in Rust, Haskell or any esoteric language, you can because OpenWhisk supports Docker. Any microservice you can wrap in a tiny Docker image you can push into the platform. OpenWhisk supports executing these images on demand, spinning up your container per request.

This is a great feature of the platform and again not supported by many of the other providers.

So, we're going to use OpenWhisk as the platform for our serverless application and we have our idea, weather forecast bots for Slack.

Next, we need some code…

## Slide 38: my_service.js

In these examples I'm going to focus on JavaScript and the Node.js runtime, because it's the language I prefer and I think most developers can at least understand it, but you could choose any of the runtimes I've just mentioned.

Now once you've developed your microservice, how does the platform know what to do with it? I've said you don't have to set up the runtime environment or infrastructure. You don't have to even package your service within a web framework or write lots of configuration files. 

Well, for each runtime you want to use there's a tiny interface to implement in your microservice. This is going to act as the entry point for the platform into your code.

## Slide 39: Node.js Runtime 

This is what the interface looks like for Node.js.

Each JavaScript file containing your microservice code, which could be hundreds of lines long, with dozens of functions and call third-party NPM modules, must implement the global function called "main".

The platform will dynamically evaluate your code inside a Node.js environment, invoking the main function for every request. Parameters for the request will be passed in as an object through the first function argument. This function must return an object, will be serialised to JSON and returned to the user as the service response.

Simples. 

It's not a difficult or overbearing interface to implement.

## Slide 40: Java Runtime

This is the interface for Java. 

The class source must implement a static main, which takes a JSON object for the parameters and returns a JSON object for the service result.

## Slide 41: Actions

So once you've written your service and deployed them to the platform OpenWhisk creates an "Action". 

This is the term we use to refer to the dormant code waiting to be invoked on-demand for each external request.

So, let's have a look at doing this now… 

We'll take some sample microservices I've written locally and deploy them as OpenWhisk Actions. We can then invoke them on-demand to create our weather bot application. 

**DEMO TIME: At this point I drop to my terminal and show the demos I've written up in the [code] directories.**

That was easy, right? I was able to deploy and invoke microservices in the cloud without having to set up or manage any servers. Hurrah. 

Once you have your OpenWhisk Actions deployed, how can you invoke them? Well, there's actually two methods for this…

## Slide 42: REST API

One way is through the REST API. 

OpenWhisk has a comprehensive REST API for the platform that allows you to do everything from deploying new services, invoking them and retrieving the results. 

Each Action has its own HTTP endpoint. Users can send an authenticated HTTP POST request to this endpoint to execute the microservice. This is an obvious way to integrate microservices into external applications.

One issue is that the API uses the developer's credentials for authentication. If we're building public APIs for a client-side web application, we can't embed our credentials in the JavaScript files without exposing them to the world.

Developers can work around this issue using "API Gateways".

## Slide 43: API Gateway

API Gateways are a category of cloud services that allow you to define and publish public APIs which can invoke private APIs and proxy the results back.

Each major cloud platform has an API Gateway service, IBM has one called API Connect, Amazon has one called API Gateway and so on. 

Using these services developers can define their public endpoints which then make the authenticated private API call to invoke their OpenWhisk Action. 

Calling APIs to invoke your services on-demand is one way to integrate the serverless functions into your application but what about having them executed when an external event occurs? We might want the services to be listening for messages on a queue or updates to a database table. 

## Slide 44: Triggers

OpenWhisk has something called "Triggers" to handle invoking microservices for external events. 

Developers create triggers for the event stream they want to model. They can also connect triggers directly to third-party event sources to be fired automatically when these events occur. 

## Slide 45: Rules

Once they have defined triggers, actions can be connected to triggers using custom rules. 

These rules say, when a trigger is fired, invoked my action, passing in the event parameters.

Using triggers and rules allows us to configure our actions to be automatically invoke when messages appear on a queue or our database is updated. 

Let's drop back to the terminal now and extend weather bot to use both of these methods.

**DEMO TIME: At this point I drop to my terminal and show the demos I've written up in the [code] directories.**

Weather bot works! 

Using the API Gateway approach, I was able to define a new public API for my service and then connect that to a Slack web hook. Users can then ask the bot directly for forecasts through the channel. 

We then connected weather bot to the alarm trigger feed, so it was invoked every morning to give us the forecast before we left for work. Awesome.

If you've been paying attention over the previous thirty minutes I hope you're thinking "Hey, this serverless stuff is really cool. I can develop and deploy applications to a scalable cloud platform without even thinking about servers" 

…and you're ready to go back to work on Monday, tell your boss about this amazing serverless thing you heard about at the conference last week, gather up all your servers, set them on fire and be free of the tyranny of looking after infrastructure forever! Right?

Well before you do that, let me tell you about some of the challenges of developing applications using serverless platforms. 

## Slide 46: CHALLENGES

Every application architecture decision comes with tradeoffs, constraints and challenges. Serverless definitely has some of those.

Let me introduce some of the issues and hopefully provide you with resolutions as well.

## Slide 47: Compute Limits

The first is compute limits for serverless microservices.

Serverless platforms are very opinionated platforms. They are opinionated about the architecture of the applications they expect you to build. 

This means they definitely not suitable for every use case. Please don't think its a good idea to try and publish your legacy cobol application which runs payroll as a series of stateless microserivces on OpenWhisk. 

Do not do this.

Serverless platforms are for modern cloud-native applications designed to run on public cloud infrastructure.

One of the ways platforms enforce this architectural style is through limiting the computational resources microservices have access to.

## Slide 48: Resource Limits

This slide shows some of the configurable resource limits for OpenWhisk. 

For example, microservices must complete processing each request in under a maximum of five minutes. If you have some super long batch job that takes hours to complete, it's not going to work as a serverless micro service.

OpenWhisk lets you vary the memory available to each service, up to a maximum of half a gigabyte. Again, if you have some incredibly memory intensive task, mining bitcoins for hours, that takes terabytes of memory, it won't work on a serverless platform. 

One of my favourite phrases is that "constraints are liberating" because you often find conforming to some set of limits means you get unintended benefits.

This is especially true for serverless platforms. They limit resources for your microservices to help you build applications that exploit the efficiencies of running in the cloud.

For example, your microservices must be stateless because they are invoked on-demand and destroyed afterwards. You cannot use application memory to store state between requests. Following this constraint gives you the unintended benefit that scaling becomes easy. For each request the platform can execute a separate instance of your service in parallel, without having to worrying about replicating and managing session state between instances. 

## Slide 49: Monitoring, Debugging and Testing

Monitoring, debugging and testing, all the things you need to do to keep your application running happily in production. 

Developers often struggle with these tasks when moving to serverless platforms because they have no access to the environment or infrastructure. Many of the tools and techniques we'd use rely on having physical access, e.g. attaching a debugger to an errant process or run top to trace process usage on the machine. 

What can you do? 

Well, on serverless platforms it's really important to ensure you have really comprehensive logging out for your services that can help you diagnose bugs and fix performance issues after the fact. You still have access to console logs on the platform. Making sure you have introduced well thought out logging to help you diagnose issues is essential but you can't jump in with a debugger. 

Testing is both really easy and really hard. Because you're building small discrete microservices with a defined entry point, it's easy to whip up a small test harness that simulates being called on the platform for unit testing. Integration or system testing is much more difficult though. 

How do you simulate an environment in a remote data centre with dozens of different services calling each other and third-party APIs? 

OpenWhisk can help with this as its open-source. You can run the full platform in a VM in your local test environment helping to simulate a more production like system but it's not perfect. This is one area that developers find very challenging. 

## Slide 50: Complexity

If you're a developer who is used to building a monolithic application that you deploy as a single package by scp'ing it over to a single server, the idea of having twenty different services in production, running in parallel and calling third-party APIs, must sound insane. It's an enormous increase in complexity.

One of the downsides of microservice-based development is this increased complexity. 

How do you roll out new versions, fall back if things go wrong whilst not having any visible downtime for your users? 

## Slide 51: Frameworks

One way to help you manage this additional complexity is through frameworks.

There's a whole ecosystem of open-source tools and frameworks that can assist developers. One of the most popular is called "the serverless framework", here's the project homepage.

These frameworks allow you to specify configuration as code, handle deploying multiple services and managing application dependencies. 

If you are serious about embracing serverless development, I'd definitely recommend looking at some of the popular frameworks to help manage the complexity.

## Slide 52: Servers Are Killing Your Productivity 

I started this presentation by telling you that servers are killing your productivity. Maybe you're now agreeing with me? 

All the time spent patching kernels, upgrading middleware and dealing with security issues is time you're not spending writing code, listening to your users and building a better product.

We've been held hostage by our infrastructure.

## Slide 53: 🐶🔥

If often felt like I was the dog in this picture. 

Everything was always on fire in my infrastructure, kernels were panicking, disks over overflowing, cpus were screaming, but I convinced myself this was normal. This is the best way to develop applications.

Anyway, I didn't have a choice, I had to run my code on something, right?

## Slide 54: Serverless Benefits

But then this serverless thing came along.

It allowed me to deploy microservices to scalable cloud platforms without setting up any servers. I didn't even have to think about Linux environments! Code was executed on-demand, which meant I wasn't paying for resources I didn't need and it could scale to cope with infinite load.

I didn't have to worry about servers anymore…

## Slide 55: Burn Your Servers.

So, I want to encourage you all to embrace the serverless movement. 

Burn your servers, delete your VMs, be free of the tyranny of looking after infrastructure forever! 

Most importantly, upgrade your productivity, get back to writing code and stop looking after computers.

## Slide 56: Links