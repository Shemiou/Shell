#!/bin/bash
export LANG=en_US.UTF-8

if [ "$#" -lt 2 ]; then
	echo "wrong paramters count, exit"
    exit
fi

# working path
pushd `dirname $0` > /dev/null
base_working_path=`pwd`
popd > /dev/null

#分区前后端库
group=$1

#当前开发分支
develop_branch=$2

#前端分支：QAtujiabnb
fe_dir_ac="fe/bnb_activity"
fe_dir_bnb="fe/bnb_tujia"
fe_branch="QAtujiabnb"
#后端分支：bnbservice
service_dir="bnbservice"
service_branch="tujiabnb"

#指定目录下拉取代码
if [[ ${group} = "fe2" ]]; then
	#拉取前端代码
	work_dir=${fe_dir_ac}
	work_branch=${fe_branch}
elif [[ ${group} = "fe1" ]]; then
    #拉取前端代码
    work_dir=${fe_dir_bnb}
    work_branch=${fe_branch}
elif [[ ${group} = "service" ]]; then
	#拉取后端代码
	work_dir=${service_dir}
	work_branch=${service_branch}
fi


for dir in `ls`; do
	#进入指定文件夹
	if [[ -d ${work_dir} ]]; then
		cd ${work_dir}

		#检查本地版本库当前连接的远程版本库
    	git config remote.origin.url

    	#把远程版本库的变化同步到本地
    	git fetch origin

		#获取 master 分支当前的SHA1
		SHA_master=`git log -1 --format="%H" origin/master`
		echo "●●●●●●●●●●●●●●●●●●●●  SHA_master:${SHA_master}    "

		#获取当前分支名
        git checkout ${work_branch}

		current_branch=`git symbolic-ref --short -q HEAD`
        echo "current_branch : ${current_branch}"

		if [[ ${work_branch} == ${current_branch} ]]; then
			#清除当前库中未提交的变更
			git reset --hard
			#清除本地库中构建过程生成的中间产物
#git clean -dqxf
			echo "●●●●●●●●●●●●●●●●●●●●  pull from bnb    "
			#拉取代码
			git pull

			#检查主干上的提交是否都已合并到QA分支
			exist=`git log origin/${work_branch} ^${SHA_master} --oneline`
			echo "●●●●●●●●●●●●●●●●●●●●  SHA_master\n${exist}    "

			#如果未合并master，先merge
			if [[ ${exist} != "" ]]; then
				#merge远端分支
				echo "●●●●●●●●●●●●●●●●●●●●  git merge --no-ff master   "
				git merge --no-ff --commit --log origin/master -m "git merge origin/master"
			fi
			

			echo "●●●●●●●●●●●●●●●●●●●●  git merge --no-ff origin/${develop_branch}    "
			git merge --no-ff --commit --log origin/${develop_branch} -m "git merge origin/${develop_branch} "

			# log
			git_log=`git --no-pager log --pretty=format:"%an%x09%ad%x09%s" --date=format:'%m/%d %H:%M' --after="yesterday"`
			echo "●●●●●●●●●●●●●●●●●●●●  git_log:  	●●●●●●●●●●●●●●●●●●●●"
			echo "${git_log}"
			
			echo "●●●●●●●●●●●●●●●●●●●●  push to bnbservice  "
            git push
		fi
	fi
done
