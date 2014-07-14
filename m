From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] set: add support for set mechanism selection
Date: Mon, 14 Jul 2014 10:41:26 +0200
Message-ID: <20140714084126.4434.20059.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55495 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753801AbaGNIlk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:41:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support to select the set mechanism.
The kernel support was added in commit:
 c50b960 netfilter: nf_tables: implement proper set selection

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/set.h |    2 +
 src/internal.h         |    5 +
 src/set.c              |  170 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 174 insertions(+), 3 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 4d08f16..77d797f 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -18,6 +18,8 @@ enum {
 	NFT_SET_ATTR_DATA_LEN,
 	NFT_SET_ATTR_FAMILY,
 	NFT_SET_ATTR_ID,
+	NFT_SET_ATTR_DESC_POLICY,
+	NFT_SET_ATTR_DESC_SIZE,
 	__NFT_SET_ATTR_MAX
 };
 #define NFT_SET_ATTR_MAX (__NFT_SET_ATTR_MAX - 1)
diff --git a/src/internal.h b/src/internal.h
index b8ed616..0ea07db 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -14,6 +14,7 @@
 #include <stdint.h>
 #include <stdbool.h>
 #include <libnftnl/common.h>
+#include <linux/netfilter/nf_tables.h>
 
 #define BASE_DEC 10
 #define BASE_HEX 16
@@ -168,6 +169,10 @@ struct nft_set {
 	uint32_t		data_type;
 	uint32_t		data_len;
 	uint32_t		id;
+	struct {
+		enum nft_set_policies	policy;
+		uint32_t		size;
+	} desc;
 	struct list_head	element_list;
 
 	uint32_t		flags;
diff --git a/src/set.c b/src/set.c
index a1e195b..f534aee 100644
--- a/src/set.c
+++ b/src/set.c
@@ -88,6 +88,8 @@ void nft_set_attr_unset(struct nft_set *s, uint16_t attr)
 	case NFT_SET_ATTR_DATA_LEN:
 	case NFT_SET_ATTR_FAMILY:
 	case NFT_SET_ATTR_ID:
+	case NFT_SET_ATTR_DESC_POLICY:
+	case NFT_SET_ATTR_DESC_SIZE:
 		break;
 	default:
 		return;
@@ -104,6 +106,8 @@ static uint32_t nft_set_attr_validate[NFT_SET_ATTR_MAX + 1] = {
 	[NFT_SET_ATTR_DATA_TYPE]	= sizeof(uint32_t),
 	[NFT_SET_ATTR_DATA_LEN]		= sizeof(uint32_t),
 	[NFT_SET_ATTR_FAMILY]		= sizeof(uint32_t),
+	[NFT_SET_ATTR_DESC_POLICY]	= sizeof(uint32_t),
+	[NFT_SET_ATTR_DESC_SIZE]	= sizeof(uint32_t),
 };
 
 void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
@@ -148,6 +152,12 @@ void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
 	case NFT_SET_ATTR_ID:
 		s->id = *((uint32_t *)data);
 		break;
+	case NFT_SET_ATTR_DESC_POLICY:
+		s->desc.policy = *((uint32_t *)data);
+		break;
+	case NFT_SET_ATTR_DESC_SIZE:
+		s->desc.size = *((uint32_t *)data);
+		break;
 	}
 	s->flags |= (1 << attr);
 }
@@ -203,6 +213,12 @@ const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
 	case NFT_SET_ATTR_ID:
 		*data_len = sizeof(uint32_t);
 		return &s->id;
+	case NFT_SET_ATTR_DESC_POLICY:
+		*data_len = sizeof(uint32_t);
+		return &s->desc.policy;
+	case NFT_SET_ATTR_DESC_SIZE:
+		*data_len = sizeof(uint32_t);
+		return &s->desc.size;
 	}
 	return NULL;
 }
@@ -232,6 +248,16 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_set_attr_get_u32);
 
+static void
+nft_set_nlmsg_build_desc_payload(struct nlmsghdr *nlh, struct nft_set *s)
+{
+	struct nlattr *nest;
+
+	nest = mnl_attr_nest_start(nlh, NFTA_SET_DESC);
+	mnl_attr_put_u32(nlh, NFTA_SET_DESC_SIZE, htonl(s->desc.size));
+	mnl_attr_nest_end(nlh, nest);
+}
+
 void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 {
 	if (s->flags & (1 << NFT_SET_ATTR_TABLE))
@@ -251,6 +277,10 @@ void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 		mnl_attr_put_u32(nlh, NFTA_SET_DATA_LEN, htonl(s->data_len));
 	if (s->flags & (1 << NFT_SET_ATTR_ID))
 		mnl_attr_put_u32(nlh, NFTA_SET_ID, htonl(s->id));
+	if (s->flags & (1 << NFT_SET_ATTR_DESC_POLICY))
+		mnl_attr_put_u32(nlh, NFTA_SET_POLICY, htonl(s->desc.policy));
+	if (s->flags & (1 << NFT_SET_ATTR_DESC_SIZE))
+		nft_set_nlmsg_build_desc_payload(nlh, s);
 }
 EXPORT_SYMBOL(nft_set_nlmsg_build_payload);
 
@@ -276,6 +306,34 @@ static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_SET_DATA_TYPE:
 	case NFTA_SET_DATA_LEN:
 	case NFTA_SET_ID:
+	case NFTA_SET_POLICY:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NFTA_SET_DESC:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int nft_set_desc_parse_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_SET_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NFTA_SET_DESC_SIZE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -287,10 +345,45 @@ static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static int nft_set_desc_parse(struct nft_set *s,
+			      const struct nlattr *attr)
+{
+	struct nlattr *tb[NFTA_SET_MAX+1] = {};
+
+	if (mnl_attr_parse_nested(attr, nft_set_desc_parse_attr_cb, tb) < 0)
+		return -1;
+
+	if (tb[NFTA_SET_DESC_SIZE]) {
+		s->desc.size = ntohl(mnl_attr_get_u32(tb[NFTA_SET_DESC_SIZE]));
+		s->flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
+	}
+
+	return 0;
+}
+
+static int nft_set_nlmsg_desc_parse(const struct nlattr *nest,
+				    struct nft_set *s)
+{
+	struct nlattr *attr;
+	int ret = 0;
+
+	mnl_attr_for_each_nested(attr, nest) {
+		if (mnl_attr_get_type(attr) != NFTA_SET_DESC)
+			return -1;
+
+		ret = nft_set_desc_parse(s, attr);
+		if (ret != 0)
+			break;
+	}
+
+	return ret;
+}
+
 int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 {
 	struct nlattr *tb[NFTA_SET_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
+	int ret = 0;
 
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nft_set_parse_attr_cb, tb) < 0)
 		return -1;
@@ -327,10 +420,17 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 		s->id = ntohl(mnl_attr_get_u32(tb[NFTA_SET_ID]));
 		s->flags |= (1 << NFT_SET_ATTR_ID);
 	}
+	if (tb[NFTA_SET_POLICY]) {
+		s->desc.policy = ntohl(mnl_attr_get_u32(tb[NFTA_SET_POLICY]));
+		s->flags |= (1 << NFT_SET_ATTR_DESC_POLICY);
+	}
+	if (tb[NFTA_SET_DESC])
+		ret = nft_set_nlmsg_desc_parse(tb[NFTA_SET_DESC], s);
+
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFT_SET_ATTR_FAMILY);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
 
@@ -339,7 +439,7 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 			  struct nft_parse_err *err)
 {
 	json_t *root, *array, *json_elem;
-	uint32_t flags, key_type, key_len, data_type, data_len;
+	uint32_t flags, key_type, key_len, data_type, data_len, policy, size;
 	int family, i;
 	const char *name, *table;
 	struct nft_set_elem *elem;
@@ -390,6 +490,22 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_LEN, data_len);
 	}
 
+	if (nft_jansson_node_exist(root, "desc_policy")) {
+		if (nft_jansson_parse_val(root, "desc_policy", NFT_TYPE_U32,
+					  &policy, err) < 0)
+			return -1;
+
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_DESC_POLICY, policy);
+	}
+
+	if (nft_jansson_node_exist(root, "desc_size")) {
+		if (nft_jansson_parse_val(root, "desc_size", NFT_TYPE_U32,
+					  &size, err) < 0)
+			return -1;
+
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_DESC_SIZE, size);
+	}
+
 	if (nft_jansson_node_exist(root, "set_elem")) {
 		array = json_object_get(root, "set_elem");
 		for (i = 0; i < json_array_size(array); i++) {
@@ -446,7 +562,7 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 	const char *name, *table;
 	int family;
 	uint32_t set_flags, key_type, key_len;
-	uint32_t data_type, data_len;
+	uint32_t data_type, data_len, policy, size;
 
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND, err);
@@ -491,6 +607,16 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 
 	}
 
+	if (nft_mxml_num_parse(tree, "desc_policy", MXML_DESCEND_FIRST,
+			       BASE_DEC, &policy, NFT_TYPE_U32,
+			       NFT_XML_OPT, err) == 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_DESC_POLICY, policy);
+
+	if (nft_mxml_num_parse(tree, "desc_size", MXML_DESCEND_FIRST,
+			       BASE_DEC, &policy, NFT_TYPE_U32,
+			       NFT_XML_OPT, err) == 0)
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_DESC_SIZE, policy);
+
 	for (node = mxmlFindElement(tree, tree, "set_elem", NULL,
 				    NULL, MXML_DESCEND);
 		node != NULL;
@@ -617,6 +743,19 @@ static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 		ret = snprintf(buf + offset, len, ",\"data_len\":%u", s->data_len);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
+
+	if (s->flags & (1 << NFT_SET_ATTR_DESC_POLICY)) {
+		ret = snprintf(buf + offset, len, ",\"desc_policy\":%u",
+			       s->desc.policy);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (s->flags & (1 << NFT_SET_ATTR_DESC_SIZE)) {
+		ret = snprintf(buf + offset, len, ",\"desc_size\":%u",
+			       s->desc.size);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	/* Empty set? Skip printinf of elements */
 	if (list_empty(&s->element_list)){
 		ret = snprintf(buf + offset, len, "}}");
@@ -658,6 +797,18 @@ static int nft_set_snprintf_default(char *buf, size_t size, struct nft_set *s,
 			s->name, s->table, s->set_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (s->flags & (1 << NFT_SET_ATTR_DESC_POLICY)) {
+		ret = snprintf(buf + offset, len, " desc policy: %u",
+			       s->desc.policy);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (s->flags & (1 << NFT_SET_ATTR_DESC_SIZE)) {
+		ret = snprintf(buf + offset, len, " desc size %u",
+			       s->desc.size);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	/* Empty set? Skip printinf of elements */
 	if (list_empty(&s->element_list))
 		return offset;
@@ -731,6 +882,19 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (s->flags & (1 << NFT_SET_ATTR_DESC_POLICY)) {
+		ret = snprintf(buf + offset, len,
+			       "<desc_policy>%u</desc_policy>",
+			       s->desc.policy);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (s->flags & (1 << NFT_SET_ATTR_DESC_SIZE)) {
+		ret = snprintf(buf + offset, len, "<desc_size>%u</desc_size>",
+			       s->desc.size);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (!list_empty(&s->element_list)) {
 		list_for_each_entry(elem, &s->element_list, head) {
 			ret = nft_set_elem_snprintf(buf + offset, len, elem,

