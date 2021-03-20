rm -f /var/run/apache2/apache2.pid
source /etc/apache2/envvars
pg_ctlcluster 12 main start
redis-server --daemonize yes
RAILS_ENV=production bundle exec rake db:initial_setup
/usr/sbin/apache2ctl -D FOREGROUND -e info