From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v4] netfilter: nf_tables: Ensure init attributes are within
 the bounds
Date: Thu, 18 Aug 2016 18:06:26 +0200
Message-ID: <20160818160623.GA25544@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34648 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbcHSEvW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 00:51:22 -0400
Received: by mail-wm0-f68.google.com with SMTP id q128so1950909wma.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 21:51:21 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id r127sm201514wmf.23.2016.08.18.09.06.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 18 Aug 2016 09:06:29 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check for overflow of u8 fields from u32 netlink attributes and maximum
values.

Refer to 4da449ae1df

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
(was: netfilter: nf_tables: Check for overflow of u8 fields from u32
netlink attributes)

Changes in V4:
	- Define NFT_CMP_MAX

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_bitwise.c              |  7 ++++++-
 net/netfilter/nft_byteorder.c            | 13 +++++++++++--
 net/netfilter/nft_cmp.c                  |  9 ++++++++-
 net/netfilter/nft_immediate.c            |  3 +++
 5 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 0ddefb1..ce12a20 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -528,7 +528,9 @@ enum nft_cmp_ops {
 	NFT_CMP_LTE,
 	NFT_CMP_GT,
 	NFT_CMP_GTE,
+	__NFT_CMP_MAX
 };
+#define NFT_CMP_MAX	(__NFT_CMP_MAX - 1)
 
 /**
  * enum nft_cmp_attributes - nf_tables cmp expression netlink attributes
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d71cc18..6e09b1e 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -53,6 +53,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_data_desc d1, d2;
 	int err;
+	u32 len;
 
 	if (tb[NFTA_BITWISE_SREG] == NULL ||
 	    tb[NFTA_BITWISE_DREG] == NULL ||
@@ -61,7 +62,11 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	    tb[NFTA_BITWISE_XOR] == NULL)
 		return -EINVAL;
 
-	priv->len  = ntohl(nla_get_be32(tb[NFTA_BITWISE_LEN]));
+	len  = ntohl(nla_get_be32(tb[NFTA_BITWISE_LEN]));
+	if (len > U8_MAX)
+		return -ERANGE;
+	priv->len = len;
+
 	priv->sreg = nft_parse_register(tb[NFTA_BITWISE_SREG]);
 	err = nft_validate_register_load(priv->sreg, priv->len);
 	if (err < 0)
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index b78c28b..763cf15 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -100,6 +100,7 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 {
 	struct nft_byteorder *priv = nft_expr_priv(expr);
 	int err;
+	u32 len, size;
 
 	if (tb[NFTA_BYTEORDER_SREG] == NULL ||
 	    tb[NFTA_BYTEORDER_DREG] == NULL ||
@@ -117,7 +118,10 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 		return -EINVAL;
 	}
 
-	priv->size = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_SIZE]));
+	size = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_SIZE]));
+	if (size > U8_MAX)
+		return -ERANGE;
+	priv->size = size;
 	switch (priv->size) {
 	case 2:
 	case 4:
@@ -128,7 +132,12 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	}
 
 	priv->sreg = nft_parse_register(tb[NFTA_BYTEORDER_SREG]);
-	priv->len  = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_LEN]));
+
+	len  = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_LEN]));
+	if (len > U8_MAX)
+		return -ERANGE;
+	priv->len = len;
+
 	err = nft_validate_register_load(priv->sreg, priv->len);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index e25b35d..cb9cfab 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -55,6 +55,8 @@ static void nft_cmp_eval(const struct nft_expr *expr,
 		if (d < 0)
 			goto mismatch;
 		break;
+	default:
+		break;
 	}
 	return;
 
@@ -84,8 +86,13 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+	if (desc.len > U8_MAX)
+		return -ERANGE;
 	priv->len = desc.len;
+	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+	if (priv->op > NFT_CMP_MAX)
+		return -ERANGE;
+
 	return 0;
 }
 
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index db3b746..b5f899c 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -53,6 +53,9 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 			    tb[NFTA_IMMEDIATE_DATA]);
 	if (err < 0)
 		return err;
+
+	if (desc.len > U8_MAX)
+		return -ERANGE;
 	priv->dlen = desc.len;
 
 	priv->dreg = nft_parse_register(tb[NFTA_IMMEDIATE_DREG]);
-- 
2.8.1

