# Jay Harris's dotfiles for Windows

A collection of PowerShell files for Windows, including common application installation through `Chocolatey` and `npm`, and developer-minded Windows configuration defaults. 

## Installation

Note: You must have your execution policy set to unrestricted (or at least in bypass) for this to work: `Set-ExecutionPolicy Unrestricted`.

### Git-free install

> **Note:** You must have your execution policy set to unrestricted (or at least in bypass) for this to work. To set this, run `Set-ExecutionPolicy Unrestricted` from a PowerShell running as Administrator.

```@Install notes:

    * Navigate to project root, with cmd-line
    * type powershell +ENTER, if not already in the PS cmd
    * type ./setup/install.ps1 +ENTER

    Some logging may appear read, or show errors - at worst, an application didn't get installed - sometimes it's already installed
```

### Sensible Windows defaults

When setting up a new Windows PC, you may want to set some Windows defaults and features, such as showing hidden files in Windows Explorer and installing IIS. This will also set your machine name and full user name, so you may want to modify this file before executing.

```post
.\windows.ps1
```

### Install dependencies and packages

When setting up a new Windows box, you may want to install some common packages, utilities, and dependencies. These could include node.js packages via [NPM](https://www.npmjs.org), [Chocolatey](http://chocolatey.org/) packages, Windows Features and Tools via [Web Platform Installer](https://www.microsoft.com/web/downloads/platform.aspx), and Visual Studio Extensions from the [Visual Studio Gallery](http://visualstudiogallery.msdn.microsoft.com/).

```posh
.\deps.ps1
```

> The scripts will install Chocolatey, node.js, and WebPI if necessary.

> **Visual Studio Extensions**  
> Extensions will be installed into your most current version of Visual Studio. You can also install additional plugins at any time via `Install-VSExtension $url`. The Url can be found on the gallery; it's the extension's `Download` link url.

## Adapted from original author

| [Jay Harris](http://twitter.com/jayharris/) |

## Thanks to…

* @[Mathias Bynens](http://mathiasbynens.be/) for his [OS X dotfiles](http://mths.be/dotfiles), which this repository is modeled after.
