From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v2 libnftnl] expr: numgen: add increment counter offset value
Date: Wed, 7 Sep 2016 19:57:59 +0200
Message-ID: <20160907175757.GA12221@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33558 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbcIGR6E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 13:58:04 -0400
Received: by mail-wm0-f66.google.com with SMTP id b187so124019wme.0
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Sep 2016 10:58:03 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id ab4sm3834630wjd.16.2016.09.07.10.58.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 07 Sep 2016 10:58:02 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to pass through an offset value to the counter
initialization. With this feature, the sysadmin is able to send an
started value for the counter.

Example:

	meta mark set numgen inc mod 2 sum 100

This will generate marks with series 100, 101, 100, 101, ...

Only supported for increment number generation.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v2:
        - Separate _SUM_ changes with _until_ attribute renaming.

include/buffer.h                    |  1 +
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/numgen.c                   | 35 +++++++++++++++++++++++++++++++----
 tests/nft-expr_numgen-test.c        |  4 ++++
 5 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index a753c78..448cccf 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -78,6 +78,7 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define SREG_KEY		"sreg_key"
 #define SREG_DATA		"sreg_data"
 #define SREG			"sreg"
+#define SUM			"sum"
 #define TABLE			"table"
 #define TOTAL			"total"
 #define TYPE			"type"
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 94ce529..3cf0db1 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -54,6 +54,7 @@ enum {
 	NFTNL_EXPR_NG_DREG	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_NG_MODULUS,
 	NFTNL_EXPR_NG_TYPE,
+	NFTNL_EXPR_NG_SUM,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index dd8b746..ee3a4c9 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1128,12 +1128,14 @@ enum nft_trace_types {
  * @NFTA_NG_DREG: destination register (NLA_U32)
  * @NFTA_NG_MODULUS: maximum value to be returned (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
+ * @NFTA_NG_SUM: offset to be added to the counter (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
 	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
+	NFTA_NG_SUM,
 	__NFTA_NG_MAX
 };
 #define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index a23be53..7e1324a 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -24,6 +24,7 @@ struct nftnl_expr_ng {
 	enum nft_registers	dreg;
 	unsigned int		modulus;
 	enum nft_ng_types	type;
+	unsigned int		sum;
 };
 
 static int
@@ -42,6 +43,9 @@ nftnl_expr_ng_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NG_TYPE:
 		ng->type = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_NG_SUM:
+		ng->sum = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -64,6 +68,9 @@ nftnl_expr_ng_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NG_TYPE:
 		*data_len = sizeof(ng->type);
 		return &ng->type;
+	case NFTNL_EXPR_NG_SUM:
+		*data_len = sizeof(ng->sum);
+		return &ng->sum;
 	}
 	return NULL;
 }
@@ -80,6 +87,7 @@ static int nftnl_expr_ng_cb(const struct nlattr *attr, void *data)
 	case NFTA_NG_DREG:
 	case NFTA_NG_MODULUS:
 	case NFTA_NG_TYPE:
+	case NFTA_NG_SUM:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -100,6 +108,8 @@ nftnl_expr_ng_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_NG_MODULUS, htonl(ng->modulus));
 	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		mnl_attr_put_u32(nlh, NFTA_NG_TYPE, htonl(ng->type));
+	if (e->flags & (1 << NFTNL_EXPR_NG_SUM))
+		mnl_attr_put_u32(nlh, NFTA_NG_SUM, htonl(ng->sum));
 }
 
 static int
@@ -124,6 +134,10 @@ nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ng->type = ntohl(mnl_attr_get_u32(tb[NFTA_NG_TYPE]));
 		e->flags |= (1 << NFTNL_EXPR_NG_TYPE);
 	}
+	if (tb[NFTA_NG_SUM]) {
+		ng->sum = ntohl(mnl_attr_get_u32(tb[NFTA_NG_SUM]));
+		e->flags |= (1 << NFTNL_EXPR_NG_SUM);
+	}
 
 	return ret;
 }
@@ -132,7 +146,7 @@ static int nftnl_expr_ng_json_parse(struct nftnl_expr *e, json_t *root,
 				    struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint32_t dreg, modulus, type;
+	uint32_t dreg, modulus, type, sum;
 
 	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32,
 				    &dreg, err) == 0)
@@ -146,6 +160,10 @@ static int nftnl_expr_ng_json_parse(struct nftnl_expr *e, json_t *root,
 				    &type, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
 
+	if (nftnl_jansson_parse_val(root, "sum", NFTNL_TYPE_U32,
+				    &sum, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_SUM, sum);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -159,7 +177,7 @@ static int nftnl_expr_ng_xml_parse(struct nftnl_expr *e,
 				   struct nftnl_parse_err *err)
 {
 #ifdef XML_PARSING
-	uint32_t dreg, modulus, type;
+	uint32_t dreg, modulus, type, sum;
 
 	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
 				 NFTNL_XML_MAND, err) == 0)
@@ -175,6 +193,11 @@ static int nftnl_expr_ng_xml_parse(struct nftnl_expr *e,
 				 err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
 
+	if (nftnl_mxml_num_parse(tree, "sum", MXML_DESCEND_FIRST, BASE_DEC,
+				 &sum, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_SUM, sum);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -191,8 +214,8 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 
 	switch (ng->type) {
 	case NFT_NG_INCREMENTAL:
-		ret = snprintf(buf, len, "reg %u = inc mod %u ", ng->dreg,
-			       ng->modulus);
+		ret = snprintf(buf, len, "reg %u = %u + inc mod %u ", ng->dreg,
+			       ng->sum, ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFT_NG_RANDOM:
@@ -220,6 +243,8 @@ static int nftnl_expr_ng_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, ng->modulus, MODULUS);
 	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		nftnl_buf_u32(&b, type, ng->type, TYPE);
+	if (e->flags & (1 << NFTNL_EXPR_NG_SUM))
+		nftnl_buf_u32(&b, type, ng->type, SUM);
 
 	return nftnl_buf_done(&b);
 }
@@ -253,6 +278,8 @@ static bool nftnl_expr_ng_cmp(const struct nftnl_expr *e1,
 		eq &= (n1->modulus == n2->modulus);
 	if (e1->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		eq &= (n1->type == n2->type);
+	if (e1->flags & (1 << NFTNL_EXPR_NG_SUM))
+		eq &= (n1->sum == n2->sum);
 
 	return eq;
 }
diff --git a/tests/nft-expr_numgen-test.c b/tests/nft-expr_numgen-test.c
index 7092c8d..b60d30c 100644
--- a/tests/nft-expr_numgen-test.c
+++ b/tests/nft-expr_numgen-test.c
@@ -39,6 +39,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_TYPE) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_TYPE))
 		print_err("Expr NFTNL_EXPR_NG_TYPE mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_SUM) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_SUM))
+		print_err("Expr NFTNL_EXPR_NG_SUM mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -61,6 +64,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_DREG, 0x1234568);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_MODULUS, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_TYPE, NFT_NG_INCREMENTAL);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_SUM, 0x1000000);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.8.1

