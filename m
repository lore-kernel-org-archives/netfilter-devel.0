Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3440350D7D
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 22:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781043532; cv=none; b=gXWOmW17yYS5Tt5OtEiTD1ApbNT2jjxihOeMyXBbHjUeqoEU/VdIDdA+8tJmch/G3b3iTCQsQ//SSTc/wYLam6ZawQaILav0OjFqP0SQhtPCfKbE56z4NsB54j3Ilc66ZKU65H3TxSLmVb0jFvDAr3rR9AQDufL+f7G66y2NIZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781043532; c=relaxed/simple;
	bh=X3K7QCVeBASTQmRdV54niQxCXBktX5joj+vgOzuhQFA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rATTobParmg2hJUn9dDvjoqljf5ZWnZMRqVn/fn4+YEi+ubgDt4L6ItDqcWRJtUkoZ+e3HUDbl1mfcsVyRc30GWzKYaIjlwN2dVcvBJNGTYH4Egj/Ajxj89fL7OcJlC7EmI64UJP9qSpNNUXCL7A9VDc5RdtbpOsRvnCV2tM1Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wPalHWUC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wPalHWUC"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E288F60272
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 00:18:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781043529;
	bh=zTHHkt4fOnYf3MNAwio73S8WWFBdMODcT9rYeRWOtOg=;
	h=From:To:Subject:Date:From;
	b=wPalHWUC6Qn10feDy8RkRFvbtwUJkZf0ZSV6BYIeNWeqjwv5U43uS4zk0JDQCUlte
	 UapoFDrAiOZq6RMQDQCIwQSpabjSSO2/ljYoj0sd5NwwTH7bSzGPVoB9KMoVBnwTeX
	 /Qpia4rPn26euV1OeywP+vFzBhO/WCEEHwaug+ezCa4I/qB25A6ZUcoc8mKp8ZNsH5
	 b93Vok+l0YEbXcbSmbBnP6tk+bk5GcemaHor4Refp3MGCMINDhI1nU1w6gdV7S8iqh
	 kWgRiq1ibhaMuO/6ow1lk3PSn+a3HLRteLzQJdpW1zLhxmKZgGOsjdhHQarqV3oUDB
	 h5drw/UmCEBeA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them
Date: Wed, 10 Jun 2026 00:18:44 +0200
Message-ID: <20260609221844.117324-1-pablo@netfilter.org>
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

Fixes: 1d47b55b36d2 ("netfilter: nft_fwd_netdev: use recursion counter in neigh egress path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_dup_netdev.h | 34 +++++++++++++++++++++++----
 net/netfilter/nf_dup_netdev.c         | 10 ++++----
 net/netfilter/nft_fwd_netdev.c        | 10 ++++----
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index 609bcf422a9b..05c0b9b4228f 100644
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
+	return unlikely(current->net_xmit.nf_dup_recursion > NF_RECURSION_LIMIT);
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
index 3d88ef927f31..914b528de90d 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -16,9 +16,7 @@
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
-	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
-
-	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT)
+	if (nf_dev_xmit_recursion())
 		goto err;
 
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
@@ -30,9 +28,11 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	(*nf_dup_skb_recursion)++;
+	local_bh_disable();
+	nf_dev_xmit_recursion_inc();
 	dev_queue_xmit(skb);
-	(*nf_dup_skb_recursion)--;
+	nf_dev_xmit_recursion_dec();
+	local_bh_enable();
 	return;
 err:
 	kfree_skb(skb);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index b9e88d7cf308..b4f1dc1dfaf3 100644
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
@@ -154,7 +153,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT) {
+	if (nf_dev_xmit_recursion()) {
 		verdict = NF_DROP;
 		goto out;
 	}
@@ -176,9 +175,12 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	(*nf_dup_skb_recursion)++;
+
+	local_bh_disable();
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

