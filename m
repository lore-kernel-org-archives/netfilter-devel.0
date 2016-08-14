From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v2] netfilter: nf_tables: Check for overflow of u8 fields
 from u32 netlink attributes
Date: Sun, 14 Aug 2016 16:59:36 +0200
Message-ID: <20160814145933.GA22849@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33687 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbcHNO7y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Aug 2016 10:59:54 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so6751507wme.0
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Aug 2016 07:59:53 -0700 (PDT)
Received: from sonyv ([213.143.60.35])
        by smtp.gmail.com with ESMTPSA id b123sm11975600wmg.17.2016.08.14.07.59.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 14 Aug 2016 07:59:39 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the direct assignment from u32 data input into an attribute with a
size of u8.

Refer to 4da449ae1df

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in V2:
	- Collapse the 5 independent patches in just one
	- Change description and subject
	- Add bug link

 net/netfilter/nft_bitwise.c   |  7 ++++++-
 net/netfilter/nft_byteorder.c | 13 +++++++++++--
 net/netfilter/nft_cmp.c       |  5 ++++-
 net/netfilter/nft_immediate.c |  3 +++
 net/netfilter/nft_nat.c       |  2 ++
 5 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d71cc18..2c49f69 100644
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
+		return -EINVAL;
+	priv->len = len;
+
 	priv->sreg = nft_parse_register(tb[NFTA_BITWISE_SREG]);
 	err = nft_validate_register_load(priv->sreg, priv->len);
 	if (err < 0)
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index b78c28b..fdd23d5 100644
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
+		return -EINVAL;
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
+		return -EINVAL;
+	priv->len = len;
+
 	err = nft_validate_register_load(priv->sreg, priv->len);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index e25b35d..ca247e5 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -84,8 +84,11 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+	if (desc.len > U8_MAX)
+		return -EINVAL;
 	priv->len = desc.len;
+	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+
 	return 0;
 }
 
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index db3b746..6de590c 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -53,6 +53,9 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 			    tb[NFTA_IMMEDIATE_DATA]);
 	if (err < 0)
 		return err;
+
+	if (desc.len > U8_MAX)
+		return -EINVAL;
 	priv->dlen = desc.len;
 
 	priv->dreg = nft_parse_register(tb[NFTA_IMMEDIATE_DREG]);
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ee2d717..74f8293 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -148,6 +148,8 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	family = ntohl(nla_get_be32(tb[NFTA_NAT_FAMILY]));
 	if (family != ctx->afi->family)
 		return -EOPNOTSUPP;
+	if (family > U8_MAX)
+		return -EINVAL;
 
 	switch (family) {
 	case NFPROTO_IPV4:
-- 
2.8.1

