From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: parse new handle attribute for tables
Date: Sat, 23 Dec 2017 11:44:52 -0800
Message-ID: <20171223194452.6010-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:46636 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751217AbdLWTpQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Dec 2017 14:45:16 -0500
Received: by mail-pl0-f66.google.com with SMTP id i6so14724503plt.13
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Dec 2017 11:45:16 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds code to parse new handle attribute for tables.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 include/libnftnl/table.h            |  3 +++
 include/libnftnl/trace.h            |  1 +
 include/linux/netfilter/nf_tables.h |  4 ++++
 src/libnftnl.map                    |  2 ++
 src/table.c                         | 38 +++++++++++++++++++++++++++++++++++--
 src/trace.c                         | 13 +++++++++++++
 6 files changed, 59 insertions(+), 2 deletions(-)

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
diff --git a/include/libnftnl/trace.h b/include/libnftnl/trace.h
index 18ab0c3..20cca84 100644
--- a/include/libnftnl/trace.h
+++ b/include/libnftnl/trace.h
@@ -24,6 +24,7 @@ enum nftnl_trace_attr {
 	NFTNL_TRACE_TRANSPORT_HEADER,
 	NFTNL_TRACE_TABLE,
 	NFTNL_TRACE_TYPE,
+	NFTNL_TRACE_TABLE_HANDLE,
 	NFTNL_TRACE_RULE_HANDLE,
 	NFTNL_TRACE_VERDICT,
 	NFTNL_TRACE_NFPROTO,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 874fa3f..dbc4e38 100644
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
@@ -1307,6 +1309,7 @@ enum nft_object_attributes {
  *
  * @NFTA_TRACE_TABLE: name of the table (NLA_STRING)
  * @NFTA_TRACE_CHAIN: name of the chain (NLA_STRING)
+ * @NFTA_TRACE_TABLE_HANDLE: numeric handle of the table (NLA_U64)
  * @NFTA_TRACE_RULE_HANDLE: numeric handle of the rule (NLA_U64)
  * @NFTA_TRACE_TYPE: type of the event (NLA_U32: nft_trace_types)
  * @NFTA_TRACE_VERDICT: verdict returned by hook (NLA_NESTED: nft_verdicts)
@@ -1326,6 +1329,7 @@ enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
 	NFTA_TRACE_TABLE,
 	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_TABLE_HANDLE,
 	NFTA_TRACE_RULE_HANDLE,
 	NFTA_TRACE_TYPE,
 	NFTA_TRACE_VERDICT,
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
index cf61dda..2d8321e 100644
--- a/src/table.c
+++ b/src/table.c
@@ -34,6 +34,7 @@ struct nftnl_table {
 	uint32_t	table_flags;
 	uint32_t	use;
 	uint32_t	flags;
+	uint64_t 	handle;
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
 
@@ -367,9 +401,9 @@ static int nftnl_table_export(char *buf, size_t size,
 static int nftnl_table_snprintf_default(char *buf, size_t size,
 					const struct nftnl_table *t)
 {
-	return snprintf(buf, size, "table %s %s flags %x use %d",
+	return snprintf(buf, size, "table %s %s flags %x use %d handle %llu",
 			t->name, nftnl_family2str(t->family),
-			t->table_flags, t->use);
+			t->table_flags, t->use, (unsigned long long)t->handle);
 }
 
 static int nftnl_table_cmd_snprintf(char *buf, size_t size,
diff --git a/src/trace.c b/src/trace.c
index b016e72..05a9478 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -34,6 +34,7 @@ struct nftnl_trace {
 	char *chain;
 	char *jump_target;
 	uint64_t rule_handle;
+	uint64_t table_handle;
 	struct nftnl_header_data ll;
 	struct nftnl_header_data nh;
 	struct nftnl_header_data th;
@@ -112,6 +113,10 @@ static int nftnl_trace_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	case NFTA_TRACE_TABLE_HANDLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
 	case NFTA_TRACE_RULE_HANDLE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
 			abi_breakage();
@@ -179,6 +184,9 @@ const void *nftnl_trace_get_data(const struct nftnl_trace *trace,
 	case NFTNL_TRACE_RULE_HANDLE:
 		*data_len = sizeof(uint64_t);
 		return &trace->rule_handle;
+	case NFTNL_TRACE_TABLE_HANDLE:
+		*data_len = sizeof(uint64_t);
+		return &trace->table_handle;
 	case NFTNL_TRACE_VERDICT:
 		*data_len = sizeof(uint32_t);
 		return &trace->verdict;
@@ -395,6 +403,11 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 		t->flags |= (1 << NFTNL_TRACE_RULE_HANDLE);
 	}
 
+	if (tb[NFTA_TRACE_TABLE_HANDLE]) {
+		t->table_handle = be64toh(mnl_attr_get_u64(tb[NFTA_TRACE_TABLE_HANDLE]));
+		t->flags |= (1 << NFTNL_TRACE_TABLE_HANDLE);
+	}
+
 	if (tb[NFTA_TRACE_VERDICT] &&
 	    nftnl_trace_parse_verdict(tb[NFTA_TRACE_VERDICT], t) < 0)
 		return -1;
-- 
2.11.0

