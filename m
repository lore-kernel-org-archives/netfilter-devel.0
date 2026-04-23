Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F4E29ACF6
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 07:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776928925; cv=none; b=qlmTE8XR+35AZrwGHg+2y1/IgLJVO20iiD3dLmurWN4kaBoWtXIRXcG05263q0vJDjF/qYACW3qWGHCwy/lbhlu7P+npkt0sQhmARFiqksJYVsm3qxyZWRwFvC2zanGpXFvin54qwkFx5oNKaYsNAwQ+ngjFZh6WJ5jTX/8HcJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776928925; c=relaxed/simple;
	bh=F1VCTaC+i96la24QhsB8n7Bd42pnRkd7vR1DniP5boQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od6thP4aUihZjzEmf8EnWtAYhPUfHqWe9qMOsGjnFoNxth2jiRThwKYl2jzLoQWnjnIlaRkkO7RIc2Ix8yCLbcrIQ8pv4kQ1nikoRNHLb7h+xDWjsYyjNLXWOtDBL8x6h6xMHNLr/uN2PR1A9YtqT4Vat35Uf6Qf8t+W68aY+Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SsLCI3j5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SsLCI3j5"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 830DA602CB
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 09:22:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776928921;
	bh=yyfg7DmfVLJCdiY2Qhi1GdBWoiru0QZ41rR1+ohqpbM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SsLCI3j5ULXgcXnJE1cEmpHP7BNDBoTslSBRXl+uSiGvUxS/ckLtnqa56XaQd8ahy
	 oMmXnTQs5MhLKLvPz0/WJA6YZP9+Fiz1PmsiRmuNI6UlTQMT48tFayZW5ffumWjrP8
	 9YSTS3AiTI5z6gyqIFteMISYJ09phYKt+Op/HQ66wqneVWQnuJeQ+srGGXk/6Ui402
	 NIR6vg8OSPVe0HBdXH86du6V/L97G5dQjSy+lLcnRch3CCzeo6N6+eE7yVjvp5Z5WX
	 5bDnkiudboVms9xLhuC+HEgNUVidI2WA70mPEIoFYXfLbBSPHMPblKFdQdHzn7TW+A
	 mz5D6GyfStU6A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 3/3] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
Date: Thu, 23 Apr 2026 09:21:55 +0200
Message-ID: <20260423072155.352333-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423072155.352333-1-pablo@netfilter.org>
References: <20260423072155.352333-1-pablo@netfilter.org>
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

[ Updated to cache the nf_get_nf_dup_skb_recursion. --pablo ]

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: cache the nf_get_nf_dup_skb_recursion.

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
index 80416017a2d5..424eefd4b1ad 100644
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
@@ -160,7 +166,9 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 
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

