From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/38] netfilter: utils: move nf_ip6_checksum* from ipv6 to utils
Date: Fri, 20 Jul 2018 15:08:33 +0200
Message-ID: <20180720130906.27687-6-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

similar to previous change, this also allows to remove it
from nf_ipv6_ops and avoid the indirection.

It also removes the bogus dependency of nf_conntrack_ipv6 on ipv6 module:
ipv6 checksum functions are built into kernel even if CONFIG_IPV6=m,
but ipv6/netfilter.o isn't.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h |  5 ---
 net/ipv6/netfilter.c           | 62 ----------------------------------
 net/netfilter/utils.c          | 76 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 65 insertions(+), 78 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 288c597e75b3..c0dc4dd78887 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -30,11 +30,6 @@ struct nf_ipv6_ops {
 	void (*route_input)(struct sk_buff *skb);
 	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
-	__sum16 (*checksum)(struct sk_buff *skb, unsigned int hook,
-			    unsigned int dataoff, u_int8_t protocol);
-	__sum16 (*checksum_partial)(struct sk_buff *skb, unsigned int hook,
-				    unsigned int dataoff, unsigned int len,
-				    u_int8_t protocol);
 	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		     bool strict);
 	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 531d6957af36..5ae8e1c51079 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -15,7 +15,6 @@
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #include <net/xfrm.h>
-#include <net/ip6_checksum.h>
 #include <net/netfilter/nf_queue.h>
 
 int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
@@ -106,71 +105,10 @@ static int nf_ip6_route(struct net *net, struct dst_entry **dst,
 	return err;
 }
 
-__sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
-			     unsigned int dataoff, u_int8_t protocol)
-{
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
-	__sum16 csum = 0;
-
-	switch (skb->ip_summed) {
-	case CHECKSUM_COMPLETE:
-		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
-			break;
-		if (!csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
-				     skb->len - dataoff, protocol,
-				     csum_sub(skb->csum,
-					      skb_checksum(skb, 0,
-							   dataoff, 0)))) {
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			break;
-		}
-		/* fall through */
-	case CHECKSUM_NONE:
-		skb->csum = ~csum_unfold(
-				csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
-					     skb->len - dataoff,
-					     protocol,
-					     csum_sub(0,
-						      skb_checksum(skb, 0,
-								   dataoff, 0))));
-		csum = __skb_checksum_complete(skb);
-	}
-	return csum;
-}
-EXPORT_SYMBOL(nf_ip6_checksum);
-
-static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
-				       unsigned int dataoff, unsigned int len,
-				       u_int8_t protocol)
-{
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
-	__wsum hsum;
-	__sum16 csum = 0;
-
-	switch (skb->ip_summed) {
-	case CHECKSUM_COMPLETE:
-		if (len == skb->len - dataoff)
-			return nf_ip6_checksum(skb, hook, dataoff, protocol);
-		/* fall through */
-	case CHECKSUM_NONE:
-		hsum = skb_checksum(skb, 0, dataoff, 0);
-		skb->csum = ~csum_unfold(csum_ipv6_magic(&ip6h->saddr,
-							 &ip6h->daddr,
-							 skb->len - dataoff,
-							 protocol,
-							 csum_sub(0, hsum)));
-		skb->ip_summed = CHECKSUM_NONE;
-		return __skb_checksum_complete_head(skb, dataoff + len);
-	}
-	return csum;
-};
-
 static const struct nf_ipv6_ops ipv6ops = {
 	.chk_addr		= ipv6_chk_addr,
 	.route_input    	= ip6_route_input,
 	.fragment		= ip6_fragment,
-	.checksum		= nf_ip6_checksum,
-	.checksum_partial	= nf_ip6_checksum_partial,
 	.route			= nf_ip6_route,
 	.reroute		= nf_ip6_reroute,
 };
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 8980c8a0fe5c..e8da9a9bba73 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -4,6 +4,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/ip6_checksum.h>
 
 #ifdef CONFIG_INET
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
@@ -59,11 +60,69 @@ static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 	return csum;
 }
 
+__sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
+			unsigned int dataoff, u8 protocol)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	__sum16 csum = 0;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_COMPLETE:
+		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
+			break;
+		if (!csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+				     skb->len - dataoff, protocol,
+				     csum_sub(skb->csum,
+					      skb_checksum(skb, 0,
+							   dataoff, 0)))) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			break;
+		}
+		/* fall through */
+	case CHECKSUM_NONE:
+		skb->csum = ~csum_unfold(
+				csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+					     skb->len - dataoff,
+					     protocol,
+					     csum_sub(0,
+						      skb_checksum(skb, 0,
+								   dataoff, 0))));
+		csum = __skb_checksum_complete(skb);
+	}
+	return csum;
+}
+EXPORT_SYMBOL(nf_ip6_checksum);
+
+static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
+				       unsigned int dataoff, unsigned int len,
+				       u8 protocol)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	__wsum hsum;
+	__sum16 csum = 0;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_COMPLETE:
+		if (len == skb->len - dataoff)
+			return nf_ip6_checksum(skb, hook, dataoff, protocol);
+		/* fall through */
+	case CHECKSUM_NONE:
+		hsum = skb_checksum(skb, 0, dataoff, 0);
+		skb->csum = ~csum_unfold(csum_ipv6_magic(&ip6h->saddr,
+							 &ip6h->daddr,
+							 skb->len - dataoff,
+							 protocol,
+							 csum_sub(0, hsum)));
+		skb->ip_summed = CHECKSUM_NONE;
+		return __skb_checksum_complete_head(skb, dataoff + len);
+	}
+	return csum;
+};
+
 __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
-		    unsigned int dataoff, u_int8_t protocol,
+		    unsigned int dataoff, u8 protocol,
 		    unsigned short family)
 {
-	const struct nf_ipv6_ops *v6ops;
 	__sum16 csum = 0;
 
 	switch (family) {
@@ -71,9 +130,7 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		csum = nf_ip_checksum(skb, hook, dataoff, protocol);
 		break;
 	case AF_INET6:
-		v6ops = rcu_dereference(nf_ipv6_ops);
-		if (v6ops)
-			csum = v6ops->checksum(skb, hook, dataoff, protocol);
+		csum = nf_ip6_checksum(skb, hook, dataoff, protocol);
 		break;
 	}
 
@@ -83,9 +140,8 @@ EXPORT_SYMBOL_GPL(nf_checksum);
 
 __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, unsigned int len,
-			    u_int8_t protocol, unsigned short family)
+			    u8 protocol, unsigned short family)
 {
-	const struct nf_ipv6_ops *v6ops;
 	__sum16 csum = 0;
 
 	switch (family) {
@@ -94,10 +150,8 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 					      protocol);
 		break;
 	case AF_INET6:
-		v6ops = rcu_dereference(nf_ipv6_ops);
-		if (v6ops)
-			csum = v6ops->checksum_partial(skb, hook, dataoff, len,
-						       protocol);
+		csum = nf_ip6_checksum_partial(skb, hook, dataoff, len,
+					       protocol);
 		break;
 	}
 
-- 
2.11.0
