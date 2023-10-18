#!/bin/bash
liebiao(){
cat <<EOF
Command action
        h       Show help
        1       Set a static IP address
        2       Set the host name
        3       Configure the YUM source base and epel
        4       The firewall and selinux are permanently turned off
        q       exit
EOF
}
while true
do
        read -p "Command (h for help): " i
        case $i in
        h)liebiao ;;
        1)
                # read -p "请输入你想要改的网卡名字:" ipname
                ipname=ifcfg-ens33
                read -p "Please enter IP:" ip
                ipa=192.168.128.
                ip=$ipa$ip
                echo $ip
                # read -p "请输入网关:" gateway
                oldip=`cat /etc/sysconfig/network-scripts/$ipname | grep IPADDR | cut -d "=" -f2`
                echo $oldip
                # oldgateway=`cat /etc/sysconfig/network-scripts/$ipname | grep GATEWAY | cut -d "\"" -f2`
                sed -i "s/IPADDR=$oldip/IPADDR=$ip/" /etc/sysconfig/network-scripts/$ipname
                systemctl restart network
                ifconfig
        # sed -i "s/${oldgateway}/${gateway}/" /etc/sysconfig/network-scripts/$ipname
        ;;
        2)
                read -p "The host name you want to set:" hostname
                hostnamectl set-hostname $hostname
        ;;
        3)
                read -p "Please enter the source you want to configure (1 or 0):" repo
                if [ $repo -eq 1 ]
                then
                        wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
                        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
                fi
        ;;
        4)
                systemctl disable --now firewalld
                setenforce 0
                sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
        ;;
        q)
                exit
        ;;
        esac
done
