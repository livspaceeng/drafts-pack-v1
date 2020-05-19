#!/bin/bash
echo $1
echo $2
echo $3

curl -o chart.zip -L https://github.com/livspaceeng/draft-charts/archive/master.zip
ls -la
mkdir charting
unzip chart.zip -d charting
rm -rf chart.zip
ls -la $pwd
ls -la charting
mv charting/draft-charts-master/packs/$1/* ./
find . -depth -type d -name charts -execdir mv {} $2 \;
mkdir charts
mv $2 charts
mv preview charts
ls -la $pwd
grep -rl 'REPLACE_ME_APP_NAME' ./ | xargs -I@ sed -i "s/REPLACE_ME_APP_NAME/$2/g" @
grep -rl 'REPLACE_ME_ORG' ./ | xargs -I@ sed -i "s/REPLACE_ME_ORG/$3/g" @
grep -rl $1 charts/$2/Chart.yaml | xargs -I@ sed -i "s/$1/$2/g" @
rm -rf charting
ls -la
ls -la $pwd
cd charts/$2
ls -la
ls -la $pwd
make replace
make release 
