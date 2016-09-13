From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v3 libnftnl] expr: numgen: add number generation offset
Date: Tue, 13 Sep 2016 13:50:41 +0200
Message-ID: <20160913115038.GA15797@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33889 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbcIMLuq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 07:50:46 -0400
Received: by mail-wm0-f66.google.com with SMTP id g141so6942803wmd.1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 04:50:45 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id uv6sm22608683wjc.31.2016.09.13.04.50.43
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 13 Sep 2016 04:50:44 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to pass through an offset value to the counter
initialization. With this feature, the sysadmin is able to apply a value
to be added to the generated number.

Example:

	meta mark set numgen inc mod 2 offset 100

This will generate marks with series 100, 101, 100, 101, ...

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v2:
	- Separate offset changes with _until_ attribute renaming, as
Pablo suggested.

Changes in v3:
	- Use OFFSET attribute instead of SUM.
	- Add offset support for random counter.

 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/numgen.c                   | 39 +++++++++++++++++++++++++++++++------
 tests/nft-expr_numgen-test.c        |  4 ++++
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 8b35203..a8206ba 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -54,6 +54,7 @@ enum {
 	NFTNL_EXPR_NG_DREG	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_NG_MODULUS,
 	NFTNL_EXPR_NG_TYPE,
+	NFTNL_EXPR_NG_OFFSET,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e608054..038895b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1130,12 +1130,14 @@ enum nft_trace_types {
  * @NFTA_NG_DREG: destination register (NLA_U32)
  * @NFTA_NG_MODULUS: maximum value to be returned (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
+ * @NFTA_NG_OFFSET: offset to be added to the counter (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
 	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
+	NFTA_NG_OFFSET,
 	__NFTA_NG_MAX
 };
 #define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index a23be53..8b667c2 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -24,6 +24,7 @@ struct nftnl_expr_ng {
 	enum nft_registers	dreg;
 	unsigned int		modulus;
 	enum nft_ng_types	type;
+	unsigned int		offset;
 };
 
 static int
@@ -42,6 +43,9 @@ nftnl_expr_ng_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NG_TYPE:
 		ng->type = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_NG_OFFSET:
+		ng->offset = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -64,6 +68,9 @@ nftnl_expr_ng_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NG_TYPE:
 		*data_len = sizeof(ng->type);
 		return &ng->type;
+	case NFTNL_EXPR_NG_OFFSET:
+		*data_len = sizeof(ng->offset);
+		return &ng->offset;
 	}
 	return NULL;
 }
@@ -80,6 +87,7 @@ static int nftnl_expr_ng_cb(const struct nlattr *attr, void *data)
 	case NFTA_NG_DREG:
 	case NFTA_NG_MODULUS:
 	case NFTA_NG_TYPE:
+	case NFTA_NG_OFFSET:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -100,6 +108,8 @@ nftnl_expr_ng_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_NG_MODULUS, htonl(ng->modulus));
 	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		mnl_attr_put_u32(nlh, NFTA_NG_TYPE, htonl(ng->type));
+	if (e->flags & (1 << NFTNL_EXPR_NG_OFFSET))
+		mnl_attr_put_u32(nlh, NFTA_NG_OFFSET, htonl(ng->offset));
 }
 
 static int
@@ -124,6 +134,10 @@ nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ng->type = ntohl(mnl_attr_get_u32(tb[NFTA_NG_TYPE]));
 		e->flags |= (1 << NFTNL_EXPR_NG_TYPE);
 	}
+	if (tb[NFTA_NG_OFFSET]) {
+		ng->offset = ntohl(mnl_attr_get_u32(tb[NFTA_NG_OFFSET]));
+		e->flags |= (1 << NFTNL_EXPR_NG_OFFSET);
+	}
 
 	return ret;
 }
@@ -132,7 +146,7 @@ static int nftnl_expr_ng_json_parse(struct nftnl_expr *e, json_t *root,
 				    struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint32_t dreg, modulus, type;
+	uint32_t dreg, modulus, type, offset;
 
 	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32,
 				    &dreg, err) == 0)
@@ -146,6 +160,10 @@ static int nftnl_expr_ng_json_parse(struct nftnl_expr *e, json_t *root,
 				    &type, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
 
+	if (nftnl_jansson_parse_val(root, "offset", NFTNL_TYPE_U32,
+				    &offset, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_OFFSET, offset);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -159,7 +177,7 @@ static int nftnl_expr_ng_xml_parse(struct nftnl_expr *e,
 				   struct nftnl_parse_err *err)
 {
 #ifdef XML_PARSING
-	uint32_t dreg, modulus, type;
+	uint32_t dreg, modulus, type, offset;
 
 	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
 				 NFTNL_XML_MAND, err) == 0)
@@ -175,6 +193,11 @@ static int nftnl_expr_ng_xml_parse(struct nftnl_expr *e,
 				 err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
 
+	if (nftnl_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
+				 &offset, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_OFFSET, offset);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -191,13 +214,13 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 
 	switch (ng->type) {
 	case NFT_NG_INCREMENTAL:
-		ret = snprintf(buf, len, "reg %u = inc mod %u ", ng->dreg,
-			       ng->modulus);
+		ret = snprintf(buf, len, "reg %u = %u + inc mod %u ", ng->dreg,
+			       ng->offset, ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFT_NG_RANDOM:
-		ret = snprintf(buf, len, "reg %u = random mod %u ", ng->dreg,
-			       ng->modulus);
+		ret = snprintf(buf, len, "reg %u = %u + random mod %u ",
+			       ng->dreg, ng->offset, ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	default:
@@ -220,6 +243,8 @@ static int nftnl_expr_ng_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, ng->modulus, MODULUS);
 	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		nftnl_buf_u32(&b, type, ng->type, TYPE);
+	if (e->flags & (1 << NFTNL_EXPR_NG_OFFSET))
+		nftnl_buf_u32(&b, type, ng->type, OFFSET);
 
 	return nftnl_buf_done(&b);
 }
@@ -253,6 +278,8 @@ static bool nftnl_expr_ng_cmp(const struct nftnl_expr *e1,
 		eq &= (n1->modulus == n2->modulus);
 	if (e1->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		eq &= (n1->type == n2->type);
+	if (e1->flags & (1 << NFTNL_EXPR_NG_OFFSET))
+		eq &= (n1->offset == n2->offset);
 
 	return eq;
 }
diff --git a/tests/nft-expr_numgen-test.c b/tests/nft-expr_numgen-test.c
index 7092c8d..0d0a3bb 100644
--- a/tests/nft-expr_numgen-test.c
+++ b/tests/nft-expr_numgen-test.c
@@ -39,6 +39,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_TYPE) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_TYPE))
 		print_err("Expr NFTNL_EXPR_NG_TYPE mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_OFFSET) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_OFFSET))
+		print_err("Expr NFTNL_EXPR_NG_OFFSET mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -61,6 +64,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_DREG, 0x1234568);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_MODULUS, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_TYPE, NFT_NG_INCREMENTAL);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_OFFSET, 0x1000000);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.8.1

