From: "webmaster @ elnportal.it" <webmaster@elnportal.it>
Subject: Re: ipsec01-02-03-04 installation problem
Date: Sun, 22 Jan 2006 13:57:29 +0100
Message-ID: <00f401c61f53$6e586030$0201a8c0@gorionstable>
References: <BAY103-F166820039D0DD7F961ADB2B21C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="Windows-1252";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Marco Berizzi" <pupilla@hotmail.com>,
	<netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Here the passages followed for installing iptables with SNAT support through 
ipsec tunnel:

1_ Downloaded from kernel.org 2.6.16-rc1.tar.bz2 kernel
2_ untarred it to /usr/src
3_ make mrproper
4_ copy an old .config file from 2.6.14 sources (Fedora Core 4)
5_ ln -s linux-2.6.16-rc1/ linux
6_ make oldconfig (hitting enter on all query)
7_ make menuconfig
8_ XFRM [IPSec] Networking Security Hooks
9_ Exit and save kernel configuration
10_ make all
11_ make modules_install
12_ make install
13_ reboot

14_ rpm -e --nodep iptables
15_ untar tarball (snapshot of iptables)
16_ make (under src directory of iptables)
17_ make install
18_ iptables -L

iptables v1.3.4-20060121: can't initialize iptables table `filter': iptables 
who? (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.

Seeking for modules under /lib/modules/2.6.16-rc1/kernel/net/ipv4/netfilter

I could see only

-rw-r--r--  1 root root  196238 22 gen 14:15 ip_conntrack_amanda.ko
-rw-r--r--  1 root root  227391 22 gen 14:15 ip_conntrack_ftp.ko
-rw-r--r--  1 root root  208996 22 gen 14:15 ip_conntrack_irc.ko
-rw-r--r--  1 root root 1136548 22 gen 14:15 ip_conntrack.ko
-rw-r--r--  1 root root  167689 22 gen 14:15 ip_conntrack_netbios_ns.ko
-rw-r--r--  1 root root  295709 22 gen 14:15 ip_conntrack_netlink.ko
-rw-r--r--  1 root root  340536 22 gen 14:15 ip_conntrack_pptp.ko
-rw-r--r--  1 root root  171796 22 gen 14:15 ip_conntrack_proto_sctp.ko
-rw-r--r--  1 root root  193359 22 gen 14:15 ip_conntrack_tftp.ko
-rw-r--r--  1 root root  232080 22 gen 14:15 ip_queue.ko

If I look under my previously installed kernel I can see ( 
/lib/modules/2.6.14-1.1656_FC4/kernel/net/ipv4/netfilter):

-rwxr--r--  1 root root  7032  6 gen 04:37 arptable_filter.ko
-rwxr--r--  1 root root 23680  6 gen 04:37 arp_tables.ko
-rwxr--r--  1 root root  6000  6 gen 04:37 arpt_mangle.ko
-rwxr--r--  1 root root 10096  6 gen 04:37 ip_conntrack_amanda.ko
-rwxr--r--  1 root root 13816  6 gen 04:37 ip_conntrack_ftp.ko
-rwxr--r--  1 root root 12656  6 gen 04:37 ip_conntrack_irc.ko
-rwxr--r--  1 root root 93392  6 gen 04:37 ip_conntrack.ko
-rwxr--r--  1 root root  6760  6 gen 04:37 ip_conntrack_netbios_ns.ko
-rwxr--r--  1 root root 39808  6 gen 04:37 ip_conntrack_netlink.ko
-rwxr--r--  1 root root 21152  6 gen 04:37 ip_conntrack_pptp.ko
-rwxr--r--  1 root root 16840  6 gen 04:37 ip_conntrack_proto_sctp.ko
-rwxr--r--  1 root root  8832  6 gen 04:37 ip_conntrack_tftp.ko
-rwxr--r--  1 root root  5744  6 gen 04:37 ip_nat_amanda.ko
-rwxr--r--  1 root root  7864  6 gen 04:37 ip_nat_ftp.ko
-rwxr--r--  1 root root  6448  6 gen 04:37 ip_nat_irc.ko
-rwxr--r--  1 root root 31960  6 gen 04:37 ip_nat.ko
-rwxr--r--  1 root root 13216  6 gen 04:37 ip_nat_pptp.ko
-rwxr--r--  1 root root 19112  6 gen 04:37 ip_nat_snmp_basic.ko
-rwxr--r--  1 root root  4992  6 gen 04:37 ip_nat_tftp.ko
-rwxr--r--  1 root root 21032  6 gen 04:37 ip_queue.ko
-rwxr--r--  1 root root  8536  6 gen 04:37 iptable_filter.ko
-rwxr--r--  1 root root  8432  6 gen 04:37 iptable_mangle.ko
-rwxr--r--  1 root root 16048  6 gen 04:37 iptable_nat.ko
-rwxr--r--  1 root root  6288  6 gen 04:37 iptable_raw.ko
-rwxr--r--  1 root root 37424  6 gen 04:37 ip_tables.ko
-rwxr--r--  1 root root  5392  6 gen 04:37 ipt_addrtype.ko
-rwxr--r--  1 root root  5112  6 gen 04:37 ipt_ah.ko
-rwxr--r--  1 root root  5592  6 gen 04:37 ipt_CLASSIFY.ko
-rwxr--r--  1 root root 16288  6 gen 04:37 ipt_CLUSTERIP.ko
-rwxr--r--  1 root root  4736  6 gen 04:37 ipt_comment.ko
-rwxr--r--  1 root root  5280  6 gen 04:37 ipt_connbytes.ko
-rwxr--r--  1 root root  5232  6 gen 04:37 ipt_connmark.ko
-rwxr--r--  1 root root  5720  6 gen 04:37 ipt_CONNMARK.ko
-rwxr--r--  1 root root  5856  6 gen 04:37 ipt_conntrack.ko
-rwxr--r--  1 root root  7040  6 gen 04:37 ipt_dccp.ko
-rwxr--r--  1 root root  4728  6 gen 04:37 ipt_dscp.ko
-rwxr--r--  1 root root  6040  6 gen 04:37 ipt_DSCP.ko
-rwxr--r--  1 root root  5632  6 gen 04:37 ipt_ecn.ko
-rwxr--r--  1 root root  7016  6 gen 04:37 ipt_ECN.ko
-rwxr--r--  1 root root  5112  6 gen 04:37 ipt_esp.ko
-rwxr--r--  1 root root 17056  6 gen 04:37 ipt_hashlimit.ko
-rwxr--r--  1 root root  5656  6 gen 04:37 ipt_helper.ko
-rwxr--r--  1 root root  4864  6 gen 04:37 ipt_iprange.ko
-rwxr--r--  1 root root  4728  6 gen 04:37 ipt_length.ko
-rwxr--r--  1 root root  6056  6 gen 04:37 ipt_limit.ko
-rwxr--r--  1 root root 15800  6 gen 04:37 ipt_LOG.ko
-rwxr--r--  1 root root  5216  6 gen 04:37 ipt_mac.ko
-rwxr--r--  1 root root  5088  6 gen 04:37 ipt_mark.ko
-rwxr--r--  1 root root  6592  6 gen 04:37 ipt_MARK.ko
-rwxr--r--  1 root root  8008  6 gen 04:37 ipt_MASQUERADE.ko
-rwxr--r--  1 root root  6144  6 gen 04:37 ipt_multiport.ko
-rwxr--r--  1 root root  5232  6 gen 04:37 ipt_NETMAP.ko
-rwxr--r--  1 root root  5224  6 gen 04:37 ipt_NFQUEUE.ko
-rwxr--r--  1 root root  5424  6 gen 04:37 ipt_NOTRACK.ko
-rwxr--r--  1 root root  5576  6 gen 04:37 ipt_owner.ko
-rwxr--r--  1 root root  5264  6 gen 04:37 ipt_physdev.ko
-rwxr--r--  1 root root  4736  6 gen 04:37 ipt_pkttype.ko
-rwxr--r--  1 root root  5208  6 gen 04:37 ipt_realm.ko
-rwxr--r--  1 root root 20632  6 gen 04:37 ipt_recent.ko
-rwxr--r--  1 root root  5256  6 gen 04:37 ipt_REDIRECT.ko
-rwxr--r--  1 root root 11064  6 gen 04:37 ipt_REJECT.ko
-rwxr--r--  1 root root  5840  6 gen 04:37 ipt_SAME.ko
-rwxr--r--  1 root root  5920  6 gen 04:37 ipt_sctp.ko
-rwxr--r--  1 root root  5168  6 gen 04:37 ipt_state.ko
-rwxr--r--  1 root root  5496  6 gen 04:37 ipt_string.ko
-rwxr--r--  1 root root  5768  6 gen 04:37 ipt_tcpmss.ko
-rwxr--r--  1 root root  8248  6 gen 04:37 ipt_TCPMSS.ko
-rwxr--r--  1 root root  4552  6 gen 04:37 ipt_tos.ko
-rwxr--r--  1 root root  6040  6 gen 04:37 ipt_TOS.ko
-rwxr--r--  1 root root  5208  6 gen 04:37 ipt_ttl.ko
-rwxr--r--  1 root root  6048  6 gen 04:37 ipt_TTL.ko
-rwxr--r--  1 root root 14120  6 gen 04:37 ipt_ULOG.ko


What I'm missing when I try to compile 2.6.16 kernel ?

TY
