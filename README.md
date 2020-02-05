# Git Pull Request and Review Steps

### Step 1: 
Create a branch
```
git pull
git checkout -b cb_dev
```

### Step 2: 
Perform changes in branch

### Step 3: 
Push the changes to branch
```
git status
git add .
git commit -m "added dev branch"
git push origin cb_dev
```

### Step 4: 
Open Pull Request tab in the repo in Github portal

### Step 5: 
Recently pushed branch should be visible with changes highlighted

### Step 6: 
Review the changes and Create Pull Request

### Step 7: 
If the changes are fine, merge the branch code into Master branch

The above steps in the background invoking the Webhooks and Events API.
It can be used to post Git status to external portals for tracking

### Other Requirements: (Below requirement is tentative, and may change during the actual implementation phase.)
- Create an Github app that will be subscribed to the events of the repo
- We may need to link  the app to process the repo webhooks and get the responses background
- Using the responses build a json response and send it to external portal.  

### Creating webhooks
- Refer the Github developer documentation on, how to enable a webhook for a repo or organisation
- Github develop documentation on [Creating Webhooks](https://developer.github.com/webhooks/creating/)
- While setting up Webhook, we need to provide Payload URL. It requires exposing localhost of a server.
- Steps to setup localhost server exposed to internet is provided below.

### Configuring a server localhost exposed to internet 
#### Steps
- Using ngrok we can expose a localhost to internet
- First, we'll install a program to expose our local host to the Internet. We'll use ngrok to do this. ngrok is a free download available for all major operating systems
- When you're done with that, you can expose your localhost by running `./ngrok http 4567` on the command line. You should see a line that looks something like this:
```
Forwarding    http://7e9ea9dc.ngrok.io -> 127.0.0.1:4567
```
- Copy that `*.ngrok.io` URL! We're now going to go back to the Payload URL and pasting this server into that field. It should look something like `http://7e9ea9dc.ngrok.io/payload.`
- By doing this, we've set ourselves up to expose our localhost at path /payload to the Internet.
