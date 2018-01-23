From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 2/2] expr: add flow offload expression
Date: Tue, 23 Jan 2018 13:10:03 +0100
Message-ID: <20180123121003.16064-2-pablo@netfilter.org>
References: <20180123121003.16064-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39542 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeAWMKR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 07:10:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D04B210564
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:10:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BEA3DA818
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:10:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36E35DA86B
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:10:09 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F21344265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:10:08 +0100 (CET)
In-Reply-To: <20180123121003.16064-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the new "flow_offload" expression to select what flows
are offloaded to an existing flowtable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |   4 +
 include/linux/netfilter/nf_tables.h |  11 +++
 src/Makefile.am                     |   1 +
 src/expr/flow_offload.c             | 184 ++++++++++++++++++++++++++++++++++++
 src/expr_ops.c                      |   2 +
 5 files changed, 202 insertions(+)
 create mode 100644 src/expr/flow_offload.c

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index f37f50963d6c..76df94276c46 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -221,6 +221,10 @@ enum {
 };
 
 enum {
+	NFTNL_EXPR_FLOW_TABLE_NAME = NFTNL_EXPR_BASE,
+};
+
+enum {
 	NFTNL_EXPR_FWD_SREG_DEV = NFTNL_EXPR_BASE,
 };
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c525e67a665d..2edccfee9506 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -952,6 +952,17 @@ enum nft_ct_attributes {
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
 
+/**
+ * enum nft_flow_attributes - ct offload expression attributes
+ * @NFTA_FLOW_TABLE_NAME: flow table name (NLA_STRING)
+ */
+enum nft_offload_attributes {
+	NFTA_FLOW_UNSPEC,
+	NFTA_FLOW_TABLE_NAME,
+	__NFTA_FLOW_MAX,
+};
+#define NFTA_FLOW_MAX		(__NFTA_FLOW_MAX - 1)
+
 enum nft_limit_type {
 	NFT_LIMIT_PKTS,
 	NFT_LIMIT_PKT_BYTES
diff --git a/src/Makefile.am b/src/Makefile.am
index 7708c279c9da..578b7d36d8a9 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -32,6 +32,7 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/data_reg.c	\
 		      expr/dup.c	\
 		      expr/exthdr.c	\
+		      expr/flow_offload.c \
 		      expr/fib.c	\
 		      expr/fwd.c	\
 		      expr/limit.c	\
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
new file mode 100644
index 000000000000..a2001c9ae9db
--- /dev/null
+++ b/src/expr/flow_offload.c
@@ -0,0 +1,184 @@
+#include "internal.h"
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h> /* for memcpy */
+#include <arpa/inet.h>
+#include <errno.h>
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nf_tables.h>
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
+struct nftnl_expr_flow {
+	char			*table_name;
+};
+
+static int nftnl_expr_flow_set(struct nftnl_expr *e, uint16_t type,
+			       const void *data, uint32_t data_len)
+{
+	struct nftnl_expr_flow *flow = nftnl_expr_data(e);
+
+	switch (type) {
+	case NFTNL_EXPR_FLOW_TABLE_NAME:
+		flow->table_name = strdup((const char *)data);
+		if (!flow->table_name)
+			return -1;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nftnl_expr_flow_get(const struct nftnl_expr *e,
+				       uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_expr_flow *flow = nftnl_expr_data(e);
+
+	switch(type) {
+	case NFTNL_EXPR_FLOW_TABLE_NAME:
+		*data_len = strlen(flow->table_name) + 1;
+		return flow->table_name;
+	}
+	return NULL;
+}
+
+static int nftnl_expr_flow_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_FLOW_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NFTA_FLOW_TABLE_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void nftnl_expr_flow_build(struct nlmsghdr *nlh,
+				  const struct nftnl_expr *e)
+{
+	struct nftnl_expr_flow *flow = nftnl_expr_data(e);
+
+	if (e->flags & (1 << NFTNL_EXPR_FLOW_TABLE_NAME))
+		mnl_attr_put_strz(nlh, NFTA_FLOW_TABLE_NAME, flow->table_name);
+}
+
+static int nftnl_expr_flow_parse(struct nftnl_expr *e, struct nlattr *attr)
+{
+	struct nftnl_expr_flow *flow = nftnl_expr_data(e);
+	struct nlattr *tb[NFTA_FLOW_MAX+1] = {};
+	int ret = 0;
+
+	if (mnl_attr_parse_nested(attr, nftnl_expr_flow_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_FLOW_TABLE_NAME]) {
+		flow->table_name =
+			strdup(mnl_attr_get_str(tb[NFTA_FLOW_TABLE_NAME]));
+		if (!flow->table_name)
+			return -1;
+		e->flags |= (1 << NFTNL_EXPR_FLOW_TABLE_NAME);
+	}
+
+	return ret;
+}
+
+static int
+nftnl_expr_flow_json_parse(struct nftnl_expr *e, json_t *root,
+				struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	const char *table_name;
+
+	table_name = nftnl_jansson_parse_str(root, "flowtable", err);
+	if (table_name != NULL)
+		nftnl_expr_set_str(e, NFTNL_EXPR_FLOW_TABLE_NAME, table_name);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_expr_flow_export(char *buf, size_t size,
+				  const struct nftnl_expr *e, int type)
+{
+	struct nftnl_expr_flow *l = nftnl_expr_data(e);
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_EXPR_FLOW_TABLE_NAME))
+		nftnl_buf_str(&b, type, l->table_name, SET);
+
+	return nftnl_buf_done(&b);
+}
+
+static int nftnl_expr_flow_snprintf_default(char *buf, size_t size,
+					    const struct nftnl_expr *e)
+{
+	int remain = size, offset = 0, ret;
+	struct nftnl_expr_flow *l = nftnl_expr_data(e);
+
+	ret = snprintf(buf, remain, "flowtable %s ", l->table_name);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+	return offset;
+}
+
+static int nftnl_expr_flow_snprintf(char *buf, size_t size, uint32_t type,
+				    uint32_t flags, const struct nftnl_expr *e)
+{
+	switch(type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_expr_flow_snprintf_default(buf, size, e);
+	case NFTNL_OUTPUT_XML:
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_expr_flow_export(buf, size, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+static void nftnl_expr_flow_free(const struct nftnl_expr *e)
+{
+	struct nftnl_expr_flow *flow = nftnl_expr_data(e);
+
+	xfree(flow->table_name);
+}
+
+static bool nftnl_expr_flow_cmp(const struct nftnl_expr *e1,
+				const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_flow *l1 = nftnl_expr_data(e1);
+	struct nftnl_expr_flow *l2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_FLOW_TABLE_NAME))
+		eq &= !strcmp(l1->table_name, l2->table_name);
+
+	return eq;
+}
+
+struct expr_ops expr_ops_flow = {
+	.name		= "flow_offload",
+	.alloc_len	= sizeof(struct nftnl_expr_flow),
+	.max_attr	= NFTA_FLOW_MAX,
+	.free		= nftnl_expr_flow_free,
+	.cmp		= nftnl_expr_flow_cmp,
+	.set		= nftnl_expr_flow_set,
+	.get		= nftnl_expr_flow_get,
+	.parse		= nftnl_expr_flow_parse,
+	.build		= nftnl_expr_flow_build,
+	.snprintf	= nftnl_expr_flow_snprintf,
+	.json_parse	= nftnl_expr_flow_json_parse,
+};
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 7a0e1e3d0a26..041bd357d370 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -33,6 +33,7 @@ extern struct expr_ops expr_ops_target;
 extern struct expr_ops expr_ops_dynset;
 extern struct expr_ops expr_ops_hash;
 extern struct expr_ops expr_ops_fib;
+extern struct expr_ops expr_ops_flow;
 
 static struct expr_ops expr_ops_notrack = {
 	.name	= "notrack",
@@ -69,6 +70,7 @@ static struct expr_ops *expr_ops[] = {
 	&expr_ops_hash,
 	&expr_ops_fib,
 	&expr_ops_objref,
+	&expr_ops_flow,
 	NULL,
 };
 
-- 
2.11.0

