From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv5 3/4] netfilter: bridge: rename br_parse_ip_options
Date: Thu, 28 May 2015 10:25:10 +0200
Message-ID: <1432801510-11902-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.133]:57897 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbbE1IZj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 04:25:39 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id ABFCA1073517
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2015 10:25:38 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

br_parse_ip_options() does not parse any IP options, it validates IP
packets as a whole and the function name is misleading.

Rename br_parse_ip_options() to br_validate_ipv4().

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
Patch revision history:

v5
* rebase to current davem/net-next

v4
* re-post due to errors in v3 formatting introduced by my MUA

v3
* re-assignment of iph variable needed because pskb_may_pull() can
invalidate the network header
* same patch as v1 again

v2
* first patch did not contain statement removing double iph variable
  assignment

 net/bridge/br_netfilter.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index a43e216..f34edb6 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -217,7 +217,7 @@ static inline void nf_bridge_pull_encap_header_rcsum(struct sk_buff *skb)
  * expected format
  */
 
-static int br_parse_ip_options(struct sk_buff *skb)
+static int br_validate_ipv4(struct sk_buff *skb)
 {
 	const struct iphdr *iph;
 	struct net_device *dev = skb->dev;
@@ -319,7 +319,7 @@ bad:
 	return -1;
 }
 
-/* Equivalent to br_parse_ip_options for IPv6 */
+/* Equivalent to br_validate_ipv4 for IPv6 */
 static int br_validate_ipv6(struct sk_buff *skb)
 {
 	const struct ipv6hdr *hdr;
@@ -731,7 +731,7 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 
 	nf_bridge_pull_encap_header_rcsum(skb);
 
-	if (br_parse_ip_options(skb))
+	if (br_validate_ipv4(skb))
 		return NF_DROP;
 
 	nf_bridge_put(skb->nf_bridge);
@@ -849,7 +849,7 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 	int frag_max = BR_INPUT_SKB_CB(skb)->frag_max_size;
 
 	if (pf == NFPROTO_IPV4) {
-		if (br_parse_ip_options(skb))
+		if (br_validate_ipv4(skb))
 			return NF_DROP;
 		IPCB(skb)->frag_max_size = frag_max;
 	}
@@ -964,7 +964,8 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 	 */
 	if (skb->protocol == htons(ETH_P_IP)) {
 		struct brnf_frag_data *data;
-		if (br_parse_ip_options(skb))
+
+		if (br_validate_ipv4(skb))
 			/* Drop invalid packet */
 			return NF_DROP;
 
-- 
1.7.10.4

