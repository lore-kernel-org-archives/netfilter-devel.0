From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v3 libnftnl] expr: numgen: Rename until attribute by modulus
Date: Wed, 7 Sep 2016 14:29:45 +0200
Message-ID: <20160907122942.GA23647@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32955 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbcIGM3v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 08:29:51 -0400
Received: by mail-wm0-f66.google.com with SMTP id j136so1026716wmj.0
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Sep 2016 05:29:50 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id r9sm15306015wjp.15.2016.09.07.05.29.47
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 07 Sep 2016 05:29:48 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The _modulus_ attribute will be reused as _until_, as it's similar to
other expressions with value limits (ex. hash).

Renaming is possible according to the kernel module ntf_numgen that has
not been released yet.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v2:
	- Separate changes with incremental counter offset value.
Changes in v3:
	- Update repo before submitting the patch.

 include/buffer.h                    |  1 -
 include/libnftnl/expr.h             |  2 +-
 include/linux/netfilter/nf_tables.h |  4 +--
 src/expr/numgen.c                   | 52 ++++++++++++++++++-------------------
 tests/nft-expr_numgen-test.c        |  8 +++---
 5 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/include/buffer.h b/include/buffer.h
index 8cfe377..a753c78 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -82,7 +82,6 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define TOTAL			"total"
 #define TYPE			"type"
 #define UNIT			"unit"
-#define UNTIL			"until"
 #define USE			"use"
 #define XOR			"xor"
 #define ADD			"add"
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 8815154..94ce529 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -52,7 +52,7 @@ enum {
 
 enum {
 	NFTNL_EXPR_NG_DREG	= NFTNL_EXPR_BASE,
-	NFTNL_EXPR_NG_UNTIL,
+	NFTNL_EXPR_NG_MODULUS,
 	NFTNL_EXPR_NG_TYPE,
 };
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 8a63f22..dd8b746 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1126,13 +1126,13 @@ enum nft_trace_types {
  * enum nft_ng_attributes - nf_tables number generator expression netlink attributes
  *
  * @NFTA_NG_DREG: destination register (NLA_U32)
- * @NFTA_NG_UNTIL: source value to increment the counter until reset (NLA_U32)
+ * @NFTA_NG_MODULUS: maximum value to be returned (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
-	NFTA_NG_UNTIL,
+	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
 	__NFTA_NG_MAX
 };
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 7f2b425..dad41c2 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -22,7 +22,7 @@
 
 struct nftnl_expr_ng {
 	enum nft_registers	dreg;
-	unsigned int		until;
+	unsigned int		modulus;
 	enum nft_ng_types	type;
 };
 
@@ -36,8 +36,8 @@ nftnl_expr_ng_set(struct nftnl_expr *e, uint16_t type,
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
@@ -58,9 +58,9 @@ nftnl_expr_ng_get(const struct nftnl_expr *e, uint16_t type,
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
@@ -78,7 +78,7 @@ static int nftnl_expr_ng_cb(const struct nlattr *attr, void *data)
 
 	switch (type) {
 	case NFTA_NG_DREG:
-	case NFTA_NG_UNTIL:
+	case NFTA_NG_MODULUS:
 	case NFTA_NG_TYPE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
@@ -96,8 +96,8 @@ nftnl_expr_ng_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 	if (e->flags & (1 << NFTNL_EXPR_NG_DREG))
 		mnl_attr_put_u32(nlh, NFTA_NG_DREG, htonl(ng->dreg));
-	if (e->flags & (1 << NFTNL_EXPR_NG_UNTIL))
-		mnl_attr_put_u32(nlh, NFTA_NG_UNTIL, htonl(ng->until));
+	if (e->flags & (1 << NFTNL_EXPR_NG_MODULUS))
+		mnl_attr_put_u32(nlh, NFTA_NG_MODULUS, htonl(ng->modulus));
 	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		mnl_attr_put_u32(nlh, NFTA_NG_TYPE, htonl(ng->type));
 }
@@ -116,9 +116,9 @@ nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
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
@@ -132,15 +132,15 @@ static int nftnl_expr_ng_json_parse(struct nftnl_expr *e, json_t *root,
 				    struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint32_t dreg, until, type;
+	uint32_t dreg, modulus, type;
 
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
@@ -159,16 +159,16 @@ static int nftnl_expr_ng_xml_parse(struct nftnl_expr *e,
 				   struct nftnl_parse_err *err)
 {
 #ifdef XML_PARSING
-	uint32_t dreg, until, type;
+	uint32_t dreg, modulus, type;
 
 	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
 				 NFTNL_XML_MAND, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_DREG, dreg);
 
-	if (nftnl_mxml_num_parse(tree, "until", MXML_DESCEND_FIRST, BASE_DEC,
-				 &until, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+	if (nftnl_mxml_num_parse(tree, "modulus", MXML_DESCEND_FIRST, BASE_DEC,
+				 &modulus, NFTNL_TYPE_U32, NFTNL_XML_MAND,
 				 err) == 0)
-		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_UNTIL, until);
+		nftnl_expr_set_u32(e, NFTNL_EXPR_NG_MODULUS, modulus);
 
 	if (nftnl_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
 				 &type, NFTNL_TYPE_U32, NFTNL_XML_MAND,
@@ -192,12 +192,12 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 	switch (ng->type) {
 	case NFT_NG_INCREMENTAL:
 		ret = snprintf(buf, len, "reg %u = inc(%u) ", ng->dreg,
-			       ng->until);
+			       ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFT_NG_RANDOM:
 		ret = snprintf(buf, len, "reg %u = random(%u) ", ng->dreg,
-			       ng->until);
+			       ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	default:
@@ -216,8 +216,8 @@ static int nftnl_expr_ng_export(char *buf, size_t size,
 
 	if (e->flags & (1 << NFTNL_EXPR_NG_DREG))
 		nftnl_buf_u32(&b, type, ng->dreg, DREG);
-	if (e->flags & (1 << NFTNL_EXPR_NG_UNTIL))
-		nftnl_buf_u32(&b, type, ng->until, UNTIL);
+	if (e->flags & (1 << NFTNL_EXPR_NG_MODULUS))
+		nftnl_buf_u32(&b, type, ng->modulus, MODULUS);
 	if (e->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		nftnl_buf_u32(&b, type, ng->type, TYPE);
 
@@ -249,8 +249,8 @@ static bool nftnl_expr_ng_cmp(const struct nftnl_expr *e1,
 
 	if (e1->flags & (1 << NFTNL_EXPR_NG_DREG))
 		eq &= (n1->dreg == n2->dreg);
-	if (e1->flags & (1 << NFTNL_EXPR_NG_UNTIL))
-		eq &= (n1->until == n2->until);
+	if (e1->flags & (1 << NFTNL_EXPR_NG_MODULUS))
+		eq &= (n1->modulus == n2->modulus);
 	if (e1->flags & (1 << NFTNL_EXPR_NG_TYPE))
 		eq &= (n1->type == n2->type);
 
diff --git a/tests/nft-expr_numgen-test.c b/tests/nft-expr_numgen-test.c
index b78ee76..7092c8d 100644
--- a/tests/nft-expr_numgen-test.c
+++ b/tests/nft-expr_numgen-test.c
@@ -33,9 +33,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
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
@@ -59,7 +59,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_DREG, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_UNTIL, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_MODULUS, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NG_TYPE, NFT_NG_INCREMENTAL);
 
 	nftnl_rule_add_expr(a, ex);
-- 
2.8.1

