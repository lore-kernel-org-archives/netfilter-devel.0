From: Andrea Rossato <mailing_list@istitutocolli.org>
Subject: Re: ECN target bug report
Date: Mon, 09 Dec 2002 22:19:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DF508CA.6000107@istitutocolli.org>
References: <3DF1F442.806@istitutocolli.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040305000300000508030809"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3DF1F442.806@istitutocolli.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040305000300000508030809
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

attached you will find 3 patches. the first one is an attempt to prove 
the existence of the problem. the second is just a hack that provides a 
temporary solution it's just a workaround: packets with ec e cwr bits 
set and good checksum will be stripped and checksum recalculated from 
scratch.

The problem, as far as I can see it, could be located in csum_partial 
(arch/i386/lib/checksum.S, meaning a platform dependent problem): i'm 
not a kernel hacker (i'm a lawyer, a legal scholar actually), but i do 
not see any mistake in the way partial checksum is carried out in 
tcp_etc_set. anyway checksum after partial or total recalculation 
differ. That's a fact. Evidence of the fact  can be gained with the 
second patch: in this case the kernel will log the checksum after 
partial recalculation and after total recalculation (that means that two 
calculations will take place). The two values differ!

Thanks for your attention.

1. check the bug:
echo 1 /proc/sys/net/ipv4/tcp_ecn
iptables -A OUTPUT -t mangle -o ppp0 -p tcp -d my.host.org --dport 80 -j 
ECN --ecn-tcp-remove
iptables -A OUTPUT -o ppp0 -p tcp -d my.host.org --dport 80 -m unclean 
-j DROP
packets will be dropped

2. apply one of the patches and try again:
packets will get though and the connection will be established.

andrea



--------------040305000300000508030809
Content-Type: text/plain;
 name="ecn_csum_with_debug_info.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ecn_csum_with_debug_info.patch"

--- linux-2.4.20/net/ipv4/netfilter/ipt_ECN.c.orig	2002-12-09 10:44:03.000000000 +0100
+++ linux-2.4.20/net/ipv4/netfilter/ipt_ECN.c	2002-12-09 10:48:46.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <net/checksum.h>
+#include <net/tcp.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
@@ -62,6 +63,7 @@
 	struct tcphdr *tcph = (void *) iph + iph->ihl * 4;
 	u_int16_t *tcpflags = (u_int16_t *)tcph + 6;
 	u_int16_t diffs[2];
+	u_int32_t tcplen;
 
 	/* raw socket (tcpdump) may have clone of incoming
 	 * skb: don't disturb it --RR */
@@ -92,6 +94,17 @@
 		tcph->check = csum_fold(csum_partial((char *)diffs,
 		                                    sizeof(diffs),
 		                                    tcph->check^0xFFFF));
+
+		printk(KERN_WARNING "ECN: checksum after partial recalculation \"%x\"\n", tcph->check );
+		
+		tcplen = (*pskb)->len - iph->ihl*4;
+		tcph->check = 0;
+		tcph->check = tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+				   csum_partial((char *)tcph, tcph->doff*4,
+					   (*pskb)->csum));
+
+		printk(KERN_WARNING "ECN: checksum after total recalculation \"%x\"\n", tcph->check );
+
 		(*pskb)->nfcache |= NFC_ALTERED;
 
 		return 1;



--------------040305000300000508030809
Content-Type: text/plain;
 name="ecn_checksum.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ecn_checksum.patch"

--- linux-2.4.20/net/ipv4/netfilter/ipt_ECN.c.orig	2002-12-09 10:44:03.000000000 +0100
+++ linux-2.4.20/net/ipv4/netfilter/ipt_ECN.c	2002-12-09 17:16:11.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <net/checksum.h>
+#include <net/tcp.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
@@ -62,6 +63,7 @@
 	struct tcphdr *tcph = (void *) iph + iph->ihl * 4;
 	u_int16_t *tcpflags = (u_int16_t *)tcph + 6;
 	u_int16_t diffs[2];
+	u_int32_t tcplen;
 
 	/* raw socket (tcpdump) may have clone of incoming
 	 * skb: don't disturb it --RR */
@@ -74,6 +76,15 @@
 		iph = (*pskb)->nh.iph;
 	}
 
+
+	/* Checksum invalid?  Ignore. */
+	/* FIXME: Source route IP option packets --RR */
+	tcplen = (*pskb)->len - iph->ihl*4;
+	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+			 csum_partial((char *) tcph, tcplen, 0))) {
+		return 0;
+	}
+
 	diffs[0] = *tcpflags;
 
 	if (einfo->operation & IPT_ECN_OP_SET_ECE
@@ -87,13 +98,12 @@
 	}
 	
 	if (diffs[0] != *tcpflags) {
-		diffs[0] = htons(diffs[0]) ^ 0xFFFF;
-		diffs[1] = htons(*tcpflags);
-		tcph->check = csum_fold(csum_partial((char *)diffs,
-		                                    sizeof(diffs),
-		                                    tcph->check^0xFFFF));
+		tcph->check = 0;
+		tcph->check = tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+				   csum_partial((char *)tcph, tcph->doff*4,
+					   (*pskb)->csum));
 		(*pskb)->nfcache |= NFC_ALTERED;
-
+	
 		return 1;
 	}
 

--------------040305000300000508030809--
