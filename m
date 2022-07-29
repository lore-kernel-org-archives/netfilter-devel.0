Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642F0C00144
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jul 2022 09:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiG2Jid (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 05:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiG2Jic (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 05:38:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F6B95FAEC
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 02:38:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl RFC 2/3] expr: add string expression
Date:   Fri, 29 Jul 2022 11:38:22 +0200
Message-Id: <20220729093823.3441-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220729093823.3441-1-pablo@netfilter.org>
References: <20220729093823.3441-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add string expression to use to match on existing "string sets" from rules.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |   9 ++
 include/linux/netfilter/nf_tables.h |  26 ++++
 src/Makefile.am                     |   1 +
 src/expr/str.c                      | 223 ++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 5 files changed, 261 insertions(+)
 create mode 100644 src/expr/str.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 00c63ab9d19b..997e19a13662 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -78,6 +78,15 @@ enum {
 	NFTNL_EXPR_RT_DREG,
 };
 
+enum {
+	NFTNL_EXPR_STR_NAME	= NFTNL_EXPR_BASE,
+	NFTNL_EXPR_STR_BASE,
+	NFTNL_EXPR_STR_FROM,
+	NFTNL_EXPR_STR_TO,
+	NFTNL_EXPR_STR_DREG,
+	NFTNL_EXPR_STR_FLAGS,
+};
+
 enum {
 	NFTNL_EXPR_SOCKET_KEY	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_SOCKET_DREG,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index d7a668199611..8ce2400952c0 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1711,6 +1711,32 @@ enum nft_string_hook_attributes {
 };
 #define NFTA_STRING_MAX	(__NFTA_STRING_MAX - 1)
 
+enum nft_string_flags {
+	NFT_STR_F_PRESENT = (1 << 0),
+};
+
+/**
+ * enum nft_str_hook_attributes - nf_tables string expression netlink attributes
+ *
+ * @NFTA_STR_NAME: string set name (NLA_STRING)
+ * @NFTA_STR_BASE: payload base (NLA_U32: nft_payload_bases)
+ * @NFTA_STR_FROM: offset to start matching from (NLA_U32)
+ * @NFTA_STR_TO: offset to end matching to (NLA_U32)
+ * @NFTA_STR_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_STR_FLAGS: flags (NLA_U32)
+ */
+enum nft_str_hook_attributes {
+	NFTA_STR_UNSPEC,
+	NFTA_STR_NAME,
+	NFTA_STR_BASE,
+	NFTA_STR_FROM,
+	NFTA_STR_TO,
+	NFTA_STR_DREG,
+	NFTA_STR_FLAGS,
+	__NFTA_STR_MAX
+};
+#define NFTA_STR_MAX	(__NFTA_STR_MAX - 1)
+
 /**
  * enum nft_osf_attributes - nftables osf expression netlink attributes
  *
diff --git a/src/Makefile.am b/src/Makefile.am
index 24825d4e3e38..15ce569636c8 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -52,6 +52,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/quota.c	\
 		      expr/reject.c	\
 		      expr/rt.c		\
+		      expr/str.c	\
 		      expr/target.c	\
 		      expr/tunnel.c	\
 		      expr/masq.c	\
diff --git a/src/expr/str.c b/src/expr/str.c
new file mode 100644
index 000000000000..398fdce22f10
--- /dev/null
+++ b/src/expr/str.c
@@ -0,0 +1,223 @@
+/*
+ * Copyright (c) 2022 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
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
+struct nftnl_expr_str {
+	const char		*name;
+	uint32_t		base;
+	uint32_t		from;
+	uint32_t		to;
+	uint32_t		flags;
+	enum nft_registers	dreg;
+};
+
+static int
+nftnl_expr_str_set(struct nftnl_expr *e, uint16_t type,
+		   const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_str *str = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_STR_NAME:
+		if (str->name)
+			xfree(str->name);
+
+		str->name = strdup(data);
+		if (!str->name)
+			return -1;
+		break;
+	case NFTNL_EXPR_STR_BASE:
+		memcpy(&str->base, data, sizeof(str->base));
+		break;
+	case NFTNL_EXPR_STR_FROM:
+		memcpy(&str->from, data, sizeof(str->from));
+		break;
+	case NFTNL_EXPR_STR_TO:
+		memcpy(&str->to, data, sizeof(str->to));
+		break;
+	case NFTNL_EXPR_STR_DREG:
+		memcpy(&str->dreg, data, sizeof(str->dreg));
+		break;
+	case NFTNL_EXPR_STR_FLAGS:
+		memcpy(&str->flags, data, sizeof(str->flags));
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *
+nftnl_expr_str_get(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_expr_str *str = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_STR_NAME:
+		if (str->name)
+			*data_len = strlen(str->name);
+		else
+			*data_len = 0;
+
+		return str->name;
+	case NFTNL_EXPR_STR_BASE:
+		*data_len = sizeof(str->base);
+		return &str->base;
+	case NFTNL_EXPR_STR_FROM:
+		*data_len = sizeof(str->from);
+		return &str->from;
+	case NFTNL_EXPR_STR_TO:
+		*data_len = sizeof(str->to);
+		return &str->to;
+	case NFTNL_EXPR_STR_DREG:
+		*data_len = sizeof(str->dreg);
+		return &str->dreg;
+	case NFTNL_EXPR_STR_FLAGS:
+		*data_len = sizeof(str->flags);
+		return &str->flags;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_str_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_STR_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_STR_BASE:
+	case NFTA_STR_FROM:
+	case NFTA_STR_TO:
+	case NFTA_STR_DREG:
+	case NFTA_STR_FLAGS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	case NFTA_STR_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_expr_str_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_str *str = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_STR_BASE))
+		mnl_attr_put_u32(nlh, NFTA_STR_BASE, htonl(str->base));
+	if (e->flags & (1 << NFTNL_EXPR_STR_FROM))
+		mnl_attr_put_u32(nlh, NFTA_STR_FROM, htonl(str->from));
+	if (e->flags & (1 << NFTNL_EXPR_STR_TO))
+		mnl_attr_put_u32(nlh, NFTA_STR_TO, htonl(str->to));
+	if (e->flags & (1 << NFTNL_EXPR_STR_NAME))
+		mnl_attr_put_strz(nlh, NFTA_STR_NAME, str->name);
+	if (e->flags & (1 << NFTNL_EXPR_STR_DREG))
+		mnl_attr_put_u32(nlh, NFTA_STR_DREG, htonl(str->dreg));
+	if (e->flags & (1 << NFTNL_EXPR_STR_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_STR_FLAGS, htonl(str->flags));
+}
+
+static int
+nftnl_expr_str_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_str *str = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_STR_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_str_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_STR_BASE]) {
+		str->base = ntohl(mnl_attr_get_u32(tb[NFTA_STR_BASE]));
+		e->flags |= (1 << NFTNL_EXPR_STR_BASE);
+	}
+	if (tb[NFTA_STR_FROM]) {
+		str->from = ntohl(mnl_attr_get_u32(tb[NFTA_STR_FROM]));
+		e->flags |= (1 << NFTNL_EXPR_STR_FROM);
+	}
+	if (tb[NFTA_STR_FROM]) {
+		str->to = ntohl(mnl_attr_get_u32(tb[NFTA_STR_TO]));
+		e->flags |= (1 << NFTNL_EXPR_STR_TO);
+	}
+	if (tb[NFTA_STR_NAME]) {
+		str->name = strdup(mnl_attr_get_str(tb[NFTA_STR_NAME]));
+		if (!str->name)
+			return -1;
+
+		e->flags |= (1 << NFTNL_EXPR_STR_NAME);
+	}
+	if (tb[NFTA_STR_DREG]) {
+		str->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_STR_DREG]));
+		e->flags |= (1 << NFTNL_EXPR_STR_DREG);
+	}
+	if (tb[NFTA_STR_FLAGS]) {
+		str->flags = ntohl(mnl_attr_get_u32(tb[NFTA_STR_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_STR_FLAGS);
+	}
+
+	return 0;
+}
+
+static const char *nft_str_base(uint32_t base)
+{
+	switch (base) {
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		return "nh";
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		return "th";
+	case NFT_PAYLOAD_INNER_HEADER:
+		return "ih";
+	default:
+		break;
+	}
+	return "unknown";
+}
+
+static int
+nftnl_expr_str_snprintf(char *buf, size_t len,
+			uint32_t flags, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_str *str = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_STR_DREG)) {
+		return snprintf(buf, len, "search @%s,%s %u-%u => reg %u",
+				str->name, nft_str_base(str->base),
+				str->from, str->to, str->dreg);
+	}
+	return 0;
+}
+
+struct expr_ops expr_ops_str = {
+	.name		= "string",
+	.alloc_len	= sizeof(struct nftnl_expr_str),
+	.max_attr	= NFTA_STR_MAX,
+	.set		= nftnl_expr_str_set,
+	.get		= nftnl_expr_str_get,
+	.parse		= nftnl_expr_str_parse,
+	.build		= nftnl_expr_str_build,
+	.output		= nftnl_expr_str_snprintf,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 7248e4f98b0a..85ea82008e1a 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -30,6 +30,7 @@ extern struct expr_ops expr_ops_range;
 extern struct expr_ops expr_ops_redir;
 extern struct expr_ops expr_ops_reject;
 extern struct expr_ops expr_ops_rt;
+extern struct expr_ops expr_ops_str;
 extern struct expr_ops expr_ops_queue;
 extern struct expr_ops expr_ops_quota;
 extern struct expr_ops expr_ops_target;
@@ -74,6 +75,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_redir,
 	&expr_ops_reject,
 	&expr_ops_rt,
+	&expr_ops_str,
 	&expr_ops_queue,
 	&expr_ops_quota,
 	&expr_ops_target,
-- 
2.30.2

