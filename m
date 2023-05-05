Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3C7C7EE23
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 11:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjEELRY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 07:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjEELRP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 07:17:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C513A5D1
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 04:17:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1putQv-0005RI-2G; Fri, 05 May 2023 13:17:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: pass context structure to nft_parse_register_load
Date:   Fri,  5 May 2023 13:16:54 +0200
Message-Id: <20230505111656.32238-2-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230505111656.32238-1-fw@strlen.de>
References: <20230505111656.32238-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mechanical transformation, no logical changes intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h      | 3 ++-
 net/bridge/netfilter/nft_meta_bridge.c | 2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c      | 4 ++--
 net/ipv6/netfilter/nft_dup_ipv6.c      | 4 ++--
 net/netfilter/nf_tables_api.c          | 3 ++-
 net/netfilter/nft_bitwise.c            | 4 ++--
 net/netfilter/nft_byteorder.c          | 2 +-
 net/netfilter/nft_cmp.c                | 6 +++---
 net/netfilter/nft_ct.c                 | 2 +-
 net/netfilter/nft_dup_netdev.c         | 2 +-
 net/netfilter/nft_dynset.c             | 4 ++--
 net/netfilter/nft_exthdr.c             | 2 +-
 net/netfilter/nft_fwd_netdev.c         | 6 +++---
 net/netfilter/nft_hash.c               | 2 +-
 net/netfilter/nft_lookup.c             | 2 +-
 net/netfilter/nft_masq.c               | 4 ++--
 net/netfilter/nft_meta.c               | 2 +-
 net/netfilter/nft_nat.c                | 8 ++++----
 net/netfilter/nft_objref.c             | 2 +-
 net/netfilter/nft_payload.c            | 2 +-
 net/netfilter/nft_queue.c              | 2 +-
 net/netfilter/nft_range.c              | 2 +-
 net/netfilter/nft_redir.c              | 4 ++--
 net/netfilter/nft_tproxy.c             | 4 ++--
 24 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3ed21d2d5659..246c4a4620ae 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -253,7 +253,8 @@ static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
 int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest);
 int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
 
-int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
+int nft_parse_register_load(const struct nft_ctx *ctx,
+			    const struct nlattr *attr, u8 *sreg, u32 len);
 int nft_parse_register_store(const struct nft_ctx *ctx,
 			     const struct nlattr *attr, u8 *dreg,
 			     const struct nft_data *data,
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index bd4d1b4d745f..4d8e15927217 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -142,7 +142,7 @@ static int nft_meta_bridge_set_init(const struct nft_ctx *ctx,
 	}
 
 	priv->len = len;
-	err = nft_parse_register_load(tb[NFTA_META_SREG], &priv->sreg, len);
+	err = nft_parse_register_load(ctx, tb[NFTA_META_SREG], &priv->sreg, len);
 	if (err < 0)
 		return err;
 
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index a522c3a3be52..ef5dd88107dd 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -40,13 +40,13 @@ static int nft_dup_ipv4_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DUP_SREG_ADDR] == NULL)
 		return -EINVAL;
 
-	err = nft_parse_register_load(tb[NFTA_DUP_SREG_ADDR], &priv->sreg_addr,
+	err = nft_parse_register_load(ctx, tb[NFTA_DUP_SREG_ADDR], &priv->sreg_addr,
 				      sizeof(struct in_addr));
 	if (err < 0)
 		return err;
 
 	if (tb[NFTA_DUP_SREG_DEV])
-		err = nft_parse_register_load(tb[NFTA_DUP_SREG_DEV],
+		err = nft_parse_register_load(ctx, tb[NFTA_DUP_SREG_DEV],
 					      &priv->sreg_dev, sizeof(int));
 
 	return err;
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index c82f3fdd4a65..492a811828a7 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -38,13 +38,13 @@ static int nft_dup_ipv6_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DUP_SREG_ADDR] == NULL)
 		return -EINVAL;
 
-	err = nft_parse_register_load(tb[NFTA_DUP_SREG_ADDR], &priv->sreg_addr,
+	err = nft_parse_register_load(ctx, tb[NFTA_DUP_SREG_ADDR], &priv->sreg_addr,
 				      sizeof(struct in6_addr));
 	if (err < 0)
 		return err;
 
 	if (tb[NFTA_DUP_SREG_DEV])
-		err = nft_parse_register_load(tb[NFTA_DUP_SREG_DEV],
+		err = nft_parse_register_load(ctx, tb[NFTA_DUP_SREG_DEV],
 					      &priv->sreg_dev, sizeof(int));
 
 	return err;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 09542951656c..4fd6bbb88cd2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10036,7 +10036,8 @@ static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 	return 0;
 }
 
-int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len)
+int nft_parse_register_load(const struct nft_ctx *ctx,
+			    const struct nlattr *attr, u8 *sreg, u32 len)
 {
 	u32 reg;
 	int err;
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 84eae7cabc67..6e94619df639 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -171,7 +171,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 
 	priv->len = len;
 
-	err = nft_parse_register_load(tb[NFTA_BITWISE_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_BITWISE_SREG], &priv->sreg,
 				      priv->len);
 	if (err < 0)
 		return err;
@@ -365,7 +365,7 @@ static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
 	struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
 	int err;
 
-	err = nft_parse_register_load(tb[NFTA_BITWISE_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_BITWISE_SREG], &priv->sreg,
 				      sizeof(u32));
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index b66647a5a171..522b84460e69 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -138,7 +138,7 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 
 	priv->len = len;
 
-	err = nft_parse_register_load(tb[NFTA_BYTEORDER_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_BYTEORDER_SREG], &priv->sreg,
 				      priv->len);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 6eb21a4f5698..4cdcbb74c74d 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -83,7 +83,7 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
+	err = nft_parse_register_load(ctx, tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
 	if (err < 0)
 		return err;
 
@@ -222,7 +222,7 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
+	err = nft_parse_register_load(ctx, tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
 	if (err < 0)
 		return err;
 
@@ -323,7 +323,7 @@ static int nft_cmp16_fast_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
+	err = nft_parse_register_load(ctx, tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index b9c84499438b..614628099ac3 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -601,7 +601,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 	}
 
 	priv->len = len;
-	err = nft_parse_register_load(tb[NFTA_CT_SREG], &priv->sreg, len);
+	err = nft_parse_register_load(ctx, tb[NFTA_CT_SREG], &priv->sreg, len);
 	if (err < 0)
 		goto err1;
 
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index e5739a59ebf1..0573f96ce079 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -40,7 +40,7 @@ static int nft_dup_netdev_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DUP_SREG_DEV] == NULL)
 		return -EINVAL;
 
-	return nft_parse_register_load(tb[NFTA_DUP_SREG_DEV], &priv->sreg_dev,
+	return nft_parse_register_load(ctx, tb[NFTA_DUP_SREG_DEV], &priv->sreg_dev,
 				       sizeof(int));
 }
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 274579b1696e..9589a72c2af6 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -211,7 +211,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			return err;
 	}
 
-	err = nft_parse_register_load(tb[NFTA_DYNSET_SREG_KEY], &priv->sreg_key,
+	err = nft_parse_register_load(ctx, tb[NFTA_DYNSET_SREG_KEY], &priv->sreg_key,
 				      set->klen);
 	if (err < 0)
 		return err;
@@ -222,7 +222,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (set->dtype == NFT_DATA_VERDICT)
 			return -EOPNOTSUPP;
 
-		err = nft_parse_register_load(tb[NFTA_DYNSET_SREG_DATA],
+		err = nft_parse_register_load(ctx, tb[NFTA_DYNSET_SREG_DATA],
 					      &priv->sreg_data, set->dlen);
 		if (err < 0)
 			return err;
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a54a7f772cec..e30cd98acc7d 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -509,7 +509,7 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 	priv->flags  = flags;
 	priv->op     = op;
 
-	return nft_parse_register_load(tb[NFTA_EXTHDR_SREG], &priv->sreg,
+	return nft_parse_register_load(ctx, tb[NFTA_EXTHDR_SREG], &priv->sreg,
 				       priv->len);
 }
 
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 7b9d4d1bd17c..aa2a54fa6800 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -52,7 +52,7 @@ static int nft_fwd_netdev_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_FWD_SREG_DEV] == NULL)
 		return -EINVAL;
 
-	return nft_parse_register_load(tb[NFTA_FWD_SREG_DEV], &priv->sreg_dev,
+	return nft_parse_register_load(ctx, tb[NFTA_FWD_SREG_DEV], &priv->sreg_dev,
 				       sizeof(int));
 }
 
@@ -178,12 +178,12 @@ static int nft_fwd_neigh_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	err = nft_parse_register_load(tb[NFTA_FWD_SREG_DEV], &priv->sreg_dev,
+	err = nft_parse_register_load(ctx, tb[NFTA_FWD_SREG_DEV], &priv->sreg_dev,
 				      sizeof(int));
 	if (err < 0)
 		return err;
 
-	return nft_parse_register_load(tb[NFTA_FWD_SREG_ADDR], &priv->sreg_addr,
+	return nft_parse_register_load(ctx, tb[NFTA_FWD_SREG_ADDR], &priv->sreg_addr,
 				       addr_len);
 }
 
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index ee8d487b69c0..9833fa429e5e 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -91,7 +91,7 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 
 	priv->len = len;
 
-	err = nft_parse_register_load(tb[NFTA_HASH_SREG], &priv->sreg, len);
+	err = nft_parse_register_load(ctx, tb[NFTA_HASH_SREG], &priv->sreg, len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index cecf8ab90e58..f0156b31b5cf 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -111,7 +111,7 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	err = nft_parse_register_load(tb[NFTA_LOOKUP_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_LOOKUP_SREG], &priv->sreg,
 				      set->klen);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index b115d77fbbc7..c1a833aa3aa1 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -54,13 +54,13 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 	}
 
 	if (tb[NFTA_MASQ_REG_PROTO_MIN]) {
-		err = nft_parse_register_load(tb[NFTA_MASQ_REG_PROTO_MIN],
+		err = nft_parse_register_load(ctx, tb[NFTA_MASQ_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_MASQ_REG_PROTO_MAX]) {
-			err = nft_parse_register_load(tb[NFTA_MASQ_REG_PROTO_MAX],
+			err = nft_parse_register_load(ctx, tb[NFTA_MASQ_REG_PROTO_MAX],
 						      &priv->sreg_proto_max,
 						      plen);
 			if (err < 0)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e384e0de7a54..ef3f8ebf6409 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -657,7 +657,7 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 	}
 
 	priv->len = len;
-	err = nft_parse_register_load(tb[NFTA_META_SREG], &priv->sreg, len);
+	err = nft_parse_register_load(ctx, tb[NFTA_META_SREG], &priv->sreg, len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 5c29915ab028..9d606ce7dda0 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -208,13 +208,13 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	priv->family = family;
 
 	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
-		err = nft_parse_register_load(tb[NFTA_NAT_REG_ADDR_MIN],
+		err = nft_parse_register_load(ctx, tb[NFTA_NAT_REG_ADDR_MIN],
 					      &priv->sreg_addr_min, alen);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_NAT_REG_ADDR_MAX]) {
-			err = nft_parse_register_load(tb[NFTA_NAT_REG_ADDR_MAX],
+			err = nft_parse_register_load(ctx, tb[NFTA_NAT_REG_ADDR_MAX],
 						      &priv->sreg_addr_max,
 						      alen);
 			if (err < 0)
@@ -228,13 +228,13 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
-		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
+		err = nft_parse_register_load(ctx, tb[NFTA_NAT_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_NAT_REG_PROTO_MAX]) {
-			err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MAX],
+			err = nft_parse_register_load(ctx, tb[NFTA_NAT_REG_PROTO_MAX],
 						      &priv->sreg_proto_max,
 						      plen);
 			if (err < 0)
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index cb37169608ba..90a84b61cc36 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -141,7 +141,7 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 	if (!(set->flags & NFT_SET_OBJECT))
 		return -EINVAL;
 
-	err = nft_parse_register_load(tb[NFTA_OBJREF_SET_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_OBJREF_SET_SREG], &priv->sreg,
 				      set->klen);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 3a3c7746e88f..3055576aa9ed 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -916,7 +916,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	}
 	priv->csum_type = csum_type;
 
-	return nft_parse_register_load(tb[NFTA_PAYLOAD_SREG], &priv->sreg,
+	return nft_parse_register_load(ctx, tb[NFTA_PAYLOAD_SREG], &priv->sreg,
 				       priv->len);
 }
 
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index b2b8127c8d43..44e6817e6e29 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -136,7 +136,7 @@ static int nft_queue_sreg_init(const struct nft_ctx *ctx,
 	struct nft_queue *priv = nft_expr_priv(expr);
 	int err;
 
-	err = nft_parse_register_load(tb[NFTA_QUEUE_SREG_QNUM],
+	err = nft_parse_register_load(ctx, tb[NFTA_QUEUE_SREG_QNUM],
 				      &priv->sreg_qnum, sizeof(u32));
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 0566d6aaf1e5..d75772986d05 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -83,7 +83,7 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 		goto err2;
 	}
 
-	err = nft_parse_register_load(tb[NFTA_RANGE_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_RANGE_SREG], &priv->sreg,
 				      desc_from.len);
 	if (err < 0)
 		goto err2;
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index a70196ffcb1e..40035784ce83 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -50,13 +50,13 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 
 	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
-		err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MIN],
+		err = nft_parse_register_load(ctx, tb[NFTA_REDIR_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_REDIR_REG_PROTO_MAX]) {
-			err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MAX],
+			err = nft_parse_register_load(ctx, tb[NFTA_REDIR_REG_PROTO_MAX],
 						      &priv->sreg_proto_max,
 						      plen);
 			if (err < 0)
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index ea83f661417e..c82ec0f99d43 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -254,14 +254,14 @@ static int nft_tproxy_init(const struct nft_ctx *ctx,
 	}
 
 	if (tb[NFTA_TPROXY_REG_ADDR]) {
-		err = nft_parse_register_load(tb[NFTA_TPROXY_REG_ADDR],
+		err = nft_parse_register_load(ctx, tb[NFTA_TPROXY_REG_ADDR],
 					      &priv->sreg_addr, alen);
 		if (err < 0)
 			return err;
 	}
 
 	if (tb[NFTA_TPROXY_REG_PORT]) {
-		err = nft_parse_register_load(tb[NFTA_TPROXY_REG_PORT],
+		err = nft_parse_register_load(ctx, tb[NFTA_TPROXY_REG_PORT],
 					      &priv->sreg_port, sizeof(u16));
 		if (err < 0)
 			return err;
-- 
2.39.2

