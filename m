From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: bridge: rework reject handling
Date: Mon, 16 Feb 2015 18:57:53 +0100
Message-ID: <1424109473-24078-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52105 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbbBPR56 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2015 12:57:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bridge reject handling is not straightforward, there are many subtle
differences depending on configuration.

skb->dev is either the bridge port (PRE_ROUTING) or the bridge
itself (INPUT), so we need to use indev instead.

Also, checksum validation will only work reliably if we trim skb
according to the l3 header size.

While at it, add csum validation for ipv6 and skip existing tests
if skb was already checked e.g. by GRO.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/nft_reject_bridge.c | 84 +++++++++++++++++++++++++-------
 1 file changed, 66 insertions(+), 18 deletions(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index b0330ae..aedc5eb 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -21,6 +21,7 @@
 #include <net/ip.h>
 #include <net/ip6_checksum.h>
 #include <linux/netfilter_bridge.h>
+#include <linux/netfilter_ipv6.h>
 #include "../br_private.h"
 
 static void nft_reject_br_push_etherhdr(struct sk_buff *oldskb,
@@ -36,7 +37,12 @@ static void nft_reject_br_push_etherhdr(struct sk_buff *oldskb,
 	skb_pull(nskb, ETH_HLEN);
 }
 
-static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb, int hook)
+/* We cannot use oldskb->dev, it can be either bridge device (NF_BRIDGE INPUT)
+ * or the bridge port (NF_BRIDGE PREROUTING).
+ */
+static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb,
+					    const struct net_device *dev,
+					    int hook)
 {
 	struct sk_buff *nskb;
 	struct iphdr *niph;
@@ -65,11 +71,12 @@ static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb, int hook)
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
+	br_deliver(br_port_get_rcu(dev), nskb);
 }
 
-static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
-					  u8 code)
+static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb,
+					  const struct net_device *dev,
+					  int hook, u8 code)
 {
 	struct sk_buff *nskb;
 	struct iphdr *niph;
@@ -77,8 +84,9 @@ static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
 	unsigned int len;
 	void *payload;
 	__wsum csum;
+	u8 proto;
 
-	if (!nft_bridge_iphdr_validate(oldskb))
+	if (oldskb->csum_bad || !nft_bridge_iphdr_validate(oldskb))
 		return;
 
 	/* IP header checks: fragment. */
@@ -91,7 +99,17 @@ static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
 	if (!pskb_may_pull(oldskb, len))
 		return;
 
-	if (nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), 0))
+	if (pskb_trim_rcsum(oldskb, htons(ip_hdr(oldskb)->tot_len)))
+		return;
+
+	if (ip_hdr(oldskb)->protocol == IPPROTO_TCP ||
+	    ip_hdr(oldskb)->protocol == IPPROTO_UDP)
+		proto = ip_hdr(oldskb)->protocol;
+	else
+		proto = 0;
+
+	if (!skb_csum_unnecessary(oldskb) &&
+	    nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), proto))
 		return;
 
 	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct icmphdr) +
@@ -120,11 +138,13 @@ static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
+	br_deliver(br_port_get_rcu(dev), nskb);
 }
 
 static void nft_reject_br_send_v6_tcp_reset(struct net *net,
-					    struct sk_buff *oldskb, int hook)
+					    struct sk_buff *oldskb,
+					    const struct net_device *dev,
+					    int hook)
 {
 	struct sk_buff *nskb;
 	const struct tcphdr *oth;
@@ -152,12 +172,37 @@ static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
+	br_deliver(br_port_get_rcu(dev), nskb);
+}
+
+static bool reject6_br_csum_ok(struct sk_buff *skb, int hook)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	int thoff;
+	__be16 fo;
+	u8 proto = ip6h->nexthdr;
+
+	if (skb->csum_bad)
+		return false;
+
+	if (skb_csum_unnecessary(skb))
+		return true;
+
+	if (ip6h->payload_len &&
+	    pskb_trim_rcsum(skb, ntohs(ip6h->payload_len) + sizeof(*ip6h)))
+		return false;
+
+	thoff = ipv6_skip_exthdr(skb, ((u8*)(ip6h+1) - skb->data), &proto, &fo);
+	if (thoff < 0 || thoff >= skb->len || (fo & htons(~0x7)) != 0)
+		return false;
+
+	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
 }
 
 static void nft_reject_br_send_v6_unreach(struct net *net,
-					  struct sk_buff *oldskb, int hook,
-					  u8 code)
+					  struct sk_buff *oldskb,
+					  const struct net_device *dev,
+					  int hook, u8 code)
 {
 	struct sk_buff *nskb;
 	struct ipv6hdr *nip6h;
@@ -176,6 +221,9 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 	if (!pskb_may_pull(oldskb, len))
 		return;
 
+	if (!reject6_br_csum_ok(oldskb, hook))
+		return;
+
 	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct icmp6hdr) +
 			 LL_MAX_HEADER + len, GFP_ATOMIC);
 	if (!nskb)
@@ -205,7 +253,7 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
+	br_deliver(br_port_get_rcu(dev), nskb);
 }
 
 static void nft_reject_bridge_eval(const struct nft_expr *expr,
@@ -224,16 +272,16 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 	case htons(ETH_P_IP):
 		switch (priv->type) {
 		case NFT_REJECT_ICMP_UNREACH:
-			nft_reject_br_send_v4_unreach(pkt->skb,
+			nft_reject_br_send_v4_unreach(pkt->skb, pkt->in,
 						      pkt->ops->hooknum,
 						      priv->icmp_code);
 			break;
 		case NFT_REJECT_TCP_RST:
-			nft_reject_br_send_v4_tcp_reset(pkt->skb,
+			nft_reject_br_send_v4_tcp_reset(pkt->skb, pkt->in,
 							pkt->ops->hooknum);
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			nft_reject_br_send_v4_unreach(pkt->skb,
+			nft_reject_br_send_v4_unreach(pkt->skb, pkt->in,
 						      pkt->ops->hooknum,
 						      nft_reject_icmp_code(priv->icmp_code));
 			break;
@@ -242,16 +290,16 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 	case htons(ETH_P_IPV6):
 		switch (priv->type) {
 		case NFT_REJECT_ICMP_UNREACH:
-			nft_reject_br_send_v6_unreach(net, pkt->skb,
+			nft_reject_br_send_v6_unreach(net, pkt->skb, pkt->in,
 						      pkt->ops->hooknum,
 						      priv->icmp_code);
 			break;
 		case NFT_REJECT_TCP_RST:
-			nft_reject_br_send_v6_tcp_reset(net, pkt->skb,
+			nft_reject_br_send_v6_tcp_reset(net, pkt->skb, pkt->in,
 							pkt->ops->hooknum);
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			nft_reject_br_send_v6_unreach(net, pkt->skb,
+			nft_reject_br_send_v6_unreach(net, pkt->skb, pkt->in,
 						      pkt->ops->hooknum,
 						      nft_reject_icmpv6_code(priv->icmp_code));
 			break;
-- 
2.0.5

