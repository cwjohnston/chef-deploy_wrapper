define :deploy_wrapper, :owner => 'root', :group => 'root', :sloppy => false do

    unless params[:ssh_wrapper_dir] and params[:ssh_key_dir] and params[:ssh_key_data]
        error_msg = "deploy_wrapper: one or more of the following required parameters were not set: \
        ssh_wrapper_dir \
        ssh_key_dir \
        ssh_key_data"
        
        Chef::Error.fatal(error_msg)
        raise
    else
        directory params[:ssh_key_dir] do
            params[:owner]
            params[:group]
            mode 0640
        end

        directory params[:ssh_wrapper_dir] do
            params[:owner]
            params[:group]
            mode 0750
            recursive true
        end

        template "#{params[:ssh_key_dir]}/#{params[:name]}_deploy_key" do
            source "ssh_deploy_key.erb"
            params[:owner]
            params[:group]
            mode 0600
            variables({ :ssh_key_data => params[:ssh_key_data] })
        end

        template "#{params[:ssh_wrapper_dir]}/#{params[:name]}_deploy_wrapper.sh" do
            source "ssh_wrapper.sh.erb"
            params[:owner]
            params[:group]
            mode 0755
            variables({
                :ssh_key_dir => params[:ssh_key_dir],
                :app_name => params[:name],
                :sloppy => params[:sloppy]
            })
        end
    end
end
