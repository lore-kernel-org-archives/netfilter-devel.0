Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9195E36B0D
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719496705; cv=none; b=lIP4OmvOAAbslg2CNNtBHvgsvpS1QhATPcuR5pJcNrXnQsm4V5N/ZXAfvbeXVfJoDtMNbkEsuhWajyw3HrlMyOBfXIRa6CXC+ghCdFGge4Ca/bD48Z2CdjraaWTrt2+QUJY4Y2U34UGJ0Pld2NqJOcWjHJiL/lfp3MqqNUN7Cts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719496705; c=relaxed/simple;
	bh=SKTsGqK3Il7VhfDGEtvTvkYl1Kx8ncmiGGqXYRVo/co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1wn8Der6tXRaQRNGMjFcxVKa+cJxUtiUvgZhg8oinjhPwDs7E8nl52vNLZ8S8zjLcVPTU5S66YW0wpryd1813tIsuJJUZtQR2xsp13SWBd9kiDyeuXAP4KoCq4yhGbUxE0layWXfuNfwShcDcl9GlSMiM2V3aUgK3KZKvQkre0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sMpdg-0002AI-CD; Thu, 27 Jun 2024 15:58:16 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 1/4] netfilter: nf_tables: pass context structure to nft_parse_register_load
Date: Thu, 27 Jun 2024 15:53:21 +0200
Message-ID: <20240627135330.17039-2-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240627135330.17039-1-fw@strlen.de>
References: <20240627135330.17039-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 1e8da1b882ac..9a71fc20598b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -254,7 +254,8 @@ static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
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
index 02d75aefaa8e..7437b38269a5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11102,7 +11102,8 @@ static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 	return 0;
 }
 
-int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len)
+int nft_parse_register_load(const struct nft_ctx *ctx,
+			    const struct nlattr *attr, u8 *sreg, u32 len)
 {
 	u32 reg;
 	int err;
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index ca857afbf061..7de95674fd8c 100644
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
index f6e791a68101..2f82a444d21b 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -139,7 +139,7 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 
 	priv->len = len;
 
-	err = nft_parse_register_load(tb[NFTA_BYTEORDER_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_BYTEORDER_SREG], &priv->sreg,
 				      priv->len);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index cd4652259095..2605f43737bc 100644
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
index 452ed94c3a4d..67a41cd2baaf 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -606,7 +606,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
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
index b4ada3ab2167..6920df754265 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -215,7 +215,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			return err;
 	}
 
-	err = nft_parse_register_load(tb[NFTA_DYNSET_SREG_KEY], &priv->sreg_key,
+	err = nft_parse_register_load(ctx, tb[NFTA_DYNSET_SREG_KEY], &priv->sreg_key,
 				      set->klen);
 	if (err < 0)
 		return err;
@@ -226,7 +226,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (set->dtype == NFT_DATA_VERDICT)
 			return -EOPNOTSUPP;
 
-		err = nft_parse_register_load(tb[NFTA_DYNSET_SREG_DATA],
+		err = nft_parse_register_load(ctx, tb[NFTA_DYNSET_SREG_DATA],
 					      &priv->sreg_data, set->dlen);
 		if (err < 0)
 			return err;
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 6eb571d0c3fd..6bfd33516241 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -588,7 +588,7 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 	priv->flags  = flags;
 	priv->op     = op;
 
-	return nft_parse_register_load(tb[NFTA_EXTHDR_SREG], &priv->sreg,
+	return nft_parse_register_load(ctx, tb[NFTA_EXTHDR_SREG], &priv->sreg,
 				       priv->len);
 }
 
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 358e742afad7..c83a794025f9 100644
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
index 868d68302d22..5d034bbb6913 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -92,7 +92,7 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 
 	priv->len = len;
 
-	err = nft_parse_register_load(tb[NFTA_HASH_SREG], &priv->sreg, len);
+	err = nft_parse_register_load(ctx, tb[NFTA_HASH_SREG], &priv->sreg, len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index b314ca728a29..146bf9444c03 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -113,7 +113,7 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	err = nft_parse_register_load(tb[NFTA_LOOKUP_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_LOOKUP_SREG], &priv->sreg,
 				      set->klen);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 8a14aaca93bb..cb43c72a8c2a 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -52,13 +52,13 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 		priv->flags = ntohl(nla_get_be32(tb[NFTA_MASQ_FLAGS]));
 
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
index 9139ce38ea7b..0214ad1ced2f 100644
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
index 808f5802c270..983dd937fe02 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -214,13 +214,13 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
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
@@ -234,13 +234,13 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
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
index 509011b1ef59..09da7a3f9f96 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -143,7 +143,7 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 	if (!(set->flags & NFT_SET_OBJECT))
 		return -EINVAL;
 
-	err = nft_parse_register_load(tb[NFTA_OBJREF_SET_SREG], &priv->sreg,
+	err = nft_parse_register_load(ctx, tb[NFTA_OBJREF_SET_SREG], &priv->sreg,
 				      set->klen);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 50429cbd42da..330609a76fb2 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -981,7 +981,7 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
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
index 51ae64cd268f..ea382f7bbd78 100644
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
index a58bd8d291ff..6568cc264078 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -51,13 +51,13 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 
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
index 71412adb73d4..1b691393d8b1 100644
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
2.44.2

