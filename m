Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1424BC48BD1
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 18:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBB73613E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 18:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhFJS4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 14:56:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35096 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhFJS4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 14:56:11 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F188264231
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Jun 2021 20:52:59 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 1/2] expr: add last match time support
Date:   Thu, 10 Jun 2021 20:54:09 +0200
Message-Id: <20210610185410.13834-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new expression displays when last matching has happened.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Already applied, I accidentally pushed it out, just for the record.

 include/libnftnl/expr.h |   4 ++
 src/Makefile.am         |   1 +
 src/expr/last.c         | 118 ++++++++++++++++++++++++++++++++++++++++
 src/expr_ops.c          |   2 +
 4 files changed, 125 insertions(+)
 create mode 100644 src/expr/last.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 4e6059a609df..9b90e3ea3569 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -311,6 +311,10 @@ enum {
 	NFTNL_EXPR_SYNPROXY_FLAGS,
 };
 
+enum {
+	NFTNL_EXPR_LAST_MSECS = NFTNL_EXPR_BASE,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 90b1967420b1..c3b0ab974bd2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -34,6 +34,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/flow_offload.c \
 		      expr/fib.c	\
 		      expr/fwd.c	\
+		      expr/last.c	\
 		      expr/limit.c	\
 		      expr/log.c	\
 		      expr/lookup.c	\
diff --git a/src/expr/last.c b/src/expr/last.c
new file mode 100644
index 000000000000..0020fbcd24dc
--- /dev/null
+++ b/src/expr/last.c
@@ -0,0 +1,118 @@
+/*
+ * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+struct nftnl_expr_last {
+	uint64_t	msecs;
+};
+
+static int nftnl_expr_last_set(struct nftnl_expr *e, uint16_t type,
+				const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_last *last = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_LAST_MSECS:
+		memcpy(&last->msecs, data, sizeof(last->msecs));
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nftnl_expr_last_get(const struct nftnl_expr *e,
+					uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_expr_last *last = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_LAST_MSECS:
+		*data_len = sizeof(last->msecs);
+		return &last->msecs;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_last_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	if (mnl_attr_type_valid(attr, NFTA_LAST_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_LAST_MSECS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_expr_last_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
+{
+	struct nftnl_expr_last *last = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_LAST_MSECS))
+		mnl_attr_put_u64(nlh, NFTA_LAST_MSECS, htobe64(last->msecs));
+}
+
+static int
+nftnl_expr_last_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_last *last = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_LAST_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_last_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_LAST_MSECS]) {
+		last->msecs = be64toh(mnl_attr_get_u64(tb[NFTA_LAST_MSECS]));
+		e->flags |= (1 << NFTNL_EXPR_LAST_MSECS);
+	}
+
+	return 0;
+}
+
+static int nftnl_expr_last_snprintf(char *buf, size_t len,
+				       uint32_t flags,
+				       const struct nftnl_expr *e)
+{
+	struct nftnl_expr_last *last = nftnl_expr_data(e);
+
+	return snprintf(buf, len, "last %"PRIu64" ", last->msecs);
+}
+
+struct expr_ops expr_ops_last = {
+	.name		= "last",
+	.alloc_len	= sizeof(struct nftnl_expr_last),
+	.max_attr	= NFTA_LAST_MAX,
+	.set		= nftnl_expr_last_set,
+	.get		= nftnl_expr_last_get,
+	.parse		= nftnl_expr_last_parse,
+	.build		= nftnl_expr_last_build,
+	.snprintf	= nftnl_expr_last_snprintf,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 3538dd60a6b7..7248e4f98b0a 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -14,6 +14,7 @@ extern struct expr_ops expr_ops_dup;
 extern struct expr_ops expr_ops_exthdr;
 extern struct expr_ops expr_ops_fwd;
 extern struct expr_ops expr_ops_immediate;
+extern struct expr_ops expr_ops_last;
 extern struct expr_ops expr_ops_limit;
 extern struct expr_ops expr_ops_log;
 extern struct expr_ops expr_ops_lookup;
@@ -57,6 +58,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_exthdr,
 	&expr_ops_fwd,
 	&expr_ops_immediate,
+	&expr_ops_last,
 	&expr_ops_limit,
 	&expr_ops_log,
 	&expr_ops_lookup,
-- 
2.30.2

