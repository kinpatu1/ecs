## fargateへの接続
sudo yum remove awscli  
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  
unzip awscliv2.zip  
sudo ./aws/install  
一度ec2から抜けるとv2になっている  
sudo yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm  
aws configure  
  
https://engineer-ninaritai.com/aws-fargate-exec/  
https://zenn.dev/xyz_kimua/articles/9e3cb57e4fe194  
https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-linux.html  
