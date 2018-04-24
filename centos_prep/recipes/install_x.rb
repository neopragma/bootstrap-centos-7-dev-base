# Install X Windows client and server and openbox window manager.

package 'epel-release'
package 'openbox'
package 'rxvt-unicode-256color'
package 'urw-fonts'

bash 'copy openbox configuration files to user root' do 
  code <<-EOF
    mkdir -p /root/.config/openbox 
    cp -r /root/bootstrap-centos-7-dev-base/openbox/* /root/.confit/openbox/.
    EOF 
end 

bash 'copy openbox configuration files to user developer' do 
  code <<-EOF
    mkdir -p /home/developer/.config/openbox
    cp -r /root/bootstrap-centos-7-dev-base/openbox/* /home/developer/.config/openbox/.
    chown -R developer /home/developer/.config/openbox
    chgrp -R developer /home/developer/.config/openbox
  EOF
end 
