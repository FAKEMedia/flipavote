SHELL := /bin/bash
PATH := bin:$(PATH)

fortnox:
	flipavote makefortnox

dump:
	flipavote makedump

static:
	LANG=en LANGUAGE=en.UTF-8 LC_ALL=en_US.UTF-8 flipavote makestatic

clean:
	rm -rf public/*
	mkdir -p public/assets
	cp -af src/public/test/README.md src/public/test/README.txt

harvest:
	flipavote makeharvest

nginx:
	flipavote makenginx

eplinks:
	find templates/ -type l -delete
	find templates/ -type f | grep -P '.(js|tex|css)$$' | xargs -iö ln -s -r ö ö.ep

iso: static
	xorrisofs -r -hfsplus -joliet -V Z`date +%Y%m%d_%H%M%S` --modification-date=`date +%Y%m%d%H%M%S00` -exclude public/iso/ -output public/iso/flipavote.iso public/

torrent:
	transmission-cli -n public

isotorrent: public/iso/flipavote.iso

devtools:

i18n:
	flipavote makei18n

debug:
	MOJO_MODE=development MOJO_DAEMON_DEBUG=1 DBI_TRACE=SQL morbo -m development -l http+unix://bin%2Fflipavote.sock -l http://0.0.0.0:3000?reuse=1 -v -w ./lib -w ./templates -w ./script -w ./public/assets ./bin/flipavote

server: clean zip
	MOJO_MODE=production hypnotoad ./bin/flipavote

routes:
	flipavote routes -v

test: clean
	prove -l -v
	ls -las public/test

zip:
	find public/assets -type f -name "*.css" -exec gzip -f -k -9 {} \;
	find public/assets -type f -name "*.js" -exec gzip -f -k -9 {} \;

database:
	sudo -u postgres -i createuser --interactive --pwprompt --login --echo --no-createrole --no-createdb --no-superuser --no-replication flipavote
	sudo -u postgres -i createdb --encoding=UTF-8 --template=template0 --locale=en_US.UTF-8 --owner=flipavote flipavote "Samizdat web application"
	sudo find /etc/postgresql -name pg_hba.conf -type f -exec sed -i -E 's/\nlocal   flipavote        flipavote                      scram-sha-256//g' {} \;
	sudo find /etc/postgresql -name pg_hba.conf -type f -exec sed -i -E 's/(#\s+TYPE\s+DATABASE\s+USER\s+ADDRESS\s+METHOD)/\1\nlocal   flipavote        flipavote                      scram-sha-256/' {} \;
	sudo systemctl restart postgresql

fetchicons:
	git clone https://github.com/twbs/icons.git ./src/icons

fetchflags:
	git clone https://github.com/lipis/flag-icons.git ./src/flag-icons

fetchcountries:
	git clone https://github.com/countries/countries-data-json.git ./src/countries-data-json

fetchlanguages:
	git clone https://github.com/cospired/i18n-iso-languages.git ./src/i18n-iso-languages

speedtest:
	flipavote speedtest

webpackinit:
	npm init -y
	npm i --save-dev webpack webpack-cli webpack-dev-server html-webpack-plugin
	npm i --save-dev autoprefixer css-loader postcss-loader sass sass-loader style-loader
	npm i --save-dev purgecss purgecss-webpack-plugin
	npm i --save-dev mini-css-extract-plugin
	npm i --save-dev css-minimizer-webpack-plugin
	npm i --save-dev image-minimizer-webpack-plugin svgo sharp
	npm i --save bootstrap @popperjs/core
	npm i --save suneditor
	npm i --save bootstrap-icons
	npm i --save sprintf-js

webpack:
	mkdir -p public/assets
	npm install
	npm run build

favicon:
	convert src/svg/f.svg -background none -bordercolor white -border 0 \
	  \( -clone 0 -resize 16x16 \) \
	  \( -clone 0 -resize 32x32 \) \
	  \( -clone 0 -resize 48x48 \) \
	  \( -clone 0 -resize 64x64 \) \
      -alpha off -colors 256 -delete 0 public/favicon.ico
	gzip -f -k -9 public/favicon.ico

icons:
	flipavote makeicons

install: clean favicon icons static webpack zip
#	chown -R www-data:www-data .

import:
	flipavote makeimport

installdata:
	flipavote makeinstalldata

purgedata:
	sudo systemctl restart postgresql
#	sudo -u postgres psql -c 'TRUNCATE account.user RESTART IDENTITY;' -d flipavote -e
	sudo -u postgres psql -c 'DROP DATABASE flipavote;' -e
