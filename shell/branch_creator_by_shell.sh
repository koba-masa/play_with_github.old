#!/bin/sh

REPOSITORY_CONFIG="shell/config/repositories.conf"

BASE_BRANCH="develop"

if [ $# -ne 2 ]; then
  echo "[ERROR] A mount of paramater is wrong."
  exit
fi

new_branch_name=$1
repositories=`cat ${REPOSITORY_CONFIG}`
work_dir=`pwd`
release_date=$2

if [[ "${new_branch_name}" =~ ^release/.*_emergency$ ]]; then
  release_type_name="緊急"
elif [[ "${new_branch_name}" =~ ^release/monthly_update_[0-9]{6}.*$ ]]; then
  release_type_name="月次"
elif [[ "${new_branch_name}" =~ ^release/[0-9]{8}$ ]]; then
  release_type_name="通常"
else
  echo "[ERROR] Branch name is wrong.:${new_branch_name}"
  exit
fi

commit_message="${release_date} ${release_type_name}リリース"

echo "[INFO ] チェック"
echo "  branch_name      : ${new_branch_name}"
echo "  release_type_name: ${release_type_name}"
echo "  release_date     : ${release_date}"
echo "  branches         : "
for repository in ${repositories}
do
  echo "    ${repository}"
done

echo "Is it OK?[Y/n]:"
read answer
if [ "${answer}" != "Y" ]; then
  echo "[INFO ] Process is abort."
  exit
fi

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
