From: =?gb2312?q?Lee=20Erngy?= <iderngylee@yahoo.com.cn>
Subject: # What's wrong with my IpTables+Squid?
Date: Sat, 14 Sep 2002 16:09:15 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020914080915.79130.qmail@web15101.mail.bjs.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm a university student in Harbin, Hei Longjiang
Province, China.
I have realized a firewall totally with iptables.
But now I want to establish a transparent firewall
with Iptables+Squid.
This firewall only offer http service.
The following is my two configure files. But when I
test it at a client computer
(192.168.0.78) I found the IE can't browse anything!
It's speed was so slow that
it couldn't get in touch with the web site any more.
Can you help solve my problem? Thank you very much!
your sincere!

# #########################
# Firewall:
# #########################

#=====  Complete stateful firewall script. Maintained
by Li Guangzhe
#!/bin/bash

#=====  Some varities
UPLINK="eth0"
UPIP="a.b.c.d"
NAT="a.b.c.d"
INTERFACES="lo eth0 eth1"
SERVICES="http ftp smtp telnet"

#=====  Display information that we start the firewall
service
echo "Starting firewall..."

#=====  Refresh all chains
/sbin/iptables -F
/sbin/iptables -F -t nat

#=====  Refuse Access From Internet
#iptables -P INPUT DROP
#iptables -A INPUT -i ! ${UPLINK} -j ACCEPT
#iptables -A INPUT -m state --state
ESTABLISHED,RELATED -j ACCEPT

#=====  Enable some services that comes from outside
for x in ${SERVICES}
do
/sbin/iptables -A INPUT -p tcp --dport ${x} -m state
--state NEW -j ACCEPT
done

#=====  If there are some attackers, cheat them
/sbin/iptables -A INPUT -p tcp -i ${UPLINK} -j REJECT
--reject-with tcp-reset
/sbin/iptables -A INPUT -p udp -i ${UPLINK} -j REJECT
--reject-with icmp-port-un

#=====  Explicitly disable ECN
if [ -e /proc/sys/net/ipv4/tcp_ecn ]
then
echo 0 > /proc/sys/net/ipv4/tcp_ecn
fi

#=====  Disable spoofing on all interfaces
for x in ${INTERFACES}
do
echo 1 > /proc/sys/net/ipv4/conf/${x}/rp_filter
done

#=====  Load Necessary Module
echo 1 > /proc/sys/net/ipv4/ip_forward
/sbin/modprobe ip_tables
/sbin/modprobe ip_nat_ftp
/sbin/modprobe ip_conntrack_ftp
/sbin/iptables -t nat -A POSTROUTING -o ${UPLINK} -j
SNAT --to ${UPIP}

#=====  Enbale LAN access The Internet
/sbin/iptables -A FORWARD -s 192.168.0.0/24 -j ACCEPT
/sbin/iptables -t nat -A POSTROUTING -o eth0 -s
192.168.0.0/24 -j MASQUERADE

#=====  Use Squid Proxy HTTP Service
/sbin/iptables -t nat -A PREROUTING -p tcp -s
192.168.0.78 --dport 80 -j  DNAT --to 192.168.0.1:8080

#=====  Tell Firewall builded
echo    "Firewall established successfully!"


# #########################
# squid.conf:
# #########################
visible_hostname mpc
http_port 8080
cache_mem 32 MB
cache_swap_low 90
cache_swap_high 95
maximum_object_size 4096 KB
cache_dir ufs /var/cache/squid 100 16 256
cache_access_log /var/log/squid/access.log
cache_log /var/log/squid/cache.log
cache_store_log /var/log/squid/store.log
#cache_dns_program /usr/lib/squid/dnsserver
#dns_nameservers 192.168.0.1
dns_nameservers 202.118.224.101
unlinkd_program /usr/lib/squid/unlinkd

acl all src 0.0.0.0/0.0.0.0
acl allow_ip src 192.168.0.0/24
acl manager proto cache_object
acl localhost src 192.168.0.1/255.255.255.255
acl SSL_ports port 443 563
acl Safe_ports port 80 21 443 563 70 210 1025-65535
acl CONNECT method CONNECT

http_access allow allow_ip
httpd_accel_host virtual
httpd_accel_port 80
httpd_accel_with_proxy on
httpd_accel_uses_host_header on
httpd_accel_single_host off

_________________________________________________________
Do You Yahoo!? 
新鲜到底,娱乐到家 - 雅虎推出免费娱乐电子周报!
http://cn.ent.yahoo.com/newsletter/index.html
