From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH libnftnl] expr: hash: Jenkins hash expression support
Date: Tue, 9 Aug 2016 16:03:51 +0200
Message-ID: <20160809140348.GA6633@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36514 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbcHIOD4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 10:03:56 -0400
Received: by mail-wm0-f65.google.com with SMTP id i138so3302481wmf.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Aug 2016 07:03:56 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id q4sm38219686wjk.24.2016.08.09.07.03.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 09 Aug 2016 07:03:54 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support for the nft hash expression within libnftnl.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/buffer.h                    |   2 +
 include/libnftnl/expr.h             |  16 ++
 include/linux/netfilter/nf_tables.h |  20 +++
 src/Makefile.am                     |   1 +
 src/expr/hash.c                     | 295 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 6 files changed, 336 insertions(+)
 create mode 100644 src/expr/hash.c

diff --git a/include/buffer.h b/include/buffer.h
index 36f0ee3..c76bd4d 100644
--- a/include/buffer.h
+++ b/include/buffer.h
@@ -90,5 +90,7 @@ int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
 #define REPLACE			"replace"
 #define FLUSH			"flush"
 #define EVERY			"every"
+#define MODULUS			"modulus"
+#define SEED			"seed"
 
 #endif
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 6aa7756..811c254 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -54,6 +54,14 @@ enum {
 };
 
 enum {
+	NFTNL_EXPR_HASH_SREG	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_HASH_DREG,
+	NFTNL_EXPR_HASH_LEN,
+	NFTNL_EXPR_HASH_MODULUS,
+	NFTNL_EXPR_HASH_SEED,
+};
+
+enum {
 	NFTNL_EXPR_META_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_META_DREG,
 	NFTNL_EXPR_META_SREG,
@@ -245,6 +253,14 @@ enum {
 };
 
 enum {
+	NFT_EXPR_HASH_SREG	= NFT_RULE_EXPR_ATTR_BASE,
+	NFT_EXPR_HASH_DREG,
+	NFT_EXPR_HASH_LEN,
+	NFT_EXPR_HASH_MODULUS,
+	NFT_EXPR_HASH_SEED,
+};
+
+enum {
 	NFT_EXPR_META_KEY	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_META_DREG,
 	NFT_EXPR_META_SREG,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 6fe5fc8..7b574c7 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -681,6 +681,26 @@ enum nft_nth_attributes {
 #define NFTA_NTH_MAX		(__NFTA_NTH_MAX - 1)
 
 /**
+ * enum nft_hash_attributes - nf_tables hash expression attributes
+ *
+ * @NFTA_HASH_SREG: source register (NLA_U32)
+ * @NFTA_HASH_DREG: destination register (NLA_U32)
+ * @NFTA_HASH_LEN: data length (NLA_U32)
+ * @NFTA_HASH_MODULUS: Modulus value (NLA_U32)
+ * @NFTA_HASH_SEED: hash initial value (NLA_U32)
+ */
+enum nft_hash_attributes {
+	NFTA_HASH_UNSPEC,
+	NFTA_HASH_SREG,
+	NFTA_HASH_DREG,
+	NFTA_HASH_LEN,
+	NFTA_HASH_MODULUS,
+	NFTA_HASH_SEED,
+	__NFTA_HASH_MAX
+};
+#define NFTA_HASH_MAX		(__NFTA_HASH_MAX - 1)
+
+/**
  * enum nft_meta_keys - nf_tables meta expression keys
  *
  * @NFT_META_LEN: packet length (skb->len)
diff --git a/src/Makefile.am b/src/Makefile.am
index 69b61ef..a01970d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -39,6 +39,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/match.c	\
 		      expr/meta.c	\
 		      expr/nth.c	\
+		      expr/hash.c	\
 		      expr/nat.c	\
 		      expr/payload.c	\
 		      expr/queue.c	\
diff --git a/src/expr/hash.c b/src/expr/hash.c
new file mode 100644
index 0000000..1383b07
--- /dev/null
+++ b/src/expr/hash.c
@@ -0,0 +1,295 @@
+/*
+ * (C) 2016 by Laura Garcia <nevola@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+
+struct nftnl_expr_hash {
+	enum nft_registers	sreg;
+	enum nft_registers	dreg;
+	unsigned int		len;
+	unsigned int		modulus;
+	unsigned int		seed;
+};
+
+static int
+nftnl_expr_hash_set(struct nftnl_expr *e, uint16_t type,
+		    const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_HASH_SREG:
+		hash->sreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_HASH_DREG:
+		hash->dreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_HASH_LEN:
+		hash->len = *((unsigned int *)data);
+		break;
+	case NFTNL_EXPR_HASH_MODULUS:
+		hash->modulus = *((unsigned int *)data);
+		break;
+	case NFTNL_EXPR_HASH_SEED:
+		hash->seed = *((unsigned int *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_hash_get(const struct nftnl_expr *e, uint16_t type,
+		    uint32_t *data_len)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_HASH_SREG:
+		*data_len = sizeof(hash->sreg);
+		return &hash->sreg;
+	case NFTNL_EXPR_HASH_DREG:
+		*data_len = sizeof(hash->dreg);
+		return &hash->dreg;
+	case NFTNL_EXPR_HASH_LEN:
+		*data_len = sizeof(hash->len);
+		return &hash->len;
+	case NFTNL_EXPR_HASH_MODULUS:
+		*data_len = sizeof(hash->modulus);
+		return &hash->modulus;
+	case NFTNL_EXPR_HASH_SEED:
+		*data_len = sizeof(hash->seed);
+		return &hash->seed;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_hash_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_HASH_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_HASH_SREG:
+	case NFTA_HASH_DREG:
+	case NFTA_HASH_LEN:
+	case NFTA_HASH_MODULUS:
+	case NFTA_HASH_SEED:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_expr_hash_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SREG))
+		mnl_attr_put_u32(nlh, NFTA_HASH_SREG, htonl(hash->sreg));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_DREG))
+		mnl_attr_put_u32(nlh, NFTA_HASH_DREG, htonl(hash->dreg));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_LEN))
+		mnl_attr_put_u32(nlh, NFTA_HASH_LEN, htonl(hash->len));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_MODULUS))
+		mnl_attr_put_u32(nlh, NFTA_HASH_MODULUS, htonl(hash->modulus));
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SEED))
+		mnl_attr_put_u32(nlh, NFTA_HASH_SEED, htonl(hash->seed));
+
+}
+
+static int
+nftnl_expr_hash_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_HASH_MAX+1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_hash_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_HASH_SREG]) {
+		hash->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_SREG]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_SREG);
+	}
+	if (tb[NFTA_HASH_DREG]) {
+		hash->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_DREG]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_DREG);
+	}
+	if (tb[NFTA_HASH_LEN]) {
+		hash->len = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_LEN]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_LEN);
+	}
+	if (tb[NFTA_HASH_MODULUS]) {
+		hash->modulus = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_MODULUS]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_MODULUS);
+	}
+	if (tb[NFTA_HASH_SEED]) {
+		hash->seed = ntohl(mnl_attr_get_u32(tb[NFTA_HASH_SEED]));
+		e->flags |= (1 << NFTNL_EXPR_HASH_SEED);
+	}
+
+	return ret;
+}
+
+static int nftnl_expr_hash_json_parse(struct nftnl_expr *e, json_t *root,
+				      struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint32_t sreg, dreg, len, modulus, seed;
+
+	if (nftnl_jansson_parse_reg(root, "sreg", NFTNL_TYPE_U32,
+				    &sreg, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SREG, sreg);
+
+	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32,
+				    &dreg, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_DREG, dreg);
+
+	if (nftnl_jansson_parse_val(root, "len", NFTNL_TYPE_U32,
+				    &len, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_LEN, len);
+
+	if (nftnl_jansson_parse_val(root, "modulus", NFTNL_TYPE_U32,
+				    &modulus, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_MODULUS, modulus);
+
+	if (nftnl_jansson_parse_val(root, "seed", NFTNL_TYPE_U32,
+				    &seed, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SEED, seed);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+
+static int nftnl_expr_hash_xml_parse(struct nftnl_expr *e,
+				     mxml_node_t *tree,
+				     struct nftnl_parse_err *err)
+{
+#ifdef XML_PARSING
+	uint32_t sreg, dreg, len, modulus, seed;
+
+	if (nftnl_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRST,
+				 NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SREG, sreg);
+
+	if (nftnl_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND_FIRST,
+				 NFTNL_XML_MAND, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_DREG, dreg);
+
+	if (nftnl_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
+				 &len, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_LEN, len);
+
+	if (nftnl_mxml_num_parse(tree, "modulus", MXML_DESCEND_FIRST, BASE_DEC,
+				 &modulus, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_MODULUS, modulus);
+
+	if (nftnl_mxml_num_parse(tree, "seed", MXML_DESCEND_FIRST, BASE_DEC,
+				 &seed, NFTNL_TYPE_U32, NFTNL_XML_MAND,
+				 err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_HASH_SEED, seed);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
+nftnl_expr_hash_snprintf_default(char *buf, size_t size,
+				 const struct nftnl_expr *e)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+	int len = size, offset = 0, ret;
+
+	ret = snprintf(buf, len, "reg %u = jhash(reg %u, %u, %u) %% modulus %u",
+		       hash->dreg, hash->sreg, hash->len, hash->seed,
+		       hash->modulus);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int nftnl_expr_hash_export(char *buf, size_t size,
+				  const struct nftnl_expr *e, int type)
+{
+	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
+
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SREG))
+		nftnl_buf_u32(&b, type, hash->sreg, SREG);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_DREG))
+		nftnl_buf_u32(&b, type, hash->dreg, DREG);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_LEN))
+		nftnl_buf_u32(&b, type, hash->len, LEN);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_MODULUS))
+		nftnl_buf_u32(&b, type, hash->modulus, MODULUS);
+	if (e->flags & (1 << NFTNL_EXPR_HASH_SEED))
+		nftnl_buf_u32(&b, type, hash->seed, SEED);
+
+	return nftnl_buf_done(&b);
+}
+
+static int
+nftnl_expr_hash_snprintf(char *buf, size_t len, uint32_t type,
+			 uint32_t flags, const struct nftnl_expr *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_hash_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_hash_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct expr_ops expr_ops_hash = {
+	.name		= "hash",
+	.alloc_len	= sizeof(struct nftnl_expr_hash),
+	.max_attr	= NFTA_HASH_MAX,
+	.set		= nftnl_expr_hash_set,
+	.get		= nftnl_expr_hash_get,
+	.parse		= nftnl_expr_hash_parse,
+	.build		= nftnl_expr_hash_build,
+	.snprintf	= nftnl_expr_hash_snprintf,
+	.xml_parse	= nftnl_expr_hash_xml_parse,
+	.json_parse	= nftnl_expr_hash_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 928bb5e..fe584fd 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -20,6 +20,7 @@ extern struct expr_ops expr_ops_masq;
 extern struct expr_ops expr_ops_match;
 extern struct expr_ops expr_ops_meta;
 extern struct expr_ops expr_ops_nth;
+extern struct expr_ops expr_ops_hash;
 extern struct expr_ops expr_ops_nat;
 extern struct expr_ops expr_ops_payload;
 extern struct expr_ops expr_ops_redir;
@@ -45,6 +46,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_match,
 	&expr_ops_meta,
 	&expr_ops_nth,
+	&expr_ops_hash,
 	&expr_ops_nat,
 	&expr_ops_payload,
 	&expr_ops_redir,
-- 
2.8.1

