Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB6B400DFB
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 11:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781089976; cv=none; b=dLuSc6iKYmqdGccRMSTjE7RKL7KA9CUMjw7K64UuDEmIe1vuiGR9ZsHLTbCxHZGNW4QlOGOPkPC7OeVrAhM9xZ1p7ovxJn7E+D1Q64iLPGgyGvzFvWLEHejl0F3rWrxZByzMcJJ75JhkjxwmOD/ok0M7EW3jY7K6zjFRypnGTnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781089976; c=relaxed/simple;
	bh=PTHUT+uC7QJma7c7w2xW6SystqHMjxmQ1q7KpfkrDkI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GpelXItuqKQIhuEBsgy8Qj+gTkL3oJ3lxwWNeO0tXaIpzWg43tyr8pTU7oFm2PtcoCBKqZfBT/ubqjsqZOaI2cK/WgVcO8HPMdV8V6qdN1vfrFjqVNa/XL83ddcTlhOlyN4WVgPM23fQlIBGIIvcU0c4MfzJfYKF4FAIcuSFvrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UQbJqNRv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UQbJqNRv"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B749560196
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 13:12:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781089970;
	bh=lZJPquL4y6+D4X1sEUzRN/JSSUVKtiglX5tXee9X/oc=;
	h=From:To:Subject:Date:From;
	b=UQbJqNRvPIqrUmTvXAimN3EK1yzsBco/RAmGP3WBdZm2a9u7nSKeZ0DRau8i+tOnT
	 dgULEpBHykiOwbyxQ+QAPXP2qnUdCffoB+FX8urQTaT3AUPreF8cwKCCmbqKUDAa/W
	 mFkcZ5+l1TIwSkCJYxKbAAbF0Y8BgGwSWv+crO5BxzpB/8tQgqZjsZbrSjCk0YOntF
	 LS4SBxQhhjLdAM0ce9xfaqcY6TWz9V2/NBnwzysZJQQdpLr8eJjy0m4eA/u8OYCaEG
	 Gblkc2u1bSWkIgg3LJ+urWW4XuzCuThkNTmPver3U8QXFrRn87YxODANDWgBAP2eP2
	 nkV3FFeK3hcsw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3] netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them
Date: Wed, 10 Jun 2026 13:12:47 +0200
Message-ID: <20260610111247.185888-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update nft_dup and nft_fwd to use the nf_dev_xmit_recursion() helpers.
This patch also disables BH when transmitting the skb to address a
possible migration to different CPU leading to imbalanced decrementation
of the recursion counters.

This is modeled after Florian Westphal's dev_xmit_recursion*() API
available since 97cdcf37b57e ("net: place xmit recursion in softnet
data") according to its current state in the tree.

While at it, remove redundant verdict to set NF_STOLEN in
skb_expand_head() since this is the default verdict.

Fixes: 1d47b55b36d2 ("netfilter: nft_fwd_netdev: use recursion counter in neigh egress path")
Fixes: f37ad9127039 ("netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: check recursion before skb_expand_head() to simplify handling, per AI reviewer.

 include/net/netfilter/nf_dup_netdev.h | 34 +++++++++++++++++++++++----
 net/netfilter/nf_dup_netdev.c         | 15 ++++++------
 net/netfilter/nft_fwd_netdev.c        | 17 ++++++++------
 3 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index 609bcf422a9b..f6b05bd80c3f 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -11,15 +11,39 @@ void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
 #define NF_RECURSION_LIMIT	2
 
-static inline u8 *nf_get_nf_dup_skb_recursion(void)
-{
 #ifndef CONFIG_PREEMPT_RT
-	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
+			NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	__this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
+}
+
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	__this_cpu_dec(softnet_data.xmit.nf_dup_skb_recursion);
+}
 #else
-	return &current->net_xmit.nf_dup_skb_recursion;
-#endif
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(current->net_xmit.nf_dup_skb_recursion > NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	current->net_xmit.nf_dup_skb_recursion++;
 }
 
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	current->net_xmit.nf_dup_skb_recursion--;
+}
+#endif
+
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 3b0a70e154cd..c189716e986a 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -16,11 +16,6 @@
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
-	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
-
-	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT)
-		goto err;
-
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
 		if (skb_cow_head(skb, skb->mac_len))
 			goto err;
@@ -30,9 +25,15 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	(*nf_dup_skb_recursion)++;
+	local_bh_disable();
+	if (nf_dev_xmit_recursion()) {
+		local_bh_enable();
+		goto err;
+	}
+	nf_dev_xmit_recursion_inc();
 	dev_queue_xmit(skb);
-	(*nf_dup_skb_recursion)--;
+	nf_dev_xmit_recursion_dec();
+	local_bh_enable();
 	return;
 err:
 	kfree_skb(skb);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index b9e88d7cf308..e8d295969a22 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -95,7 +95,6 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs,
 			      const struct nft_pktinfo *pkt)
 {
-	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
 	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
 	void *addr = &regs->data[priv->sreg_addr];
 	int oif = regs->data[priv->sreg_dev];
@@ -154,13 +153,15 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT) {
+	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
+	if (dev == NULL) {
 		verdict = NF_DROP;
 		goto out;
 	}
 
-	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL) {
+	local_bh_disable();
+	if (nf_dev_xmit_recursion()) {
+		local_bh_enable();
 		verdict = NF_DROP;
 		goto out;
 	}
@@ -169,16 +170,18 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
-			verdict = NF_STOLEN;
+			local_bh_enable();
 			goto out;
 		}
 	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	(*nf_dup_skb_recursion)++;
+
+	nf_dev_xmit_recursion_inc();
 	neigh_xmit(neigh_table, dev, addr, skb);
-	(*nf_dup_skb_recursion)--;
+	nf_dev_xmit_recursion_dec();
+	local_bh_enable();
 out:
 	regs->verdict.code = verdict;
 }
-- 
2.47.3

