sfdx shane:org:create -a ltngshare -f config/project-scratch-def.json -s -d 1 -o ltng.share --userprefix shane
sfdx force:mdapi:deploy -d experienceBundlePilot -w 20
sfdx force:source:deploy -p boilerplate

# for mobile
sfdx shane:user:password:set -g User -l User -p sfdx1234 

sfdx force:source:push -f
sfdx shane:communities:publish
sfdx force:user:permset:assign -n TestingPerms
sfdx force:user:permset:assign -n LightningOnMobile

sfdx force:apex:execute -f scripts/roleAssign.cls 
sfdx force:apex:execute -f scripts/communityUserCreate.cls 

# create some records
sfdx force:data:tree:import -f data/PrivateTestObject__c.json
sfdx force:data:tree:import -f data/ReadOnlyTestObject__c.json

# for security testing
sfdx force:user:create generatepassword=true FirstName=Test LastName=Privilege permsets=TestingPerms profileName="Standard User"

sfdx force:org:open