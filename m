Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9F3C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 00:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiATAEL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:04:11 -0500
Received: from mail.netfilter.org ([217.70.188.207]:37196 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiATAEK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 19:04:10 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6978860029;
        Thu, 20 Jan 2022 01:01:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH libnftnl 1/3] desc: add expression description
Date:   Thu, 20 Jan 2022 01:04:00 +0100
Message-Id: <20220120000402.916332-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120000402.916332-1-pablo@netfilter.org>
References: <20220120000402.916332-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new object to describe an expression. This allows to describe the
set key when typeof is used to define the set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Makefile.am          |   1 +
 include/desc.h               |  19 +++++
 include/expr_ops.h           |  11 +++
 include/internal.h           |   1 +
 include/libnftnl/Makefile.am |   1 +
 include/libnftnl/desc.h      |  57 ++++++++++++++
 src/Makefile.am              |   1 +
 src/desc.c                   | 142 +++++++++++++++++++++++++++++++++++
 src/expr/payload.c           |  81 ++++++++++++++++++++
 src/expr_ops.c               |  13 ++++
 10 files changed, 327 insertions(+)
 create mode 100644 include/desc.h
 create mode 100644 include/libnftnl/desc.h
 create mode 100644 src/desc.c

diff --git a/include/Makefile.am b/include/Makefile.am
index 738f80708ca0..83a0e5209ed7 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -3,6 +3,7 @@ SUBDIRS = libnftnl linux
 noinst_HEADERS = internal.h	\
 		 linux_list.h	\
 		 data_reg.h	\
+		 desc.h		\
 		 expr_ops.h	\
 		 obj.h		\
 		 linux_list.h	\
diff --git a/include/desc.h b/include/desc.h
new file mode 100644
index 000000000000..d78af3528118
--- /dev/null
+++ b/include/desc.h
@@ -0,0 +1,19 @@
+#ifndef _LIBNFTNL_DESC_INTERNAL_H_
+#define _LIBNFTNL_DESC_INTERNAL_H_
+
+struct nftnl_expr_desc {
+	uint32_t	etype;
+	uint32_t	byteorder;
+	uint32_t	len;
+
+	struct expr_ops *ops;
+
+	union {
+		struct {
+			uint32_t desc_id;
+			uint32_t type;
+		} payload;
+	};
+};
+
+#endif
diff --git a/include/expr_ops.h b/include/expr_ops.h
index 7a6aa23f9bd1..77e010bf2a7d 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -2,14 +2,19 @@
 #define _EXPR_OPS_H_
 
 #include <stdint.h>
+#include <libnftnl/desc.h>
 #include "internal.h"
 
 struct nlattr;
 struct nlmsghdr;
 struct nftnl_expr;
+struct nftnl_expr_desc;
+struct nftnl_udata;
+struct nftnl_udata_buf;
 
 struct expr_ops {
 	const char *name;
+	enum nftnl_expr_desc_type type;
 	uint32_t alloc_len;
 	int	max_attr;
 	void	(*init)(const struct nftnl_expr *e);
@@ -19,9 +24,15 @@ struct expr_ops {
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
 	int	(*snprintf)(char *buf, size_t len, uint32_t flags, const struct nftnl_expr *e);
+	struct {
+		int	(*set)(struct nftnl_expr_desc *uexpr, uint8_t type, const void *data, uint32_t data_len);
+		int	(*build)(struct nftnl_udata_buf *ud, const struct nftnl_expr_desc *uexpr);
+		int	(*parse)(const struct nftnl_udata *attr, struct nftnl_expr_desc *uexpr);
+	} desc;
 };
 
 struct expr_ops *nftnl_expr_ops_lookup(const char *name);
+struct expr_ops *nftnl_expr_ops_lookup_by_type(uint32_t type);
 
 #define nftnl_expr_data(ops) (void *)ops->data
 
diff --git a/include/internal.h b/include/internal.h
index 1f96731589c0..7b058aa2ced8 100644
--- a/include/internal.h
+++ b/include/internal.h
@@ -12,5 +12,6 @@
 #include "expr.h"
 #include "expr_ops.h"
 #include "rule.h"
+#include "desc.h"
 
 #endif /* _LIBNFTNL_INTERNAL_H_ */
diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.am
index d846a574f438..3d072ed8642b 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -1,4 +1,5 @@
 pkginclude_HEADERS = batch.h		\
+		     desc.h		\
 		     table.h		\
 		     trace.h		\
 		     chain.h		\
diff --git a/include/libnftnl/desc.h b/include/libnftnl/desc.h
new file mode 100644
index 000000000000..1202eb9ddf79
--- /dev/null
+++ b/include/libnftnl/desc.h
@@ -0,0 +1,57 @@
+#ifndef _LIBNFTNL_DESC_H_
+#define _LIBNFTNL_DESC_H_
+
+#include <stdio.h>
+#include <stdint.h>
+#include <stdbool.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* from include/expression.h in libnftables */
+enum nftnl_expr_desc_type {
+	NFTNL_EXPR_UNSPEC	= 0,
+	NFTNL_EXPR_PAYLOAD	= 7,
+	NFTNL_EXPR_EXTHDR,
+	NFTNL_EXPR_META,
+	NFTNL_EXPR_SOCKET,
+	NFTNL_EXPR_OSF,
+	NFTNL_EXPR_CT,
+	NFTNL_EXPR_RT		= 25,
+};
+
+#define NFTNL_DESC_EXPR_BASE		16
+
+enum nftnl_expr_desc_types {
+	NFTNL_DESC_EXPR_TYPE,
+	NFTNL_DESC_EXPR_BYTEORDER,
+	NFTNL_DESC_EXPR_LEN,
+	NFTNL_DESC_EXPR_DATA		= NFTNL_DESC_EXPR_BASE,
+	__NFTNL_DESC_EXPR_MAX
+};
+#define NFTNL_DESC_EXPR_MAX (__NFTNL_DESC_EXPR_MAX - 1)
+
+enum nftnl_expr_desc_payload_types {
+	NFTNL_DESC_PAYLOAD_DESC		= NFTNL_DESC_EXPR_BASE,
+	NFTNL_DESC_PAYLOAD_TYPE
+};
+
+struct nftnl_expr_desc;
+struct nftnl_udata_buf;
+struct nftnl_udata;
+
+struct nftnl_expr_desc *nftnl_expr_desc_alloc(void);
+void nftnl_expr_desc_free(struct nftnl_expr_desc *dexpr);
+int nftnl_expr_desc_set(struct nftnl_expr_desc *dexpr, uint8_t type,
+			const void *data, uint32_t data_len);
+int nftnl_expr_desc_build(struct nftnl_udata_buf *udbuf,
+			  const struct nftnl_expr_desc *dexpr);
+int nftnl_expr_desc_parse(const struct nftnl_udata *attr,
+			  struct nftnl_expr_desc *dexpr);
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _LIBNFTNL_DESC_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index c3b0ab974bd2..06e1567ffd13 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -7,6 +7,7 @@ libnftnl_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftnl.map	\
 
 libnftnl_la_SOURCES = utils.c		\
 		      batch.c		\
+		      desc.c		\
 		      flowtable.c	\
 		      common.c		\
 		      gen.c		\
diff --git a/src/desc.c b/src/desc.c
new file mode 100644
index 000000000000..d8566ba2ee38
--- /dev/null
+++ b/src/desc.c
@@ -0,0 +1,142 @@
+/*
+ * (C) 2022 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include "internal.h"
+
+#include <time.h>
+#include <endian.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <netinet/in.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libnftnl/udata.h>
+#include <libnftnl/desc.h>
+
+EXPORT_SYMBOL(nftnl_expr_desc_alloc);
+struct nftnl_expr_desc *nftnl_expr_desc_alloc(void)
+{
+	return calloc(1, sizeof(struct nftnl_expr_desc));
+}
+
+EXPORT_SYMBOL(nftnl_expr_desc_free);
+void nftnl_expr_desc_free(struct nftnl_expr_desc *dexpr)
+{
+	free(dexpr);
+}
+
+EXPORT_SYMBOL(nftnl_expr_desc_set);
+int nftnl_expr_desc_set(struct nftnl_expr_desc *dexpr, uint8_t type,
+			const void *data, uint32_t data_len)
+{
+	int err = 0;
+
+	switch (type) {
+	case NFTNL_DESC_EXPR_TYPE:
+		memcpy(&dexpr->etype, data, data_len);
+		dexpr->ops = nftnl_expr_ops_lookup_by_type(dexpr->etype);
+		break;
+	case NFTNL_DESC_EXPR_BYTEORDER:
+		memcpy(&dexpr->byteorder, data, data_len);
+		break;
+	case NFTNL_DESC_EXPR_LEN:
+		memcpy(&dexpr->len, data, data_len);
+		break;
+	case NFTNL_DESC_EXPR_DATA:
+		if (dexpr->ops && dexpr->ops->desc.set)
+			err = dexpr->ops->desc.set(dexpr, type, data, data_len);
+		break;
+	default:
+		err = -1;
+		break;
+	}
+
+	return err;
+}
+
+#define NFTNL_UDATA_EXPR_TYPE		0
+#define NFTNL_UDATA_EXPR_BYTEORDER	1
+#define NFTNL_UDATA_EXPR_LEN		2
+#define NFTNL_UDATA_EXPR_DATA		3
+#define NFTNL_UDATA_EXPR_MAX		4
+
+EXPORT_SYMBOL(nftnl_expr_desc_build);
+int nftnl_expr_desc_build(struct nftnl_udata_buf *udbuf,
+			  const struct nftnl_expr_desc *dexpr)
+{
+	struct nftnl_udata *nest;
+	int err = 0;
+
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXPR_TYPE, dexpr->etype);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXPR_BYTEORDER, dexpr->byteorder);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_EXPR_LEN, dexpr->len);
+	if (dexpr->ops && dexpr->ops->desc.build) {
+		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_EXPR_DATA);
+		err = dexpr->ops->desc.build(udbuf, dexpr);
+		nftnl_udata_nest_end(udbuf, nest);
+	}
+
+	return err;
+}
+
+static int nftnl_expr_desc_parse_nested(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_EXPR_TYPE:
+	case NFTNL_UDATA_EXPR_BYTEORDER:
+	case NFTNL_UDATA_EXPR_LEN:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	case NFTNL_UDATA_EXPR_DATA:
+		break;
+	default:
+	        return 0;
+	}
+
+	ud[type] = attr;
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_expr_desc_parse);
+int nftnl_expr_desc_parse(const struct nftnl_udata *attr,
+			  struct nftnl_expr_desc *dexpr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_EXPR_MAX + 1] = {};
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				nftnl_expr_desc_parse_nested, ud);
+	if (err < 0)
+		return -1;
+
+	err = 0;
+	if (ud[NFTNL_UDATA_EXPR_TYPE]) {
+		dexpr->etype = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXPR_TYPE]);
+		dexpr->ops = nftnl_expr_ops_lookup_by_type(dexpr->etype);
+	}
+	if (ud[NFTNL_UDATA_EXPR_BYTEORDER])
+		dexpr->byteorder = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXPR_BYTEORDER]);
+	if (ud[NFTNL_UDATA_EXPR_LEN])
+		dexpr->len = nftnl_udata_get_u32(ud[NFTNL_UDATA_EXPR_LEN]);
+	if (ud[NFTNL_UDATA_EXPR_DATA]) {
+		if (dexpr->ops && dexpr->ops->desc.parse)
+			err = dexpr->ops->desc.parse(ud[NFTNL_UDATA_EXPR_DATA], dexpr);
+	}
+
+	return err;
+}
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 82747ec8994f..afa0f2451155 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -23,6 +23,7 @@
 
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
+#include <libnftnl/udata.h>
 
 struct nftnl_expr_payload {
 	enum nft_registers	sreg;
@@ -251,8 +252,83 @@ nftnl_expr_payload_snprintf(char *buf, size_t len,
 				payload->offset, payload->dreg);
 }
 
+static int nftnl_expr_payload_desc_set(struct nftnl_expr_desc *dexpr,
+				       uint8_t type, const void *data,
+				       uint32_t data_len)
+{
+	switch (type) {
+	case NFTNL_DESC_PAYLOAD_DESC:
+		memcpy(&dexpr->payload.desc_id, data, sizeof(dexpr->payload.desc_id));
+		break;
+	case NFTNL_DESC_PAYLOAD_TYPE:
+		memcpy(&dexpr->payload.type, data, sizeof(dexpr->payload.type));
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+#define NFTNL_UDATA_PAYLOAD_DESC 0
+#define NFTNL_UDATA_PAYLOAD_TYPE 1
+#define NFTNL_UDATA_PAYLOAD_MAX 2
+
+static int nftnl_expr_payload_desc_build(struct nftnl_udata_buf *udbuf,
+					 const struct nftnl_expr_desc *dexpr)
+{
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_PAYLOAD_DESC,
+			    dexpr->payload.desc_id);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_PAYLOAD_TYPE,
+			    dexpr->payload.type);
+
+	return 0;
+}
+
+static int payload_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_PAYLOAD_DESC:
+	case NFTNL_UDATA_PAYLOAD_TYPE:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	default:
+		return 0;
+	}
+
+	ud[type] = attr;
+	return 0;
+}
+
+static int nftnl_expr_payload_desc_parse(const struct nftnl_udata *attr,
+					 struct nftnl_expr_desc *dexpr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_PAYLOAD_MAX + 1] = {};
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				payload_parse_udata, ud);
+	if (err < 0)
+		return -1;
+
+	if (!ud[NFTNL_UDATA_PAYLOAD_DESC] ||
+	    !ud[NFTNL_UDATA_PAYLOAD_TYPE])
+		return -1;
+
+	dexpr->payload.desc_id = nftnl_udata_get_u32(ud[NFTNL_UDATA_PAYLOAD_DESC]);
+	dexpr->payload.type = nftnl_udata_get_u32(ud[NFTNL_UDATA_PAYLOAD_TYPE]);
+
+	return 0;
+}
+
 struct expr_ops expr_ops_payload = {
 	.name		= "payload",
+	.type		= NFTNL_EXPR_PAYLOAD,
 	.alloc_len	= sizeof(struct nftnl_expr_payload),
 	.max_attr	= NFTA_PAYLOAD_MAX,
 	.set		= nftnl_expr_payload_set,
@@ -260,4 +336,9 @@ struct expr_ops expr_ops_payload = {
 	.parse		= nftnl_expr_payload_parse,
 	.build		= nftnl_expr_payload_build,
 	.snprintf	= nftnl_expr_payload_snprintf,
+	.desc		= {
+		.set	= nftnl_expr_payload_desc_set,
+		.build	= nftnl_expr_payload_desc_build,
+		.parse	= nftnl_expr_payload_desc_parse,
+	},
 };
diff --git a/src/expr_ops.c b/src/expr_ops.c
index 7248e4f98b0a..383414a42619 100644
--- a/src/expr_ops.c
+++ b/src/expr_ops.c
@@ -102,3 +102,16 @@ struct expr_ops *nftnl_expr_ops_lookup(const char *name)
 	}
 	return NULL;
 }
+
+struct expr_ops *nftnl_expr_ops_lookup_by_type(uint32_t type)
+{
+	int i = 0;
+
+	while (expr_ops[i] != NULL) {
+		if (expr_ops[i]->type == type)
+			return expr_ops[i];
+
+		i++;
+	}
+	return NULL;
+}
-- 
2.30.2

