# The *PURCHASE!* App

A starter package used by the [2GP Handbook](http://google.com) from **ISV Bedrock**.

## Step One (Recommended): Create a New Repository from this Template Repository

This project is published as a GitHub template repository. Any GitHub user can be quickly create their own copy using this template repo.

1. Open the [2GP Starter Package](https://github.com/sfdx-isv/2gp-starter-package) repo on GitHub.
2. Click the **Use this template** button at the top-right of the page.
3. Select the **Create a new repository** option. 

After creating a new repository from this template repo...

1. Click the **Code** button.
2. Copy the **HTTPS** URL of your repo to the clipboard.
3. Use your repo's URL to run the following command in your terminal.
   ```bash
   git clone PASTE_YOUR_REPO_URL_HERE
   ```

## Step One (Alternative): Clone This Repository

If you don't want to create your own copy of this repo, simply run the following command in your terminal to get started.

```bash
git clone https://github.com/sfdx-isv/2gp-starter-package.git 
```

## Step Two: Follow the 2GP Handbook for ISVs

Once you've cloned this project to your dev environment, follow the exercises in the [2GP Handbook for ISVs](http://google.com) to learn how to build second-generation managed packages.

## Additional Resources for 2GP

- [Deep Dive: 2GP for ISVs](https://trailhead.salesforce.com/users/isv-platform-experts/trailmixes/deep-dive-2gp)
- [Salesforce DX for ISVs](https://trailhead.salesforce.com/users/isv-platform-experts/trailmixes/salesforce-dx-for-isvs)
- [Documentation for Second-Generation Packaging (2GP)](https://trailhead.salesforce.com/users/isv-platform-experts/trailmixes/documentation-for-2gp)


# List of `sf` Commands Related to the Starter Package Project

## Package Creation

Create new managed package (must update namespace in `sfdx-project.json` and `force-app/main/default/flows/Approve_Purchase_Orders.flow-meta.xml` first).
```bash
sf package create -n "PURCHASE! Starter Package" -r "force-app" -t "Managed"
```

Create a package version.
```bash
sf package version create  -c -x -w 10 -d "config/package-scratch-def.json" -p "PURCHASE! Starter Package"
```



## Subscriber Testing

Create a Subscriber Test scratch org.
```bash
sf org create scratch -a "SubscriberTestScratchOrg" -f "config/subscriber-scratch-def.json"
```

Install a package version in the Subscriber Test scratch org.
```bash
sf package install -p "PURCHASE! Starter Package@0.1.0-1" -w 10 -s "AllUsers" -o "SubscriberTestScratchOrg"
```

Assign the `PURCHASE_User` permission set to the default user in the Subscriber Test scratch org.
```bash
sf org assign permset -n "PURCHASE_User" -o "SubscriberTestScratchOrg"
```

Open the Subscriber Test scratch org directly into Setup.  
If you normally use Chrome, add the `-b "firefox"`. If you normally use Firefox, add `-b "chrome"` instead.
This way it's easy to know you're operating in your scratch org because it's a different browser than you normally use.
```bash
sf org open -o "SubscriberTestScratchOrg" -p "/lightning/setup/SetupOneHome/home" -b "firefox"
```



## Package Development

Create a Package Development scratch org as your project's default org.
```bash
sf org create scratch -d -a "PackageDevOrg" -f "config/package-scratch-def.json"
```

Deploy package source to the default (Package Development) scratch org.
```bash
sf project deploy start
```

Assign the `PURCHASE_User` permission set to the default (Package Development) scratch org user.
Note this is optional. It is not needed if you're only making declarative changes.
```bash
sf org assign permset -n "PURCHASE_User"
```

Open the default (Package Development) scratch org.
If you normally use Chrome, add the `-b "firefox"`. If you normally use Firefox, add `-b "chrome"` instead.
This way it's easy to know you're operating in your scratch org because it's a different browser than you normally use.
```bash
sf org open -b "firefox"
```

Retrieve changes from the default (Package Development) scratch org.
```bash
sf project retrieve start
```



## Deleting Scratch Orgs

Delete Subscriber Test scratch org
```bash
sf org delete scratch -p -o "SubscriberTestScratchOrg"
```

Delete Package Development scratch org
```bash
sf org delete scratch -p -o "PackageDevOrg"
```
