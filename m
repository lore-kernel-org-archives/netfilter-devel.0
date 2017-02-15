From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 3/3] rule: add NFTA_RULE_ID attribute
Date: Wed, 15 Feb 2017 11:43:36 +0100
Message-ID: <1487155416-7337-3-git-send-email-pablo@netfilter.org>
References: <1487155416-7337-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbdBOKnw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 05:43:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1EC52DA722
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02EBEDA807
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00333DA847
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 11:43:46 +0100 (CET)
In-Reply-To: <1487155416-7337-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the new NFTA_RULE_ID attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/rule.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/rule.c                          | 38 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index ae329d22d09c..947994364bd8 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -27,6 +27,7 @@ enum nftnl_rule_attr {
 	NFTNL_RULE_COMPAT_FLAGS,
 	NFTNL_RULE_POSITION,
 	NFTNL_RULE_USERDATA,
+	NFTNL_RULE_ID,
 	__NFTNL_RULE_MAX
 };
 #define NFTNL_RULE_MAX (__NFTNL_RULE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b00a05d1ee56..be101d1aa89c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -207,6 +207,7 @@ enum nft_chain_attributes {
  * @NFTA_RULE_COMPAT: compatibility specifications of the rule (NLA_NESTED: nft_rule_compat_attributes)
  * @NFTA_RULE_POSITION: numeric handle of the previous rule (NLA_U64)
  * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
+ * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -218,6 +219,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_POSITION,
 	NFTA_RULE_USERDATA,
 	NFTA_RULE_PAD,
+	NFTA_RULE_ID,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/src/rule.c b/src/rule.c
index 02d013bbeac3..31cd3ed7dc99 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -38,6 +38,7 @@ struct nftnl_rule {
 	const char	*chain;
 	uint64_t	handle;
 	uint64_t	position;
+	uint32_t	id;
 	struct {
 			void		*data;
 			uint32_t	len;
@@ -105,6 +106,7 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr)
 	case NFTNL_RULE_COMPAT_FLAGS:
 	case NFTNL_RULE_POSITION:
 	case NFTNL_RULE_FAMILY:
+	case NFTNL_RULE_ID:
 		break;
 	case NFTNL_RULE_USERDATA:
 		xfree(r->user.data);
@@ -120,7 +122,8 @@ static uint32_t nftnl_rule_validate[NFTNL_RULE_MAX + 1] = {
 	[NFTNL_RULE_COMPAT_PROTO]	= sizeof(uint32_t),
 	[NFTNL_RULE_COMPAT_FLAGS]	= sizeof(uint32_t),
 	[NFTNL_RULE_FAMILY]		= sizeof(uint32_t),
-	[NFTNL_RULE_POSITION]	= sizeof(uint64_t),
+	[NFTNL_RULE_POSITION]		= sizeof(uint64_t),
+	[NFTNL_RULE_ID]			= sizeof(uint32_t),
 };
 
 int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
@@ -172,6 +175,9 @@ int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 		memcpy(r->user.data, data, data_len);
 		r->user.len = data_len;
 		break;
+	case NFTNL_RULE_ID:
+		r->id = *((uint32_t *)data);
+		break;
 	}
 	r->flags |= (1 << attr);
 	return 0;
@@ -233,6 +239,9 @@ const void *nftnl_rule_get_data(const struct nftnl_rule *r, uint16_t attr,
 	case NFTNL_RULE_USERDATA:
 		*data_len = r->user.len;
 		return r->user.data;
+	case NFTNL_RULE_ID:
+		*data_len = sizeof(uint32_t);
+		return &r->id;
 	}
 	return NULL;
 }
@@ -322,6 +331,8 @@ void nftnl_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_rule *r)
 				 htonl(r->compat.flags));
 		mnl_attr_nest_end(nlh, nest);
 	}
+	if (r->flags & (1 << NFTNL_RULE_ID))
+		mnl_attr_put_u32(nlh, NFTA_RULE_ID, htonl(r->id));
 }
 EXPORT_SYMBOL(nftnl_rule_nlmsg_build_payload);
 
@@ -361,6 +372,10 @@ static int nftnl_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
+	case NFTA_RULE_ID:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -484,6 +499,10 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 		memcpy(r->user.data, udata, r->user.len);
 		r->flags |= (1 << NFTNL_RULE_USERDATA);
 	}
+	if (tb[NFTA_RULE_ID]) {
+		r->id = ntohl(mnl_attr_get_u32(tb[NFTA_RULE_ID]));
+		r->flags |= (1 << NFTNL_RULE_ID);
+	}
 
 	r->family = nfg->nfgen_family;
 	r->flags |= (1 << NFTNL_RULE_FAMILY);
@@ -562,6 +581,13 @@ int nftnl_jansson_parse_rule(struct nftnl_rule *r, json_t *tree,
 		nftnl_rule_set_u64(r, NFTNL_RULE_POSITION, uval64);
 	}
 
+	if (nftnl_jansson_node_exist(root, "id")) {
+		if (nftnl_jansson_parse_val(root, "id", NFTNL_TYPE_U32,
+					    &uval32, err) < 0)
+			goto err;
+		nftnl_rule_set_u32(r, NFTNL_RULE_COMPAT_PROTO, uval32);
+	}
+
 	array = json_object_get(root, "expr");
 	if (array == NULL) {
 		err->error = NFTNL_PARSE_EMISSINGNODE;
@@ -692,6 +718,11 @@ static int nftnl_rule_snprintf_json(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (r->flags & (1 << NFTNL_RULE_ID)) {
+		ret = snprintf(buf+offset, len, "\"id\":%u,", r->id);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	ret = snprintf(buf+offset, len, "\"expr\":[");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -760,6 +791,11 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (r->flags & (1 << NFTNL_RULE_ID)) {
+		ret = snprintf(buf + offset, len, "%u ", r->id);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	ret = snprintf(buf+offset, len, "\n");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-- 
2.1.4

