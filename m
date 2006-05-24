From: philipc@snapgear.com
Subject: [PATCH 1/4] TCPMSS: dont drop packets
Date: Wed, 24 May 2006 14:04:42 +1000
Message-ID: <20060524040950.838105000@snapgear.com>
References: <20060524040441.111049000@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=tcpmssdrop.patch
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

MSS clamping should be best effort, since we are doing the clamping
to avoid dropped packets.  If we can't clamp, then forward it anyway
and hope PMTU discovery works.

The test case that caused problems was syn packet containing data.

Related questions:
This patch changes the behaviour when setting the MSS too, is this
acceptable?

Should skb_make_writable() and skb_checksum_help() cause dropped packets
if they fail?

Which mangle targets should drop packets if they fail?
MARK should, since the mark may be used in filter rules.
What about DSCP, ECN, TOS, TTL?

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: linux-2.6.17-rc4.orig/net/ipv4/netfilter/ipt_TCPMSS.c
===================================================================
--- linux-2.6.17-rc4.orig.orig/net/ipv4/netfilter/ipt_TCPMSS.c	2006-05-24 11:56:47.000000000 +1000
+++ linux-2.6.17-rc4.orig/net/ipv4/netfilter/ipt_TCPMSS.c	2006-05-24 12:59:32.000000000 +1000
@@ -81,7 +81,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 			printk(KERN_ERR
 			       "ipt_tcpmss_target: bad length (%d bytes)\n",
 			       (*pskb)->len);
-		return NF_DROP;
+		return IPT_CONTINUE;
 	}
 
 	if(tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU) {
@@ -89,14 +89,14 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 			if (net_ratelimit())
 				printk(KERN_ERR
 			       		"ipt_tcpmss_target: no dst?! can't determine path-MTU\n");
-			return NF_DROP; /* or IPT_CONTINUE ?? */
+			return IPT_CONTINUE;
 		}
 
 		if(dst_mtu((*pskb)->dst) <= (sizeof(struct iphdr) + sizeof(struct tcphdr))) {
 			if (net_ratelimit())
 				printk(KERN_ERR
 		       			"ipt_tcpmss_target: unknown or invalid path-MTU (%d)\n", dst_mtu((*pskb)->dst));
-			return NF_DROP; /* or IPT_CONTINUE ?? */
+			return IPT_CONTINUE;
 		}
 
 		newmss = dst_mtu((*pskb)->dst) - sizeof(struct iphdr) - sizeof(struct tcphdr);
@@ -147,7 +147,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 			if (net_ratelimit())
 				printk(KERN_ERR "ipt_tcpmss_target:"
 				       " unable to allocate larger skb\n");
-			return NF_DROP;
+			return IPT_CONTINUE;
 		}
 
 		kfree_skb(*pskb);

--
