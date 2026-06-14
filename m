Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5303A0E80;
	Sun, 14 Jun 2026 11:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437591; cv=none; b=H6e7jyshgV0GuNw8j+LbXcNghHTS6pgwp8gkx/R0ti5vAtP1KAFC1zUrcz7x1jHnVjhwdOfAMl5Jh3A+dRqnEpVMJjWLupb5LIwOlSvGkrxmLYwW+F6wPsdD8bUhw6RpoGXDsszHtP2pxHOh1f5jzijRWLTNhVQVsQzvA6QEH78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437591; c=relaxed/simple;
	bh=vzLCHx1hAqGetMmrjbZIqn8SjhkZcAqFIpFbFyCvyok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UK9Sz1UyD6uzlTNLNg5z65dIdqtoPYH5xWYz9wWW0owHrcXK8Vmmj0dUuGFjamHIhOSHIk81AH+j1TVbLz9aNMyvCW75AsrqhaVicQtyoi8A1RVN5yCes284+RUL6VHK9rs7+etAEYe1dsqItHbSaAVZVQg2TjCPk1eneG+mVcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZGXQxOeM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZGXQxOeM"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2182B6019D;
	Sun, 14 Jun 2026 13:46:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437585;
	bh=AwQeuoRCJG1FgkxcxXuYunBDtKXxB/ikWS1NelbngmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGXQxOeMkt37HD/X1OEifXi3mpFss9jELz7fY+RxvFnZSm6TTO0ohrB/ryJY4xXI0
	 0hF0IBmwQCeBXA3oEK1BAIwGCVs44bdXANlDh6Dk5zMyLlq+K4LD+m89dQldr4te+k
	 yB8gvSvvLwQ33RJdxcYSDYOqLil1vvYd462AvzBf5pkreBwo8PXQX9OCC9tmPy1kBH
	 rTH6v5IXUdM/zzwNP7SS5WJoRmvQzzrNMNUIRq2y+SaqphSTdnolKvdzD0DHZBDSvj
	 K4fdSb1tS/2tW+JmNa2u2wWXxJ7hez5mTp9JoIJ4545gXRVI0u2k61p8i2sm4PLYy9
	 i3uFvoQ54zkdQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 11/11] netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them
Date: Sun, 14 Jun 2026 13:46:05 +0200
Message-ID: <20260614114605.474783-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
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
available since commit 97cdcf37b57e ("net: place xmit recursion in
softnet data") according to its current state in the tree.

Fixes: 1d47b55b36d2 ("netfilter: nft_fwd_netdev: use recursion counter in neigh egress path")
Fixes: f37ad9127039 ("netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
index b9e88d7cf308..a48c2f765bba 100644
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
+	if (!dev) {
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

