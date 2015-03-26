From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl 2/2] set_elem: add timeout support
Date: Thu, 26 Mar 2015 13:10:20 +0000
Message-ID: <1427375420-24892-3-git-send-email-kaber@trash.net>
References: <1427375420-24892-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58482 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbbCZNKZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 09:10:25 -0400
In-Reply-To: <1427375420-24892-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/libnftnl/set.h              |  4 ++++
 include/linux/netfilter/nf_tables.h |  4 ++++
 include/set_elem.h                  |  2 ++
 src/libnftnl.map                    |  2 ++
 src/set_elem.c                      | 38 +++++++++++++++++++++++++++++++++++++
 5 files changed, 50 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 5c4109f..db38d6b 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -90,6 +90,8 @@ enum {
 	NFT_SET_ELEM_ATTR_VERDICT,
 	NFT_SET_ELEM_ATTR_CHAIN,
 	NFT_SET_ELEM_ATTR_DATA,
+	NFT_SET_ELEM_ATTR_TIMEOUT,
+	NFT_SET_ELEM_ATTR_EXPIRATION,
 };
 
 struct nft_set_elem;
@@ -104,11 +106,13 @@ void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem);
 void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr);
 void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr, const void *data, uint32_t data_len);
 void nft_set_elem_attr_set_u32(struct nft_set_elem *s, uint16_t attr, uint32_t val);
+void nft_set_elem_attr_set_u64(struct nft_set_elem *s, uint16_t attr, uint64_t val);
 void nft_set_elem_attr_set_str(struct nft_set_elem *s, uint16_t attr, const char *str);
 
 const void *nft_set_elem_attr_get(struct nft_set_elem *s, uint16_t attr, uint32_t *data_len);
 const char *nft_set_elem_attr_get_str(struct nft_set_elem *s, uint16_t attr);
 uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr);
+uint64_t nft_set_elem_attr_get_u64(struct nft_set_elem *s, uint16_t attr);
 
 bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr);
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 8671505..6894ba3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -289,12 +289,16 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_KEY: key value (NLA_NESTED: nft_data)
  * @NFTA_SET_ELEM_DATA: data value of mapping (NLA_NESTED: nft_data_attributes)
  * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
+ * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
+ * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
 	NFTA_SET_ELEM_KEY,
 	NFTA_SET_ELEM_DATA,
 	NFTA_SET_ELEM_FLAGS,
+	NFTA_SET_ELEM_TIMEOUT,
+	NFTA_SET_ELEM_EXPIRATION,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
diff --git a/include/set_elem.h b/include/set_elem.h
index 467c1a0..de864db 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -9,6 +9,8 @@ struct nft_set_elem {
 	union nft_data_reg	key;
 	union nft_data_reg	data;
 	uint32_t		flags;
+	uint64_t		timeout;
+	uint64_t		expiration;
 };
 
 #endif
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 84018a7..01eba13 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -158,10 +158,12 @@ global:
   nft_set_elem_attr_unset;
   nft_set_elem_attr_set;
   nft_set_elem_attr_set_u32;
+  nft_set_elem_attr_set_u64;
   nft_set_elem_attr_set_str;
   nft_set_elem_attr_get;
   nft_set_elem_attr_get_str;
   nft_set_elem_attr_get_u32;
+  nft_set_elem_attr_get_u64;
   nft_set_elem_nlmsg_build_payload;
   nft_set_elem_parse;
   nft_set_elem_parse_file;
diff --git a/src/set_elem.c b/src/set_elem.c
index e822acc..5760902 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -70,6 +70,8 @@ void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr)
 	case NFT_SET_ELEM_ATTR_KEY:	/* NFTA_SET_ELEM_KEY */
 	case NFT_SET_ELEM_ATTR_VERDICT:	/* NFTA_SET_ELEM_DATA */
 	case NFT_SET_ELEM_ATTR_DATA:	/* NFTA_SET_ELEM_DATA */
+	case NFT_SET_ELEM_ATTR_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
+	case NFT_SET_ELEM_ATTR_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
 		break;
 	default:
 		return;
@@ -103,6 +105,9 @@ void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr,
 		memcpy(s->data.val, data, data_len);
 		s->data.len = data_len;
 		break;
+	case NFT_SET_ELEM_ATTR_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
+		s->timeout = *((uint64_t *)data);
+		break;
 	default:
 		return;
 	}
@@ -116,6 +121,12 @@ void nft_set_elem_attr_set_u32(struct nft_set_elem *s, uint16_t attr, uint32_t v
 }
 EXPORT_SYMBOL(nft_set_elem_attr_set_u32);
 
+void nft_set_elem_attr_set_u64(struct nft_set_elem *s, uint16_t attr, uint64_t val)
+{
+	nft_set_elem_attr_set(s, attr, &val, sizeof(uint64_t));
+}
+EXPORT_SYMBOL(nft_set_elem_attr_set_u64);
+
 void nft_set_elem_attr_set_str(struct nft_set_elem *s, uint16_t attr, const char *str)
 {
 	nft_set_elem_attr_set(s, attr, str, strlen(str));
@@ -140,6 +151,10 @@ const void *nft_set_elem_attr_get(struct nft_set_elem *s, uint16_t attr, uint32_
 	case NFT_SET_ELEM_ATTR_DATA:	/* NFTA_SET_ELEM_DATA */
 		*data_len = s->data.len;
 		return &s->data.val;
+	case NFT_SET_ELEM_ATTR_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
+		return &s->timeout;
+	case NFT_SET_ELEM_ATTR_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
+		return &s->expiration;
 	}
 	return NULL;
 }
@@ -161,6 +176,14 @@ uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_elem_attr_get_u32);
 
+uint64_t nft_set_elem_attr_get_u64(struct nft_set_elem *s, uint16_t attr)
+{
+	uint32_t size;
+	uint64_t val = *((uint64_t *)nft_set_elem_attr_get(s, attr, &size));
+	return val;
+}
+EXPORT_SYMBOL(nft_set_elem_attr_get_u64);
+
 struct nft_set_elem *nft_set_elem_clone(struct nft_set_elem *elem)
 {
 	struct nft_set_elem *newelem;
@@ -182,6 +205,8 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 {
 	if (e->flags & (1 << NFT_SET_ELEM_ATTR_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_SET_ELEM_FLAGS, htonl(e->set_elem_flags));
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_TIMEOUT))
+		mnl_attr_put_u64(nlh, NFTA_SET_ELEM_TIMEOUT, htobe64(e->timeout));
 	if (e->flags & (1 << NFT_SET_ELEM_ATTR_KEY)) {
 		struct nlattr *nest1;
 
@@ -262,6 +287,11 @@ static int nft_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	case NFTA_SET_ELEM_TIMEOUT:
+	case NFTA_SET_ELEM_EXPIRATION:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
 	case NFTA_SET_ELEM_KEY:
 	case NFTA_SET_ELEM_DATA:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
@@ -293,6 +323,14 @@ static int nft_set_elems_parse2(struct nft_set *s, const struct nlattr *nest)
 			ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_FLAGS]));
 		e->flags |= (1 << NFT_SET_ELEM_ATTR_FLAGS);
 	}
+	if (tb[NFTA_SET_ELEM_TIMEOUT]) {
+		e->timeout = be64toh(mnl_attr_get_u64(tb[NFTA_SET_ELEM_TIMEOUT]));
+		e->flags |= (1 << NFT_SET_ELEM_ATTR_TIMEOUT);
+	}
+	if (tb[NFTA_SET_ELEM_EXPIRATION]) {
+		e->expiration = be64toh(mnl_attr_get_u64(tb[NFTA_SET_ELEM_EXPIRATION]));
+		e->flags |= (1 << NFT_SET_ELEM_ATTR_EXPIRATION);
+	}
         if (tb[NFTA_SET_ELEM_KEY]) {
 		ret = nft_parse_data(&e->key, tb[NFTA_SET_ELEM_KEY], &type);
 		e->flags |= (1 << NFT_SET_ELEM_ATTR_KEY);
-- 
2.1.0

