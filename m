Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF330C77B7F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbjEEPb4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbjEEPbz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:31:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 563D0191C8
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:37 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 04/12] netfilter: nf_tables: add nft_reg_load*() and use it
Date:   Fri,  5 May 2023 17:31:22 +0200
Message-Id: <20230505153130.2385-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a helper function to wrap data read from register and use it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      | 31 +++++++------
 net/bridge/netfilter/nft_meta_bridge.c | 14 ++++--
 net/ipv4/netfilter/nft_dup_ipv4.c      | 26 ++++++++---
 net/ipv6/netfilter/nft_dup_ipv6.c      | 20 +++++++--
 net/netfilter/nf_tables_core.c         | 17 +++++--
 net/netfilter/nft_bitwise.c            |  7 ++-
 net/netfilter/nft_byteorder.c          | 16 +++++--
 net/netfilter/nft_cmp.c                |  8 +++-
 net/netfilter/nft_ct.c                 | 27 ++++++++----
 net/netfilter/nft_dup_netdev.c         | 12 ++++-
 net/netfilter/nft_dynset.c             | 27 +++++++++---
 net/netfilter/nft_exthdr.c             | 15 +++++--
 net/netfilter/nft_fwd_netdev.c         | 27 +++++++++---
 net/netfilter/nft_hash.c               | 10 ++++-
 net/netfilter/nft_lookup.c             |  9 +++-
 net/netfilter/nft_masq.c               | 18 ++++++--
 net/netfilter/nft_meta.c               | 21 ++++++---
 net/netfilter/nft_nat.c                | 61 ++++++++++++++++++--------
 net/netfilter/nft_objref.c             | 17 ++++---
 net/netfilter/nft_payload.c            |  6 ++-
 net/netfilter/nft_queue.c              | 13 ++++--
 net/netfilter/nft_range.c              | 13 +++++-
 net/netfilter/nft_redir.c              | 18 ++++++--
 net/netfilter/nft_tproxy.c             | 49 +++++++++++++++++----
 24 files changed, 366 insertions(+), 116 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ac95b704cd70..ea258bfc6506 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -141,24 +141,34 @@ struct nft_regs_track {
  * garbage values.
  */
 
-static inline u8 nft_reg_load8(const u32 *sreg)
+static inline const u8 *nft_reg_load_u8(const struct nft_regs *regs, u32 sreg)
 {
-	return *(u8 *)sreg;
+	return (const u8 *)&regs->data[sreg];
 }
 
-static inline u16 nft_reg_load16(const u32 *sreg)
+static inline const u16 *nft_reg_load_u16(const struct nft_regs *regs, u32 sreg)
 {
-	return *(u16 *)sreg;
+	return (const u16 *)&regs->data[sreg];
 }
 
-static inline __be16 nft_reg_load_be16(const u32 *sreg)
+static inline const u32 *nft_reg_load_u32(const struct nft_regs *regs, u32 sreg)
 {
-	return (__force __be16)nft_reg_load16(sreg);
+	return &regs->data[sreg];
 }
 
-static inline __be32 nft_reg_load_be32(const u32 *sreg)
+static inline const void *nft_reg_load(const struct nft_regs *regs, u32 sreg, u8 len)
 {
-	return *(__force __be32 *)sreg;
+	return (const void *)&regs->data[sreg];
+}
+
+static inline const __be16 *nft_reg_load_be16(const struct nft_regs *regs, u32 sreg)
+{
+	return (__force __be16 *)nft_reg_load_u16(regs, sreg);
+}
+
+static inline const __be32 *nft_reg_load_be32(const struct nft_regs *regs, u32 sreg)
+{
+	return (__force __be32 *)nft_reg_load_u32(regs, sreg);
 }
 
 static inline void nft_reg_store_u8(struct nft_regs *regs, u32 dreg, u8 value)
@@ -238,11 +248,6 @@ static inline void nft_reg_reset(struct nft_regs *regs, u32 dreg, u8 len)
 	memset(dest, 0, len);
 }
 
-static inline u64 nft_reg_load64(const u32 *sreg)
-{
-	return get_unaligned((u64 *)sreg);
-}
-
 static inline void nft_data_copy(struct nft_regs *regs,
 				 const struct nft_data *src,
 				 u32 dreg, unsigned int len)
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index c96a0f08bb3e..5e592b4df642 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -109,18 +109,24 @@ static void nft_meta_bridge_set_eval(const struct nft_expr *expr,
 				     const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *meta = nft_expr_priv(expr);
-	u32 *sreg = &regs->data[meta->sreg];
 	struct sk_buff *skb = pkt->skb;
-	u8 value8;
+	const u8 *value8;
 
 	switch (meta->key) {
 	case NFT_META_BRI_BROUTE:
-		value8 = nft_reg_load8(sreg);
-		BR_INPUT_SKB_CB(skb)->br_netfilter_broute = !!value8;
+		value8 = nft_reg_load_u8(regs, meta->sreg);
+		if (!value8)
+			goto err;
+
+		BR_INPUT_SKB_CB(skb)->br_netfilter_broute = !!*value8;
 		break;
 	default:
 		nft_meta_set_eval(expr, regs, pkt);
 	}
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static int nft_meta_bridge_set_init(const struct nft_ctx *ctx,
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index a522c3a3be52..559636e4de52 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -22,12 +22,26 @@ static void nft_dup_ipv4_eval(const struct nft_expr *expr,
 			      const struct nft_pktinfo *pkt)
 {
 	struct nft_dup_ipv4 *priv = nft_expr_priv(expr);
-	struct in_addr gw = {
-		.s_addr = (__force __be32)regs->data[priv->sreg_addr],
-	};
-	int oif = priv->sreg_dev ? regs->data[priv->sreg_dev] : -1;
-
-	nf_dup_ipv4(nft_net(pkt), pkt->skb, nft_hook(pkt), &gw, oif);
+	const int *oif = NULL;
+	struct in_addr gw;
+	const u32 *addr;
+
+	addr = nft_reg_load_be32(regs, priv->sreg_addr);
+	if (!addr)
+		goto err;
+
+	if (priv->sreg_dev) {
+		oif = nft_reg_load_u32(regs, priv->sreg_dev);
+		if (!oif)
+			goto err;
+	}
+
+	gw.s_addr = *addr;
+	nf_dup_ipv4(nft_net(pkt), pkt->skb, nft_hook(pkt), &gw, oif ? *oif : -1);
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static int nft_dup_ipv4_init(const struct nft_ctx *ctx,
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index c82f3fdd4a65..9323ff81fd12 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -22,10 +22,24 @@ static void nft_dup_ipv6_eval(const struct nft_expr *expr,
 			      const struct nft_pktinfo *pkt)
 {
 	struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
-	struct in6_addr *gw = (struct in6_addr *)&regs->data[priv->sreg_addr];
-	int oif = priv->sreg_dev ? regs->data[priv->sreg_dev] : -1;
+	const struct in6_addr *gw;
+	const u32 *oif;
 
-	nf_dup_ipv6(nft_net(pkt), pkt->skb, nft_hook(pkt), gw, oif);
+	gw = nft_reg_load(regs, priv->sreg_addr, sizeof(struct in6_addr));
+	if (!gw)
+		goto err;
+
+	if (priv->sreg_dev) {
+		oif = nft_reg_load_be32(regs, priv->sreg_dev);
+		if (!oif)
+			goto err;
+	}
+
+	nf_dup_ipv6(nft_net(pkt), pkt->skb, nft_hook(pkt), gw, *oif);
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static int nft_dup_ipv6_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 1ee950368b6c..812d580b61cf 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -78,7 +78,12 @@ static void nft_bitwise_fast_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs)
 {
 	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
-	u32 *src = &regs->data[priv->sreg];
+	const u32 *src = nft_reg_load_u32(regs, priv->sreg);
+
+	if (!src) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
 
 	nft_reg_store_u32(regs, priv->dreg, (*src & priv->mask) ^ priv->xor);
 }
@@ -87,9 +92,11 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
+	const u32 *src = nft_reg_load_u32(regs, priv->sreg);
 
-	if (((regs->data[priv->sreg] & priv->mask) == priv->data) ^ priv->inv)
+	if (src && (((*src & priv->mask) == priv->data) ^ priv->inv))
 		return;
+
 	regs->verdict.code = NFT_BREAK;
 }
 
@@ -97,13 +104,15 @@ static void nft_cmp16_fast_eval(const struct nft_expr *expr,
 				struct nft_regs *regs)
 {
 	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
-	const u64 *reg_data = (const u64 *)&regs->data[priv->sreg];
+	const u64 *reg_data = nft_reg_load(regs, priv->sreg, 16);
 	const u64 *mask = (const u64 *)&priv->mask;
 	const u64 *data = (const u64 *)&priv->data;
 
-	if (((reg_data[0] & mask[0]) == data[0] &&
+	if (reg_data &&
+	    ((reg_data[0] & mask[0]) == data[0] &&
 	    ((reg_data[1] & mask[1]) == data[1])) ^ priv->inv)
 		return;
+
 	regs->verdict.code = NFT_BREAK;
 }
 
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d3c066aa399a..66a73df4b484 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -69,7 +69,12 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
-	const u32 *src = &regs->data[priv->sreg];
+	const u32 *src = nft_reg_load(regs, priv->sreg, priv->len);
+
+	if (!src) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
 
 	switch (priv->op) {
 	case NFT_BITWISE_BOOL:
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 7c9c32706d10..494acf7ac993 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -28,10 +28,14 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 			const struct nft_pktinfo *pkt)
 {
 	const struct nft_byteorder *priv = nft_expr_priv(expr);
-	u32 *src = &regs->data[priv->sreg];
-	union { u32 u32; u16 u16; } *s;
+	const union { u32 u32; u16 u16; } *s;
+	const u32 *src;
 	unsigned int i;
 
+	src = nft_reg_load(regs, priv->sreg, priv->len);
+	if (!src)
+		goto err;
+
 	s = (void *)src;
 
 	switch (priv->size) {
@@ -41,7 +45,7 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
-				src64 = nft_reg_load64(&src[i]);
+				src64 = get_unaligned((u64 *)&src[i]);
 				nft_reg_store_u64(regs, priv->dreg,
 						  be64_to_cpu((__force __be64)src64));
 			}
@@ -49,7 +53,7 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = (__force __u64)
-					cpu_to_be64(nft_reg_load64(&src[i]));
+					cpu_to_be64(get_unaligned((u64 *)&src[i]));
 				nft_reg_store_u64(regs, priv->dreg, src64);
 			}
 			break;
@@ -82,6 +86,10 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		break;
 		}
 	}
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_byteorder_policy[NFTA_BYTEORDER_MAX + 1] = {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 6eb21a4f5698..a4659597c6a7 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -28,9 +28,13 @@ void nft_cmp_eval(const struct nft_expr *expr,
 		  const struct nft_pktinfo *pkt)
 {
 	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
+	const u32 *src = nft_reg_load(regs, priv->sreg, priv->len);
 	int d;
 
-	d = memcmp(&regs->data[priv->sreg], &priv->data, priv->len);
+	if (!src)
+		goto mismatch;
+
+	d = memcmp(src, &priv->data, priv->len);
 	switch (priv->op) {
 	case NFT_CMP_EQ:
 		if (d != 0)
@@ -167,7 +171,7 @@ static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
 
 	if (reg->key == FLOW_DISSECTOR_KEY_META &&
 	    reg->offset == offsetof(struct nft_flow_key, meta.ingress_iftype) &&
-	    nft_reg_load16(priv->data.data) != ARPHRD_ETHER)
+	    *(u16 *)priv->data.data != ARPHRD_ETHER)
 		return -EOPNOTSUPP;
 
 	nft_offload_update_dependency(ctx, &priv->data, reg->len);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 8477f1b636bc..12f45c38905e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -243,16 +243,18 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 {
 	struct nf_conntrack_zone zone = { .dir = NF_CT_DEFAULT_ZONE_DIR };
 	const struct nft_ct *priv = nft_expr_priv(expr);
+	const u16 *value = nft_reg_load_u16(regs, priv->sreg);
 	struct sk_buff *skb = pkt->skb;
 	enum ip_conntrack_info ctinfo;
-	u16 value = nft_reg_load16(&regs->data[priv->sreg]);
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct) /* already tracked */
+	if (!value || ct) { /* already tracked */
+		regs->verdict.code = NFT_BREAK;
 		return;
+	}
 
-	zone.id = value;
+	zone.id = *value;
 
 	switch (priv->dir) {
 	case IP_CT_DIR_ORIGINAL:
@@ -292,11 +294,18 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 	const struct nft_ct *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
 #if defined(CONFIG_NF_CONNTRACK_MARK) || defined(CONFIG_NF_CONNTRACK_SECMARK)
-	u32 value = regs->data[priv->sreg];
+	const u32 *pvalue;
+	u32 value;
 #endif
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
+	pvalue = nft_reg_load(regs, priv->sreg, priv->len);
+	if (!pvalue)
+		goto err;
+
+	value = *pvalue;
+
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct == NULL || nf_ct_is_template(ct))
 		return;
@@ -320,16 +329,14 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 #endif
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 	case NFT_CT_LABELS:
-		nf_connlabels_replace(ct,
-				      &regs->data[priv->sreg],
-				      &regs->data[priv->sreg],
+		nf_connlabels_replace(ct, pvalue, pvalue,
 				      NF_CT_LABELS_MAX_SIZE / sizeof(u32));
 		break;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	case NFT_CT_EVENTMASK: {
 		struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
-		u32 ctmask = regs->data[priv->sreg];
+		u32 ctmask = value;
 
 		if (e) {
 			if (e->ctmask != ctmask)
@@ -345,6 +352,10 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 	default:
 		break;
 	}
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index e5739a59ebf1..75b6e1ad5f0f 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -22,9 +22,17 @@ static void nft_dup_netdev_eval(const struct nft_expr *expr,
 				const struct nft_pktinfo *pkt)
 {
 	struct nft_dup_netdev *priv = nft_expr_priv(expr);
-	int oif = regs->data[priv->sreg_dev];
+	const u32 *oif;
 
-	nf_dup_netdev_egress(pkt, oif);
+	oif = nft_reg_load_u32(regs, priv->sreg_dev);
+	if (!oif)
+		goto err;
+
+	nf_dup_netdev_egress(pkt, *oif);
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_dup_netdev_policy[NFTA_DUP_MAX + 1] = {
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 274579b1696e..e2ac29142921 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -48,17 +48,26 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 			    struct nft_regs *regs)
 {
 	const struct nft_dynset *priv = nft_expr_priv(expr);
+	const u32 *src_key, *src_data = NULL;
 	struct nft_set_ext *ext;
 	u64 timeout;
 	void *elem;
 
+	src_key = nft_reg_load(regs, priv->sreg_key, set->klen);
+	if (!src_key)
+		return NULL;
+
+	if (priv->set->flags & NFT_SET_MAP) {
+		src_data = nft_reg_load(regs, priv->sreg_data, set->dlen);
+		if (!src_data)
+			return NULL;
+	}
+
 	if (!atomic_add_unless(&set->nelems, 1, set->size))
 		return NULL;
 
 	timeout = priv->timeout ? : set->timeout;
-	elem = nft_set_elem_init(set, &priv->tmpl,
-				 &regs->data[priv->sreg_key], NULL,
-				 &regs->data[priv->sreg_data],
+	elem = nft_set_elem_init(set, &priv->tmpl, src_key, NULL, src_data,
 				 timeout, 0, GFP_ATOMIC);
 	if (IS_ERR(elem))
 		goto err1;
@@ -83,15 +92,21 @@ void nft_dynset_eval(const struct nft_expr *expr,
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext;
+	const u32 *src;
 	u64 timeout;
 
+	src = nft_reg_load(regs, priv->sreg_key, set->klen);
+	if (!src) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	if (priv->op == NFT_DYNSET_OP_DELETE) {
-		set->ops->delete(set, &regs->data[priv->sreg_key]);
+		set->ops->delete(set, src);
 		return;
 	}
 
-	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
-			     expr, regs, &ext)) {
+	if (set->ops->update(set, src, nft_dynset_new, expr, regs, &ext)) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 			timeout = priv->timeout ? : set->timeout;
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 4af9af63a604..0eade4035e0a 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -228,6 +228,8 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	u8 buff[sizeof(struct tcphdr) + MAX_TCP_OPTION_SPACE];
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	unsigned int i, optl, tcphdr_len, offset;
+	const __be16 *src16;
+	const __be32 *src32;
 	struct tcphdr *tcph;
 	u8 *opt;
 
@@ -263,9 +265,12 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 		switch (priv->len) {
 		case 2:
+			src16 = nft_reg_load_be16(regs, priv->sreg);
+			if (!src16)
+				goto err;
+
 			old.v16 = (__force __be16)get_unaligned((u16 *)(opt + offset));
-			new.v16 = (__force __be16)nft_reg_load16(
-				&regs->data[priv->sreg]);
+			new.v16 = *src16;
 
 			switch (priv->type) {
 			case TCPOPT_MSS:
@@ -283,7 +288,11 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 						 old.v16, new.v16, false);
 			break;
 		case 4:
-			new.v32 = nft_reg_load_be32(&regs->data[priv->sreg]);
+			src32 = nft_reg_load_be32(regs, priv->sreg);
+			if (!src32)
+				goto err;
+
+			new.v32 = *src32;
 			old.v32 = (__force __be32)get_unaligned((u32 *)(opt + offset));
 
 			if (old.v32 == new.v32)
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 7b9d4d1bd17c..235e899a00db 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -26,15 +26,23 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 				const struct nft_pktinfo *pkt)
 {
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
-	int oif = regs->data[priv->sreg_dev];
 	struct sk_buff *skb = pkt->skb;
+	const u32 *oif;
+
+	oif = nft_reg_load_u32(regs, priv->sreg_dev);
+	if (!oif)
+		goto err;
 
 	/* This is used by ifb only. */
 	skb->skb_iif = skb->dev->ifindex;
 	skb_set_redirected(skb, nft_hook(pkt) == NF_NETDEV_INGRESS);
 
-	nf_fwd_netdev_egress(pkt, oif);
+	nf_fwd_netdev_egress(pkt, *oif);
 	regs->verdict.code = NF_STOLEN;
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_fwd_netdev_policy[NFTA_FWD_MAX + 1] = {
@@ -89,6 +97,7 @@ struct nft_fwd_neigh {
 	u8			sreg_dev;
 	u8			sreg_addr;
 	u8			nfproto;
+	u8			addr_len;
 };
 
 static void nft_fwd_neigh_eval(const struct nft_expr *expr,
@@ -96,12 +105,20 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			      const struct nft_pktinfo *pkt)
 {
 	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
-	void *addr = &regs->data[priv->sreg_addr];
-	int oif = regs->data[priv->sreg_dev];
 	unsigned int verdict = NF_STOLEN;
 	struct sk_buff *skb = pkt->skb;
 	struct net_device *dev;
+	const void *addr;
 	int neigh_table;
+	const u32 *oif;
+
+	oif = nft_reg_load_u32(regs, priv->sreg_dev);
+	addr = nft_reg_load(regs, priv->sreg_addr, priv->addr_len);
+
+	if (!oif || !addr) {
+		verdict = NFT_BREAK;
+		goto out;
+	}
 
 	switch (priv->nfproto) {
 	case NFPROTO_IPV4: {
@@ -141,7 +158,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
+	dev = dev_get_by_index_rcu(nft_net(pkt), *oif);
 	if (dev == NULL)
 		return;
 
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 8bcf9e9aa550..cca6a620214c 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -28,13 +28,21 @@ static void nft_jhash_eval(const struct nft_expr *expr,
 			   const struct nft_pktinfo *pkt)
 {
 	struct nft_jhash *priv = nft_expr_priv(expr);
-	const void *data = &regs->data[priv->sreg];
+	const void *data;
 	u32 h;
 
+	data = nft_reg_load(regs, priv->sreg, priv->len);
+	if (!data)
+		goto err;
+
 	h = reciprocal_scale(jhash(data, priv->len, priv->seed),
 			     priv->modulus);
 
 	nft_reg_store_u32(regs, priv->dreg, h + priv->offset);
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 struct nft_symhash {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 3e3c20e42385..f48704187a94 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -62,9 +62,16 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	const struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext = NULL;
 	const struct net *net = nft_net(pkt);
+	const u32 *src;
 	bool found;
 
-	found =	nft_set_do_lookup(net, set, &regs->data[priv->sreg], &ext) ^
+	src = nft_reg_load(regs, priv->sreg, set->klen);
+	if (!src) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	found =	nft_set_do_lookup(net, set, src, &ext) ^
 				  priv->invert;
 	if (!found) {
 		ext = nft_set_catchall_lookup(net, set);
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index b115d77fbbc7..8c327088c3f9 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -101,15 +101,21 @@ static void nft_masq_eval(const struct nft_expr *expr,
 			  const struct nft_pktinfo *pkt)
 {
 	const struct nft_masq *priv = nft_expr_priv(expr);
+	const __be16 *src_proto_min, *src_proto_max;
 	struct nf_nat_range2 range;
 
+	if (priv->sreg_proto_min) {
+		src_proto_min = nft_reg_load_be16(regs, priv->sreg_proto_min);
+		src_proto_max = nft_reg_load_be16(regs, priv->sreg_proto_max);
+		if (!src_proto_min || !src_proto_max)
+			goto err;
+	}
+
 	memset(&range, 0, sizeof(range));
 	range.flags = priv->flags;
 	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)
-			nft_reg_load16(&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)
-			nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+		range.min_proto.all = *src_proto_min;
+		range.max_proto.all = *src_proto_max;
 	}
 
 	switch (nft_pf(pkt)) {
@@ -129,6 +135,10 @@ static void nft_masq_eval(const struct nft_expr *expr,
 		WARN_ON_ONCE(1);
 		break;
 	}
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static void
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 05b98b39a132..5ec80b7a0289 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -443,19 +443,22 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 {
 	const struct nft_meta *meta = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
-	u32 *sreg = &regs->data[meta->sreg];
-	u32 value = *sreg;
+	const u32 *src;
 	u8 value8;
 
+	src = nft_reg_load(regs, meta->sreg, meta->len);
+	if (!src)
+		goto err;
+
 	switch (meta->key) {
 	case NFT_META_MARK:
-		skb->mark = value;
+		skb->mark = *src;
 		break;
 	case NFT_META_PRIORITY:
-		skb->priority = value;
+		skb->priority = *src;
 		break;
 	case NFT_META_PKTTYPE:
-		value8 = nft_reg_load8(sreg);
+		value8 = *(u8 *)src;
 
 		if (skb->pkt_type != value8 &&
 		    skb_pkt_type_ok(value8) &&
@@ -463,18 +466,22 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 			skb->pkt_type = value8;
 		break;
 	case NFT_META_NFTRACE:
-		value8 = nft_reg_load8(sreg);
+		value8 = *(u8 *)src;
 
 		skb->nf_trace = !!value8;
 		break;
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
-		skb->secmark = value;
+		skb->secmark = *src;
 		break;
 #endif
 	default:
 		WARN_ON(1);
 	}
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 EXPORT_SYMBOL_GPL(nft_meta_set_eval);
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 5c29915ab028..8b3b75282549 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -27,37 +27,52 @@ struct nft_nat {
 	u8			sreg_proto_max;
 	enum nf_nat_manip_type  type:8;
 	u8			family;
+	u8			addr_len;
 	u16			flags;
 };
 
-static void nft_nat_setup_addr(struct nf_nat_range2 *range,
-			       const struct nft_regs *regs,
-			       const struct nft_nat *priv)
+static int nft_nat_setup_addr(struct nf_nat_range2 *range,
+			      const struct nft_regs *regs,
+			      const struct nft_nat *priv)
 {
+	const __be32 *src_addr_min, *src_addr_max;
+
+	src_addr_min = nft_reg_load(regs, priv->sreg_addr_min, priv->addr_len);
+	src_addr_max = nft_reg_load(regs, priv->sreg_addr_max, priv->addr_len);
+	if (!src_addr_min || !src_addr_max)
+		return -1;
+
 	switch (priv->family) {
 	case AF_INET:
-		range->min_addr.ip = (__force __be32)
-				regs->data[priv->sreg_addr_min];
-		range->max_addr.ip = (__force __be32)
-				regs->data[priv->sreg_addr_max];
+		range->min_addr.ip = *src_addr_min;
+		range->max_addr.ip = *src_addr_max;
 		break;
 	case AF_INET6:
-		memcpy(range->min_addr.ip6, &regs->data[priv->sreg_addr_min],
+		memcpy(range->min_addr.ip6, src_addr_min,
 		       sizeof(range->min_addr.ip6));
-		memcpy(range->max_addr.ip6, &regs->data[priv->sreg_addr_max],
+		memcpy(range->max_addr.ip6, src_addr_max,
 		       sizeof(range->max_addr.ip6));
 		break;
 	}
+
+	return 0;
 }
 
-static void nft_nat_setup_proto(struct nf_nat_range2 *range,
-				const struct nft_regs *regs,
-				const struct nft_nat *priv)
+static int nft_nat_setup_proto(struct nf_nat_range2 *range,
+			       const struct nft_regs *regs,
+			       const struct nft_nat *priv)
 {
-	range->min_proto.all = (__force __be16)
-		nft_reg_load16(&regs->data[priv->sreg_proto_min]);
-	range->max_proto.all = (__force __be16)
-		nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+	const __be16 *src_proto_min, *src_proto_max;
+
+	src_proto_min = nft_reg_load_be16(regs, priv->sreg_proto_min);
+	src_proto_max = nft_reg_load_be16(regs, priv->sreg_proto_max);
+	if (!src_proto_min || !src_proto_max)
+		return -1;
+
+	range->min_proto.all = *src_proto_min;
+	range->max_proto.all = *src_proto_max;
+
+	return 0;
 }
 
 static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
@@ -112,17 +127,24 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	memset(&range, 0, sizeof(range));
 
 	if (priv->sreg_addr_min) {
-		nft_nat_setup_addr(&range, regs, priv);
+		if (nft_nat_setup_addr(&range, regs, priv) < 0)
+			goto err;
+
 		if (priv->flags & NF_NAT_RANGE_NETMAP)
 			nft_nat_setup_netmap(&range, pkt, priv);
 	}
 
-	if (priv->sreg_proto_min)
-		nft_nat_setup_proto(&range, regs, priv);
+	if (priv->sreg_proto_min &&
+	    nft_nat_setup_proto(&range, regs, priv) < 0)
+		goto err;
 
 	range.flags = priv->flags;
 
 	regs->verdict.code = nf_nat_setup_info(ct, &range, priv->type);
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
@@ -206,6 +228,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		break;
 	}
 	priv->family = family;
+	priv->addr_len = alen;
 
 	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_NAT_REG_ADDR_MIN],
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index cb37169608ba..9b1c85ab9d04 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -109,18 +109,25 @@ void nft_objref_map_eval(const struct nft_expr *expr,
 	struct net *net = nft_net(pkt);
 	const struct nft_set_ext *ext;
 	struct nft_object *obj;
+	const u32 *src;
 	bool found;
 
-	found = nft_set_do_lookup(net, set, &regs->data[priv->sreg], &ext);
+	src = nft_reg_load(regs, priv->sreg, set->klen);
+	if (!src)
+		goto err;
+
+	found = nft_set_do_lookup(net, set, src, &ext);
 	if (!found) {
 		ext = nft_set_catchall_lookup(net, set);
-		if (!ext) {
-			regs->verdict.code = NFT_BREAK;
-			return;
-		}
+		if (!ext)
+			goto err;
 	}
 	obj = *nft_set_ext_obj(ext);
 	obj->ops->eval(obj, regs, pkt);
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static int nft_objref_map_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 1c016089727b..20a6079667eb 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -805,9 +805,13 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 {
 	const struct nft_payload_set *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
-	const u32 *src = &regs->data[priv->sreg];
 	int offset, csum_offset;
 	__wsum fsum, tsum;
+	const u32 *src;
+
+	src = nft_reg_load(regs, priv->sreg, priv->len);
+	if (!src)
+		goto err;
 
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index b2b8127c8d43..76fe8e97bdab 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -57,15 +57,22 @@ static void nft_queue_sreg_eval(const struct nft_expr *expr,
 				const struct nft_pktinfo *pkt)
 {
 	struct nft_queue *priv = nft_expr_priv(expr);
-	u32 queue, ret;
+	const u32 *queue;
+	u32 ret;
 
-	queue = regs->data[priv->sreg_qnum];
+	queue = nft_reg_load_u32(regs, priv->sreg_qnum);
+	if (!queue)
+		goto err;
 
-	ret = NF_QUEUE_NR(queue);
+	ret = NF_QUEUE_NR(*queue);
 	if (priv->flags & NFT_QUEUE_FLAG_BYPASS)
 		ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
 
 	regs->verdict.code = ret;
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static int nft_queue_validate(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 0566d6aaf1e5..204a472bbafa 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -24,10 +24,15 @@ void nft_range_eval(const struct nft_expr *expr,
 		    struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_range_expr *priv = nft_expr_priv(expr);
+	const u32 *src;
 	int d1, d2;
 
-	d1 = memcmp(&regs->data[priv->sreg], &priv->data_from, priv->len);
-	d2 = memcmp(&regs->data[priv->sreg], &priv->data_to, priv->len);
+	src = nft_reg_load(regs, priv->sreg, priv->len);
+	if (!src)
+		goto err;
+
+	d1 = memcmp(src, &priv->data_from, priv->len);
+	d2 = memcmp(src, &priv->data_to, priv->len);
 	switch (priv->op) {
 	case NFT_RANGE_EQ:
 		if (d1 < 0 || d2 > 0)
@@ -38,6 +43,10 @@ void nft_range_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 		break;
 	}
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_range_policy[NFTA_RANGE_MAX + 1] = {
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index a70196ffcb1e..3c4a0ff450e3 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -106,15 +106,21 @@ static void nft_redir_eval(const struct nft_expr *expr,
 			   const struct nft_pktinfo *pkt)
 {
 	const struct nft_redir *priv = nft_expr_priv(expr);
+	const __be16 *src_proto_min, *src_proto_max;
 	struct nf_nat_range2 range;
 
+	if (priv->sreg_proto_min) {
+		src_proto_min = nft_reg_load_be16(regs, priv->sreg_proto_min);
+		src_proto_max = nft_reg_load_be16(regs, priv->sreg_proto_max);
+		if (!src_proto_min || !src_proto_max)
+			goto err;
+	}
+
 	memset(&range, 0, sizeof(range));
 	range.flags = priv->flags;
 	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)
-			nft_reg_load16(&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)
-			nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+		range.min_proto.all = *src_proto_min;
+		range.max_proto.all = *src_proto_max;
 	}
 
 	switch (nft_pf(pkt)) {
@@ -132,6 +138,10 @@ static void nft_redir_eval(const struct nft_expr *expr,
 		WARN_ON_ONCE(1);
 		break;
 	}
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static void
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index ea83f661417e..b2891237b9c1 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -26,6 +26,8 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	struct sk_buff *skb = pkt->skb;
 	const struct iphdr *iph = ip_hdr(skb);
 	struct udphdr _hdr, *hp;
+	const __be32 *addr;
+	const __be16 *port;
 	__be32 taddr = 0;
 	__be16 tport = 0;
 	struct sock *sk;
@@ -51,12 +53,23 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 				   hp->source, hp->dest,
 				   skb->dev, NF_TPROXY_LOOKUP_ESTABLISHED);
 
-	if (priv->sreg_addr)
-		taddr = nft_reg_load_be32(&regs->data[priv->sreg_addr]);
+	if (priv->sreg_addr) {
+		addr = nft_reg_load_be32(regs, priv->sreg_addr);
+		if (!addr)
+			goto err;
+
+		taddr = *addr;
+	}
+
 	taddr = nf_tproxy_laddr4(skb, taddr, iph->daddr);
 
-	if (priv->sreg_port)
-		tport = nft_reg_load_be16(&regs->data[priv->sreg_port]);
+	if (priv->sreg_port) {
+		port = nft_reg_load_be16(regs, priv->sreg_port);
+		if (!port)
+			goto err;
+
+		tport = *port;
+	}
 	if (!tport)
 		tport = hp->dest;
 
@@ -78,6 +91,10 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 		nf_tproxy_assign_sock(skb, sk);
 	else
 		regs->verdict.code = NFT_BREAK;
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
@@ -92,6 +109,8 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	struct udphdr _hdr, *hp;
 	struct in6_addr taddr;
 	__be16 tport = 0;
+	const u32 *addr;
+	const u16 *port;
 	struct sock *sk;
 	int l4proto;
 
@@ -119,12 +138,22 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 				   hp->source, hp->dest,
 				   nft_in(pkt), NF_TPROXY_LOOKUP_ESTABLISHED);
 
-	if (priv->sreg_addr)
-		memcpy(&taddr, &regs->data[priv->sreg_addr], sizeof(taddr));
+	if (priv->sreg_addr) {
+		addr = nft_reg_load(regs, priv->sreg_addr, sizeof(taddr));
+		if (!addr)
+			goto err;
+
+		memcpy(&taddr, addr, sizeof(taddr));
+	}
 	taddr = *nf_tproxy_laddr6(skb, &taddr, &iph->daddr);
 
-	if (priv->sreg_port)
-		tport = nft_reg_load_be16(&regs->data[priv->sreg_port]);
+	if (priv->sreg_port) {
+		port = nft_reg_load_be16(regs, priv->sreg_port);
+		if (!port)
+			goto err;
+
+		tport = *port;
+	}
 	if (!tport)
 		tport = hp->dest;
 
@@ -151,6 +180,10 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 		nf_tproxy_assign_sock(skb, sk);
 	else
 		regs->verdict.code = NFT_BREAK;
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 #endif
 
-- 
2.30.2

