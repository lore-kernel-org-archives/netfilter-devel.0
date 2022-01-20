Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF43C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 00:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240240AbiATAEL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:04:11 -0500
Received: from mail.netfilter.org ([217.70.188.207]:37194 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiATAEK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 19:04:10 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F1C5860027;
        Thu, 20 Jan 2022 01:01:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH libnftnl 2/3] desc: add datatype description
Date:   Thu, 20 Jan 2022 01:04:01 +0100
Message-Id: <20220120000402.916332-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120000402.916332-1-pablo@netfilter.org>
References: <20220120000402.916332-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new object to describe a datatype. This allows to describe the
set key when type is used to define the set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/desc.h          |  6 +++
 include/libnftnl/desc.h | 19 ++++++++
 src/desc.c              | 96 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+)

diff --git a/include/desc.h b/include/desc.h
index d78af3528118..2f61a1e5963e 100644
--- a/include/desc.h
+++ b/include/desc.h
@@ -16,4 +16,10 @@ struct nftnl_expr_desc {
 	};
 };
 
+struct nftnl_dtype_desc {
+	uint32_t	dtype;
+	uint32_t	byteorder;
+	uint32_t	len;
+};
+
 #endif
diff --git a/include/libnftnl/desc.h b/include/libnftnl/desc.h
index 1202eb9ddf79..cb1cac91f934 100644
--- a/include/libnftnl/desc.h
+++ b/include/libnftnl/desc.h
@@ -50,6 +50,25 @@ int nftnl_expr_desc_build(struct nftnl_udata_buf *udbuf,
 int nftnl_expr_desc_parse(const struct nftnl_udata *attr,
 			  struct nftnl_expr_desc *dexpr);
 
+enum nftnl_dtype_desc_types {
+	NFTNL_DESC_DTYPE_TYPE,
+	NFTNL_DESC_DTYPE_BYTEORDER,
+	NFTNL_DESC_DTYPE_LEN,
+	__NFTNL_DESC_DTYPE_MAX
+};
+#define NFTNL_DESC_DTYPE_MAX (__NFTNL_DESC_DTYPE_MAX - 1)
+
+struct nftnl_dtype_desc;
+
+struct nftnl_dtype_desc *nftnl_dtype_desc_alloc(void);
+void nftnl_dtype_desc_free(struct nftnl_dtype_desc *dtype);
+int nftnl_dtype_desc_set(struct nftnl_dtype_desc *dtype, uint8_t type,
+			 const void *data, uint32_t data_len);
+int nftnl_dtype_desc_build(struct nftnl_udata_buf *udbuf,
+			   const struct nftnl_dtype_desc *dtype);
+int nftnl_dtype_desc_parse(const struct nftnl_udata *attr,
+			    struct nftnl_dtype_desc *dtype);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/desc.c b/src/desc.c
index d8566ba2ee38..f73e74c2c7d3 100644
--- a/src/desc.c
+++ b/src/desc.c
@@ -140,3 +140,99 @@ int nftnl_expr_desc_parse(const struct nftnl_udata *attr,
 
 	return err;
 }
+
+EXPORT_SYMBOL(nftnl_dtype_desc_alloc);
+struct nftnl_dtype_desc *nftnl_dtype_desc_alloc(void)
+{
+	return calloc(1, sizeof(struct nftnl_dtype_desc));
+}
+
+EXPORT_SYMBOL(nftnl_dtype_desc_free);
+void nftnl_dtype_desc_free(struct nftnl_dtype_desc *dtype)
+{
+	free(dtype);
+}
+
+EXPORT_SYMBOL(nftnl_dtype_desc_set);
+int nftnl_dtype_desc_set(struct nftnl_dtype_desc *dtype, uint8_t type,
+			 const void *data, uint32_t data_len)
+{
+	int err = 0;
+
+	switch (type) {
+	case NFTNL_DESC_DTYPE_TYPE:
+		memcpy(&dtype->dtype, data, data_len);
+		break;
+	case NFTNL_DESC_DTYPE_BYTEORDER:
+		memcpy(&dtype->byteorder, data, data_len);
+		break;
+	case NFTNL_DESC_DTYPE_LEN:
+		memcpy(&dtype->len, data, data_len);
+		break;
+	default:
+		err = -1;
+		break;
+	}
+
+	return err;
+}
+
+#define NFTNL_UDATA_DTYPE_TYPE		0
+#define NFTNL_UDATA_DTYPE_BYTEORDER	1
+#define NFTNL_UDATA_DTYPE_LEN		2
+#define NFTNL_UDATA_DTYPE_MAX		3
+
+EXPORT_SYMBOL(nftnl_dtype_desc_build);
+int nftnl_dtype_desc_build(struct nftnl_udata_buf *udbuf,
+			   const struct nftnl_dtype_desc *dtype)
+{
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_DTYPE_TYPE, dtype->dtype);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_DTYPE_BYTEORDER, dtype->byteorder);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_DTYPE_LEN, dtype->len);
+
+	return 0;
+}
+
+static int nftnl_dtype_desc_parse_nested(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_DTYPE_TYPE:
+	case NFTNL_UDATA_DTYPE_BYTEORDER:
+	case NFTNL_UDATA_DTYPE_LEN:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	default:
+	        return 0;
+	}
+
+	ud[type] = attr;
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_dtype_desc_parse);
+int nftnl_dtype_desc_parse(const struct nftnl_udata *attr,
+			   struct nftnl_dtype_desc *dtype)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_DTYPE_MAX + 1] = {};
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				nftnl_dtype_desc_parse_nested, ud);
+	if (err < 0)
+		return -1;
+
+	err = 0;
+	if (ud[NFTNL_UDATA_DTYPE_TYPE])
+		dtype->dtype = nftnl_udata_get_u32(ud[NFTNL_UDATA_DTYPE_TYPE]);
+	if (ud[NFTNL_UDATA_DTYPE_BYTEORDER])
+		dtype->byteorder = nftnl_udata_get_u32(ud[NFTNL_UDATA_DTYPE_BYTEORDER]);
+	if (ud[NFTNL_UDATA_DTYPE_LEN])
+		dtype->len = nftnl_udata_get_u32(ud[NFTNL_UDATA_DTYPE_LEN]);
+
+	return err;
+}
-- 
2.30.2

