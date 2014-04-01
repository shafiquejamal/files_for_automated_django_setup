# 1.2
# - use PEP8 plug in to check for PEP8 (ctrl+shift+r)
# 1.3
# - import order: (1) Standard library imports (1b) Core Django imports (2) Related third-party imports (3) Local application or library specific imports
# 1.4 
# - use explicit relative imports:
# from __future__ import absolute_import
# from . import ...
# from .models import ...
# 1.6 
# - for URL pattern names (arg to url() ), use _ not -
# - use _ not - in template block names

# 4.2
# - app names: one word, plural of app's main model, short, all lowercase, no periods, no dashes, no special chars, no underscores

# 5.1 
# - put passwords, keys, etc. in environment variables

# 6.5.1 
# - model inheritance of the timestampmodel is a great idea

# 7.4 Use URL namespaces

# 9.5.1 Generate a confirmation page

# 10.6 Re-usable search mixin view


# Create a virtual environment
echo "--------------- Creating virtual environment -----------------------------------------"
echo $WORKON_HOME
echo "################ pip freeze --local BEFORE source virtualenvwrapper"
pip freeze --local
source `which virtualenvwrapper.sh` # https://stackoverflow.com/questions/7538628/virtualenvwrapper-functions-unavailable-in-shell-scripts
echo "################ pip freeze --local AFTER source virtualenvwrapper"
pip freeze --local
cd ~/allfiles/htdocs
rm -R $1
rmvirtualenv $1_venv
mkvirtualenv $1_venv --no-site-packages
echo "################ pip freeze --local BEFORE activate"
source $WORKON_HOME/$1_venv/bin/activate # https://stackoverflow.com/questions/20391943/how-to-activate-python-virtual-environment-by-shell-script
echo "################ pip freeze --local AFTER activate"
pip freeze --local
echo "################ which django-admin.py ?"
which django-admin.py
pip install Django==1.6.2
echo "################ pip freeze --local AFTER installing requirements"
pip freeze --local
echo "--------------- DONE: Creating virtual environment -----------------------------------------"


echo "--------------- Creating project -----------------------------------------------------------"
# Create the repository for the new project, and start the project
django-admin.py startproject --template=https://github.com/twoscoops/django-twoscoops-project/zipball/master --extension=py,rst,html $1
echo "################ project created, now rename to top level to $1_repo"
cp -r $1 $1_repo
rm -R $1
# make a media directory
mkdir $1_repo/$1/media
echo "################ Get rid of initial settings files and replace them with my own"
rm $1_repo/$1/$1/settings/*.pyc 
rm $1_repo/$1/$1/settings/base.py 
rm $1_repo/$1/$1/settings/local.py 
rm $1_repo/$1/$1/settings/production.py 
rm $1_repo/$1/$1/settings/test.py 
wget -c -P $1_repo/$1/$1/settings/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/base.py 
wget -c -P $1_repo/$1/$1/settings/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/local.py
wget -c -P $1_repo/$1/$1/settings/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/production.py
wget -c -P $1_repo/$1/$1/settings/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/test.py
echo "################ create a 'core' app"
cd $1_repo/$1 # This gets us into the project directory, where the apps should be placed
django-admin.py startapp core
cd ../../ # lets stay in the _repo directory by default
add2virtualenv ~/allfiles/htdocs/$1_repo/$1
# Need to change the secret key: generate a random secret_key and add it to the virtual environment: http://techblog.leosoto.com/django-secretkey-generation/
secret_key=$(python -c 'import random; import string; print "".join([random.SystemRandom().choice(string.digits + string.letters) for i in range(100)])')
echo "export SECRET_KEY='$secret_key'" >> $WORKON_HOME/$1_venv/bin/activate
databases_default_name=db_name # b$(python -c 'import random; import string; print "".join([random.SystemRandom().choice(string.digits + string.lowercase) for i in range(50)])')
echo "export databases_default_name='$databases_default_name'" >> $WORKON_HOME/$1_venv/bin/activate
databases_default_user=db_user # h$(python -c 'import random; import string; print "".join([random.SystemRandom().choice(string.digits + string.lowercase) for i in range(50)])')
echo "export databases_default_user='$databases_default_user'" >> $WORKON_HOME/$1_venv/bin/activate
databases_default_password=db_password # l$(python -c 'import random; import string; print "".join([random.SystemRandom().choice(string.digits + string.lowercase) for i in range(50)])')
echo "export databases_default_password='$databases_default_password'" >> $WORKON_HOME/$1_venv/bin/activate

echo "secret_key:$secret_key"
# Need to create database with this info
echo "databases_default_name:$databases_default_name"
echo "databases_default_user:$databases_default_user"
echo "databases_default_password:$databases_default_password"

echo "--------------- DONE: Creating project -----------------------------------------------------------"


echo "--------------- Installing the other requirements -----------------------------------------------------------"
# Need to add psycopg2==2.5.2 to support postgres
# http://www.cyberciti.biz/faq/howto-add-postgresql-user-account/
# To start the postgres client from the terminal:
#	createdb # (only once)
#	psql -h localhost
# To add a user, database, and grant priviliges:
#   CREATE DATABASE db_name;
# 	CREATE USER tom WITH PASSWORD 'myPassword';
#   GRANT ALL PRIVILEGES ON DATABASE db_name to db_user;
# To quit the client:
#	\q
# use database (\c database;), list databases (\l), users (select * from pg_user;), tables in current context (select * from pg_tables; \d):
# describe table (\d+ tablename)	
#
#
#
echo "psycopg2==2.5.2" >> $1_repo/requirements/base.txt
echo "django-extensions" >> $1_repo/requirements/base.txt
echo "django-sslify" >> $1_repo/requirements/base.txt
pip install -r $1_repo/requirements/local.txt
echo "--------------- DONE: Installing the other requirements -----------------------------------------------------------"

echo "--------------- Copying some templates, vagrant file, cheffile -----------------------------------------------------------"
echo "################ copy the base.html template"
rm $1_repo/$1/templates/base.html
wget -c -P $1_repo/$1/templates/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/base.html
wget -c -P $1_repo/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/Cheffile
wget -c -P $1_repo/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/Vagrantfile
wget -c -P $1_repo/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/uwsgi.ini
wget -c -P $1_repo/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/nginx.conf
wget -c -P $1_repo/ https://raw.github.com/shafiquejamal/files_for_automated_django_setup/master/uwsgi_params
echo "--------------- DONE: Copying some templates, vagrant file, cheffile  ----------------------------------------------------"

echo "--------------- Use vagrant to spin up the local development server ------------------------------------------------------"
cd $1_repo
librarian-chef install
vagrant up
cd ..
echo "--------------- DONE: Use vagrant to spin up the local development server ------------------------------------------------------"

echo "--------------- Creating SSL certificates ------------------------------------------------------"
cd $1_repo/
openssl genrsa -out server.key 2048
# openssl req -new -key server.key -out server.csr
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost" -keyout server.key  -out server.crt
# openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
cd ..
echo "--------------- DONE: Creating SSL certificates ------------------------------------------------------"


echo "repo:"
ls -al $1_repo/
echo "project:"
ls -al $1_repo/$1/
echo "config:"
ls -al $1_repo/$1/$1/


echo ""
echo "****************************************************************"
echo "* Now do the following:										 *"
echo "****************************************************************"
echo " "
echo "----------------------------------------------------------------"
echo "1. Create database with this info:"
echo "databases_default_name:$databases_default_name"
echo "databases_default_user:$databases_default_user"
echo "databases_default_password:$databases_default_password"
echo " "
echo "Here are the commands: "
echo "psql -h localhost "
echo "CREATE DATABASE $databases_default_name;"
createdb $databases_default_name
echo "CREATE USER $databases_default_user WITH PASSWORD '$databases_default_password';"
echo "GRANT ALL PRIVILEGES ON DATABASE $databases_default_name to $databases_default_user;"
echo " "
echo "----------------------------------------------------------------"
echo "2. Synchronize and migrate the database:"
echo "django-admin.py syncdb --settings=$1.settings.local"
echo "django-admin.py migrate --settings=$1.settings.local"
echo "django-admin.py runserver 8000 --settings=$1.settings.local"
echo " "
echo "----------------------------------------------------------------"
new_admin_url=$(python -c 'import random; import string; print "".join([random.SystemRandom().choice(string.digits + string.lowercase) for i in range(20)])')
echo "3. Change the admin URL from r'^admin/' to something r'^$new_admin_url/'" 
echo " "
echo " "
echo "----------------------------------------------------------------"
echo "4. Use vagrant to spin up a development environment:"
echo " "
echo "****************************************************************"
echo ""
echo "The skeleton repository is now set up. Here is what happens next:"
echo ""
echo " You will develop on you HOST machine, but files will be"
echo "		served from the GUEST machine. You just need to create"
echo "		a virtual environment on the GUEST machine and install"
echo "		the requirements in that virutal environment, then link"
echo "		to that virtual environment in the mysite_wsgi.ini file"
echo ""
echo " A. $ vagrant ssh 																	# access the guest machine"
echo " B. $ mkvirtualenv mysite_venv 														# on the guest"
echo " C. $ 																				# on the guest"
echo " D. $ pip install -r /vagrant/requirements/local.txt'									# on the guest"
echo " E. Create the database, role, and grant priviliges   								# on the guest"
echo " F. On the GUEST machine, simlink to the site in the project directory located on the host machine:"
echo "		sudo ln -s /vagrant/nginx.conf /etc/nginx/sites-enabled/   	# on the guest"
echo "		sudo ln -s /vagrant/uwsgi.ini /etc/uwsgi/vassals/			# on the guest"
echo ""
echo ""



