Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F836C54EE9
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Sep 2022 11:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiIPLsa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Sep 2022 07:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiIPLs2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Sep 2022 07:48:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 521B4ACA32
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Sep 2022 04:48:26 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl,RFC] expr: add inner support
Date:   Fri, 16 Sep 2022 13:48:22 +0200
Message-Id: <20220916114822.31988-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds support for the inner expression, which allows you to
match on the inner headers that are coveyed by the network packet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |   8 +
 include/linux/netfilter/nf_tables.h |  33 +++-
 src/Makefile.am                     |   1 +
 src/expr/inner.c                    | 229 ++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 5 files changed, 271 insertions(+), 2 deletions(-)
 create mode 100644 src/expr/inner.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 00c63ab9d19b..5f64d567312b 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -316,6 +316,14 @@ enum {
 	NFTNL_EXPR_LAST_SET,
 };
 
+enum {
+	NFTNL_EXPR_INNER_TYPE = NFTNL_EXPR_BASE,
+	NFTNL_EXPR_INNER_FLAGS,
+	NFTNL_EXPR_INNER_HDRSIZE,
+	NFTNL_EXPR_INNER_NFPROTO,
+	NFTNL_EXPR_INNER_EXPR,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0ae912054cf1..4c92ff2e83be 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -753,13 +753,14 @@ enum nft_dynset_attributes {
  * @NFT_PAYLOAD_LL_HEADER: link layer header
  * @NFT_PAYLOAD_NETWORK_HEADER: network header
  * @NFT_PAYLOAD_TRANSPORT_HEADER: transport header
- * @NFT_PAYLOAD_INNER_HEADER: inner header
+ * @NFT_PAYLOAD_INNER_HEADER: inner header / payload
  */
 enum nft_payload_bases {
 	NFT_PAYLOAD_LL_HEADER,
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
 	NFT_PAYLOAD_INNER_HEADER,
+	NFT_PAYLOAD_TUN_HEADER,
 };
 
 /**
@@ -779,6 +780,32 @@ enum nft_payload_csum_flags {
 	NFT_PAYLOAD_L4CSUM_PSEUDOHDR = (1 << 0),
 };
 
+enum nft_inner_type {
+	NFT_INNER_UNSPEC	= 0,
+	NFT_INNER_VXLAN,
+};
+
+enum nft_inner_flags {
+	NFT_INNER_HDRSIZE	= (1 << 0),
+	NFT_INNER_LL		= (1 << 1),
+	NFT_INNER_NH		= (1 << 2),
+	NFT_INNER_TH		= (1 << 3),
+};
+#define NFT_INNER_MASK		(NFT_INNER_HDRSIZE | NFT_INNER_LL | \
+				 NFT_INNER_NH |  NFT_INNER_TH)
+
+enum nft_inner_attributes {
+	NFTA_INNER_UNSPEC,
+	NFTA_INNER_NUM,
+	NFTA_INNER_TYPE,
+	NFTA_INNER_FLAGS,
+	NFTA_INNER_HDRSIZE,
+	NFTA_INNER_NFPROTO,
+	NFTA_INNER_EXPR,
+	__NFTA_INNER_MAX
+};
+#define NFTA_INNER_MAX	(__NFTA_INNER_MAX - 1)
+
 /**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
@@ -898,7 +925,8 @@ enum nft_meta_keys {
 	NFT_META_OIF,
 	NFT_META_IIFNAME,
 	NFT_META_OIFNAME,
-	NFT_META_IIFTYPE,
+	NFT_META_IFTYPE,
+#define NFT_META_IIFTYPE	NFT_META_IFTYPE
 	NFT_META_OIFTYPE,
 	NFT_META_SKUID,
 	NFT_META_SKGID,
@@ -925,6 +953,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	__NFT_META_IIFTYPE,
 };
 
 /**
diff --git a/src/Makefile.am b/src/Makefile.am
index c3b0ab974bd2..3cd259c04d1c 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -40,6 +40,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/lookup.c	\
 		      expr/dynset.c	\
 		      expr/immediate.c	\
+		      expr/inner.c	\
 		      expr/match.c	\
 		      expr/meta.c	\
 		      expr/numgen.c	\
diff --git a/src/expr/inner.c b/src/expr/inner.c
new file mode 100644
index 000000000000..15ae717a5c34
--- /dev/null
+++ b/src/expr/inner.c
@@ -0,0 +1,229 @@
+/*
+ * (C) 2012-2022 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "internal.h"
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <limits.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <libmnl/libmnl.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+struct nftnl_expr_inner {
+	uint32_t	type;
+	uint32_t	flags;
+	uint32_t	hdrsize;
+	uint32_t	nfproto;
+	struct nftnl_expr *expr;
+};
+
+static void nftnl_expr_inner_free(const struct nftnl_expr *e)
+{
+	struct nftnl_expr_inner *inner = nftnl_expr_data(e);
+
+	if (inner->expr)
+		nftnl_expr_free(inner->expr);
+}
+
+static int
+nftnl_expr_inner_set(struct nftnl_expr *e, uint16_t type,
+		     const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_inner *inner = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_INNER_TYPE:
+		memcpy(&inner->type, data, sizeof(inner->type));
+		break;
+	case NFTNL_EXPR_INNER_FLAGS:
+		memcpy(&inner->flags, data, sizeof(inner->flags));
+		break;
+	case NFTNL_EXPR_INNER_HDRSIZE:
+		memcpy(&inner->hdrsize, data, sizeof(inner->hdrsize));
+		break;
+	case NFTNL_EXPR_INNER_NFPROTO:
+		memcpy(&inner->nfproto, data, sizeof(inner->nfproto));
+		break;
+	case NFTNL_EXPR_INNER_EXPR:
+		if (inner->expr)
+			nftnl_expr_free(inner->expr);
+
+		inner->expr = (void *)data;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_inner_get(const struct nftnl_expr *e, uint16_t type,
+		     uint32_t *data_len)
+{
+	struct nftnl_expr_inner *inner = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_INNER_FLAGS:
+		*data_len = sizeof(inner->flags);
+		return &inner->flags;
+	case NFTNL_EXPR_INNER_TYPE:
+		*data_len = sizeof(&inner->type);
+		break;
+	case NFTNL_EXPR_INNER_HDRSIZE:
+		*data_len = sizeof(&inner->hdrsize);
+		break;
+	case NFTNL_EXPR_INNER_NFPROTO:
+		*data_len = sizeof(&inner->nfproto);
+		break;
+	case NFTNL_EXPR_INNER_EXPR:
+		return inner->expr;
+	}
+	return NULL;
+}
+
+static void
+nftnl_expr_inner_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_inner *inner = nftnl_expr_data(e);
+	struct nlattr *nest;
+
+	mnl_attr_put_u32(nlh, NFTA_INNER_NUM, htonl(0));
+	if (e->flags & (1 << NFTNL_EXPR_INNER_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_INNER_TYPE, htonl(inner->type));
+	if (e->flags & (1 << NFTNL_EXPR_INNER_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_INNER_FLAGS, htonl(inner->flags));
+	if (e->flags & (1 << NFTNL_EXPR_INNER_HDRSIZE))
+		mnl_attr_put_u32(nlh, NFTA_INNER_HDRSIZE, htonl(inner->hdrsize));
+	if (e->flags & (1 << NFTNL_EXPR_INNER_NFPROTO))
+		mnl_attr_put_u32(nlh, NFTA_INNER_NFPROTO, htonl(inner->nfproto));
+	if (e->flags & (1 << NFTNL_EXPR_INNER_EXPR)) {
+		nest = mnl_attr_nest_start(nlh, NFTA_INNER_EXPR);
+		nftnl_expr_build_payload(nlh, inner->expr);
+		mnl_attr_nest_end(nlh, nest);
+	}
+}
+
+static int nftnl_inner_parse_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_INNER_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_INNER_NUM:
+	case NFTA_INNER_TYPE:
+	case NFTA_INNER_HDRSIZE:
+	case NFTA_INNER_NFPROTO:
+	case NFTA_INNER_FLAGS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTA_INNER_EXPR:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+
+	return MNL_CB_OK;
+}
+
+static int
+nftnl_expr_inner_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_inner *inner = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_INNER_MAX + 1] = {};
+	struct nftnl_expr *expr;
+	int err;
+
+	err = mnl_attr_parse_nested(attr, nftnl_inner_parse_cb, tb);
+	if (err < 0)
+		return err;
+
+	if (tb[NFTA_INNER_HDRSIZE]) {
+		inner->hdrsize =
+			ntohl(mnl_attr_get_u32(tb[NFTA_INNER_HDRSIZE]));
+		e->flags |= (1 << NFTNL_EXPR_INNER_HDRSIZE);
+	}
+	if (tb[NFTA_INNER_FLAGS]) {
+		inner->flags =
+			ntohl(mnl_attr_get_u32(tb[NFTA_INNER_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_INNER_FLAGS);
+	}
+	if (tb[NFTA_INNER_TYPE]) {
+		inner->type =
+			ntohl(mnl_attr_get_u32(tb[NFTA_INNER_TYPE]));
+		e->flags |= (1 << NFTNL_EXPR_INNER_TYPE);
+	}
+	if (tb[NFTA_INNER_NFPROTO]) {
+		inner->nfproto =
+			ntohl(mnl_attr_get_u32(tb[NFTA_INNER_NFPROTO]));
+		e->flags |= (1 << NFTNL_EXPR_INNER_NFPROTO);
+	}
+	if (tb[NFTA_INNER_EXPR]) {
+		expr = nftnl_expr_parse(tb[NFTA_INNER_EXPR]);
+		if (!expr)
+			return -1;
+
+		if (inner->expr)
+			nftnl_expr_free(inner->expr);
+
+		inner->expr = expr;
+		e->flags |= (1 << NFTNL_EXPR_INNER_EXPR);
+	}
+
+	return 0;
+}
+
+static int
+nftnl_expr_inner_snprintf(char *buf, size_t remain, uint32_t flags,
+			  const struct nftnl_expr *e)
+{
+	struct nftnl_expr_inner *inner = nftnl_expr_data(e);
+	uint32_t offset = 0;
+	int ret;
+
+	ret = snprintf(buf, remain, "hdrsize %u flags %x type %u nfproto %u [",
+		       inner->hdrsize, inner->flags, inner->type, inner->nfproto);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	ret = snprintf(buf + offset, remain, " %s ", inner->expr->ops->name);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	ret = nftnl_expr_snprintf(buf + offset, remain, inner->expr,
+				  NFTNL_OUTPUT_DEFAULT, 0);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	ret = snprintf(buf + offset, remain, "] ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	return offset;
+}
+
+struct expr_ops expr_ops_inner = {
+	.name		= "inner",
+	.alloc_len	= sizeof(struct nftnl_expr_inner),
+	.max_attr	= NFTA_INNER_MAX,
+	.free		= nftnl_expr_inner_free,
+	.set		= nftnl_expr_inner_set,
+	.get		= nftnl_expr_inner_get,
+	.parse		= nftnl_expr_inner_parse,
+	.build		= nftnl_expr_inner_build,
+	.output		= nftnl_expr_inner_snprintf,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 7248e4f98b0a..b85f47209725 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -14,6 +14,7 @@ extern struct expr_ops expr_ops_dup;
 extern struct expr_ops expr_ops_exthdr;
 extern struct expr_ops expr_ops_fwd;
 extern struct expr_ops expr_ops_immediate;
+extern struct expr_ops expr_ops_inner;
 extern struct expr_ops expr_ops_last;
 extern struct expr_ops expr_ops_limit;
 extern struct expr_ops expr_ops_log;
@@ -58,6 +59,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_exthdr,
 	&expr_ops_fwd,
 	&expr_ops_immediate,
+	&expr_ops_inner,
 	&expr_ops_last,
 	&expr_ops_limit,
 	&expr_ops_log,
-- 
2.30.2

