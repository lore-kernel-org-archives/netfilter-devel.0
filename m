From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv6 2/4] netfilter: bridge: rename br_parse_ip_options
Date: Sat, 30 May 2015 15:29:02 +0200
Message-ID: <1432992542-4127-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.135]:3164 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbbE3N3e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 May 2015 09:29:34 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 34DE21107F39
	for <netfilter-devel@vger.kernel.org>; Sat, 30 May 2015 15:29:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

br_parse_ip_options() does not parse any IP options, it validates IP
packets as a whole and the function name is misleading.

Rename br_parse_ip_options() to br_validate_ipv4() and remove unneeded
commments.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
Patch revision history:

v6
* put this patch in front of "netfilter: bridge: forward IPv6 fragmented
  packets"

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

 net/bridge/br_netfilter.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 1f30b28..962d5f8 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -216,7 +216,7 @@ static inline void nf_bridge_pull_encap_header_rcsum(struct sk_buff *skb)
  * expected format
  */
 
-static int br_parse_ip_options(struct sk_buff *skb)
+static int br_validate_ipv4(struct sk_buff *skb)
 {
 	const struct iphdr *iph;
 	struct net_device *dev = skb->dev;
@@ -692,7 +692,7 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 
 	nf_bridge_pull_encap_header_rcsum(skb);
 
-	if (br_parse_ip_options(skb))
+	if (br_validate_ipv4(skb))
 		return NF_DROP;
 
 	nf_bridge_put(skb->nf_bridge);
@@ -802,7 +802,7 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 	}
 
 	if (pf == NFPROTO_IPV4) {
-		if (br_parse_ip_options(skb))
+		if (br_validate_ipv4(skb))
 			return NF_DROP;
 		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 	}
@@ -913,8 +913,7 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 	if (skb->len + mtu_reserved > skb->dev->mtu) {
 		struct brnf_frag_data *data;
 
-		if (br_parse_ip_options(skb))
-			/* Drop invalid packet */
+		if (br_validate_ipv4(skb))
 			return NF_DROP;
 
 		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
-- 
1.7.10.4

