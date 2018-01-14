From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: parse new handle attribute for sets
Date: Sun, 14 Jan 2018 22:13:52 +0530
Message-ID: <20180114164352.21777-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38763 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbeANQoV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jan 2018 11:44:21 -0500
Received: by mail-pg0-f67.google.com with SMTP id y27so958386pgc.5
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2018 08:44:21 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds code to allocate set handles and delete sets via set
handle.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 include/libnftnl/set.h              |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/set.h                       |  1 +
 src/set.c                           | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index e760d31..ecb4b5a 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -11,6 +11,7 @@
 enum nftnl_set_attr {
 	NFTNL_SET_TABLE,
 	NFTNL_SET_NAME,
+	NFTNL_SET_HANDLE,
 	NFTNL_SET_FLAGS,
 	NFTNL_SET_KEY_TYPE,
 	NFTNL_SET_KEY_LEN,
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index dbc4e38..120fa23 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -299,6 +299,7 @@ enum nft_set_desc_attributes {
  *
  * @NFTA_SET_TABLE: table name (NLA_STRING)
  * @NFTA_SET_NAME: set name (NLA_STRING)
+ * @NFTA_SET_HANDLE: numerical table handle (NLA_U64)
  * @NFTA_SET_FLAGS: bitmask of enum nft_set_flags (NLA_U32)
  * @NFTA_SET_KEY_TYPE: key data type, informational purpose only (NLA_U32)
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
@@ -316,6 +317,7 @@ enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
 	NFTA_SET_TABLE,
 	NFTA_SET_NAME,
+	NFTA_SET_HANDLE,
 	NFTA_SET_FLAGS,
 	NFTA_SET_KEY_TYPE,
 	NFTA_SET_KEY_LEN,
diff --git a/include/set.h b/include/set.h
index c6deb73..3bcec7c 100644
--- a/include/set.h
+++ b/include/set.h
@@ -10,6 +10,7 @@ struct nftnl_set {
 	uint32_t		set_flags;
 	const char		*table;
 	const char		*name;
+	uint64_t		handle;
 	uint32_t		key_type;
 	uint32_t		key_len;
 	uint32_t		data_type;
diff --git a/src/set.c b/src/set.c
index 592ea24..e27eed9 100644
--- a/src/set.c
+++ b/src/set.c
@@ -77,6 +77,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 	case NFTNL_SET_NAME:
 		xfree(s->name);
 		break;
+	case NFTNL_SET_HANDLE:
 	case NFTNL_SET_FLAGS:
 	case NFTNL_SET_KEY_TYPE:
 	case NFTNL_SET_KEY_LEN:
@@ -102,6 +103,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 EXPORT_SYMBOL(nftnl_set_unset);
 
 static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
+	[NFTNL_SET_HANDLE]		= sizeof(uint64_t),
 	[NFTNL_SET_FLAGS]		= sizeof(uint32_t),
 	[NFTNL_SET_KEY_TYPE]		= sizeof(uint32_t),
 	[NFTNL_SET_KEY_LEN]		= sizeof(uint32_t),
@@ -138,6 +140,9 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		if (!s->name)
 			return -1;
 		break;
+	case NFTNL_SET_HANDLE:
+		s->handle = *((uint64_t *)data);
+		break;
 	case NFTNL_SET_FLAGS:
 		s->set_flags = *((uint32_t *)data);
 		break;
@@ -227,6 +232,9 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 	case NFTNL_SET_NAME:
 		*data_len = strlen(s->name) + 1;
 		return s->name;
+	case NFTNL_SET_HANDLE:
+		*data_len = sizeof(uint64_t);
+		return &s->handle;
 	case NFTNL_SET_FLAGS:
 		*data_len = sizeof(uint32_t);
 		return &s->set_flags;
@@ -359,6 +367,8 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 		mnl_attr_put_strz(nlh, NFTA_SET_TABLE, s->table);
 	if (s->flags & (1 << NFTNL_SET_NAME))
 		mnl_attr_put_strz(nlh, NFTA_SET_NAME, s->name);
+	if (s->handle & (1 << NFTNL_SET_HANDLE))
+		mnl_attr_put_u64(nlh, NFTA_SET_HANDLE, htobe64(s->handle));
 	if (s->flags & (1 << NFTNL_SET_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_SET_FLAGS, htonl(s->set_flags));
 	if (s->flags & (1 << NFTNL_SET_KEY_TYPE))
@@ -401,6 +411,10 @@ static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	case NFTA_SET_HANDLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
 	case NFTA_SET_FLAGS:
 	case NFTA_SET_KEY_TYPE:
 	case NFTA_SET_KEY_LEN:
@@ -490,6 +504,10 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 			return -1;
 		s->flags |= (1 << NFTNL_SET_NAME);
 	}
+	if (tb[NFTA_SET_HANDLE]) {
+		s->handle = be64toh(mnl_attr_get_u64(tb[NFTA_SET_HANDLE]));
+		s->flags |= (1 << NFTNL_SET_HANDLE);
+	}
 	if (tb[NFTA_SET_FLAGS]) {
 		s->set_flags = ntohl(mnl_attr_get_u32(tb[NFTA_SET_FLAGS]));
 		s->flags |= (1 << NFTNL_SET_FLAGS);
-- 
2.11.0

