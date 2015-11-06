From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netfilter: ingress: fix wrong input interface on hook
Date: Fri,  6 Nov 2015 19:27:24 +0100
Message-ID: <1446834444-960-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49606 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbbKFSUK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:20:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The input and output interfaces in nf_hook_state_init() are flipped.
This fixes iif matching on nftables.

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ingress.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index 187feab..f06fcf17 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -16,8 +16,8 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 	struct nf_hook_state state;
 
 	nf_hook_state_init(&state, &skb->dev->nf_hooks_ingress,
-			   NF_NETDEV_INGRESS, INT_MIN, NFPROTO_NETDEV, NULL,
-			   skb->dev, NULL, dev_net(skb->dev), NULL);
+			   NF_NETDEV_INGRESS, INT_MIN, NFPROTO_NETDEV,
+			   skb->dev, NULL, NULL, dev_net(skb->dev), NULL);
 	return nf_hook_slow(skb, &state);
 }
 
-- 
2.1.4

