#! /bin/bash

TESTPATH="testing"
COVFILE="coverage.info"

# a dbus session is needed
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
	## if not found, launch a new one
	eval `dbus-launch --sh-syntax`
	echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi

echo "use $DBUS_SESSION_BUS_ADDRESS as dbus address"

# build for testing
mkdir $TESTPATH
cd $TESTPATH
qmake .. DEFINES+=TRAVIS DEFINES+=DBUS
make

# run the test clients
xvfb-run -a -e /dev/stdout ./harbour-shmoose lhs &
xvfb-run -a -e /dev/stdout ./harbour-shmoose rhs &
cd ..

# build the test
cd test/integration_test/ClientCommunicationTest/
mkdir build
cd build
qmake ..
make
xvfb-run -a -e /dev/stdout ./ClientCommunicationTest
cd ../../../..

# collect the coverage info
lcov --capture --directory $TESTPATH --output-file $COVFILE
# remove system files from /usr and generated moc files
lcov --remove $COVFILE '/usr/*' --output-file $COVFILE
lcov --remove $COVFILE '*/test/moc_*' --output-file $COVFILE

# Uploading report to CodeCov
bash <(curl -s https://codecov.io/bash) -f $COVFILE || echo "failed upload to Codecov"
