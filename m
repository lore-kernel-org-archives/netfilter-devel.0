From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/39]: ipt_TCPMSS: misc cleanup
Date: Wed, 20 Sep 2006 10:23:59 +0200 (MEST)
Message-ID: <20060920082450.14636.18814.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_TCPMSS: misc cleanup

- remove debugging cruft
- remove printk for reallocation failures
- remove unused addition

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 78cd435225fca1420030a898433ae7eae9ab0cf6
tree eb429a0d0fddd69a4bcafc05def8b7521e1d6ced
parent a33f866d48a8ce0f83293a6ee1dbfd4a5345499f
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:11 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:11 +0200

 net/ipv4/netfilter/ipt_TCPMSS.c |   36 ++----------------------------------
 1 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
index b2d3c4f..4246c43 100644
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -21,12 +21,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables TCP MSS modification module");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
 static inline unsigned int
 optlen(const u_int8_t *opt, unsigned int offset)
 {
@@ -106,16 +100,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 							   htons(oldmss)^0xFFFF,
 							   htons(newmss),
 							   tcph->check, 0);
-
-			DEBUGP(KERN_INFO "ipt_tcpmss_target: %u.%u.%u.%u:%hu"
-			       "->%u.%u.%u.%u:%hu changed TCP MSS option"
-			       " (from %u to %u)\n",
-			       NIPQUAD((*pskb)->nh.iph->saddr),
-			       ntohs(tcph->source),
-			       NIPQUAD((*pskb)->nh.iph->daddr),
-			       ntohs(tcph->dest),
-			       oldmss, newmss);
-			goto retmodified;
+			return IPT_CONTINUE;
 		}
 	}
 
@@ -127,13 +112,8 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 
 		newskb = skb_copy_expand(*pskb, skb_headroom(*pskb),
 					 TCPOLEN_MSS, GFP_ATOMIC);
-		if (!newskb) {
-			if (net_ratelimit())
-				printk(KERN_ERR "ipt_tcpmss_target:"
-				       " unable to allocate larger skb\n");
+		if (!newskb)
 			return NF_DROP;
-		}
-
 		kfree_skb(*pskb);
 		*pskb = newskb;
 		iph = (*pskb)->nh.iph;
@@ -149,8 +129,6 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 					   htons(tcplen) ^ 0xFFFF,
 				           htons(tcplen + TCPOLEN_MSS),
 					   tcph->check, 1);
-	tcplen += TCPOLEN_MSS;
-
 	opt[0] = TCPOPT_MSS;
 	opt[1] = TCPOLEN_MSS;
 	opt[2] = (newmss & 0xff00) >> 8;
@@ -170,16 +148,6 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	iph->check = nf_csum_update(iph->tot_len ^ 0xFFFF,
 				    newtotlen, iph->check);
 	iph->tot_len = newtotlen;
-
-	DEBUGP(KERN_INFO "ipt_tcpmss_target: %u.%u.%u.%u:%hu"
-	       "->%u.%u.%u.%u:%hu added TCP MSS option (%u)\n",
-	       NIPQUAD((*pskb)->nh.iph->saddr),
-	       ntohs(tcph->source),
-	       NIPQUAD((*pskb)->nh.iph->daddr),
-	       ntohs(tcph->dest),
-	       newmss);
-
- retmodified:
 	return IPT_CONTINUE;
 }
 
