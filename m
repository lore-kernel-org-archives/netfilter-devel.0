From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] set: add set ID support
Date: Thu, 27 Mar 2014 22:53:59 +0100
Message-ID: <1395957239-4960-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49594 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757396AbaC0VyM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:54:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the set ID (u32) which allows us to uniquely identify the set
in the batch that is sent to kernel-space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |    1 +
 include/libnftnl/set.h              |    1 +
 include/linux/netfilter/nf_tables.h |    3 +++
 src/expr/lookup.c                   |   16 ++++++++++++++++
 src/internal.h                      |    1 +
 src/set.c                           |   14 ++++++++++++++
 src/set_elem.c                      |    6 ++++++
 7 files changed, 42 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 2cfb4dc..cfa5c66 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -106,6 +106,7 @@ enum {
 	NFT_EXPR_LOOKUP_SREG	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_LOOKUP_DREG,
 	NFT_EXPR_LOOKUP_SET,
+	NFT_EXPR_LOOKUP_SET_ID,
 };
 
 enum {
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index a975f1c..4d08f16 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -17,6 +17,7 @@ enum {
 	NFT_SET_ATTR_DATA_TYPE,
 	NFT_SET_ATTR_DATA_LEN,
 	NFT_SET_ATTR_FAMILY,
+	NFT_SET_ATTR_ID,
 	__NFT_SET_ATTR_MAX
 };
 #define NFT_SET_ATTR_MAX (__NFT_SET_ATTR_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index bb160d5..3c892a1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -231,6 +231,7 @@ enum nft_set_attributes {
 	NFTA_SET_KEY_LEN,
 	NFTA_SET_DATA_TYPE,
 	NFTA_SET_DATA_LEN,
+	NFTA_SET_ID,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -272,6 +273,7 @@ enum nft_set_elem_list_attributes {
 	NFTA_SET_ELEM_LIST_TABLE,
 	NFTA_SET_ELEM_LIST_SET,
 	NFTA_SET_ELEM_LIST_ELEMENTS,
+	NFTA_SET_ELEM_LIST_SET_ID,
 	__NFTA_SET_ELEM_LIST_MAX
 };
 #define NFTA_SET_ELEM_LIST_MAX	(__NFTA_SET_ELEM_LIST_MAX - 1)
@@ -463,6 +465,7 @@ enum nft_lookup_attributes {
 	NFTA_LOOKUP_SET,
 	NFTA_LOOKUP_SREG,
 	NFTA_LOOKUP_DREG,
+	NFTA_LOOKUP_SET_ID,
 	__NFTA_LOOKUP_MAX
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 5e0bf75..a0928cb 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -31,6 +31,7 @@ struct nft_expr_lookup {
 	enum nft_registers	sreg;
 	enum nft_registers	dreg;
 	char			set_name[IFNAMSIZ];
+	uint32_t		set_id;
 };
 
 static int
@@ -50,6 +51,9 @@ nft_rule_expr_lookup_set(struct nft_rule_expr *e, uint16_t type,
 		memcpy(lookup->set_name, data, IFNAMSIZ);
 		lookup->set_name[IFNAMSIZ-1] = '\0';
 		break;
+	case NFT_EXPR_LOOKUP_SET_ID:
+		lookup->set_id = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -71,6 +75,8 @@ nft_rule_expr_lookup_get(const struct nft_rule_expr *e, uint16_t type,
 		return &lookup->dreg;
 	case NFT_EXPR_LOOKUP_SET:
 		return lookup->set_name;
+	case NFT_EXPR_LOOKUP_SET_ID:
+		return &lookup->set_id;
 	}
 	return NULL;
 }
@@ -86,6 +92,7 @@ static int nft_rule_expr_lookup_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_LOOKUP_SREG:
 	case NFTA_LOOKUP_DREG:
+	case NFTA_LOOKUP_SET_ID:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -114,6 +121,10 @@ nft_rule_expr_lookup_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_LOOKUP_DREG, htonl(lookup->dreg));
 	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET))
 		mnl_attr_put_strz(nlh, NFTA_LOOKUP_SET, lookup->set_name);
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_SET_ID)) {
+		mnl_attr_put_u32(nlh, NFTA_LOOKUP_SET_ID,
+				 htonl(lookup->set_id));
+	}
 }
 
 static int
@@ -138,6 +149,11 @@ nft_rule_expr_lookup_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		strcpy(lookup->set_name, mnl_attr_get_str(tb[NFTA_LOOKUP_SET]));
 		e->flags |= (1 << NFT_EXPR_LOOKUP_SET);
 	}
+	if (tb[NFTA_LOOKUP_SET_ID]) {
+		lookup->set_id =
+			ntohl(mnl_attr_get_u32(tb[NFTA_LOOKUP_SET_ID]));
+		e->flags |= (1 << NFT_EXPR_LOOKUP_SET_ID);
+	}
 
 	return ret;
 }
diff --git a/src/internal.h b/src/internal.h
index 3216bc6..89ea962 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -161,6 +161,7 @@ struct nft_set {
 	uint32_t		key_len;
 	uint32_t		data_type;
 	uint32_t		data_len;
+	uint32_t		id;
 	struct list_head	element_list;
 
 	uint32_t		flags;
diff --git a/src/set.c b/src/set.c
index 368d069..b3ff4ce 100644
--- a/src/set.c
+++ b/src/set.c
@@ -87,6 +87,7 @@ void nft_set_attr_unset(struct nft_set *s, uint16_t attr)
 	case NFT_SET_ATTR_DATA_TYPE:
 	case NFT_SET_ATTR_DATA_LEN:
 	case NFT_SET_ATTR_FAMILY:
+	case NFT_SET_ATTR_ID:
 		break;
 	default:
 		return;
@@ -144,6 +145,9 @@ void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
 	case NFT_SET_ATTR_FAMILY:
 		s->family = *((uint32_t *)data);
 		break;
+	case NFT_SET_ATTR_ID:
+		s->id = *((uint32_t *)data);
+		break;
 	}
 	s->flags |= (1 << attr);
 }
@@ -196,6 +200,9 @@ const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
 	case NFT_SET_ATTR_FAMILY:
 		*data_len = sizeof(uint32_t);
 		return &s->family;
+	case NFT_SET_ATTR_ID:
+		*data_len = sizeof(uint32_t);
+		return &s->id;
 	}
 	return NULL;
 }
@@ -242,6 +249,8 @@ void nft_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 		mnl_attr_put_u32(nlh, NFTA_SET_DATA_TYPE, htonl(s->data_type));
 	if (s->flags & (1 << NFT_SET_ATTR_DATA_LEN))
 		mnl_attr_put_u32(nlh, NFTA_SET_DATA_LEN, htonl(s->data_len));
+	if (s->flags & (1 << NFT_SET_ATTR_ID))
+		mnl_attr_put_u32(nlh, NFTA_SET_ID, htonl(s->id));
 }
 EXPORT_SYMBOL(nft_set_nlmsg_build_payload);
 
@@ -266,6 +275,7 @@ static int nft_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_SET_KEY_LEN:
 	case NFTA_SET_DATA_TYPE:
 	case NFTA_SET_DATA_LEN:
+	case NFTA_SET_ID:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -313,6 +323,10 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 		s->data_len = ntohl(mnl_attr_get_u32(tb[NFTA_SET_DATA_LEN]));
 		s->flags |= (1 << NFT_SET_ATTR_DATA_LEN);
 	}
+	if (tb[NFTA_SET_ID]) {
+		s->id = ntohl(mnl_attr_get_u32(tb[NFTA_SET_ID]));
+		s->flags |= (1 << NFT_SET_ATTR_ID);
+	}
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFT_SET_ATTR_FAMILY);
 
diff --git a/src/set_elem.c b/src/set_elem.c
index b71a916..5812e8b 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -199,6 +199,8 @@ void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 
 	if (s->flags & (1 << NFT_SET_ATTR_NAME))
 		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_SET, s->name);
+	if (s->flags & (1 << NFT_SET_ATTR_ID))
+		mnl_attr_put_u32(nlh, NFTA_SET_ELEM_LIST_SET_ID, htonl(s->id));
 	if (s->flags & (1 << NFT_SET_ATTR_TABLE))
 		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_TABLE, s->table);
 
@@ -355,6 +357,10 @@ int nft_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_SET]));
 		s->flags |= (1 << NFT_SET_ATTR_NAME);
 	}
+	if (tb[NFTA_SET_ELEM_LIST_SET_ID]) {
+		s->id = ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_LIST_SET_ID]));
+		s->flags |= (1 << NFT_SET_ATTR_ID);
+	}
         if (tb[NFTA_SET_ELEM_LIST_ELEMENTS])
 	 	ret = nft_set_elems_parse(s, tb[NFTA_SET_ELEM_LIST_ELEMENTS]);
 
-- 
1.7.10.4

