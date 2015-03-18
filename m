From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCH 4/4] netfilter: bridge: rename br_parse_ip_options and delete unneeded code
Date: Wed, 18 Mar 2015 22:56:08 +0100
Message-ID: <1426715768-17011-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smarthost1.wvnet.at ([62.212.174.130]:57460 "EHLO
	smarthost2.wvnet.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755157AbbCRWEW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 18:04:22 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by smarthost1.wvnet.at (Postfix) with ESMTP id E66A8FD6059
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2015 22:56:38 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

br_parse_ip_options() does not parse any IP options, it validates IP
packets as a whole and the function name is misleading.

Rename it and delete unneeded assignment of iph variable.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
 net/bridge/br_netfilter.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 0e129fb..2d73565 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -198,7 +198,7 @@ static inline void nf_bridge_save_header(struct sk_buff *skb)
  * expected format
  */
 
-static int br_parse_ip_options(struct sk_buff *skb)
+static int br_validate_ipv4(struct sk_buff *skb)
 {
 	const struct iphdr *iph;
 	struct net_device *dev = skb->dev;
@@ -300,7 +300,7 @@ bad:
 	return -1;
 }
 
-/* Equivalent to br_parse_ip_options for IPv6 */
+/* Equivalent to br_validate_ipv4 for IPv6 */
 static int br_validate_ipv6(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
@@ -718,7 +718,7 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 
 	nf_bridge_pull_encap_header_rcsum(skb);
 
-	if (br_parse_ip_options(skb))
+	if (br_validate_ipv4(skb))
 		return NF_DROP;
 
 	nf_bridge_put(skb->nf_bridge);
@@ -819,7 +819,7 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 		nf_bridge->mask |= BRNF_PKT_TYPE;
 	}
 
-	if (pf == NFPROTO_IPV4 && br_parse_ip_options(skb))
+	if (pf == NFPROTO_IPV4 && br_validate_ipv4(skb))
 		return NF_DROP;
 
 	/* The physdev module checks on this */
@@ -914,7 +914,7 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 	 * boundaries by preserving frag_list rather than refragmenting.
 	 */
 	if (skb->protocol == htons(ETH_P_IP)) {
-		if (br_parse_ip_options(skb))
+		if (br_validate_ipv4(skb))
 			/* Drop invalid packet */
 			return NF_DROP;
 		IPCB(skb)->frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
-- 
1.7.10.4

