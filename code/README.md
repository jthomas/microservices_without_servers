# Demonstration Code

Example code used in this presentation is included within this directory. Each sub-directory contains the sample code and instructions for running that demonstration. 

- **Hello World** - Introductory examples creating OpenWhisk Actions for Node.js and Java.
- **Weather Bot** - Sample microservices used to build the *Weather Bot* application using OpenWhisk.

*Developers need to register with an OpenWhisk platform to deploy these examples, see instructions below for IBM Bluemix.*

## OpenWhisk on IBM Bluemix

These steps explain how to provision a new OpenWhisk service on IBM's cloud platform. Developers need to register for an account and setup the command-line utility to interact with OpenWhisk. 

## Register for an account with IBM Bluemix

- Browse to https://console.ng.bluemix.net/ and click _Sign Up_

- Fill out the registration form details to create a new account.

- Open the link emailed by IBM Bluemix to confirm your account.

- Log into IBM Bluemix using your new credentials.

## Setting up your account

- During this initial logon, developers are asked to set up _organisation_ and _space_ identifiers for their region.
- Ensure the Region dropdown is set to _US-South_ not _London_ or _Sydney_.
- Use your account email address as the organisation identifier.
- Use _dev_ as the space identifier.
- Click _I'm Ready_ to finalise environment setup.

## OpenWhisk on IBM Bluemix

_Note: You can skip the following steps and visit the [CLI setup link](https://new-console.ng.bluemix.net/openwhisk/cli) directly without having to manually find it._

OpenWhisk is currently in beta (September 2016) and only available through new IBM Bluemix UI. Once you've logged into the platform and finished setting up your account, follow these steps to provision an instance. 

- Click the "[Try the new Bluemix](https://new-console.eu-gb.bluemix.net/)" link in the home page.

- In the new catalogue page, scroll down the bottom to access the "[Bluemix Experimental Services](https://new-console.ng.bluemix.net/catalog/labs/)" link. 

- Select [OpenWhisk](https://new-console.ng.bluemix.net/openwhisk) from the _Compute_ section.

- Select the [Use The CLI](https://new-console.ng.bluemix.net/openwhisk/cli) link at the bottom of the page.

## Setting up OpenWhisk CLI

- Follow the steps on the CLI setup page. This includes downloading and installing the command-line utility and authenticating with your user credentials. 

- You can verify everyting is correctly configured by invoking this sample Action using the CLI.

  ```
  wsk action invoke /whisk.system/samples/echo -p message hello --blocking --result
  ```


**All good? Great, you're ready to deploy those demos…**

