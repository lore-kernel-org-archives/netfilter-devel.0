From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/38] netfilter: utils: move nf_ip_checksum* from ipv4 to utils
Date: Fri, 20 Jul 2018 15:08:32 +0200
Message-ID: <20180720130906.27687-5-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

allows to make nf_ip_checksum_partial static, it no longer
has an external caller.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv4.h | 11 ---------
 net/ipv4/netfilter.c           | 53 ----------------------------------------
 net/netfilter/utils.c          | 55 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 64 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index b31dabfdb453..95ab5cc64422 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -23,9 +23,6 @@ struct nf_queue_entry;
 #ifdef CONFIG_INET
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		       unsigned int dataoff, u_int8_t protocol);
-__sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
-			       unsigned int dataoff, unsigned int len,
-			       u_int8_t protocol);
 int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		bool strict);
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
@@ -35,14 +32,6 @@ static inline __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 {
 	return 0;
 }
-static inline __sum16 nf_ip_checksum_partial(struct sk_buff *skb,
-					     unsigned int hook,
-					     unsigned int dataoff,
-					     unsigned int len,
-					     u_int8_t protocol)
-{
-	return 0;
-}
 static inline int nf_ip_route(struct net *net, struct dst_entry **dst,
 			      struct flowi *fl, bool strict)
 {
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index e6774ccb7731..8d2e5dc9a827 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -98,59 +98,6 @@ int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry)
 }
 EXPORT_SYMBOL_GPL(nf_ip_reroute);
 
-__sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
-			    unsigned int dataoff, u_int8_t protocol)
-{
-	const struct iphdr *iph = ip_hdr(skb);
-	__sum16 csum = 0;
-
-	switch (skb->ip_summed) {
-	case CHECKSUM_COMPLETE:
-		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
-			break;
-		if ((protocol == 0 && !csum_fold(skb->csum)) ||
-		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
-				       skb->len - dataoff, protocol,
-				       skb->csum)) {
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			break;
-		}
-		/* fall through */
-	case CHECKSUM_NONE:
-		if (protocol == 0)
-			skb->csum = 0;
-		else
-			skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr,
-						       skb->len - dataoff,
-						       protocol, 0);
-		csum = __skb_checksum_complete(skb);
-	}
-	return csum;
-}
-EXPORT_SYMBOL(nf_ip_checksum);
-
-__sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
-			       unsigned int dataoff, unsigned int len,
-			       u_int8_t protocol)
-{
-	const struct iphdr *iph = ip_hdr(skb);
-	__sum16 csum = 0;
-
-	switch (skb->ip_summed) {
-	case CHECKSUM_COMPLETE:
-		if (len == skb->len - dataoff)
-			return nf_ip_checksum(skb, hook, dataoff, protocol);
-		/* fall through */
-	case CHECKSUM_NONE:
-		skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr, protocol,
-					       skb->len - dataoff, 0);
-		skb->ip_summed = CHECKSUM_NONE;
-		return __skb_checksum_complete_head(skb, dataoff + len);
-	}
-	return csum;
-}
-EXPORT_SYMBOL_GPL(nf_ip_checksum_partial);
-
 int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		bool strict __always_unused)
 {
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 0b660c568156..8980c8a0fe5c 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -1,9 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_queue.h>
 
+#ifdef CONFIG_INET
+__sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
+		       unsigned int dataoff, u8 protocol)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	__sum16 csum = 0;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_COMPLETE:
+		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
+			break;
+		if ((protocol == 0 && !csum_fold(skb->csum)) ||
+		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
+				       skb->len - dataoff, protocol,
+				       skb->csum)) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			break;
+		}
+		/* fall through */
+	case CHECKSUM_NONE:
+		if (protocol == 0)
+			skb->csum = 0;
+		else
+			skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr,
+						       skb->len - dataoff,
+						       protocol, 0);
+		csum = __skb_checksum_complete(skb);
+	}
+	return csum;
+}
+EXPORT_SYMBOL(nf_ip_checksum);
+#endif
+
+static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
+				      unsigned int dataoff, unsigned int len,
+				      u8 protocol)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	__sum16 csum = 0;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_COMPLETE:
+		if (len == skb->len - dataoff)
+			return nf_ip_checksum(skb, hook, dataoff, protocol);
+		/* fall through */
+	case CHECKSUM_NONE:
+		skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr, protocol,
+					       skb->len - dataoff, 0);
+		skb->ip_summed = CHECKSUM_NONE;
+		return __skb_checksum_complete_head(skb, dataoff + len);
+	}
+	return csum;
+}
+
 __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u_int8_t protocol,
 		    unsigned short family)
-- 
2.11.0
