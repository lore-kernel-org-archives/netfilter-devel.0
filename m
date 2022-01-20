Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571B8C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 00:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiATAEN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:04:13 -0500
Received: from mail.netfilter.org ([217.70.188.207]:37198 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiATAEL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 19:04:11 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6BF696006E;
        Thu, 20 Jan 2022 01:01:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH libnftnl 3/3] desc: add set description
Date:   Thu, 20 Jan 2022 01:04:02 +0100
Message-Id: <20220120000402.916332-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120000402.916332-1-pablo@netfilter.org>
References: <20220120000402.916332-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new object to describe a set. Add helpers to build and to parse
the userdata set description.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/desc.h           |  25 +++
 include/libnftnl/desc.h  |  31 ++++
 include/libnftnl/udata.h |  18 +-
 src/desc.c               | 360 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 427 insertions(+), 7 deletions(-)

diff --git a/include/desc.h b/include/desc.h
index 2f61a1e5963e..135f1a7b6317 100644
--- a/include/desc.h
+++ b/include/desc.h
@@ -1,6 +1,8 @@
 #ifndef _LIBNFTNL_DESC_INTERNAL_H_
 #define _LIBNFTNL_DESC_INTERNAL_H_
 
+#include <libnftnl/udata.h>
+
 struct nftnl_expr_desc {
 	uint32_t	etype;
 	uint32_t	byteorder;
@@ -22,4 +24,27 @@ struct nftnl_dtype_desc {
 	uint32_t	len;
 };
 
+#define NFTNL_SET_DESC_MAX        6
+
+struct nftnl_concat_desc {
+	union {
+		struct {
+			const struct nftnl_expr_desc	*expr[NFTNL_SET_DESC_MAX];
+			uint32_t			num_typeof;
+		};
+		struct {
+			const struct nftnl_dtype_desc	*dtype[NFTNL_SET_DESC_MAX];
+			uint32_t			num_type;
+		};
+	};
+};
+
+struct nftnl_set_desc {
+	enum nftnl_set_desc_type	type;
+	uint32_t			flags;
+	struct nftnl_concat_desc	key;
+	struct nftnl_concat_desc	data;
+	char				comment[NFTNL_UDATA_COMMENT_MAXLEN];
+};
+
 #endif
diff --git a/include/libnftnl/desc.h b/include/libnftnl/desc.h
index cb1cac91f934..aa14145d4b41 100644
--- a/include/libnftnl/desc.h
+++ b/include/libnftnl/desc.h
@@ -69,6 +69,37 @@ int nftnl_dtype_desc_build(struct nftnl_udata_buf *udbuf,
 int nftnl_dtype_desc_parse(const struct nftnl_udata *attr,
 			    struct nftnl_dtype_desc *dtype);
 
+enum nftnl_set_desc_type {
+	NFTNL_DESC_SET_UNSPEC	= 0,
+	NFTNL_DESC_SET_DATATYPE,
+	NFTNL_DESC_SET_TYPEOF,
+};
+
+enum nftnl_set_desc_types {
+	NFTNL_DESC_SET_TYPE,
+	NFTNL_DESC_SET_KEY,
+	NFTNL_DESC_SET_DATA,
+	NFTNL_DESC_SET_FLAGS,
+	NFTNL_DESC_SET_COMMENT,
+	__NFTNL_DESC_SET_MAX
+};
+#define NFTNL_DESC_SET_MAX (__NFTNL_DESC_SET_MAX - 1)
+
+struct nftnl_set_desc;
+
+struct nftnl_set_desc *nftnl_set_desc_alloc(void);
+void nftnl_set_desc_free(struct nftnl_set_desc *dset);
+int nftnl_set_desc_set(struct nftnl_set_desc *dset, enum nftnl_set_desc_types type,
+		       const void *data, uint32_t data_len);
+int nftnl_set_desc_add_expr(struct nftnl_set_desc *su, enum nftnl_set_desc_types type,
+			    const struct nftnl_expr_desc *dexpr);
+int nftnl_set_desc_add_datatype(struct nftnl_set_desc *dset, enum nftnl_set_desc_types type,
+				const struct nftnl_dtype_desc *dtype);
+int nftnl_set_desc_build_udata(struct nftnl_udata_buf *udbuf,
+			       const struct nftnl_set_desc *dset);
+int nftnl_set_desc_parse_udata(const char *udata, uint32_t len,
+			       struct nftnl_set_desc *dset);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index dbf3a60ff06e..3349ae7bf7b1 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -37,14 +37,18 @@ enum nftnl_udata_obj_types {
 #define NFTNL_UDATA_COMMENT_MAXLEN	128
 
 enum nftnl_udata_set_types {
-	NFTNL_UDATA_SET_KEYBYTEORDER,
-	NFTNL_UDATA_SET_DATABYTEORDER,
-	NFTNL_UDATA_SET_MERGE_ELEMENTS,
-	NFTNL_UDATA_SET_KEY_TYPEOF,
-	NFTNL_UDATA_SET_DATA_TYPEOF,
-	NFTNL_UDATA_SET_EXPR,
-	NFTNL_UDATA_SET_DATA_INTERVAL,
+	NFTNL_UDATA_SET_KEYBYTEORDER,	/* not used in newer versions */
+	NFTNL_UDATA_SET_DATABYTEORDER,	/* not used in newer versions */
+	NFTNL_UDATA_SET_MERGE_ELEMENTS,	/* not used in newer versions */
+	NFTNL_UDATA_SET_KEY_TYPEOF,	/* not used in newer versions */
+	NFTNL_UDATA_SET_DATA_TYPEOF,	/* not used in newer versions */
+	NFTNL_UDATA_SET_EXPR,		/* not used in newer versions */
+	NFTNL_UDATA_SET_DATA_INTERVAL,	/* not used in newer versions */
 	NFTNL_UDATA_SET_COMMENT,
+	NFTNL_UDATA_SET_TYPE,
+	NFTNL_UDATA_SET_KEY,
+	NFTNL_UDATA_SET_DATA,
+	NFTNL_UDATA_SET_FLAGS,
 	__NFTNL_UDATA_SET_MAX
 };
 #define NFTNL_UDATA_SET_MAX (__NFTNL_UDATA_SET_MAX - 1)
diff --git a/src/desc.c b/src/desc.c
index f73e74c2c7d3..c8b3195db850 100644
--- a/src/desc.c
+++ b/src/desc.c
@@ -236,3 +236,363 @@ int nftnl_dtype_desc_parse(const struct nftnl_udata *attr,
 
 	return err;
 }
+
+EXPORT_SYMBOL(nftnl_set_desc_alloc);
+struct nftnl_set_desc *nftnl_set_desc_alloc(void)
+{
+	return calloc(1, sizeof(struct nftnl_set_desc));
+}
+
+EXPORT_SYMBOL(nftnl_set_desc_free);
+void nftnl_set_desc_free(struct nftnl_set_desc *dset)
+{
+	uint32_t i;
+
+	if (dset->type == NFTNL_DESC_SET_TYPEOF) {
+		for (i = 0; i < dset->key.num_typeof; i++)
+			free((void *)dset->key.expr[i]);
+		for (i = 0; i < dset->data.num_typeof; i++)
+			free((void *)dset->data.expr[i]);
+	}
+
+	free(dset);
+}
+
+EXPORT_SYMBOL(nftnl_set_desc_set);
+int nftnl_set_desc_set(struct nftnl_set_desc *dset, enum nftnl_set_desc_types type,
+		       const void *data, uint32_t data_len)
+{
+	switch (type) {
+	case NFTNL_DESC_SET_TYPE:
+		memcpy(&dset->type, data, data_len);
+		break;
+	case NFTNL_DESC_SET_KEY:
+	case NFTNL_DESC_SET_DATA:
+		/* use nftnl_set_desc_add_expr() */
+		return -1;
+	case NFTNL_DESC_SET_FLAGS:
+		memcpy(&dset->flags, data, data_len);
+		break;
+	case NFTNL_DESC_SET_COMMENT:
+		memcpy(dset->comment, data, data_len);
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_set_desc_add_expr);
+int nftnl_set_desc_add_expr(struct nftnl_set_desc *dset, uint32_t type,
+			    const struct nftnl_expr_desc *dexpr)
+{
+	switch (type) {
+	case NFTNL_DESC_SET_KEY:
+		if (dset->key.num_typeof >= NFTNL_DESC_SET_MAX)
+			return -1;
+
+		dset->key.expr[dset->key.num_typeof++] = dexpr;
+		break;
+	case NFTNL_DESC_SET_DATA:
+		if (dset->key.num_type >= NFTNL_DESC_SET_MAX)
+			return -1;
+
+		dset->data.expr[dset->key.num_typeof++] = dexpr;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_set_desc_add_datatype);
+int nftnl_set_desc_add_datatype(struct nftnl_set_desc *dset, uint32_t type,
+				 const struct nftnl_dtype_desc *dtype)
+{
+	switch (type) {
+	case NFTNL_DESC_SET_KEY:
+		if (dset->data.num_typeof >= NFTNL_DESC_SET_MAX)
+			return -1;
+
+		dset->key.dtype[dset->data.num_typeof++] = dtype;
+		break;
+	case NFTNL_DESC_SET_DATA:
+		if (dset->data.num_type >= NFTNL_DESC_SET_MAX)
+			return -1;
+
+		dset->data.dtype[dset->data.num_type++] = dtype;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __nftnl_udata_set_dtype_build(struct nftnl_udata_buf *udbuf,
+					 const struct nftnl_dtype_desc *dtype,
+					 uint8_t attr_type)
+{
+	struct nftnl_udata *nest;
+	int err;
+
+	nest = nftnl_udata_nest_start(udbuf, attr_type);
+	err = nftnl_dtype_desc_build(udbuf, dtype);
+	nftnl_udata_nest_end(udbuf, nest);
+
+	return err;
+}
+
+static int nftnl_set_desc_build_dtype(struct nftnl_udata_buf *udbuf,
+				      const struct nftnl_set_desc *dset)
+{
+	struct nftnl_udata *nest;
+	int i, err;
+
+	switch (dset->type) {
+	case NFTNL_DESC_SET_TYPEOF:
+		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY);
+		for (i = 0; i < dset->key.num_type; i++) {
+			err = __nftnl_udata_set_dtype_build(udbuf, dset->key.dtype[i], i);
+			if (err < 0)
+				return err;
+		}
+		nftnl_udata_nest_end(udbuf, nest);
+		break;
+	case NFTNL_DESC_SET_DATATYPE:
+		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_DATA);
+		for (i = 0; i < dset->data.num_type; i++) {
+			err = __nftnl_udata_set_dtype_build(udbuf, dset->data.dtype[i], i);
+			if (err < 0)
+				return err;
+		}
+		nftnl_udata_nest_end(udbuf, nest);
+		break;
+	case NFTNL_DESC_SET_UNSPEC:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __nftnl_set_desc_build_typeof(struct nftnl_udata_buf *udbuf,
+					 const struct nftnl_expr_desc *dexpr,
+					 uint8_t attr_type)
+{
+	struct nftnl_udata *nest;
+	int err;
+
+	nest = nftnl_udata_nest_start(udbuf, attr_type);
+	err = nftnl_expr_desc_build(udbuf, dexpr);
+	nftnl_udata_nest_end(udbuf, nest);
+
+	return err;
+}
+
+static int nftnl_set_desc_build_typeof(struct nftnl_udata_buf *udbuf,
+				       const struct nftnl_set_desc *dset)
+{
+	struct nftnl_udata *nest;
+	int i;
+
+	switch (dset->type) {
+	case NFTNL_DESC_SET_TYPEOF:
+		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_KEY_TYPEOF);
+		for (i = 0; i < dset->key.num_typeof; i++)
+			__nftnl_set_desc_build_typeof(udbuf, dset->key.expr[i], i);
+
+		nftnl_udata_nest_end(udbuf, nest);
+		break;
+	case NFTNL_DESC_SET_DATATYPE:
+		nest = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_DATA_TYPEOF);
+		for (i = 0; i < dset->key.num_typeof; i++)
+			__nftnl_set_desc_build_typeof(udbuf, dset->data.expr[i], i);
+
+		nftnl_udata_nest_end(udbuf, nest);
+		break;
+	case NFTNL_DESC_SET_UNSPEC:
+		return -1;
+	}
+
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_set_desc_build_udata);
+int nftnl_set_desc_build_udata(struct nftnl_udata_buf *udbuf,
+			       const struct nftnl_set_desc *dset)
+{
+	if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_FLAGS, dset->flags))
+		return -1;
+
+	switch (dset->type) {
+	case NFTNL_DESC_SET_DATATYPE:
+		return nftnl_set_desc_build_dtype(udbuf, dset);
+	case NFTNL_DESC_SET_TYPEOF:
+		return nftnl_set_desc_build_typeof(udbuf, dset);
+	case NFTNL_DESC_SET_UNSPEC:
+		return -1;
+	}
+
+	if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_SET_COMMENT, dset->comment))
+		return -1;
+
+	return -1;
+}
+
+static int parse_concat(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+
+	if (type >= 10)
+		return -1;
+
+	ud[type] = attr;
+
+	return 0;
+}
+
+static int nftnl_set_desc_parse_datatype(const struct nftnl_udata *attr,
+					 struct nftnl_concat_desc *concat)
+{
+	const struct nftnl_udata *ud[NFTNL_DESC_SET_MAX + 1];
+	struct nftnl_dtype_desc *dtype;
+	int err, i;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				parse_concat, ud);
+	if (err < 0)
+		return -1;
+
+	for (i = 0; i < array_size(ud); i++) {
+		if (!ud[i])
+			break;
+
+		dtype = nftnl_dtype_desc_alloc();
+		err = nftnl_dtype_desc_parse(ud[i], dtype);
+		if (err < 0) {
+			nftnl_dtype_desc_free(dtype);
+			break;
+		}
+		concat->dtype[concat->num_type++] = dtype;
+	}
+
+	return err;
+}
+
+static int nftnl_set_desc_parse_typeof(const struct nftnl_udata *attr,
+				       struct nftnl_concat_desc *concat)
+{
+	const struct nftnl_udata *ud[NFTNL_DESC_SET_MAX + 1];
+	struct nftnl_expr_desc *dexpr;
+	int err, i;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				parse_concat, ud);
+	if (err < 0)
+		return -1;
+
+	for (i = 0; i < array_size(ud); i++) {
+		if (!ud[i])
+			break;
+
+		dexpr = nftnl_expr_desc_alloc();
+		err = nftnl_expr_desc_parse(ud[i], dexpr);
+		if (err < 0) {
+			nftnl_expr_desc_free(dexpr);
+			break;
+		}
+		concat->expr[concat->num_typeof++] = dexpr;
+	}
+
+	return err;
+}
+
+static int nftnl_set_desc_parse_concat(const struct nftnl_udata *attr,
+				       struct nftnl_concat_desc *concat,
+				       enum nftnl_set_desc_type type)
+{
+	int err;
+
+	switch (type) {
+	case NFTNL_DESC_SET_DATATYPE:
+		err = nftnl_set_desc_parse_datatype(attr, concat);
+		break;
+	case NFTNL_DESC_SET_TYPEOF:
+		err = nftnl_set_desc_parse_typeof(attr, concat);
+		break;
+	default:
+		err = -1;
+		break;
+	}
+
+	return err;
+}
+
+static int parse_set_desc(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_SET_TYPE:
+	case NFTNL_UDATA_SET_FLAGS:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	case NFTNL_UDATA_SET_KEY:
+	case NFTNL_UDATA_SET_DATA:
+	case NFTNL_UDATA_SET_COMMENT:
+		break;
+	default:
+		return 0;
+	}
+
+	ud[type] = attr;
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_set_desc_parse_udata);
+int nftnl_set_desc_parse_udata(const char *udata, uint32_t len,
+			       struct nftnl_set_desc *dset)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_SET_MAX + 1];
+	int err;
+
+	err = nftnl_udata_parse(udata, len, parse_set_desc, ud);
+	if (err < 0)
+		return -1;
+
+	if (ud[NFTNL_UDATA_SET_TYPE])
+		dset->type = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_TYPE]);
+
+	if (ud[NFTNL_UDATA_SET_KEY]) {
+		err = nftnl_set_desc_parse_concat(ud[NFTNL_UDATA_SET_KEY],
+						  &dset->key, dset->type);
+		if (err < 0)
+			return err;
+	}
+
+	if (ud[NFTNL_UDATA_SET_DATA]) {
+		err = nftnl_set_desc_parse_concat(ud[NFTNL_UDATA_SET_DATA],
+						  &dset->data, dset->type);
+		if (err < 0)
+			return err;
+	}
+
+	if (ud[NFTNL_UDATA_SET_FLAGS]) {
+		dset->flags = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_FLAGS]);
+		if (err < 0)
+			return err;
+	}
+
+	if (ud[NFTNL_UDATA_SET_COMMENT]) {
+		memcpy(dset->comment, nftnl_udata_get(ud[NFTNL_UDATA_SET_COMMENT]),
+		       nftnl_udata_len(ud[NFTNL_UDATA_SET_COMMENT]));
+	}
+
+	return err;
+}
-- 
2.30.2

