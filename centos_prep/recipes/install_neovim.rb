# install and configure neovim editor

apt_repository 'neovim-ppa' do 
  uri          'ppa:neovim-ppa/stable'
end 

package 'python-pip'
package 'python34-setuptools'

#bash 'install python3-pip' do 
#  code <<-EOF 
#    easy_install-3.4 pip 
#    EOF 
#end 

package 'neovim'

#bash 'add python support to neovim' do
#  code <<-EOF
#    pip2 install --upgrade pip 
#    pip2 install --user neovim
#    pip3 install --user neovim 
#    EOF
#end

directory 'root nvim autoload directory' do 
  path '/root/.config/nvim/autoload' 
  recursive true 
  owner 'root'
  group 'root'
  mode '0755'
end 

directory 'root nvim bundle directory' do 
  path '/root/.config/nvim/bundle' 
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
end 

execute 'install pathogen plugin' do
  command "$(curl -LSso /root/.config/nvim/autoload/pathogen.vim https://tpo.pe/pathogen.vim)"
end

git 'install neovim plugin deoplete' do
  destination '/root/.config/nvim/bundle/deoplete'
  repository 'git://github.com/Shougo/deoplete.nvim.git'
end

git 'install neovim plugin neomake' do 
  destination '/root/.config/nvim/bundle/neomake' 
  repository 'git://github.com/neomake/neomake'
end
git 'install nerdtree plugin to neovim' do 
  destination '/root/.config/nvim/bundle/nerdtree' 
  repository 'git://github.com/scrooloose/nerdtree.git' 
end 

git 'install neovim plugin nerdtree-git-plugin' do 
  destination '/root/.config/nvim/bundle/nerdtree-git-plugin'
  repository 'git://github.com/Xuyuanp/nerdtree-git-plugin.git'
end  

git 'install neovim plugin bash-support' do 
  destination '/root/.config/nvim/bundle/bash-support' 
  repository 'git://github.com/WolfgangMehner/bash-support.git' 
end 

git 'install neovim plugin c-support' do 
  destination '/root/.config/nvim/bundle/c-support'
  repository 'git://github.com/WolfgangMehner/c-support.git' 
end 

git 'install neovim plugin python-mode' do 
  destination '/root/.config/nvim/bundle/python-mode' 
  repository 'git://github.com/klen/python-mode.git'
end

git 'install neovim plugin vim-ruby' do
  destination '/root/.config/nvim/bundle/vim-ruby' 
  repository 'git://github.com/vim-ruby/vim-ruby.git'
end 
 
directory 'root nvim after indent' do
  path '/root/.config/nvim/after/indent'
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
end 

bash 'copy neovim after indent files' do
  code <<-EOF
    cp /root/bootstrap-centos-7-dev-base/neovim/after/indent/* /root/.config/nvim/after/indent/.
    EOF
end

# Add Spacegray color scheme to neovim 
directory 'root nvim pack vendor directory' do
  path '/root/.config/nvim/pack/vendor/start'
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
end 

git 'install Spacegray plugin to neovim' do 
  destination '/root/.config/nvim/pack/vendor/start/Spacegray' 
  repository 'git://github.com/ajh17/Spacegray.vim' 
end 

# copy neovim configuration files to dev user space

bash 'copy neovim configuration files and set ownership' do
  code <<-EOF
    cp /root/bootstrap-centos-7-dev-base/neovim/init.vim /root/.config/nvim/. 
    mkdir -p /home/developer/.config/nvim 
    cp -r /root/.config/nvim/* /home/developer/.config/nvim/.
    chown -R developer /home/developer
    chgrp -R developer /home/developer
    chown -R developer /home/developer/.config 
    chgrp -R developer /home/developer/.config
    chown -R developer /home/developer/.config/nvim 
    chgrp -R developer /home/developer/.config/nvim
    EOF
end

