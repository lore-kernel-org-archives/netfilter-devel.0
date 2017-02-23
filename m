From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH libnftnl] expr: hash: support of symmetric hash
Date: Thu, 23 Feb 2017 12:11:08 +0100
Message-ID: <20170223111108.r2sw3wr6nbpuip7v@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33343 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdBWLNF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 06:13:05 -0500
Received: by mail-wr0-f194.google.com with SMTP id s27so3513633wrb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 03:11:12 -0800 (PST)
Received: from nevthink ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id o143sm5931720wmd.3.2017.02.23.03.11.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Feb 2017 03:11:10 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch provides symmetric hash support according to source
ip address and port, and destination ip address and port.

The new attribute NFTA_HASH_TYPE has been included to support
different types of hashing functions. Currently supported
NFT_HASH_JENKINS through jhash and NFT_HASH_SYM through symhash.

The main difference between both types are:
 - jhash requires an expression with sreg, symhash doesn't.
 - symhash supports modulus and offset, but not seed.

Examples:

 nft add rule ip nat prerouting ct mark set jhash ip saddr mod 2
 nft add rule ip nat prerouting ct mark set symhash mod 2

Signed-off-by: Laura Garcia Liebana <laura.garcia@zevenet.com>
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h | 13 +++++++++++
 src/expr/hash.c                     | 46 ++++++++++++++++++++++++++++++++-----
 tests/nft-expr_hash-test.c          |  4 ++++
 4 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 38a4b83..6a571fe 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -227,6 +227,7 @@ enum {
 	NFTNL_EXPR_HASH_MODULUS,
 	NFTNL_EXPR_HASH_SEED,
 	NFTNL_EXPR_HASH_OFFSET,
+	NFTNL_EXPR_HASH_TYPE,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b00a05d..74a42fa 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -793,6 +793,17 @@ enum nft_rt_keys {
 };
 
 /**
+ * enum nft_hash_types - nf_tables hash expression types
+ *
+ * @NFT_HASH_JENKINS: Jenkins Hash
+ * @NFT_HASH_SYM: Symmetric Hash
+ */
+enum nft_hash_types {
+	NFT_HASH_JENKINS,
+	NFT_HASH_SYM,
+};
+
+/**
  * enum nft_hash_attributes - nf_tables hash expression netlink attributes
  *
  * @NFTA_HASH_SREG: source register (NLA_U32)
@@ -801,6 +812,7 @@ enum nft_rt_keys {
  * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
  * @NFTA_HASH_SEED: seed value (NLA_U32)
  * @NFTA_HASH_OFFSET: add this offset value to hash result (NLA_U32)
+ * @NFTA_HASH_TYPE: hash operation (NLA_U32: nft_hash_types)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -810,6 +822,7 @@ enum nft_hash_attributes {
 	NFTA_HASH_MODULUS,
 	NFTA_HASH_SEED,
 	NFTA_HASH_OFFSET,
+	NFTA_HASH_TYPE,
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 83f9317..d870510 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -21,6 +21,7 @@
 #include <libnftnl/rule.h>
 
 struct nftnl_expr_hash {
+	enum nft_hash_types	type;
 	enum nft_registers	sreg;
 	enum nft_registers	dreg;
 	unsigned int		len;
@@ -34,7 +35,6 @@ nftnl_expr_hash_set(struct nftnl_expr *e, uint16_t type,
 		    const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
-
 	switch (type) {
 	case NFTNL_EXPR_HASH_SREG:
 		hash->sreg = *((uint32_t *)data);
@@ -54,6 +54,9 @@ nftnl_expr_hash_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_HASH_OFFSET:
 		hash->offset = *((uint32_t *)data);
 		break;
+	case NFTNL_EXPR_HASH_TYPE:
+		hash->type = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -85,6 +88,9 @@ nftnl_expr_hash_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_HASH_OFFSET:
 		*data_len = sizeof(hash->offset);
 		return &hash->offset;
+	case NFTNL_EXPR_HASH_TYPE:
+		*data_len = sizeof(hash->type);
+		return &hash->type;
 	}
 	return NULL;
 }
@@ -104,6 +110,7 @@ static int nftnl_expr_hash_cb(const struct nlattr *attr, void *data)
 	case NFTA_HASH_MODULUS:
 	case NFTA_HASH_SEED:
 	case NFTA_HASH_OFFSET:
+	case NFTA_HASH_TYPE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -130,6 +137,8 @@ nftnl_expr_hash_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_HASH_SEED, htonl(hash->seed));
 	if (e->flags & (1 << NFTNL_EXPR_HASH_OFFSET))
 		mnl_attr_put_u32(nlh, NFTA_HASH_OFFSET, htonl(hash->offset));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_HASH_TYPE, htonl(hash->type));
 }
 
 static int
@@ -166,6 +175,10 @@ nftnl_expr_hash_parse(struct nftnl_expr *e, struct nlattr *attr)
 		hash->offset = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_OFFSET]));
 		e->flags |= (1 << NFTNL_EXPR_HASH_OFFSET);
 	}
+	if (tb[NFTA_HASH_TYPE]) {
+		hash->type = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_TYPE]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_TYPE);
+	}
 
 	return ret;
 }
@@ -174,7 +187,7 @@ static int nftnl_expr_hash_json_parse(struct nftnl_expr *e, json_t *root,
 				      struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	uint32_t sreg, dreg, len, modulus, seed, offset;
+	uint32_t sreg, dreg, len, modulus, seed, offset, type;
 
 	if (nftnl_jansson_parse_reg(root, "sreg", NFTNL_TYPE_U32,
 				    &sreg, err) == 0)
@@ -200,6 +213,10 @@ static int nftnl_expr_hash_json_parse(struct nftnl_expr *e, json_t *root,
 				    &offset, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_OFFSET, offset);
 
+	if (nftnl_jansson_parse_val(root, "type", NFTNL_TYPE_U32,
+				    &type, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_TYPE, type);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -214,10 +231,23 @@ nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "reg %u = jhash(reg %u, %u, 0x%x) %% mod %u ",
-		       hash->dreg, hash->sreg, hash->len, hash->seed,
-		       hash->modulus);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	switch (hash->type) {
+	case NFT_HASH_SYM:
+		ret =
+		snprintf(buf, len, "reg %u = symhash() %% mod %u ", hash->dreg,
+			 hash->modulus);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		break;
+	case NFT_HASH_JENKINS:
+	default:
+		ret =
+		snprintf(buf, len,
+			 "reg %u = jhash(reg %u, %u, 0x%x) %% mod %u ",
+			 hash->dreg, hash->sreg, hash->len, hash->seed,
+			 hash->modulus);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		break;
+	}
 
 	if (hash->offset) {
 		ret = snprintf(buf + offset, len, "offset %u ", hash->offset);
@@ -246,6 +276,8 @@ static int nftnl_expr_hash_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, hash->seed, SEED);
 	if (e->flags & (1 << NFTNL_EXPR_HASH_OFFSET))
 		nftnl_buf_u32(&b, type, hash->offset, OFFSET);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_TYPE))
+		nftnl_buf_u32(&b, type, hash->type, TYPE);
 
 	return nftnl_buf_done(&b);
 }
@@ -285,6 +317,8 @@ static bool nftnl_expr_hash_cmp(const struct nftnl_expr *e1,
                eq &= (h1->seed == h2->seed);
 	if (e1->flags & (1 << NFTNL_EXPR_HASH_OFFSET))
 		eq &= (h1->offset == h2->offset);
+	if (e1->flags & (1 << NFTNL_EXPR_HASH_TYPE))
+		eq &= (h1->type == h2->type);
 
        return eq;
 }
diff --git a/tests/nft-expr_hash-test.c b/tests/nft-expr_hash-test.c
index d928234..7be6e9e 100644
--- a/tests/nft-expr_hash-test.c
+++ b/tests/nft-expr_hash-test.c
@@ -45,6 +45,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_OFFSET) !=
 	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_OFFSET))
 		print_err("Expr NFTNL_EXPR_HASH_OFFSET mismatches");
+	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_HASH_TYPE) !=
+	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_HASH_TYPE))
+		print_err("Expr NFTNL_EXPR_HASH_TYPE mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -69,6 +72,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_MODULUS, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_SEED, 0x78123456);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_OFFSET, 0x3612845);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_HASH_TYPE, NFT_HASH_JENKINS);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
2.11.0

