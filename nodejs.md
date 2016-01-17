# Nodejs

To install nodejs with npm (the package manager) use:

    sudo apt-get install nodejs npm

NOTE: If the above fails, try to install `node` instead of `nodejs`.

Then see your node version with: 

    node --version

###How Node Works
Node does not do anything until you start installing packages. 
There are a few ways to install packages, they all rely on the **npm package manager**.

This will install a package called gulp **globally** so you can use it anywhere:

    sudo npm install -g gulp
    gulp

This will install bower **locally** to your user folder, if you have the correct permissions:

    npm install bower
    
Lastly is the `packages.json` file, you can create this file with `node init` or manually in a text editor. The file looks something like this:

**packages.json**
```
{
  "name": "my_package",
  "version": "1.0.0",
  "dependencies": {
    "my_dep": "^1.0.0"
  },
  "devDependencies" : {
    "my_test_framework": "^3.1.0"
  }
}
```

You can look on [npmjs.com](http://npmjs.com) to find packages to add to your dependencies.

Wherever your `packages.json` file is located, when you run `npm install` it will install all the packages to a folder called `node_modules`. If that folder is a project you **do not** want to upload the node_modules, it is a huge waste of time, you would just re-install them if you moved computers or worked on a team.

**.gitignore**
```
`node_modules
npm-debug.log*
.npm
```

###Managing Versions

Clear NPM's cache:

    sudo npm cache clean -f
    
Install a helper called `n`

    sudo npm install -g n
    
Useing **n** Install latest stable NodeJS version

    sudo n stable
  
To use a specific version from a menu:

    sudo n
    
Or if you know your version, quickly swap to a specific version:

    sudo n 0.8.20
