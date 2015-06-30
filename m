From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: bridge: don't leak skb in error paths
Date: Tue, 30 Jun 2015 22:27:51 +0200
Message-ID: <1435696071-26841-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50217 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbbF3U1y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jun 2015 16:27:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

br_nf_dev_queue_xmit must free skb in its error path.
NF_DROP is misleading -- its an okfn, not a netfilter hook.

Fixes: 462fb2af9788a ("bridge : Sanitize skb before it enters the IP stack")
Fixes: efb6de9b4ba00 ("netfilter: bridge: forward IPv6 fragmented packets")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Not sure the br_validate* calls are needed. When we reach br_nf_dev_queue_xmit
 skbs have already been through all brnf hooks where we also have these checks.

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index d89f4fa..1a6fa67 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -742,7 +742,7 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 		struct brnf_frag_data *data;
 
 		if (br_validate_ipv4(skb))
-			return NF_DROP;
+			goto drop;
 
 		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
@@ -767,7 +767,7 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 		struct brnf_frag_data *data;
 
 		if (br_validate_ipv6(skb))
-			return NF_DROP;
+			goto drop;
 
 		IP6CB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
@@ -782,12 +782,16 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 
 		if (v6ops)
 			return v6ops->fragment(sk, skb, br_nf_push_frag_xmit);
-		else
-			return -EMSGSIZE;
+
+		kfree_skb(skb);
+		return -EMSGSIZE;
 	}
 #endif
 	nf_bridge_info_free(skb);
 	return br_dev_queue_push_xmit(sk, skb);
+ drop:
+	kfree_skb(skb);
+	return 0;
 }
 
 /* PF_BRIDGE/POST_ROUTING ********************************************/
-- 
2.0.5

