From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH libnftnl] expr: hash: Add offset to hash value
Date: Mon, 5 Sep 2016 10:55:03 +0200
Message-ID: <20160905085500.GA21103@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34639 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754563AbcIEIzI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 04:55:08 -0400
Received: by mail-wm0-f67.google.com with SMTP id w12so2697893wmf.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Sep 2016 01:55:07 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id lv9sm26472825wjb.22.2016.09.05.01.55.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 05 Sep 2016 01:55:05 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to pass through an offset to the hash value. With this
feature, the sysadmin is able to generate a hash with a given
started value.

Example:

	meta mark set jhash ip saddr mod 2 seed 0xabcd sum 100

This option generates marks according to the source address from 100 to
101.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/hash.c                     | 39 +++++++++++++++++++++++++++++++------
 tests/nft-expr_hash-test.c          |  4 ++++
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 3cf0db1..9188364 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -211,6 +211,7 @@ enum {
 	NFTNL_EXPR_HASH_LEN,
 	NFTNL_EXPR_HASH_MODULUS,
 	NFTNL_EXPR_HASH_SEED,
+	NFTNL_EXPR_HASH_SUM,
 };
 
 /*
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2718832..65d9fe8 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1139,6 +1139,7 @@ enum nft_trace_types {
  * @NFTA_HASH_LEN: data length (NLA_U32)
  * @NFTA_HASH_MODULUS: Modulus value (NLA_U32)
  * @NFTA_HASH_SEED: hash initial value (NLA_U32)
+ * @NFTA_HASH_SUM: offset value to be added (NLA_U32)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -1147,6 +1148,7 @@ enum nft_hash_attributes {
 	NFTA_HASH_LEN,
 	NFTA_HASH_MODULUS,
 	NFTA_HASH_SEED,
+	NFTA_HASH_SUM,
 	__NFTA_HASH_MAX
 };
 #define NFTA_HASH_MAX		(__NFTA_HASH_MAX - 1)
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 2d61508..54c6dbc 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -26,6 +26,7 @@ struct nftnl_expr_hash {
 	unsigned int		len;
 	unsigned int		modulus;
 	unsigned int		seed;
+	unsigned int		sum;
 };
 
 static int
@@ -50,6 +51,9 @@ nftnl_expr_hash_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_HASH_SEED:
 		hash->seed = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_HASH_SUM:
+		hash->sum = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -78,6 +82,9 @@ nftnl_expr_hash_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_HASH_SEED:
 		*data_len = sizeof(hash->seed);
 		return &hash->seed;
+	case NFTNL_EXPR_HASH_SUM:
+		*data_len = sizeof(hash->sum);
+		return &hash->sum;
 	}
 	return NULL;
 }
@@ -96,6 +103,7 @@ static int nftnl_expr_hash_cb(const struct nlattr *attr, void *data)
 	case NFTA_HASH_LEN:
 	case NFTA_HASH_MODULUS:
 	case NFTA_HASH_SEED:
+	case NFTA_HASH_SUM:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -120,7 +128,8 @@ nftnl_expr_hash_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_HASH_MODULUS, htonl(hash->modulus));
 	if (e->flags & (1 << NFTNL_EXPR_HASH_SEED))
 		mnl_attr_put_u32(nlh, NFTA_HASH_SEED, htonl(hash->seed));
-
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SUM))
+		mnl_attr_put_u32(nlh, NFTA_HASH_SUM, htonl(hash->sum));
 }
 
 static int
@@ -153,6 +162,10 @@ nftnl_expr_hash_parse(struct nftnl_expr *e, struct nlattr *attr)
 		hash->seed = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_SEED]));
 		e->flags |= (1 << NFTNL_EXPR_HASH_SEED);
 	}
+	if (tb[NFTA_HASH_SUM]) {
+		hash->sum = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_SUM]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_SUM);
+	}
 
 	return ret;
 }
@@ -161,7 +174,7 @@ static int nftnl_expr_hash_json_parse(struct nftnl_expr *e, json_t *root,
 				      struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint32_t sreg, dreg, len, modulus, seed;
+	uint32_t sreg, dreg, len, modulus, seed, sum;
 
 	if (nftnl_jansson_parse_reg(root, "sreg", NFTNL_TYPE_U32,
 				    &sreg, err) == 0)
@@ -183,6 +196,10 @@ static int nftnl_expr_hash_json_parse(struct nftnl_expr *e, json_t *root,
 				    &seed, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SEED, seed);
 
+	if (nftnl_jansson_parse_val(root, "sum", NFTNL_TYPE_U32,
+				    &sum, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SUM, sum);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -196,7 +213,7 @@ static int nftnl_expr_hash_xml_parse(struct nftnl_expr *e,
 				     struct nftnl_parse_err *err)
 {
 #ifdef XML_PARSING
-	uint32_t sreg, dreg, len, modulus, seed;
+	uint32_t sreg, dreg, len, modulus, seed, sum;
 
 	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
 				 NFTNL_XML_MAND, err) == 0)
@@ -221,6 +238,11 @@ static int nftnl_expr_hash_xml_parse(struct nftnl_expr *e,
 				 err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SEED, seed);
 
+	if (nftnl_mxml_num_parse(tree, "sum", MXML_DESCEND_FIRST, BASE_DEC,
+				 &sum, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SUM, sum);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -235,9 +257,10 @@ nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "reg %u = jhash(reg %u, %u, 0x%x) %% mod %u ",
-		       hash->dreg, hash->sreg, hash->len, hash->seed,
-		       hash->modulus);
+	ret = snprintf(buf, len,
+		       "reg %u = %u + jhash(reg %u, %u, 0x%x) %% mod %u ",
+		       hash->sum, hash->dreg, hash->sreg, hash->len,
+		       hash->seed, hash->modulus);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -260,6 +283,8 @@ static int nftnl_expr_hash_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, hash->modulus, MODULUS);
 	if (e->flags & (1 << NFTNL_EXPR_HASH_SEED))
 		nftnl_buf_u32(&b, type, hash->seed, SEED);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SUM))
+		nftnl_buf_u32(&b, type, hash->sum, SUM);
 
 	return nftnl_buf_done(&b);
 }
@@ -297,6 +322,8 @@ static bool nftnl_expr_hash_cmp(const struct nftnl_expr *e1,
                eq &= (h1->modulus == h2->modulus);
        if (e1->flags & (1 << NFTNL_EXPR_HASH_SEED))
                eq &= (h1->seed == h2->seed);
+	if (e1->flags & (1 << NFTNL_EXPR_HASH_SUM))
+		eq &= (h1->sum == h2->sum);
 
        return eq;
 }
diff --git a/tests/nft-expr_hash-test.c b/tests/nft-expr_hash-test.c
index 699197c..52c494e 100644
--- a/tests/nft-expr_hash-test.c
+++ b/tests/nft-expr_hash-test.c
@@ -42,6 +42,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_SEED) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_SEED))
 		print_err("Expr NFTNL_EXPR_HASH_SEED mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_SUM) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_SUM))
+		print_err("Expr NFTNL_EXPR_HASH_SUM mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -65,6 +68,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_DREG, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_MODULUS, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_SEED, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_SUM, 0x1234568);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.8.1

