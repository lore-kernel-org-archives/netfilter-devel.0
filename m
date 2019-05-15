Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F87C04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 18:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18B4420815
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 18:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfEOSPc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 14:15:32 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51310 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbfEOSPc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 14:15:32 -0400
Received: from localhost ([::1]:36168 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hQyR8-0006U8-RA; Wed, 15 May 2019 20:15:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_fib: Fix existence check support
Date:   Wed, 15 May 2019 20:15:32 +0200
Message-Id: <20190515181532.15811-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NFTA_FIB_F_PRESENT flag was not always honored since eval functions did
not call nft_fib_store_result in all cases.

Given that in all callsites there is a struct net_device pointer
available which holds the interface data to be stored in destination
register, simplify nft_fib_store_result() to just accept that pointer
instead of the nft_pktinfo pointer and interface index. This also
allows to drop the index to interface lookup previously needed to get
the name associated with given index.

Fixes: 055c4b34b94f6 ("netfilter: nft_fib: Support existence check")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nft_fib.h   |  2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c | 23 +++--------------------
 net/ipv6/netfilter/nft_fib_ipv6.c | 16 ++--------------
 net/netfilter/nft_fib.c           |  6 +++---
 4 files changed, 9 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index a88f92737308d..e4c4d8eaca8ca 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -34,5 +34,5 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt);
 
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
-			  const struct nft_pktinfo *pkt, int index);
+			  const struct net_device *dev);
 #endif
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 94eb25bc8d7eb..c8888e52591f2 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -58,11 +58,6 @@ void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval_type);
 
-static int get_ifindex(const struct net_device *dev)
-{
-	return dev ? dev->ifindex : 0;
-}
-
 void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt)
 {
@@ -94,8 +89,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, pkt,
-				     nft_in(pkt)->ifindex);
+		nft_fib_store_result(dest, priv, nft_in(pkt));
 		return;
 	}
 
@@ -108,8 +102,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (ipv4_is_zeronet(iph->saddr)) {
 		if (ipv4_is_lbcast(iph->daddr) ||
 		    ipv4_is_local_multicast(iph->daddr)) {
-			nft_fib_store_result(dest, priv, pkt,
-					     get_ifindex(pkt->skb->dev));
+			nft_fib_store_result(dest, priv, pkt->skb->dev);
 			return;
 		}
 	}
@@ -150,17 +143,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		found = oif;
 	}
 
-	switch (priv->result) {
-	case NFT_FIB_RESULT_OIF:
-		*dest = found->ifindex;
-		break;
-	case NFT_FIB_RESULT_OIFNAME:
-		strncpy((char *)dest, found->name, IFNAMSIZ);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
+	nft_fib_store_result(dest, priv, found);
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval);
 
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 73cdc0bc63f75..ec068b0cffca8 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -169,8 +169,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, pkt,
-				     nft_in(pkt)->ifindex);
+		nft_fib_store_result(dest, priv, nft_in(pkt));
 		return;
 	}
 
@@ -187,18 +186,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (oif && oif != rt->rt6i_idev->dev)
 		goto put_rt_err;
 
-	switch (priv->result) {
-	case NFT_FIB_RESULT_OIF:
-		*dest = rt->rt6i_idev->dev->ifindex;
-		break;
-	case NFT_FIB_RESULT_OIFNAME:
-		strncpy((char *)dest, rt->rt6i_idev->dev->name, IFNAMSIZ);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
+	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
  put_rt_err:
 	ip6_rt_put(rt);
 }
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 21df8cccea658..77f00a99dfabb 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -135,17 +135,17 @@ int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr)
 EXPORT_SYMBOL_GPL(nft_fib_dump);
 
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
-			  const struct nft_pktinfo *pkt, int index)
+			  const struct net_device *dev)
 {
-	struct net_device *dev;
 	u32 *dreg = reg;
+	int index;
 
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
+		index = dev ? dev->ifindex : 0;
 		*dreg = (priv->flags & NFTA_FIB_F_PRESENT) ? !!index : index;
 		break;
 	case NFT_FIB_RESULT_OIFNAME:
-		dev = dev_get_by_index_rcu(nft_net(pkt), index);
 		if (priv->flags & NFTA_FIB_F_PRESENT)
 			*dreg = !!dev;
 		else
-- 
2.21.0

