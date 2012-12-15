#!/bin/bash

SITE=$1
SITE_PATH="/var/www/server/$1/"
SITE_TEST_DIRECTORY="${SITE_PATH}tests/"

if [ -d $SITE_TEST_DIRECTORY ]; then
	echo "Testing directory already exists..."
	echo -e "I'm going to move to the side for backup and reconstruct for you\n"
	BACKUP="tests.bak."`eval date +%Y%m%d%H%M%S`
	mv $SITE_TEST_DIRECTORY $SITE_PATH$BACKUP
	echo -e "existing tests directory moved to\n$SITE_PATH$BACKUP\n"
fi

mkdir $SITE_TEST_DIRECTORY
echo "Setting up bootstrap..."

cp "$HOME/Magento/ibuildings-Mage-Test-6a7cac4/bootstrap.php" $SITE_TEST_DIRECTORY
