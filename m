From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] src: parse new handle attribute for tables
Date: Tue, 30 Jan 2018 02:41:02 +0530
Message-ID: <20180129211102.12335-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45064 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbeA2VLY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jan 2018 16:11:24 -0500
Received: by mail-pg0-f67.google.com with SMTP id m136so5433817pga.12
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2018 13:11:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds code to parse new handle attribute for tables.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:
 - Remove code for tracing table handle.

 include/libnftnl/table.h            |  3 +++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/libnftnl.map                    |  2 ++
 src/table.c                         | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 2e76c45..44017c6 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -22,6 +22,7 @@ enum nftnl_table_attr {
 	NFTNL_TABLE_FAMILY,
 	NFTNL_TABLE_FLAGS,
 	NFTNL_TABLE_USE,
+	NFTNL_TABLE_HANDLE,
 	__NFTNL_TABLE_MAX
 };
 #define NFTNL_TABLE_MAX (__NFTNL_TABLE_MAX - 1)
@@ -37,9 +38,11 @@ const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 
 void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t data);
 void nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_t data);
+void nftnl_table_set_u64(struct nftnl_table *t, uint16_t attr, uint64_t data);
 int nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const char *str);
 uint8_t nftnl_table_get_u8(const struct nftnl_table *t, uint16_t attr);
 uint32_t nftnl_table_get_u32(const struct nftnl_table *t, uint16_t attr);
+uint64_t nftnl_table_get_u64(const struct nftnl_table *t, uint16_t attr);
 const char *nftnl_table_get_str(const struct nftnl_table *t, uint16_t attr);
 
 struct nlmsghdr;
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 874fa3f..b057d67 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -160,12 +160,14 @@ enum nft_table_flags {
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
+ * @NFTA_TABLE_HANDLE: numeric handle of the table (NLA_U64)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
 	NFTA_TABLE_FLAGS,
 	NFTA_TABLE_USE,
+	NFTA_TABLE_HANDLE,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/src/libnftnl.map b/src/libnftnl.map
index d59e802..e641824 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -8,9 +8,11 @@ global:
   nftnl_table_get;
   nftnl_table_set_u8;
   nftnl_table_set_u32;
+  nftnl_table_set_u64;
   nftnl_table_set_str;
   nftnl_table_get_u8;
   nftnl_table_get_u32;
+  nftnl_table_get_u64;
   nftnl_table_get_str;
   nftnl_table_parse;
   nftnl_table_parse_file;
diff --git a/src/table.c b/src/table.c
index cf61dda..5196db0 100644
--- a/src/table.c
+++ b/src/table.c
@@ -34,6 +34,7 @@ struct nftnl_table {
 	uint32_t	table_flags;
 	uint32_t	use;
 	uint32_t	flags;
+	uint64_t	handle;
 };
 
 struct nftnl_table *nftnl_table_alloc(void)
@@ -67,6 +68,7 @@ void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 		xfree(t->name);
 		break;
 	case NFTNL_TABLE_FLAGS:
+	case NFTNL_TABLE_HANDLE:
 	case NFTNL_TABLE_FAMILY:
 		break;
 	case NFTNL_TABLE_USE:
@@ -79,6 +81,7 @@ EXPORT_SYMBOL(nftnl_table_unset);
 static uint32_t nftnl_table_validate[NFTNL_TABLE_MAX + 1] = {
 	[NFTNL_TABLE_FLAGS]	= sizeof(uint32_t),
 	[NFTNL_TABLE_FAMILY]	= sizeof(uint32_t),
+	[NFTNL_TABLE_HANDLE] = sizeof(uint64_t),
 };
 
 int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
@@ -96,6 +99,9 @@ int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 		if (!t->name)
 			return -1;
 		break;
+	case NFTNL_TABLE_HANDLE:
+		t->handle = *((uint64_t *)data);
+		break;
 	case NFTNL_TABLE_FLAGS:
 		t->table_flags = *((uint32_t *)data);
 		break;
@@ -123,6 +129,12 @@ void nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_t val)
 }
 EXPORT_SYMBOL(nftnl_table_set_u32);
 
+void nftnl_table_set_u64(struct nftnl_table *t, uint16_t attr, uint64_t val)
+{
+	nftnl_table_set_data(t, attr, &val, sizeof(uint64_t));
+}
+EXPORT_SYMBOL(nftnl_table_set_u64);
+
 void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t val)
 {
 	nftnl_table_set_data(t, attr, &val, sizeof(uint8_t));
@@ -145,6 +157,9 @@ const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 	case NFTNL_TABLE_NAME:
 		*data_len = strlen(t->name) + 1;
 		return t->name;
+	case NFTNL_TABLE_HANDLE:
+		*data_len = sizeof(uint64_t);
+		return &t->handle;
 	case NFTNL_TABLE_FLAGS:
 		*data_len = sizeof(uint32_t);
 		return &t->table_flags;
@@ -173,6 +188,13 @@ uint32_t nftnl_table_get_u32(const struct nftnl_table *t, uint16_t attr)
 }
 EXPORT_SYMBOL(nftnl_table_get_u32);
 
+uint64_t nftnl_table_get_u64(const struct nftnl_table *t, uint16_t attr)
+{
+	const void *ret = nftnl_table_get(t, attr);
+	return ret == NULL ? 0 : *((uint64_t *)ret);
+}
+EXPORT_SYMBOL(nftnl_table_get_u64);
+
 uint8_t nftnl_table_get_u8(const struct nftnl_table *t, uint16_t attr)
 {
 	const void *ret = nftnl_table_get(t, attr);
@@ -190,6 +212,8 @@ void nftnl_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ta
 {
 	if (t->flags & (1 << NFTNL_TABLE_NAME))
 		mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, t->name);
+	if (t->flags & (1 << NFTNL_TABLE_HANDLE))
+		mnl_attr_put_u64(nlh, NFTA_TABLE_HANDLE, htobe64(t->handle));
 	if (t->flags & (1 << NFTNL_TABLE_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TABLE_FLAGS, htonl(t->table_flags));
 }
@@ -208,6 +232,10 @@ static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	case NFTA_TABLE_HANDLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
 	case NFTA_TABLE_FLAGS:
 	case NFTA_TABLE_USE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
@@ -243,6 +271,10 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 		t->use = ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_USE]));
 		t->flags |= (1 << NFTNL_TABLE_USE);
 	}
+	if (tb[NFTA_TABLE_HANDLE]) {
+		t->handle = be64toh(mnl_attr_get_u64(tb[NFTA_TABLE_HANDLE]));
+		t->flags |= (1 << NFTNL_TABLE_HANDLE);
+	}
 
 	t->family = nfg->nfgen_family;
 	t->flags |= (1 << NFTNL_TABLE_FAMILY);
@@ -358,6 +390,8 @@ static int nftnl_table_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, t->table_flags, FLAGS);
 	if (t->flags & (1 << NFTNL_TABLE_USE))
 		nftnl_buf_u32(&b, type, t->use, USE);
+	if (t->flags & (1 << NFTNL_TABLE_HANDLE))
+		nftnl_buf_u64(&b, type, t->handle, HANDLE);
 
 	nftnl_buf_close(&b, type, TABLE);
 
-- 
2.11.0

