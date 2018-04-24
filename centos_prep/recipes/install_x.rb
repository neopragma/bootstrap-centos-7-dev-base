# Install X Windows client and server and openbox window manager.

execute 'install x window support' do
  command "$(yum -y groupinstall 'X Window System')"
end

package 'epel-release'
package 'openbox'
package 'rxvt-unicode'

bash 'copy openbox configuration files to user developer' do 
  code <<-EOF
    mkdir -p /home/developer/.config/openbox
    cp -r /root/bootstrap-centos-7-dev-base/openbox/* /home/developer/.config/openbox/.
    chown -R dev /home/developer/.config/openbox
    chgrp -R dev /home/developer/.config/openbox
  EOF
end 
