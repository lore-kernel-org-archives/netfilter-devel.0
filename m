From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 2/7] src: ct helper support
Date: Mon, 27 Feb 2017 16:02:50 +0100
Message-ID: <20170227150255.12624-3-fw@strlen.de>
References: <20170227150255.12624-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55744 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751748AbdB0PCo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 10:02:44 -0500
In-Reply-To: <20170227150255.12624-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

add support for ct helper objects, these are used to assign helpers to
connections, similar to iptables -j CT --set-helper target.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnftnl/object.h           |   6 ++
 include/linux/netfilter/nf_tables.h |  12 ++-
 include/obj.h                       |   6 ++
 src/Makefile.am                     |   1 +
 src/obj/ct_helper.c                 | 210 ++++++++++++++++++++++++++++++++++++
 src/object.c                        |   3 +-
 6 files changed, 236 insertions(+), 2 deletions(-)
 create mode 100644 src/obj/ct_helper.c

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index ca3abeae66cc..ccd9d19b9364 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -34,6 +34,12 @@ enum {
 	NFTNL_OBJ_QUOTA_FLAGS,
 };
 
+enum {
+	NFTNL_OBJ_CT_HELPER_NAME = NFTNL_OBJ_BASE,
+	NFTNL_OBJ_CT_HELPER_L3PROTO,
+	NFTNL_OBJ_CT_HELPER_L4PROTO,
+};
+
 struct nftnl_obj;
 
 struct nftnl_obj *nftnl_obj_alloc(void);
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 05215d30fe5c..121e79cacc49 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1246,10 +1246,20 @@ enum nft_fib_flags {
 	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
 };
 
+enum nft_ct_helper_attributes {
+	NFTA_CT_HELPER_UNSPEC,
+	NFTA_CT_HELPER_NAME,
+	NFTA_CT_HELPER_L3PROTO,
+	NFTA_CT_HELPER_L4PROTO,
+	__NFTA_CT_HELPER_MAX,
+};
+#define NFTA_CT_HELPER_MAX	(__NFTA_CT_HELPER_MAX - 1)
+
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
-#define __NFT_OBJECT_MAX	3
+#define NFT_OBJECT_CT_HELPER	3
+#define __NFT_OBJECT_MAX	4
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/include/obj.h b/include/obj.h
index edbf023f5cdd..d90919f2d86b 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -30,6 +30,11 @@ struct nftnl_obj {
 			uint64_t	consumed;
 			uint32_t        flags;
 		} quota;
+		struct nftnl_obj_ct_helper {
+			uint16_t	l3proto;
+			uint8_t		l4proto;
+			char		name[16];
+		} ct_helper;
 	} data;
 };
 
@@ -49,6 +54,7 @@ struct obj_ops {
 
 extern struct obj_ops obj_ops_counter;
 extern struct obj_ops obj_ops_quota;
+extern struct obj_ops obj_ops_ct_helper;
 
 #define nftnl_obj_data(obj) (void *)&obj->data
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 485a8c4acbef..77b67b267672 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -53,5 +53,6 @@ libnftnl_la_SOURCES = utils.c		\
 		      expr/redir.c	\
 		      expr/hash.c	\
 		      obj/counter.c	\
+		      obj/ct_helper.c	\
 		      obj/quota.c	\
 		      libnftnl.map
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
new file mode 100644
index 000000000000..d6d3111ecce8
--- /dev/null
+++ b/src/obj/ct_helper.c
@@ -0,0 +1,210 @@
+/*
+ * (C) 2017 Red Hat GmbH
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
+#include <arpa/inet.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include "internal.h"
+#include <libmnl/libmnl.h>
+#include <libnftnl/object.h>
+
+#include "obj.h"
+
+static int nftnl_obj_ct_helper_set(struct nftnl_obj *e, uint16_t type,
+				   const void *data, uint32_t data_len)
+{
+	struct nftnl_obj_ct_helper *helper = nftnl_obj_data(e);
+
+	switch (type) {
+	case NFTNL_OBJ_CT_HELPER_NAME:
+		snprintf(helper->name, sizeof(helper->name), "%s", (const char *)data);
+		break;
+	case NFTNL_OBJ_CT_HELPER_L3PROTO:
+		helper->l3proto = *((uint16_t *)data);
+		break;
+	case NFTNL_OBJ_CT_HELPER_L4PROTO:
+		helper->l4proto = *((uint8_t *)data);
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static const void *nftnl_obj_ct_helper_get(const struct nftnl_obj *e,
+					   uint16_t type, uint32_t *data_len)
+{
+	struct nftnl_obj_ct_helper *helper = nftnl_obj_data(e);
+
+	switch (type) {
+	case NFTNL_OBJ_CT_HELPER_NAME:
+		*data_len = strlen(helper->name);
+		return helper->name;
+	case NFTNL_OBJ_CT_HELPER_L3PROTO:
+		*data_len = sizeof(helper->l3proto);
+		return &helper->l3proto;
+	case NFTNL_OBJ_CT_HELPER_L4PROTO:
+		*data_len = sizeof(helper->l4proto);
+		return &helper->l4proto;
+	}
+	return NULL;
+}
+
+static int nftnl_obj_ct_helper_cb(const struct nlattr *attr, void *data)
+{
+	const struct nftnl_obj_ct_helper *helper = NULL;
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	if (mnl_attr_type_valid(attr, NFTA_CT_HELPER_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_CT_HELPER_NAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			abi_breakage();
+		if (mnl_attr_get_payload_len(attr) >= sizeof(helper->name))
+			abi_breakage();
+		break;
+	case NFTA_CT_HELPER_L3PROTO:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			abi_breakage();
+		break;
+	case NFTA_CT_HELPER_L4PROTO:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void
+nftnl_obj_ct_helper_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
+{
+	struct nftnl_obj_ct_helper *helper = nftnl_obj_data(e);
+
+	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_NAME))
+		mnl_attr_put_str(nlh, NFTA_CT_HELPER_NAME, helper->name);
+	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_L3PROTO))
+		mnl_attr_put_u16(nlh, NFTA_CT_HELPER_L3PROTO, htons(helper->l3proto));
+	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_L4PROTO))
+		mnl_attr_put_u8(nlh, NFTA_CT_HELPER_L4PROTO, helper->l4proto);
+}
+
+static int
+nftnl_obj_ct_helper_parse(struct nftnl_obj *e, struct nlattr *attr)
+{
+	struct nftnl_obj_ct_helper *helper = nftnl_obj_data(e);
+	struct nlattr *tb[NFTA_CT_HELPER_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nftnl_obj_ct_helper_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_CT_HELPER_NAME]) {
+		snprintf(helper->name, sizeof(helper->name), "%s",
+			 mnl_attr_get_str(tb[NFTA_CT_HELPER_NAME]));
+		e->flags |= (1 << NFTNL_OBJ_CT_HELPER_NAME);
+	}
+	if (tb[NFTA_CT_HELPER_L3PROTO]) {
+		helper->l3proto = ntohs(mnl_attr_get_u16(tb[NFTA_CT_HELPER_L3PROTO]));
+		e->flags |= (1 << NFTNL_OBJ_CT_HELPER_L3PROTO);
+	}
+	if (tb[NFTA_CT_HELPER_L4PROTO]) {
+		helper->l4proto = mnl_attr_get_u8(tb[NFTA_CT_HELPER_L4PROTO]);
+		e->flags |= (1 << NFTNL_OBJ_CT_HELPER_L4PROTO);
+	}
+
+	return 0;
+}
+
+static int
+nftnl_obj_quota_json_parse(struct nftnl_obj *e, json_t *root,
+				 struct nftnl_parse_err *err)
+{
+#ifdef JSON_PARSING
+	uint64_t bytes;
+	uint32_t flags;
+
+	if (nftnl_jansson_parse_val(root, "bytes", NFTNL_TYPE_U64, &bytes,
+				  err) == 0)
+		nftnl_obj_set_u64(e, NFTNL_OBJ_QUOTA_BYTES, bytes);
+	if (nftnl_jansson_parse_val(root, "consumed", NFTNL_TYPE_U64, &bytes,
+				    err) == 0)
+		nftnl_obj_set_u64(e, NFTNL_OBJ_QUOTA_CONSUMED, bytes);
+	if (nftnl_jansson_parse_val(root, "flags", NFTNL_TYPE_U32, &flags,
+				  err) == 0)
+		nftnl_obj_set_u32(e, NFTNL_OBJ_QUOTA_FLAGS, flags);
+
+	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nftnl_obj_ct_helper_export(char *buf, size_t size,
+				   const struct nftnl_obj *e, int type)
+{
+	struct nftnl_obj_ct_helper *helper = nftnl_obj_data(e);
+	NFTNL_BUF_INIT(b, buf, size);
+
+	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_NAME))
+		nftnl_buf_str(&b, type, helper->name, NAME);
+	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_L3PROTO))
+		nftnl_buf_u32(&b, type, helper->l3proto, FAMILY);
+	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_L4PROTO))
+		nftnl_buf_u32(&b, type, helper->l4proto, "service");
+
+	return nftnl_buf_done(&b);
+}
+
+static int nftnl_obj_ct_helper_snprintf_default(char *buf, size_t len,
+					       const struct nftnl_obj *e)
+{
+	struct nftnl_obj_ct_helper *helper = nftnl_obj_data(e);
+
+	return snprintf(buf, len, "name %s family %d protocol %d ",
+			helper->name, helper->l3proto, helper->l4proto);
+}
+
+static int nftnl_obj_ct_helper_snprintf(char *buf, size_t len, uint32_t type,
+				       uint32_t flags,
+				       const struct nftnl_obj *e)
+{
+	switch (type) {
+	case NFTNL_OUTPUT_DEFAULT:
+		return nftnl_obj_ct_helper_snprintf_default(buf, len, e);
+	case NFTNL_OUTPUT_JSON:
+		return nftnl_obj_ct_helper_export(buf, len, e, type);
+	default:
+		break;
+	}
+	return -1;
+}
+
+struct obj_ops obj_ops_ct_helper = {
+	.name		= "ct_helper",
+	.type		= NFT_OBJECT_CT_HELPER,
+	.alloc_len	= sizeof(struct nftnl_obj_ct_helper),
+	.max_attr	= NFTA_CT_HELPER_MAX,
+	.set		= nftnl_obj_ct_helper_set,
+	.get		= nftnl_obj_ct_helper_get,
+	.parse		= nftnl_obj_ct_helper_parse,
+	.build		= nftnl_obj_ct_helper_build,
+	.snprintf	= nftnl_obj_ct_helper_snprintf,
+	.json_parse	= nftnl_obj_quota_json_parse,
+};
diff --git a/src/object.c b/src/object.c
index e635f6a8ff0e..e1a5ac4757b6 100644
--- a/src/object.c
+++ b/src/object.c
@@ -28,11 +28,12 @@
 static struct obj_ops *obj_ops[] = {
 	[NFT_OBJECT_COUNTER]	= &obj_ops_counter,
 	[NFT_OBJECT_QUOTA]	= &obj_ops_quota,
+	[NFT_OBJECT_CT_HELPER]	= &obj_ops_ct_helper,
 };
 
 static struct obj_ops *nftnl_obj_ops_lookup(uint32_t type)
 {
-	if (type > NFT_OBJECT_QUOTA)
+	if (type > NFT_OBJECT_CT_HELPER)
 		return NULL;
 
 	return obj_ops[type];
-- 
2.10.2

