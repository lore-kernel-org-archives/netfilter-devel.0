From: Simon Horman <horms@verge.net.au>
Subject: [PATCH nf] ipvs: Keep skb->sk when allocating headroom on tunnel xmit
Date: Wed, 12 Nov 2014 11:22:00 +0900
Message-ID: <1415758920-32578-2-git-send-email-horms@verge.net.au>
References: <1415758920-32578-1-git-send-email-horms@verge.net.au>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Wensong Zhang <wensong@linux-vs.org>,
	Julian Anastasov <ja@ssi.bg>,
	Calvin Owens <calvinowens@fb.com>,
	Simon Horman <horms@verge.net.au>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:47342 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaKLCWI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:22:08 -0500
In-Reply-To: <1415758920-32578-1-git-send-email-horms@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Calvin Owens <calvinowens@fb.com>

ip_vs_prepare_tunneled_skb() ignores ->sk when allocating a new
skb, either unconditionally setting ->sk to NULL or allowing
the uninitialized ->sk from a newly allocated skb to leak through
to the caller.

This patch properly copies ->sk and increments its reference count.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 437a366..bd90bf8 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -846,6 +846,8 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
 		new_skb = skb_realloc_headroom(skb, max_headroom);
 		if (!new_skb)
 			goto error;
+		if (skb->sk)
+			skb_set_owner_w(new_skb, skb->sk);
 		consume_skb(skb);
 		skb = new_skb;
 	}
-- 
2.1.1

