GITHUB_TOKEN=$1
BRANCH=$2


git fetch https://$GITHUB_TOKEN:x-oauth-basic@github.com/robocin/ssl-coach.git

git reset --hard origin/$BRANCH

git checkout $BRANCH

git pull https://$GITHUB_TOKEN:x-oauth-basic@github.com/robocin/ssl-coach.git



qmake ssl-coach.pro -spec linux-g++ && make -j8

cd run-ssl-coach
qmake run-ssl-coach.pro -spec linux-g++ && make -j8
cd ..