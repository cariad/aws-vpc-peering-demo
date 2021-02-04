#!/bin/bash -e

echo "Linting shell scripts..."
find . -name '*.sh' -exec shellcheck -o all --severity style -x {} +

echo "Linting YAML..."
yamllint . --strict

count=0

while IFS="" read -r dir_path
do
  echo "Validating: ${dir_path}"
  aws cloudformation validate-template \
    --template-body file://"${dir_path}" > /dev/null
  count=$((count + 1))
done < <(find cloudformation-templates -name "*.cf.yml")

if [[ ${count} == 0 ]]; then
  echo "No CloudFormation templates to validate."
  exit 1
fi

zip -r                       \
    aws-vpc-peering-demo     \
    cloudformation-templates \
    LICENSE                  \
    README.md
