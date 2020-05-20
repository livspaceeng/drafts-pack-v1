#!/bin/bash
pack=$1
appName=$2
org=$3
tag=$4

curl -o chart.zip -L https://github.com/livspaceeng/draft-charts/archive/master/${tag}.zip
mkdir charting
unzip chart.zip -d charting
rm -rf chart.zip
mv charting/draft-charts-master/packs/$pack/* ./
find . -depth -type d -name charts -execdir mv {} $appName \;
mkdir charts
mv $appName charts
mv preview charts
cp ./values.yaml charts/$appName
ls la 
ls la $pwd
grep -rl 'REPLACE_ME_APP_NAME' ./ | xargs -I@ sed -i "s/REPLACE_ME_APP_NAME/$appName/g" @
grep -rl 'REPLACE_ME_ORG' ./ | xargs -I@ sed -i "s/REPLACE_ME_ORG/$org/g" @
grep -rl $pack charts/$appName/Chart.yaml | xargs -I@ sed -i "s/$pack/$appName/g" @
rm -rf charting
ls -la $pwd
cd charts/$appName
ls -la
ls -la $pwd
make replace
make release