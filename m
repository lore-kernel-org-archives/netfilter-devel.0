From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl 1/2] set: add support for set timeouts
Date: Thu, 26 Mar 2015 13:10:19 +0000
Message-ID: <1427375420-24892-2-git-send-email-kaber@trash.net>
References: <1427375420-24892-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58480 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbCZNKY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 09:10:24 -0400
In-Reply-To: <1427375420-24892-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/libnftnl/set.h              |  4 +++
 include/linux/netfilter/nf_tables.h |  6 +++++
 include/set.h                       |  2 ++
 src/libnftnl.map                    |  2 ++
 src/set.c                           | 50 +++++++++++++++++++++++++++++++++++++
 5 files changed, 64 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 55a47b0..5c4109f 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -20,6 +20,8 @@ enum {
 	NFT_SET_ATTR_ID,
 	NFT_SET_ATTR_POLICY,
 	NFT_SET_ATTR_DESC_SIZE,
+	NFT_SET_ATTR_TIMEOUT,
+	NFT_SET_ATTR_GC_INTERVAL,
 	__NFT_SET_ATTR_MAX
 };
 #define NFT_SET_ATTR_MAX (__NFT_SET_ATTR_MAX - 1)
@@ -37,6 +39,7 @@ void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void *data);
 void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
 			   uint32_t data_len);
 void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_t val);
+void nft_set_attr_set_u64(struct nft_set *s, uint16_t attr, uint64_t val);
 void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const char *str);
 
 const void *nft_set_attr_get(struct nft_set *s, uint16_t attr);
@@ -44,6 +47,7 @@ const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
 				  uint32_t *data_len);
 const char *nft_set_attr_get_str(struct nft_set *s, uint16_t attr);
 uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr);
+uint64_t nft_set_attr_get_u64(struct nft_set *s, uint16_t attr);
 
 struct nlmsghdr;
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 832bc46..8671505 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -207,12 +207,14 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_CONSTANT: set contents may not change while bound
  * @NFT_SET_INTERVAL: set contains intervals
  * @NFT_SET_MAP: set is used as a dictionary
+ * @NFT_SET_TIMEOUT: set uses timeouts
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
 	NFT_SET_CONSTANT		= 0x2,
 	NFT_SET_INTERVAL		= 0x4,
 	NFT_SET_MAP			= 0x8,
+	NFT_SET_TIMEOUT			= 0x10,
 };
 
 /**
@@ -251,6 +253,8 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_POLICY: selection policy (NLA_U32)
  * @NFTA_SET_DESC: set description (NLA_NESTED)
  * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
+ * @NFTA_SET_TIMEOUT: default timeout value (NLA_U64)
+ * @NFTA_SET_GC_INTERVAL: garbage collection interval (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -264,6 +268,8 @@ enum nft_set_attributes {
 	NFTA_SET_POLICY,
 	NFTA_SET_DESC,
 	NFTA_SET_ID,
+	NFTA_SET_TIMEOUT,
+	NFTA_SET_GC_INTERVAL,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 29b9ce5..008ed6e 100644
--- a/include/set.h
+++ b/include/set.h
@@ -22,6 +22,8 @@ struct nft_set {
 	struct list_head	element_list;
 
 	uint32_t		flags;
+	uint32_t		gc_interval;
+	uint64_t		timeout;
 };
 
 struct nft_set_list;
diff --git a/src/libnftnl.map b/src/libnftnl.map
index c0b2031..84018a7 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -124,10 +124,12 @@ global:
   nft_set_attr_is_set;
   nft_set_attr_set;
   nft_set_attr_set_u32;
+  nft_set_attr_set_u64;
   nft_set_attr_set_str;
   nft_set_attr_get;
   nft_set_attr_get_str;
   nft_set_attr_get_u32;
+  nft_set_attr_get_u64;
   nft_set_nlmsg_build_payload;
   nft_set_nlmsg_parse;
   nft_set_parse;
diff --git a/src/set.c b/src/set.c
index 70b4bc6..d58c9e1 100644
--- a/src/set.c
+++ b/src/set.c
@@ -88,6 +88,8 @@ void nft_set_attr_unset(struct nft_set *s, uint16_t attr)
 	case NFT_SET_ATTR_ID:
 	case NFT_SET_ATTR_POLICY:
 	case NFT_SET_ATTR_DESC_SIZE:
+	case NFT_SET_ATTR_TIMEOUT:
+	case NFT_SET_ATTR_GC_INTERVAL:
 		break;
 	default:
 		return;
@@ -106,6 +108,8 @@ static uint32_t nft_set_attr_validate[NFT_SET_ATTR_MAX + 1] = {
 	[NFT_SET_ATTR_FAMILY]		= sizeof(uint32_t),
 	[NFT_SET_ATTR_POLICY]		= sizeof(uint32_t),
 	[NFT_SET_ATTR_DESC_SIZE]	= sizeof(uint32_t),
+	[NFT_SET_ATTR_TIMEOUT]		= sizeof(uint64_t),
+	[NFT_SET_ATTR_GC_INTERVAL]	= sizeof(uint32_t),
 };
 
 void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
@@ -156,6 +160,12 @@ void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
 	case NFT_SET_ATTR_DESC_SIZE:
 		s->desc.size = *((uint32_t *)data);
 		break;
+	case NFT_SET_ATTR_TIMEOUT:
+		s->timeout = *((uint64_t *)data);
+		break;
+	case NFT_SET_ATTR_GC_INTERVAL:
+		s->gc_interval = *((uint32_t *)data);
+		break;
 	}
 	s->flags |= (1 << attr);
 }
@@ -173,6 +183,12 @@ void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_t val)
 }
 EXPORT_SYMBOL(nft_set_attr_set_u32);
 
+void nft_set_attr_set_u64(struct nft_set *s, uint16_t attr, uint64_t val)
+{
+	nft_set_attr_set(s, attr, &val);
+}
+EXPORT_SYMBOL(nft_set_attr_set_u64);
+
 void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const char *str)
 {
 	nft_set_attr_set(s, attr, str);
@@ -217,6 +233,12 @@ const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
 	case NFT_SET_ATTR_DESC_SIZE:
 		*data_len = sizeof(uint32_t);
 		return &s->desc.size;
+	case NFT_SET_ATTR_TIMEOUT:
+		*data_len = sizeof(uint64_t);
+		return &s->timeout;
+	case NFT_SET_ATTR_GC_INTERVAL:
+		*data_len = sizeof(uint32_t);
+		return &s->gc_interval;
 	}
 	return NULL;
 }
@@ -246,6 +268,17 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_attr_get_u32);
 
+uint64_t nft_set_attr_get_u64(struct nft_set *s, uint16_t attr)
+{
+	uint32_t data_len;
+	const uint64_t *val = nft_set_attr_get_data(s, attr, &data_len);
+
+	nft_assert(val, attr, data_len == sizeof(uint64_t));
+
+	return val ? *val : 0;
+}
+EXPORT_SYMBOL(nft_set_attr_get_u64);
+
 struct nft_set *nft_set_clone(const struct nft_set *set)
 {
 	struct nft_set *newset;
@@ -310,6 +343,10 @@ void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 		mnl_attr_put_u32(nlh, NFTA_SET_POLICY, htonl(s->policy));
 	if (s->flags & (1 << NFT_SET_ATTR_DESC_SIZE))
 		nft_set_nlmsg_build_desc_payload(nlh, s);
+	if (s->flags & (1 << NFT_SET_ATTR_TIMEOUT))
+		mnl_attr_put_u64(nlh, NFTA_SET_TIMEOUT, htobe64(s->timeout));
+	if (s->flags & (1 << NFT_SET_ATTR_GC_INTERVAL))
+		mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
 }
 EXPORT_SYMBOL(nft_set_nlmsg_build_payload);
 
@@ -334,9 +371,14 @@ static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_SET_DATA_LEN:
 	case NFTA_SET_ID:
 	case NFTA_SET_POLICY:
+	case NFTA_SET_GC_INTERVAL:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	case NFTA_SET_TIMEOUT:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
 	case NFTA_SET_DESC:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
@@ -427,6 +469,14 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 		s->policy = ntohl(mnl_attr_get_u32(tb[NFTA_SET_POLICY]));
 		s->flags |= (1 << NFT_SET_ATTR_POLICY);
 	}
+	if (tb[NFTA_SET_TIMEOUT]) {
+		s->timeout = be64toh(mnl_attr_get_u64(tb[NFTA_SET_TIMEOUT]));
+		s->flags |= (1 << NFT_SET_ATTR_TIMEOUT);
+	}
+	if (tb[NFTA_SET_GC_INTERVAL]) {
+		s->gc_interval = ntohl(mnl_attr_get_u32(tb[NFTA_SET_GC_INTERVAL]));
+		s->flags |= (1 << NFT_SET_ATTR_GC_INTERVAL);
+	}
 	if (tb[NFTA_SET_DESC])
 		ret = nft_set_desc_parse(s, tb[NFTA_SET_DESC]);
 
-- 
2.1.0

