#!/bin/sh

REPOSITORY_CONFIG="shell/config/repositories.conf"

BASE_BRANCH="develop"

if [ $# -ne 1 ]; then
  echo "[ERROR] A mount of paramater is wrong."
  exit
fi

new_branch_name=$1
repositories=`cat ${REPOSITORY_CONFIG}`
work_dir=`pwd`
commit_message="hoge"

for repository in ${repositories}
do
  cd "${repository}"
  git checkout ${BASE_BRANCH}
  if [ $? -ne 0 ]; then
    echo "[WARN ] To checkout(${BASE_BRANCH}) was failed.:${repository}"
    continue
  fi
  git fetch
  git pull origin ${BASE_BRANCH}
  if [ $? -ne 0 ]; then
    echo "[WARN ] To pull was failed.:${repository}"
    continue
  fi
  git checkout -b ${new_branch_name}
  if [ $? -ne 0 ]; then
    echo "[WARN ] To checkout(${new_branch_name}) was failed.:${repository}"
    continue
  fi
  git commit -m "${commit_message}" --allow-empty
  if [ $? -ne 0 ]; then
    echo "[WARN ] To commit was failed.:${repository}"
    continue
  fi
  git push origin ${new_branch_name}
  if [ $? -ne 0 ]; then
    echo "[WARN ] To commit was failed.:${repository}"
    continue
  fi
done

cd "${work_dir}"
