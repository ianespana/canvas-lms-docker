#!/bin/bash
pg_ctlcluster 12 main start
redis-server --daemonize yes
psql canvas_production -c 'select count(*);' -t > assert.tmp
line=$(head -n 1 assert.tmp)
if ! [ $line -ge 2 ]; then
  RAILS_ENV=production bundle exec rake db:initial_setup
fi
rm assert.tmp
/etc/init.d/canvas_init start
echo "canvasuser:${EMAIL_OUTGOING_ADDRESS}" > /etc/ssmtp/revaliases
apache2ctl -D FOREGROUND -e info