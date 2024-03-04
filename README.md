# The *PURCHASE!* App

A starter package used by the [2GP Handbook](http://google.com) from **ISV Bedrock**.

## Step One: Clone This Repository

Run this command in your terminal to get started

```bash
git clone https://github.com/sfdx-isv/2gp-starter-package.git 
```

## Step Two: Follow the 2GP Handbook for ISVs

Once cloned, follow the exercises in the [2GP Handbook for ISVs](http://google.com) to learn how to build second-generation managed packages.

## Additional Resources for 2GP

- [Deep Dive: 2GP for ISVs](https://trailhead.salesforce.com/users/isv-platform-experts/trailmixes/deep-dive-2gp)
- [Salesforce DX for ISVs](https://trailhead.salesforce.com/users/isv-platform-experts/trailmixes/salesforce-dx-for-isvs)
- [Documentation for Second-Generation Packaging (2GP)](https://trailhead.salesforce.com/users/isv-platform-experts/trailmixes/documentation-for-2gp)


## List of `sf` Commands Related to the Starter Package Project

### Package Creation

Create new managed package (must specify namespace in `sfdx-project.json` first)
```bash
sf package create -n "PURCHASE! Starter Package" -r "force-app" -t "Managed"
```

Create a package version
```bash
sf package version create  -c -x -w 10 -d "config/scratch-def.json" -p "PURCHASE! Starter Package"
```



### Subscriber Testing

Create a Subscriber Test scratch org
```bash
sf org create scratch -d -a "SubscriberTestOrg" -f "config/subscriber-scratch-def.json"
```

Install a package version
```bash
sf package install -p "PURCHASE! Starter Package@0.1.0-1" -w 10 -s "AllUsers" -o "SubscriberTestOrg"
```

Assign the `PURCHASE_User` permission set to the default user in the Subscriber Test org.
```bash
sf org assign permset -n "PURCHASE_User" -o "SubscriberTestOrg"
```

Open the Subscriber Test Org directly into Setup.
```bash
sf org open -o "SubscriberTestOrg" -p "/lightning/setup/SetupOneHome/home" -b "firefox"
```



### Package Development

Create package development scratch org
```bash
sf org create scratch -d -a "PackageDevOrg" -f "config/package-scratch-def.json"
```

Deploy package source to default scratch org
```bash
sf project deploy start -o "PackageDevOrg"
```

Assign the `PURCHASE_User` permission set to the default user (Optional - Not needed if you're only making declarative changes).
```bash
sf org assign permset -n "PURCHASE_User" -o "PackageDevOrg"
```

Open the Package Development scratch org in Firefox
```bash
sf org open -o "PackageDevOrg" -b "firefox"
```

Retrieve changes from the package development scratch org
```bash
sf project retrieve start -o "PackageDevOrg"
```



### Delete Scratch Orgs

Delete Subscriber Test scratch org
```bash
sf org delete scratch -p -o "SubscriberTestOrg"
```

Delete Package Development scratch org
```bash
sf org delete scratch -p -o "PackageDevOrg"
```
