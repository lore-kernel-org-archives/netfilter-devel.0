Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CFEF9C0
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 12:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777293428; cv=none; b=Wwb+y+Umrp0e1BjVhEXHHfdCkTubDw9kS66sWvAj8kt0MVheajGm1yyXn9mVZF2QH/ZRmNB4xFAqgak+S+Rsj/coEV6MUIai431yXU+rZSMBRgIgWEk7KaHJu2U5zKrtCip7kXxJTHQ1jeeGlw32It1SPn1PNcD4nRFAz0IRV2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777293428; c=relaxed/simple;
	bh=czDgBSB3O+P/Dh5c18sxMvLnnbpN48qaT9ohBL3Jf8I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDDzWGoF8HsVJTaZ3spBYXWicNawCsUJHLVyAWvrVZfTWMxA1AXZVmneYMakrlYDo0hJieJ7h/p1o0pYMgwTjA3+xuwuC4iNV/EEMFNz0ah8Z7MiMmyDMqJ3wqw3kiriqwDlcEzBPCUMzglxCsvwQTtA4/5RnS/RgBiLikqyCjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dN0/N3Rh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dN0/N3Rh"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 271A360251
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 14:37:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777293420;
	bh=1vLBknvJ8nfo7Hi0BeL05p+srbLrpOHL/+mKDr04Qws=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dN0/N3RhC4bBHEnZabNFk8cn59T72qMGDe4au03J9dWv17qD0F6IchqFYGxEAm6Yh
	 CAGmpyX3Xjhaa8mzG1juoMeLcoud00cUkVi2z18otNcCPbzPn3YJFXpNe3OR5Bkryp
	 W3s+7QdX8GINuViIjwnFdt2yrvWhtx3XYsNddIlTJRzVqHkdeRM+7pnbDhKf9GhYcv
	 clK64LN6QniFabqrE01oFjpT97Coft4N/pdBJL+sA54gEtDZp3KmmtfQ8uQ1dugug3
	 zkHun7djYkr8y6QrM8LpG/COK4tcGkuGx0MVbX790YdxO4Ra660EHfmrYgNZWNh72Z
	 5iq7hM8sVVvww==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 3/3] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
Date: Mon, 27 Apr 2026 14:36:53 +0200
Message-ID: <20260427123653.9103-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427123653.9103-1-pablo@netfilter.org>
References: <20260427123653.9103-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

nft_fwd_neigh can be used in egress chains (NF_NETDEV_EGRESS). When the
forwarding rule targets the same device or two devices forward to each
other, neigh_xmit() triggers dev_queue_xmit() which re-enters
nf_hook_egress(), causing infinite recursion and stack overflow.

Move the nf_get_nf_dup_skb_recursion() accessor and NF_RECURSION_LIMIT
to the shared header nf_dup_netdev.h as a static inline, so that
nft_fwd_netdev can use the recursion counter directly without exported
function call overhead. Guard neigh_xmit() with the same recursion
limit already used in nf_do_netdev_egress().

[ Updated to cache the nf_get_nf_dup_skb_recursion pointer. --pablo ]

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: no changes

 include/net/netfilter/nf_dup_netdev.h | 13 +++++++++++++
 net/netfilter/nf_dup_netdev.c         | 16 ----------------
 net/netfilter/nft_fwd_netdev.c        |  8 ++++++++
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index b175d271aec9..609bcf422a9b 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -3,10 +3,23 @@
 #define _NF_DUP_NETDEV_H_
 
 #include <net/netfilter/nf_tables.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
 
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
+#define NF_RECURSION_LIMIT	2
+
+static inline u8 *nf_get_nf_dup_skb_recursion(void)
+{
+#ifndef CONFIG_PREEMPT_RT
+	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+#else
+	return &current->net_xmit.nf_dup_skb_recursion;
+#endif
+}
+
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index e348fb90b8dc..3b0a70e154cd 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,22 +13,6 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
-#define NF_RECURSION_LIMIT	2
-
-#ifndef CONFIG_PREEMPT_RT
-static u8 *nf_get_nf_dup_skb_recursion(void)
-{
-	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
-}
-#else
-
-static u8 *nf_get_nf_dup_skb_recursion(void)
-{
-	return &current->net_xmit.nf_dup_skb_recursion;
-}
-
-#endif
-
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 94d6397f10a8..2c4abf24f26a 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -95,6 +95,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs,
 			      const struct nft_pktinfo *pkt)
 {
+	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
 	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
 	void *addr = &regs->data[priv->sreg_addr];
 	int oif = regs->data[priv->sreg_dev];
@@ -152,6 +153,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
+	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
 	if (dev == NULL) {
 		verdict = NF_DROP;
@@ -165,7 +171,9 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	(*nf_dup_skb_recursion)++;
 	neigh_xmit(neigh_table, dev, addr, skb);
+	(*nf_dup_skb_recursion)--;
 out:
 	regs->verdict.code = verdict;
 }
-- 
2.47.3

