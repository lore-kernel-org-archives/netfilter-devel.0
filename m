From: Andrea Rossato <arossato@istitutocolli.org>
Subject: Re: ECN target bug report
Date: Mon, 09 Dec 2002 17:23:35 +0100
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <3DF4C387.2050509@istitutocolli.org>
References: <3DF1F442.806@istitutocolli.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010201070408020402060202"
Return-path: <netfilter-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
In-Reply-To: <3DF1F442.806@istitutocolli.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010201070408020402060202
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

attached you will find what could be a suitable, even though temporary, 
solution for ECN target.
a packet with ec and cwr bits set and a bad checksum will not be 
processed. If the checksum is good the bits will be stripped.
andrea

-- 


~  GnuGP public key for arossato@istitutocolli.org
~      http://www.istitutocolli.org/pubkey.asc



--------------010201070408020402060202
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
 

--------------010201070408020402060202--
