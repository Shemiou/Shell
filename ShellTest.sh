#/bin/bash
echo "Is it morning? Please answer yes or no."
read YES_OR_NO
if [ "$YES_OR_NO" = "yes" ]; then
echo "Good morning!"
elif [ "$YES_OR_NO" = "no" ]; then
echo "Good afternoon!"
else
echo "Sorry, $YES_OR_NO not recognized. Enter yes or no."
exit 1
fi
if [ "$#" -lt 2 ]; then
echo "wrong paramters count, exit"
exit
fi

git_branch=$1
build_type=$2

mail_group=$3
if [ -z $3 ]; then
mail_group='develop'
fi
echo "$# and $@ and ${1} and ${2} and $3"

if [ "$#" -lt 3 -a "$3" == "develop" ]; then
echo "参数总个数小于3 and 第三个参数值为develop"
elif [ "$#" -gt 2 -a "$3" == "develop" ]; then
echo "参数总个数大于2 and 第三个参数值为develop"
else
echo "false"
fi

s=0
i=0
while [ "$i" != "100" ]
do
i=$(($i+1))
s=$(($s+$i))
done
echo "result is => $s"

pushd `dirname $0` > /dev/null
working_path=`pwd`
popd > /dev/null

cd ${working_path}
echo $working_path
