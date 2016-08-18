From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v3] netfilter: nf_tables: Ensure init attributes are within
 the bounds
Date: Thu, 18 Aug 2016 13:45:24 +0200
Message-ID: <20160818114521.GA32566@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35190 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbcHRLqB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2016 07:46:01 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so5256243wmg.2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 04:45:29 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id d80sm31305080wmd.14.2016.08.18.04.45.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 18 Aug 2016 04:45:27 -0700 (PDT)
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

Changes in V3:
	- Use ERANGE instead of EINVAL when validating the value is
within the bounds.
	- Add op verification in nft_cmp_init().
	- Remove additional bounds verification for family attribute in
nft_nat_init().

 net/netfilter/nft_bitwise.c   |  7 ++++++-
 net/netfilter/nft_byteorder.c | 13 +++++++++++--
 net/netfilter/nft_cmp.c       |  7 ++++++-
 net/netfilter/nft_immediate.c |  3 +++
 4 files changed, 26 insertions(+), 4 deletions(-)

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
index e25b35d..7412c82 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -84,8 +84,13 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+	if (desc.len > U8_MAX)
+		return -ERANGE;
 	priv->len = desc.len;
+	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+	if (priv->op >= NFT_CMP_MAX)
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

