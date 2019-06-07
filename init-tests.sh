#! /bin/bash

export MOODLE_DOCKER_WWWROOT=/var/www/moodlebehat/
export MOODLE_DOCKER_DB=mariadb
export MOODLE_DOCKER_WEB_HOST=webserver
export MOODLE_DOCKER_BROWSER=firefox
export MOODLE_DOCKER_PHP_VERSION=7.1

bin/moodle-docker-compose down

bin/moodle-docker-compose up -d
bin/moodle-docker-wait-for-db

docker run -d -p4444:4444 selenium/standalone-firefox:2.53.1-beryllium

bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/init.php --tags="@plagiarism_turnitin" -j 2 -o
bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/run.php --tags="@plagiarism_turnitin" -v --format=pretty --out=std > /root/behat-`date +"%Y-%m-%d"`-turnitin.log

#bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/init.php --tags blocks_quickmail -j 2 -o
#bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/run.php -v --format=pretty --out=std > /root/behat-`date +"%Y-%m-%d"`-quickmail.log

#bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/run.php -v --format=pretty --out=std > /root/behat-`date +"%Y-%m-%d"`.log