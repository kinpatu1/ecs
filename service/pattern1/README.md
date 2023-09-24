## ECS
yum install python3 -y

pip3 install awscli --upgrade

touch miki_from_container

aws s3 cp miki_from_container s3://miki-another/ --acl bucket-owner-full-control --region ap-northeast-1
