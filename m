From: Nicolas Bouliane <nib@cookinglinux.org>
Subject: [testesuite] ipt_dscp
Date: Wed, 22 Dec 2004 02:14:46 -0500
Message-ID: <41C91EE6.4040005@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010309050903070004070208"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Samuel Jean <sjean@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
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

This is a multi-part message in MIME format.
--------------010309050903070004070208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rusty,

This is the testsuite related with the patchs I sent to you about the 
dscp implementation into nfsim.

Cheers :-)


- acidfu

--------------010309050903070004070208
Content-Type: text/plain;
 name="22ipt_dscp.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="22ipt_dscp.sim"

# Input outbound value to DSCP.
expect iptables iptables: command failed
iptables -A INPUT -m dscp --dscp 64

# Check if inputing the same option twice overwrite previous one.
expect iptables iptables: command failed
iptables -A INPUT -m dscp --dscp 1 --dscp 2

expect iptables iptables: command failed
iptables -A INPUT -m dscp --dscp-class BE --dscp-class EF

# Test for match function.
# --dscp
iptables -A INPUT -m dscp --dscp 0x01 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 DSCP=0x1 192.168.0.2 192.168.0.1 0 6 1 2 ACK}
gen_ip IF=eth0 DSCP=0x1 192.168.0.2 192.168.0.1 0 TCP 1 2 ACK

expect gen_ip send:LOCAL {IPv4 DSCP=0x2 192.168.0.2 192.168.0.1 0 6 1 2 ACK}
gen_ip IF=eth0 DSCP=0x2 192.168.0.2 192.168.0.1 0 TCP 1 2 ACK
iptables -D INPUT -m dscp --dscp 0x01 -j DROP

# --dscp-class
iptables -A INPUT -m dscp --dscp-class EF -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 DSCP=0x2e 192.168.0.2 192.168.0.1 0 6 1 2 ACK}
gen_ip IF=eth0 DSCP=0x2e 192.168.0.2 192.168.0.1 0 TCP 1 2 ACK

expect gen_ip send:LOCAL {IPv4 DSCP=0x2f 192.168.0.2 192.168.0.1 0 6 1 2 ACK}
gen_ip IF=eth0 DSCP=0x2f 192.168.0.2 192.168.0.1 0 TCP 1 2 ACK
iptables -D INPUT -m dscp --dscp-class EF -j DROP

--------------010309050903070004070208
Content-Type: text/x-patch;
 name="things-to-test.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="things-to-test.patch"

Index: things-to-test
===================================================================
--- things-to-test	(revision 3488)
+++ things-to-test	(working copy)
@@ -100,20 +100,17 @@
 ip_nat_tftp.c
 ip_nat_snmp_basic.c
 ipt_CLASSIFY.c
-ipt_DSCP.c
 ipt_ECN.c
 ipt_NETMAP.c
 ipt_REDIRECT.c
 ipt_SAME.c
 ipt_TCPMSS.c
-ipt_TOS.c
 ipt_ah.c
 ipt_conntrack.c
 ipt_dscp.c
 ipt_ecn.c
 ipt_esp.c
 ipt_helper.c
-ipt_length.c
 ipt_pkttype.c
 ipt_tcpmss.c
 ---------------------

--------------010309050903070004070208--
