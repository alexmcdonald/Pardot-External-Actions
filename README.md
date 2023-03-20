# Pardot-External-Actions #

Sample code to demonstrate the use of the new Pardot (Account Engagement) External Actions.

Two samples:
1) Send an SMS message using Salesforce Marketing Cloud MobileConnect
2) Create a Case in the Salesforce org.


### Pre-requisites ###
* Account Engagement (fka Pardot) must be active in the org, and of an edition that support External Actions
* External Actions must be enabled
* To send a Marketing Cloud SMS, you need to have access to a Salesforce Marketing Cloud environment with MobileConnect and an active phone number (long code) in your region
* You need to be an administrator in both your Salesforce org and the Account Engagement tenant


## Setup ##

### Marketing Cloud Setup: ###
1. Log in to your MC learning account (mc.exacttarget.com), then click on your name and go to Setup.  Expand Platform Tools / Apps and click on Installed Packages.
2. Create a new package, name it what you want.  Click Add Component, and add API Integration.  Click Next, and select Server-to-Server.  Click Next again, and select all the options for SMS (Read, Write, Send).  That might be all that's needed, but I've also always added Email (Read, Write, Send), Journeys (all the options), List and Subscribers (Read, Write), and Data Extensions (Read, Write).
3. Click Save, and make note of the Client Id, Client Secret, and the prefix for the URIs (ie. https://PREFIX.auth.marketingcloudapis.com/).  Also note down the MID for the MC Business Unit you're using, by hovering over the BU name in the top right corner.
4. Open Mobile Studio / MobileConnect, click on Administration and confirm you've got a mobile number (Long Code) assigned.  Click on the number. Create a new keyword (eg. TRIGGERED) by typing it into the box on the right.
5. Click on the Overview tab, then click Create Message.  Click Text Response, call it something descriptive, select your long code, and select the keyword you just created.  Click next a few times to eventually save the message, then click Send.
6. On the Overview tab, click Create Message again, and this time click Outbound.  Give it a name, select your Long code, leave the From Name as your long code, and change the Send Method to API Trigger.  Click Next and enter a default outbound message, doesn't really matter what as this would usually be over-ridden in the External Action.  Set the Next Keyword to your created keyword (this is really important), then Save and Activate the message.  Take note of the Api Key that is displayed, if you forget to you can click into the message from the Overview screen to find it again.

### Salesforce Setup: ###
1. Go to Setup / Permission Sets.  Find the MC Pardot External Actions Permissions permission set, and click into it.  Click on the Manage Assignments button, and then Add Assignment.  Select yourself (change the list view to All Users if need be) then click Next, then click Assign.
2. Add two more assignments, one for the B2BMA Integration User, and the other for the Automated Process user.  Find these by changing the list view to All Users and then using the "Search this list" box.
3. Open the Send Marketing Cloud SMS flow from Setup / Flows.  Click into the Send SMS action, and adjust:
    * the API Prefix, Client Id, and Client Secret to match your Marketing Cloud API creds.
    * the MID to the Marketing Cloud Business Units MID
    * the SMS Message API key and Message Keyword, from the MobileConnect Outbound SMS message definition
    * and if using ApiLayer, your (freemium) APILayer.com number verification API key (https://apilayer.com/marketplace/number_verification-api)
4. Go to Setup / Remote Site Settings, click on "M", and find the three settings starting with MC_.
5. Change the two MC_APIs keys to reflect the details for your MC orgs API settings.
6. In Setup, Quick Find "Marketing App Extensions".  Create a new extension and activate it, then change to its related list and create a new External Action. In Invocable Actions, select either the MC_SendSmsPEAction or the MC_CreateCasePEAction, set the defaults as appropriate, and save.  Do the same with the other invocable action.
7. Now you can add the external actions to your Engagement Studio Automations.


https://github.com/alexmcdonald/Pardot-External-Actions

This code is released as sample code only, and is not warranted in any way by me or any current or future employer.  It's released under the CC0 licence in the hope it may be useful.
