From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3 libnftables] expr: add fib expression
Date: Mon, 24 Oct 2016 16:56:41 +0200
Message-ID: <1477321002-14056-3-git-send-email-fw@strlen.de>
References: <1477321002-14056-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46002 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932806AbcJXO4b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Oct 2016 10:56:31 -0400
In-Reply-To: <1477321002-14056-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/expr.h             |   6 +
 include/linux/netfilter/nf_tables.h |  36 +++++
 src/Makefile.am                     |   1 +
 src/expr/fib.c                      | 273 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 5 files changed, 318 insertions(+)
 create mode 100644 src/expr/fib.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index edf86a966fc0..ad765d28d472 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -222,6 +222,12 @@ enum {
 	NFTNL_EXPR_HASH_OFFSET,
 };
 
+enum {
+	NFTNL_EXPR_FIB_DREG	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_FIB_RESULT,
+	NFTNL_EXPR_FIB_FLAGS,
+};
+
 /*
  * Compat
  */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 30e3b21418c5..8d950dc601d1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1103,6 +1103,42 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/*
+ * enum nft_fib_attributes - nf_tables fib expression netlink attributes
+ *
+ * @NFTA_FIB_DREG: destination register (NLA_U32)
+ * @NFTA_FIB_RESULT: desired result (NLA_U32)
+ * @NFTA_FIB_FLAGS: flowi fields to initialize when querying the FIB (NLA_U32)
+ *
+ * The FIB expression performs a route lookup according
+ * to the packet data.
+ */
+enum nft_fib_attributes {
+	NFTA_FIB_UNSPEC,
+	NFTA_FIB_DREG,
+	NFTA_FIB_RESULT,
+	NFTA_FIB_FLAGS,
+	__NFTA_FIB_MAX
+};
+#define NFTA_FIB_MAX (__NFTA_FIB_MAX - 1)
+
+enum nft_fib_result {
+	NFT_FIB_RESULT_UNSPEC,
+	NFT_FIB_RESULT_OIF,
+	NFT_FIB_RESULT_OIFNAME,
+	NFT_FIB_RESULT_ADDRTYPE,
+	__NFT_FIB_RESULT_MAX
+};
+#define NFT_FIB_RESULT_MAX	(__NFT_FIB_RESULT_MAX - 1)
+
+enum nft_fib_flags {
+	NFTA_FIB_F_SADDR	= 1 << 0,	/* look up src, not dst */
+	NFTA_FIB_F_DADDR	= 1 << 1,	/* look up dst (default) */
+	NFTA_FIB_F_MARK		= 1 << 2,	/* set fib mark */
+	NFTA_FIB_F_IIF		= 1 << 3,	/* restrict to iif */
+	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
+};
+
 /**
  * enum nft_trace_attributes - nf_tables trace netlink attributes
  *
diff --git a/src/Makefile.am b/src/Makefile.am
index eac7a5678009..578374915647 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -30,6 +30,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/data_reg.c	\
 		      expr/dup.c	\
 		      expr/exthdr.c	\
+		      expr/fib.c	\
 		      expr/fwd.c	\
 		      expr/limit.c	\
 		      expr/log.c	\
diff --git a/src/expr/fib.c b/src/expr/fib.c
new file mode 100644
index 000000000000..9e63621e7287
--- /dev/null
+++ b/src/expr/fib.c
@@ -0,0 +1,273 @@
+/*
+ * (C) 2016 Red Hat GmbH
+ * Author: Florian Westphal <fw@strlen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <inttypes.h>
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
+struct nftnl_expr_fib {
+	uint32_t		flags;
+	uint32_t		result;
+	enum nft_registers	dreg;
+};
+
+static int
+nftnl_expr_fib_set(struct nftnl_expr *e, uint16_t result,
+		    const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+
+	switch (result) {
+	case NFTNL_EXPR_FIB_RESULT:
+		fib->result = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_FIB_DREG:
+		fib->dreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_FIB_FLAGS:
+		fib->flags = *((uint32_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_fib_get(const struct nftnl_expr *e, uint16_t result,
+		    uint32_t *data_len)
+{
+	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+
+	switch (result) {
+	case NFTNL_EXPR_FIB_RESULT:
+		*data_len = sizeof(fib->result);
+		return &fib->result;
+	case NFTNL_EXPR_FIB_DREG:
+		*data_len = sizeof(fib->dreg);
+		return &fib->dreg;
+	case NFTNL_EXPR_FIB_FLAGS:
+		*data_len = sizeof(fib->flags);
+		return &fib->flags;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_fib_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_FIB_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_FIB_RESULT:
+	case NFTA_FIB_DREG:
+	case NFTA_FIB_FLAGS:
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
+nftnl_expr_fib_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_FIB_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_FIB_FLAGS, htonl(fib->flags));
+	if (e->flags & (1 << NFTNL_EXPR_FIB_RESULT))
+		mnl_attr_put_u32(nlh, NFTA_FIB_RESULT, htonl(fib->result));
+	if (e->flags & (1 << NFTNL_EXPR_FIB_DREG))
+		mnl_attr_put_u32(nlh, NFTA_FIB_DREG, htonl(fib->dreg));
+}
+
+static int
+nftnl_expr_fib_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_FIB_MAX+1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_fib_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_FIB_RESULT]) {
+		fib->result = ntohl(mnl_attr_get_u32(tb[NFTA_FIB_RESULT]));
+		e->flags |= (1 << NFTNL_EXPR_FIB_RESULT);
+	}
+	if (tb[NFTA_FIB_DREG]) {
+		fib->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_FIB_DREG]));
+		e->flags |= (1 << NFTNL_EXPR_FIB_DREG);
+	}
+	if (tb[NFTA_FIB_FLAGS]) {
+		fib->flags = ntohl(mnl_attr_get_u32(tb[NFTA_FIB_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_FIB_FLAGS);
+	}
+	return ret;
+}
+
+static int nftnl_expr_fib_json_parse(struct nftnl_expr *e, json_t *root,
+				      struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint32_t result, flags, dreg;
+
+	if (nftnl_jansson_parse_reg(root, "result", NFTNL_TYPE_U32,
+				    &result, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_FIB_RESULT, result);
+
+	if (nftnl_jansson_parse_reg(root, "dreg", NFTNL_TYPE_U32,
+				    &dreg, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_FIB_DREG, dreg);
+
+	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U32,
+				    &flags, err) == 0)
+		nftnl_expr_set_u32(e, NFTNL_EXPR_FIB_FLAGS, flags);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static const char *fib_type[NFT_FIB_RESULT_MAX + 1] = {
+	[NFT_FIB_RESULT_OIF] = "oif",
+	[NFT_FIB_RESULT_OIFNAME] = "oifname",
+	[NFT_FIB_RESULT_ADDRTYPE] = "type",
+};
+
+static const char *fib_type_str(enum nft_fib_result r)
+{
+	if (r <= NFT_FIB_RESULT_MAX)
+		return fib_type[r];
+
+	return "unknown";
+}
+
+static int
+nftnl_expr_fib_snprintf_default(char *buf, size_t size,
+				const struct nftnl_expr *e)
+{
+	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+	int len = size, offset = 0, ret, i;
+	uint32_t flags = fib->flags;
+	static const struct {
+		int bit;
+		const char *name;
+	} tab[] = {
+		{ NFTA_FIB_F_SADDR, "saddr" },
+		{ NFTA_FIB_F_DADDR, "daddr" },
+		{ NFTA_FIB_F_MARK, "mark" },
+		{ NFTA_FIB_F_IIF, "iif" },
+		{ NFTA_FIB_F_OIF, "oif" },
+	};
+
+	for (i = 0; i < (sizeof(tab) / sizeof(tab[0])); i++) {
+		if (flags & tab[i].bit) {
+			ret = snprintf(buf + offset, len, "%s ", tab[i].name);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+			flags &= ~tab[i].bit;
+			if (flags) {
+				ret = snprintf(buf + offset, len, ". ");
+				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			}
+		}
+	}
+
+	if (flags) {
+		ret = snprintf(buf + offset, len, "unknown 0x%" PRIx32, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret = snprintf(buf + offset, len, "%s => reg %d ", fib_type_str(fib->result), fib->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int nftnl_expr_fib_export(char *buf, size_t size,
+				  const struct nftnl_expr *e, int type)
+{
+	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
+
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_FIB_RESULT))
+		nftnl_buf_u32(&b, type, fib->result, OP);
+	if (e->flags & (1 << NFTNL_EXPR_FIB_DREG))
+		nftnl_buf_u32(&b, type, fib->dreg, DREG);
+	if (e->flags & (1 << NFTNL_EXPR_FIB_FLAGS))
+		nftnl_buf_u32(&b, type, fib->flags, FLAGS);
+
+	return nftnl_buf_done(&b);
+}
+
+static int
+nftnl_expr_fib_snprintf(char *buf, size_t len, uint32_t type,
+			 uint32_t flags, const struct nftnl_expr *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_fib_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_fib_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+static bool nftnl_expr_fib_cmp(const struct nftnl_expr *e1,
+				const struct nftnl_expr *e2)
+{
+       struct nftnl_expr_fib *h1 = nftnl_expr_data(e1);
+       struct nftnl_expr_fib *h2 = nftnl_expr_data(e2);
+       bool eq = true;
+
+       if (e1->flags & (1 << NFTNL_EXPR_FIB_RESULT))
+               eq &= (h1->result == h2->result);
+       if (e1->flags & (1 << NFTNL_EXPR_FIB_DREG))
+               eq &= (h1->dreg == h2->dreg);
+       if (e1->flags & (1 << NFTNL_EXPR_FIB_FLAGS))
+               eq &= (h1->flags == h2->flags);
+
+       return eq;
+}
+
+struct expr_ops expr_ops_fib = {
+	.name		= "fib",
+	.alloc_len	= sizeof(struct nftnl_expr_fib),
+	.max_attr	= NFTA_FIB_MAX,
+	.cmp		= nftnl_expr_fib_cmp,
+	.set		= nftnl_expr_fib_set,
+	.get		= nftnl_expr_fib_get,
+	.parse		= nftnl_expr_fib_parse,
+	.build		= nftnl_expr_fib_build,
+	.snprintf	= nftnl_expr_fib_snprintf,
+	.json_parse	= nftnl_expr_fib_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 96b1f8df9d3b..897c002dabab 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -30,6 +30,7 @@ extern struct expr_ops expr_ops_quota;
 extern struct expr_ops expr_ops_target;
 extern struct expr_ops expr_ops_dynset;
 extern struct expr_ops expr_ops_hash;
+extern struct expr_ops expr_ops_fib;
 
 static struct expr_ops expr_ops_notrack = {
 	.name	= "notrack",
@@ -63,6 +64,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_target,
 	&expr_ops_dynset,
 	&expr_ops_hash,
+	&expr_ops_fib,
 	NULL,
 };
 
-- 
2.7.3

