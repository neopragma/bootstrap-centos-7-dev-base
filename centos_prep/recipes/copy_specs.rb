# Copy specs from bootstrap directory to chefspec directory

bash 'copy specs from bootstrap dir to chefspec dir' do 
  code <<-EOF
    mkdir -p /root/chef-repo/cookbooks/centos_prep/spec/unit/recipes
    cp -r /root/bootstrap-centos-7-dev-base/centos_prep/spec/* /root/chef-repo/cookbooks/centos_prep/spec/.
  EOF
end 
