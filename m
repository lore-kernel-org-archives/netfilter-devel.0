From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH libnftnl] expr: numgen: add counter offset value and rename
 until by modulus
Date: Fri, 2 Sep 2016 10:40:51 +0200
Message-ID: <20160902084048.GA10287@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33053 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbcIBIkz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 04:40:55 -0400
Received: by mail-wm0-f65.google.com with SMTP id w207so1907757wmw.0
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Sep 2016 01:40:55 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id d64sm2456886wmc.22.2016.09.02.01.40.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 02 Sep 2016 01:40:53 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to pass through an offset value to the counter
initialization. With this feature, the sysadmin is able to send an
started value for the counter.

Example:

	meta mark set numgen inc mod 2 sum 100

This will generate marks with series 100, 101, 100, 101, ...

The _modulus_ attribute will be reused as _until_, as it's similar to
other expressions with value limits (ex. hash).

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/buffer.h                    |  2 +-
 include/libnftnl/expr.h             |  3 +-
 include/linux/netfilter/nf_tables.h |  6 ++-
 src/expr/numgen.c                   | 83 ++++++++++++++++++++++++-------------
 tests/nft-expr_numgen-test.c        | 12 ++++--
 5 files changed, 70 insertions(+), 36 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index 8cfe377..448cccf 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -78,11 +78,11 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define SREG_KEY		"sreg_key"
 #define SREG_DATA		"sreg_data"
 #define SREG			"sreg"
+#define SUM			"sum"
 #define TABLE			"table"
 #define TOTAL			"total"
 #define TYPE			"type"
 #define UNIT			"unit"
-#define UNTIL			"until"
 #define USE			"use"
 #define XOR			"xor"
 #define ADD			"add"
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 8815154..3cf0db1 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -52,8 +52,9 @@ enum {
 
 enum {
 	NFTNL_EXPR_NG_DREG	= NFTNL_EXPR_BASE,
-	NFTNL_EXPR_NG_UNTIL,
+	NFTNL_EXPR_NG_MODULUS,
 	NFTNL_EXPR_NG_TYPE,
+	NFTNL_EXPR_NG_SUM,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0b11abf..2718832 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -670,14 +670,16 @@ enum nft_exthdr_attributes {
  * enum nft_ng_attributes - nf_tables number generator expression attributes
  *
  * @NFTA_NG_DREG: destination register (NLA_U32)
- * @NFTA_NG_UNTIL: limit value (NLA_U32)
+ * @NFTA_NG_MODULUS: maximum value to be returned (NLA_U32)
  * @NFTA_NG_TYPE: type of operation (NLA_U32)
+ * @NFTA_NG_SUM: offset to be added to the counter (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
-	NFTA_NG_UNTIL,
+	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
+	NFTA_NG_SUM,
 	__NFTA_NG_MAX
 };
 #define NFTA_NG_MAX		(__NFTA_NG_MAX - 1)
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 0669eda..c119d5f 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -22,8 +22,9 @@
 
 struct nftnl_expr_ng {
 	enum nft_registers	dreg;
-	unsigned int		until;
+	unsigned int		modulus;
 	enum nft_ng_type	type;
+	unsigned int		sum;
 };
 
 static int
@@ -36,12 +37,15 @@ nftnl_expr_ng_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NG_DREG:
 		ng->dreg = *((uint32_t *)data);
 		break;
-	case NFTNL_EXPR_NG_UNTIL:
-		ng->until = *((uint32_t *)data);
+	case NFTNL_EXPR_NG_MODULUS:
+		ng->modulus = *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_NG_TYPE:
 		ng->type = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_NG_SUM:
+		ng->sum = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -58,12 +62,15 @@ nftnl_expr_ng_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NG_DREG:
 		*data_len = sizeof(ng->dreg);
 		return &ng->dreg;
-	case NFTNL_EXPR_NG_UNTIL:
-		*data_len = sizeof(ng->until);
-		return &ng->until;
+	case NFTNL_EXPR_NG_MODULUS:
+		*data_len = sizeof(ng->modulus);
+		return &ng->modulus;
 	case NFTNL_EXPR_NG_TYPE:
 		*data_len = sizeof(ng->type);
 		return &ng->type;
+	case NFTNL_EXPR_NG_SUM:
+		*data_len = sizeof(ng->sum);
+		return &ng->sum;
 	}
 	return NULL;
 }
@@ -78,8 +85,9 @@ static int nftnl_expr_ng_cb(const struct nlattr *attr, void *data)
 
 	switch (type) {
 	case NFTA_NG_DREG:
-	case NFTA_NG_UNTIL:
+	case NFTA_NG_MODULUS:
 	case NFTA_NG_TYPE:
+	case NFTA_NG_SUM:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -96,10 +104,12 @@ nftnl_expr_ng_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 	if (e->flags & (1 << NFTNL_EXPR_NG_DREG))
 		mnl_attr_put_u32(nlh, NFTA_NG_DREG, htonl(ng->dreg));
-	if (e->flags & (1 << NFTNL_EXPR_NG_UNTIL))
-		mnl_attr_put_u32(nlh, NFTA_NG_UNTIL, htonl(ng->until));
+	if (e->flags & (1 << NFTNL_EXPR_NG_MODULUS))
+		mnl_attr_put_u32(nlh, NFTA_NG_MODULUS, htonl(ng->modulus));
 	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		mnl_attr_put_u32(nlh, NFTA_NG_TYPE, htonl(ng->type));
+	if (e->flags & (1 << NFTNL_EXPR_NG_SUM))
+		mnl_attr_put_u32(nlh, NFTA_NG_SUM, htonl(ng->sum));
 }
 
 static int
@@ -116,14 +126,18 @@ nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ng->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_NG_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_NG_DREG);
 	}
-	if (tb[NFTA_NG_UNTIL]) {
-		ng->until = ntohl(mnl_attr_get_u32(tb[NFTA_NG_UNTIL]));
-		e->flags |= (1 << NFTNL_EXPR_NG_UNTIL);
+	if (tb[NFTA_NG_MODULUS]) {
+		ng->modulus = ntohl(mnl_attr_get_u32(tb[NFTA_NG_MODULUS]));
+		e->flags |= (1 << NFTNL_EXPR_NG_MODULUS);
 	}
 	if (tb[NFTA_NG_TYPE]) {
 		ng->type = ntohl(mnl_attr_get_u32(tb[NFTA_NG_TYPE]));
 		e->flags |= (1 << NFTNL_EXPR_NG_TYPE);
 	}
+	if (tb[NFTA_NG_SUM]) {
+		ng->sum = ntohl(mnl_attr_get_u32(tb[NFTA_NG_SUM]));
+		e->flags |= (1 << NFTNL_EXPR_NG_SUM);
+	}
 
 	return ret;
 }
@@ -132,20 +146,24 @@ static int nftnl_expr_ng_json_parse(struct nftnl_expr *e, json_t *root,
 				    struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint32_t dreg, until, type;
+	uint32_t dreg, modulus, type, sum;
 
 	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32,
 				    &dreg, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_DREG, dreg);
 
-	if (nftnl_jansson_parse_val(root, "until", NFTNL_TYPE_U32,
-				    &until, err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_UNTIL, until);
+	if (nftnl_jansson_parse_val(root, "modulus", NFTNL_TYPE_U32,
+				    &modulus, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_MODULUS, modulus);
 
 	if (nftnl_jansson_parse_val(root, "type", NFTNL_TYPE_U32,
 				    &type, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
 
+	if (nftnl_jansson_parse_val(root, "sum", NFTNL_TYPE_U32,
+				    &sum, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_SUM, sum);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -159,22 +177,27 @@ static int nftnl_expr_ng_xml_parse(struct nftnl_expr *e,
 				   struct nftnl_parse_err *err)
 {
 #ifdef XML_PARSING
-	uint32_t dreg, until, type;
+	uint32_t dreg, modulus, type, sum;
 
 	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
 				 NFTNL_XML_MAND, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_DREG, dreg);
 
-	if (nftnl_mxml_num_parse(tree, "until", MXML_DESCEND_FIRST, BASE_DEC,
-				 &until, NFTNL_TYPE_U32, NFTNL_XML_MAND,
-				 err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_UNTIL, until);
+	if (nftnl_mxml_num_parse(tree, "modulus", MXML_DESCEND_FIRST,
+				 BASE_DEC, &modulus, NFTNL_TYPE_U32,
+				 NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_MODULUS, modulus);
 
 	if (nftnl_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
 				 &type, NFTNL_TYPE_U32, NFTNL_XML_MAND,
 				 err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_TYPE, type);
 
+	if (nftnl_mxml_num_parse(tree, "sum", MXML_DESCEND_FIRST, BASE_DEC,
+				&sum, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_SUM, sum);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -191,13 +214,13 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 
 	switch (ng->type) {
 	case NFT_NG_INCREMENTAL:
-		ret = snprintf(buf, len, "reg %u = inc(%u) ", ng->dreg,
-			       ng->until);
+		ret = snprintf(buf, len, "reg %u = %u + inc(%u)", ng->dreg,
+			       ng->sum, ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFT_NG_RANDOM:
 		ret = snprintf(buf, len, "reg %u = random(%u) ", ng->dreg,
-			       ng->until);
+			       ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	}
@@ -214,10 +237,12 @@ static int nftnl_expr_ng_export(char *buf, size_t size,
 
 	if (e->flags & (1 << NFTNL_EXPR_NG_DREG))
 		nftnl_buf_u32(&b, type, ng->dreg, DREG);
-	if (e->flags & (1 << NFTNL_EXPR_NG_UNTIL))
-		nftnl_buf_u32(&b, type, ng->until, UNTIL);
+	if (e->flags & (1 << NFTNL_EXPR_NG_MODULUS))
+		nftnl_buf_u32(&b, type, ng->modulus, MODULUS);
 	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		nftnl_buf_u32(&b, type, ng->type, TYPE);
+	if (e->flags & (1 << NFTNL_EXPR_NG_SUM))
+		nftnl_buf_u32(&b, type, ng->type, SUM);
 
 	return nftnl_buf_done(&b);
 }
@@ -247,10 +272,12 @@ static bool nftnl_expr_ng_cmp(const struct nftnl_expr *e1,
 
 	if (e1->flags & (1 << NFTNL_EXPR_NG_DREG))
 		eq &= (n1->dreg == n2->dreg);
-	if (e1->flags & (1 << NFTNL_EXPR_NG_UNTIL))
-		eq &= (n1->until == n2->until);
+	if (e1->flags & (1 << NFTNL_EXPR_NG_MODULUS))
+		eq &= (n1->modulus == n2->modulus);
 	if (e1->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		eq &= (n1->type == n2->type);
+	if (e1->flags & (1 << NFTNL_EXPR_NG_SUM))
+		eq &= (n1->sum == n2->sum);
 
 	return eq;
 }
diff --git a/tests/nft-expr_numgen-test.c b/tests/nft-expr_numgen-test.c
index b78ee76..b60d30c 100644
--- a/tests/nft-expr_numgen-test.c
+++ b/tests/nft-expr_numgen-test.c
@@ -33,12 +33,15 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_DREG) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_DREG))
 		print_err("Expr NFTNL_EXPR_NG_DREG mismatches");
-	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_UNTIL) !=
-	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_UNTIL))
-		print_err("Expr NFTNL_EXPR_NG_UNTIL mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_MODULUS) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_MODULUS))
+		print_err("Expr NFTNL_EXPR_NG_MODULUS mismatches");
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_TYPE) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_TYPE))
 		print_err("Expr NFTNL_EXPR_NG_TYPE mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_NG_SUM) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_NG_SUM))
+		print_err("Expr NFTNL_EXPR_NG_SUM mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -59,8 +62,9 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_DREG, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_UNTIL, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_MODULUS, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_TYPE, NFT_NG_INCREMENTAL);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_SUM, 0x1000000);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.8.1

