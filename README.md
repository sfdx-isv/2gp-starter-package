# 2GP Starter Package

A simple starter package used by the [2GP Handbook for ISVs](http://google.com).

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


## Placeholder for `sf` Commands

Create new managed package (must specify namespace in `sfdx-project.json` first)
```
sf package create -n "PURCHASE! Starter Package" -r force-app -t Managed
```

Create package development scratch org
```
sf org create scratch -d -a PKG-DEV:starter-package -f config/scratch-def.json
```

Deploy package source to default scratch org
```
sf project deploy start
```

Assign permission set to the default user
```
sf org assign permset -n PURCHASE_User
```

Open the default scratch org in Firefox
```
sf org open -b firefox
```

Retrieve changes from the package development scratch org
```
sf project retrieve start
```


Delete package development scratch org
```
sf org delete scratch -p -o PKG-DEV:starter-package
```

