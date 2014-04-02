# Automated set-up of an https only development server 

This script will set up a skeleton django project and a vagrant box for serving the django project via https only. It uses `nginx` + `uwsgi`

## Some credits

I took a lot from others. I am using the "two scoops of django" approach of Greenfield and Roy. I use files from their website and git repository. More info on their great work is at [twoscoopspress.org]. I got the base vagrant box from [rove.io]. I got instructions on how to package my own box from [abhishek-tiwari.com]. Many commands for setting up uwsgi and nginx are from [uwsgi-docs.readthedocs.org], and for the base template I took a design from the [Twitter Bootstrap 3 samples] page. 

## How to use it

This script works well on OS X 10.9.2. If you're using a Linux distrubution, you might run into some problems. If so, please let me know.

cd into the directory in which you want the project repository located:

    cd ~/
execute the file (make sure you've changed the permissions to make it executable) tsd_cheatsheet_v2p0.sh from this directory:
    /path/to/tsd_cheatsheet_v2p0.sh NAME_OF_YOUR_PROJECT

The script will do its magic. At the end, there are instructions on what to do after. These are (change NAME_OF_YOUR_PROJECT to the name of your project):

cd into the project repository:

    cd NAME_OF_YOUR_PROJECT_repo
    vagrant up
    vagrant ssh   
    mkvirtualenv NAME_OF_YOUR_PROJECT_venv
    pip install -r /vagrant/requirements/local.txt
    sudo -u postgres psql # create the database as per the instructions that the script will output
    \l 	# done in psql 
    \du	# done in psql 
    \q 	# done in psql 
    /etc/init.d/nginx restart
    sudo uwsgi --emperor /etc/uwsgi/vassals --uid vagrant --gid vagrant

You should be able to access the server on your host machine using the following url:
    
    https://localhost:8443

## Some aspects you might want to configure, after the install

You access the server on your host machine using the following url:
    
    https://localhost:8443

You might want to use a different port. In this case, in the file `nginx.conf` in the project repository, change `8443` to something else. Ditto for port `8000`.

## License

This project was put together by Shafique Jamal, and is released under the Apache 2.0 license. See the LICENSE file in this repository. You are free to use/modify/sell/ignore/laugh at/distribute it. Enjoy!

[twoscoopspress.org]: http://twoscoopspress.org/
[rove.io]: http://rove.io/
[abhishek-tiwari.com]: http://abhishek-tiwari.com/hacking/creating-a-new-vagrant-base-box-from-an-existing-vm
[uwsgi-docs.readthedocs.org]: http://uwsgi-docs.readthedocs.org/en/latest/tutorials/Django_and_nginx.html
[Twitter Bootstrap 3 samples]: http://getbootstrap.com/getting-started/#examples
