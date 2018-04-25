# CentOS 7: Build Base for Lightweight Development Environments

For general information about this repo and related ones, please see [Provision Lightweight Development Environments](http://github.com/neopragma/provision-lightweight-development-environments).

## From -> To

**From:** No operating system installed.

**To:** CentOS configured to receive provisioning to customize it for software development.

## 1. Install CentOS 7

### 1.1. Download iso

Download the "Minimal ISO" from <a href="https://www.centos.org/download/">https://www.centos.org/download/</a>.

### 1.2. Install CentOS 7.

Install CentOS 7 as a VM (any [hypervisor](hypervisor.md)). 

On the "users" panel:

Set the root password to 'admin'. 

Dreate user 'developer' with password 'developer' and give it administrator privileges.  

Note: On most of these setups, the standard user is 'dev'. That name is reserved for system use on CentOS.

## 2. Provision the instance as a "base" for development environments.

This will install enough software on the instance to enable it to be used as a template for building software development environments tailored to different programming languages and development/testing tools. 

### 2.1. Start networking.

CentOS minimal ships with networking turned off. Turn it on. Log on as root.

```shell 
dhclient
```

### 2.2. Install git.

The provisioning scripts are on Github. The instance needs git support to clone the repository and complete the configuration. 

```shell 
yum -y install git 
``` 

### 2.3. Clone the repository.

Log on as root.

Clone the repository for building a template instance from CentOS 7:

```shell 
git clone git://github.com/neopragma/bootstrap-centos-7-dev-base
``` 

### 2.4. (Optional) Review default configuration and modify as desired.

If you want your template to be configured differently than the default, make the necessary changes to bash scripts, Chef recipes, and configuration files. 

In particular, look at:

- ubuntu_prep/recipes/install_neovim.rb - the ```pip2 --install``` command will probably not work if you are running this with ssh. When testing, I had to run it while logged into the target instance as root. Even if run locally, people have reported problems with it on Ubuntu 16.04. 
- openbox/autostart - this contains xrandr commands corresponding to the monitor I used when testing the script. There were problems with Ubuntu 16.04 getting Xorg configuration to work as documented. Including xrandr settings in the autostart file is a brute-force workaround. You might want to try configuring X the usual way on your instance, and it might work. 

The directory structure of the provisioning repository looks like this:

```
bootstrap-ubuntu-server-16.04-base/
    bootstrap              Bash script to prepare the instance to run Chef
                           and kick off the Chef cookbook that completes
                           the provisioning.

    scripts/               ```bootstrap``` copies these files to /usr/local/bin.
        cli                Escape from OpenBox to command line from terminal
        provision          Run the Chef cookbook to provision the instance
        cook               Run one Chef cookbook or cookbook::recipe
        recipes            List the available Chef recipes for provisioning
        runchefspec        Run `bundle exec rake` to run rspec on Chef recipes

    ubuntu_prep/           ```bootstrap``` copies these files to prepare Chef
        Gemfile            => /root/chef-repo/cookbooks/ubuntu_prep/
        Rakefile           => /root/chef-repo/cookbooks/ubuntu_prep/
        recipes/           => /root/chef-repo/cookbooks/ubuntu_prep/
        spec/
            spec_helper.rb => /root/chef-repo/cookbooks/ubuntu_prep/spec
            unit/recipes/  => /root/chef-repo/cookbooks/ubuntu_prep/spec/unit/recipes

    neovim/                Chef recipe ```install_neovim``` performs these copies.
                           => /root/.config/nvim/
                           => /dev/.config/nvim/

    openbox/               Chef recipe ```install_x``` performs these copies.
                           => /dev/.config/openbox/
```

### 2.5. Run the bootstrap script.

If all goes well, this will provision the instance as a base or template for building development environments. Check the results carefully in case of errors. There are many steps and anything can happen despite care in preparing the script. 

```shell 
cd /root/bootstrap-centos-7-dev-base
./bootstrap
``` 

### 3. Post-installation manual steps 

#### 3.1. Chef doesn't install the X Window System 

I was unable to get the X Window installation to work through Chef. Log in as root and run yum from a command line:

```shell 
yum -y groupinstall 'X Window System'
```

#### 3.2. Scripted install of python pip fails

For unknown reasons, python pip installs did not work when executed as part of a script or a Chef recipe. Run them on the command line:

```shell
easy_install-3.4 pip 
pip2 install --upgrade pip 
pip2 install --user neovim 
pip3 install --user neovim 
```

#### 3.3. Enable NeoVim plugins after installation 

Enable NeoVim plugins that require the :UpdateRemotePlugins command: 

- Start neovim 
- Run the editor command :UpdateRemotePlugins
- Quit neovim

#### 3.4. Optionally create aliases 

CentOS does not have an ```editor``` symlink like Debian-based distros have. You can add an alias at the end of ```.bashrc```:

```shell 
alias editor='nvim' 
``` 

#### 3.5. Difficulties starting openbox session 

As noted under 5.1 below, I wasn't able to get this system to start an openbox session in the same way as other systems. You can add an alias at the end of ```.bashrc``` for convenience:

```shell 
alias gui='xinit /bin/openbox-session'
```

### 4. Known issues with the bootstrap process

Real solutions to these issues would be welcome:

- Chef limitations for yum groupinstall, as noted above under 3.1 above. 
- CentOS oddities with regard to python/pip installs, as noted above under 3.2 above.

#### 4.1. rvm issues 

25 Apr 2018. Using rvm to install Ruby 2.4.4 (required by Chef 2.0.28), install appears to work but when logged in as 'developer' and starting irb, the irb history file is written at RVM_HOME instead of HOME, resulting in 'permission denied'.

According to [this report](https://stackoverflow.com/questions/46636056/ruby-irbrc-history-system-wide-how-to-make-it-local) the solution is to run:

```shell 
rvm get head
rvm reinstall 2.4.4
``` 

Unfortunately, the ```rvm get head``` command gets gpg errors and the ```rvm reinstall 2.4.4``` command will not run afterwards. 

One user suggests deleting the irb history file at ```/usr/local/rvm/rubies/ruby-2.4.1/.irbrc_history```. 

This seems to work, but does not "feel" like a reliable solution. Be alert to potential problems.

### 5. Known issues after system comes up

#### 5.1. Starting an X session 

For unknown reasons, the following commands do not work on this environment for starting an openbox session:

```shell 
startx 
xinit
xinit openbox-session 
``` 

This is the only way I found to start the session:

```shell 
xinit /bin/openbox-session
``` 
