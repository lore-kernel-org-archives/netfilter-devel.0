From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: Ensure u8 attributes are loaded
 from u32 within the bounds
Date: Wed, 14 Sep 2016 15:00:02 +0200
Message-ID: <20160914125959.GA3020@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35982 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755632AbcINNAI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Sep 2016 09:00:08 -0400
Received: by mail-wm0-f66.google.com with SMTP id b184so2491271wma.3
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Sep 2016 06:00:07 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check storage of u32 netlink attributes in smaller resources. This
validation is usually required when the u32 netlink attributes are being
stored in a private structure size of u8 in the kernel.

4da449a ("netfilter: nft_exthdr: Add size check on u8 nft_exthdr
attributes")

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 26 ++++++++++++++++++++++++++
 net/netfilter/nft_bitwise.c       | 10 +++++++++-
 net/netfilter/nft_byteorder.c     | 17 +++++++++++++++--
 net/netfilter/nft_cmp.c           |  6 +++++-
 net/netfilter/nft_exthdr.c        | 19 ++++++++++++-------
 net/netfilter/nft_immediate.c     |  4 ++++
 7 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f2f1339..608130f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -127,6 +127,8 @@ static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
 	return type == NFT_DATA_VERDICT ? NFT_REG_VERDICT : NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE;
 }
 
+unsigned int nft_parse_u32_check(const struct nlattr *attr, int maxlen,
+				 u32 *dest);
 unsigned int nft_parse_register(const struct nlattr *attr);
 int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7e1c876..d7b000f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4343,6 +4343,32 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 }
 
 /**
+ *	nft_parse_u32_check - parse a u32 value to store the value into a
+ *			      smaller resource.
+ *
+ *	@attr: netlink attribute
+ *	@maxlen: maximum value to be stored in dest
+ *	@dest: pointer to the resource
+ *
+ *	Parse and store a given u32 value into a resource. Returns an error
+ *	ERANGE if the value will overload the maxlen, otherwise a 0 will be
+ *	returned and the value is stored into dest.
+ */
+unsigned int nft_parse_u32_check(const struct nlattr *attr, int maxlen,
+				 u32 *dest)
+{
+	int reg;
+
+	reg = ntohl(nla_get_be32(attr));
+	if (reg > maxlen)
+		return -ERANGE;
+
+	*dest = reg;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_parse_u32_check);
+
+/**
  *	nft_parse_register - parse a register value from a netlink attribute
  *
  *	@attr: netlink attribute
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d71cc18..e7f23a1 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -14,6 +14,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/static_key.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
@@ -52,6 +53,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 {
 	struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_data_desc d1, d2;
+	u32 len;
 	int err;
 
 	if (tb[NFTA_BITWISE_SREG] == NULL ||
@@ -61,7 +63,13 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	    tb[NFTA_BITWISE_XOR] == NULL)
 		return -EINVAL;
 
-	priv->len  = ntohl(nla_get_be32(tb[NFTA_BITWISE_LEN]));
+	err  = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX,
+				   &len);
+	if (err < 0)
+		return err;
+
+	priv->len = len;
+
 	priv->sreg = nft_parse_register(tb[NFTA_BITWISE_SREG]);
 	err = nft_validate_register_load(priv->sreg, priv->len);
 	if (err < 0)
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index b78c28b..8cac219 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -99,6 +99,7 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 			      const struct nlattr * const tb[])
 {
 	struct nft_byteorder *priv = nft_expr_priv(expr);
+	u32 size, len;
 	int err;
 
 	if (tb[NFTA_BYTEORDER_SREG] == NULL ||
@@ -117,7 +118,13 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 		return -EINVAL;
 	}
 
-	priv->size = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_SIZE]));
+	err = nft_parse_u32_check(tb[NFTA_BYTEORDER_SIZE], U8_MAX,
+				  &size);
+	if (err < 0)
+		return err;
+
+	priv->size = size;
+
 	switch (priv->size) {
 	case 2:
 	case 4:
@@ -128,7 +135,13 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	}
 
 	priv->sreg = nft_parse_register(tb[NFTA_BYTEORDER_SREG]);
-	priv->len  = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_LEN]));
+	err = nft_parse_u32_check(tb[NFTA_BYTEORDER_LEN], U8_MAX,
+				  &len);
+	if (err < 0)
+		return err;
+
+	priv->len = len;
+
 	err = nft_validate_register_load(priv->sreg, priv->len);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index e25b35d..3d31432 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -84,8 +84,12 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+	if (desc.len > U8_MAX)
+		return -ERANGE;
 	priv->len = desc.len;
+
+	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
+
 	return 0;
 }
 
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 82c264e..613732d8 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -59,7 +59,7 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 offset, len;
+	u32 offset, len, err;
 
 	if (tb[NFTA_EXTHDR_DREG] == NULL ||
 	    tb[NFTA_EXTHDR_TYPE] == NULL ||
@@ -67,15 +67,20 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 	    tb[NFTA_EXTHDR_LEN] == NULL)
 		return -EINVAL;
 
-	offset = ntohl(nla_get_be32(tb[NFTA_EXTHDR_OFFSET]));
-	len = ntohl(nla_get_be32(tb[NFTA_EXTHDR_LEN]));
+	err = nft_parse_u32_check(tb[NFTA_EXTHDR_OFFSET], U8_MAX,
+				  &offset);
+	if (err < 0)
+		return err;
 
-	if (offset > U8_MAX || len > U8_MAX)
-		return -ERANGE;
+	priv->offset = offset;
 
+	err = nft_parse_u32_check(tb[NFTA_EXTHDR_LEN], U8_MAX,
+				  &len);
+	if (err < 0)
+		return err;
+
+	priv->len = len;
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
-	priv->offset = offset;
-	priv->len    = len;
 	priv->dreg   = nft_parse_register(tb[NFTA_EXTHDR_DREG]);
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index db3b746..d17018f 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -53,6 +53,10 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 			    tb[NFTA_IMMEDIATE_DATA]);
 	if (err < 0)
 		return err;
+
+	if (desc.len > U8_MAX)
+		return -ERANGE;
+
 	priv->dlen = desc.len;
 
 	priv->dreg = nft_parse_register(tb[NFTA_IMMEDIATE_DREG]);
-- 
2.8.1

