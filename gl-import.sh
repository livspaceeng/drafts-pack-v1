
url=$1
pack=$2

if [ "$#" -ne 2 ]; then
  echo "
Usage: git-init4.sh <repo-url> <lang-pack>

Eg: To import https://gitlab.com/livspaceengg/core-infra/ls-scheduler.git using gradle pack 

git-init4.sh https://gitlab.com/livspaceengg/core-infra/ls-scheduler.git gradle

All list of supported packs are at https://github.com/livspaceeng/drafts-pack-v1/tree/master/packs

" >&2
  exit 1
fi


reg="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)[\/:]([^\/:]+)[\/.](.+).git$"

if [[ $url =~ $reg ]]; then    
    protocol=${BASH_REMATCH[1]}
    separator=${BASH_REMATCH[2]}
    hostname=${BASH_REMATCH[3]}
    org=${BASH_REMATCH[4]}
    group=${BASH_REMATCH[5]}
    app=${BASH_REMATCH[6]}
fi

org=$org
group=$group
app=$app
pack=$2
awsRegion=ap-southeast-1
httpUrl=https://gitlab.com/$org/$group/$app

### Application Repo Validation

git ls-remote $httpUrl
if [ $? -ne 0 ]; then
   echo "No such repo exists, "$url
   exit 1
fi

### Pack Validation

curl -I  https://github.com/livspaceeng/drafts-pack-v1/tree/master/packs/$pack | grep "404 Not Found"
if [ $? -eq 0 ]; then
  echo "$pack pack doesn't exist."
  echo "All list of supported packs are at https://github.com/livspaceeng/drafts-pack-v1/tree/master/packs"
  exit 1
fi

### Draft charts validation if draft chart pack exists

curl -I  https://github.com/livspaceeng/draft-charts/tree/master/packs/$pack | grep "404 Not Found"
if [ $? -eq 0 ]; then
  echo "$pack charts pack doesn't exist in draft-charts"
  echo "All list of supported packs are at https://github.com/livspaceeng/draft-charts/tree/master/packs"
  exit 1
fi

# tmpfile=$(mktemp /tmp/aws-ecr.XXXXXX)
# kubeapp=`echo ${app} | sed -e 's/\(.*\)/\L\1/' | sed -r 's/[_ ]+/-/g'`
# aws --region ${awsRegion} ecr create-repository --repository-name ${org}/${kubeapp} &> ${tmpfile}

# if [ $? -ne 0 ]; then 
#    cat ${tmpfile} | grep "'${org}/${kubeapp}' already exists" > /dev/null
#    if [ $? -ne 0 ]; then
# 	echo "Unable to create ${org}/${kubeapp} repo in ECR"
# 	cat ${tmpfile}
# 	exit 2
#    else
# 	echo "${org}/${kubeapp} already exists in ECR, ignoring ECR creation" 
#    fi
# else 
# 	echo "Successfully created ${org}/${kubeapp} in ECR"
# fi

# rm -rf ${tmpfile}


git clone $url
echo "Cloning done"
cd $app

curl -o ${pack}.zip -L https://github.com/livspaceeng/drafts-pack-v1/archive/master.zip
mkdir ${pack}
unzip ${pack}.zip -d ${pack}
rm -rf ${pack}.zip


mv ${pack}/drafts-pack-v1-master/packs/${pack}/.[!.]* ./
mv ${pack}/drafts-pack-v1-master/packs/${pack}/* ./
rm -rf ${pack}

egrep -rl 'REPLACE_ME_APP_NAME' ./ | xargs -I@ sed -i '' "s/REPLACE_ME_APP_NAME/$app/g" @
egrep -rl 'REPLACE_ME_ORG' ./ | xargs -I@ sed -i '' "s/REPLACE_ME_ORG/$org/g" @
egrep -rl 'REPLACE_ME_GROUP_NAME' ./ | xargs -I@ sed -i '' "s/REPLACE_ME_GROUP_NAME/$group/g" @
egrep -rl 'REPLACE_ME_httpUrl_NAME' ./ | xargs -I@ sed -i '' "s#REPLACE_ME_httpUrl_NAME#$httpUrl#g" @
egrep -rl 'REPLACE_ME_PACK_NAME' ./ | xargs -I@ sed -i '' "s/REPLACE_ME_PACK_NAME/$pack/g" @

git add .
git commit -m "Added pack files"
git push origin master
echo "Commit pushed"
