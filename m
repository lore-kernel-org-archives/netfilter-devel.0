From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: log: add support for level and flags
Date: Tue,  1 Jul 2014 14:20:15 +0200
Message-ID: <1404217215-8734-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40347 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbaGAMUc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:20:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is required by changes scheduled for Linux kernel 3.17.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h             |    2 +
 include/linux/netfilter/nf_tables.h |    4 ++
 src/expr/log.c                      |   91 ++++++++++++++++++++++++++++++++---
 3 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index cfa5c66..b493ba8 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -114,6 +114,8 @@ enum {
 	NFT_EXPR_LOG_GROUP,
 	NFT_EXPR_LOG_SNAPLEN,
 	NFT_EXPR_LOG_QTHRESHOLD,
+	NFT_EXPR_LOG_LEVEL,
+	NFT_EXPR_LOG_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2a88f64..801bdd1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -697,6 +697,8 @@ enum nft_counter_attributes {
  * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
  * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
+ * @NFTA_LOG_LEVEL: log level (NLA_U32)
+ * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
  */
 enum nft_log_attributes {
 	NFTA_LOG_UNSPEC,
@@ -704,6 +706,8 @@ enum nft_log_attributes {
 	NFTA_LOG_PREFIX,
 	NFTA_LOG_SNAPLEN,
 	NFTA_LOG_QTHRESHOLD,
+	NFTA_LOG_LEVEL,
+	NFTA_LOG_FLAGS,
 	__NFTA_LOG_MAX
 };
 #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
diff --git a/src/expr/log.c b/src/expr/log.c
index 5032fa7..740db03 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -26,6 +26,8 @@ struct nft_expr_log {
 	uint32_t		snaplen;
 	uint16_t		group;
 	uint16_t		qthreshold;
+	uint32_t		level;
+	uint32_t		flags;
 	const char		*prefix;
 };
 
@@ -50,6 +52,12 @@ static int nft_rule_expr_log_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LOG_QTHRESHOLD:
 		log->qthreshold = *((uint16_t *)data);
 		break;
+	case NFT_EXPR_LOG_LEVEL:
+		log->level = *((uint32_t *)data);
+		break;
+	case NFT_EXPR_LOG_FLAGS:
+		log->flags = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -75,6 +83,12 @@ nft_rule_expr_log_get(const struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LOG_QTHRESHOLD:
 		*data_len = sizeof(log->qthreshold);
 		return &log->qthreshold;
+	case NFT_EXPR_LOG_LEVEL:
+		*data_len = sizeof(log->level);
+		return &log->level;
+	case NFT_EXPR_LOG_FLAGS:
+		*data_len = sizeof(log->flags);
+		return &log->flags;
 	}
 	return NULL;
 }
@@ -102,6 +116,8 @@ static int nft_rule_expr_log_cb(const struct nlattr *attr, void *data)
 		}
 		break;
 	case NFTA_LOG_SNAPLEN:
+	case NFTA_LOG_LEVEL:
+	case NFTA_LOG_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -126,6 +142,10 @@ nft_rule_expr_log_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_LOG_SNAPLEN, htonl(log->snaplen));
 	if (e->flags & (1 << NFT_EXPR_LOG_QTHRESHOLD))
 		mnl_attr_put_u16(nlh, NFTA_LOG_QTHRESHOLD, htons(log->qthreshold));
+	if (e->flags & (1 << NFT_EXPR_LOG_LEVEL))
+		mnl_attr_put_u32(nlh, NFTA_LOG_LEVEL, htonl(log->level));
+	if (e->flags & (1 << NFT_EXPR_LOG_FLAGS))
+		mnl_attr_put_u32(nlh, NFTA_LOG_FLAGS, htonl(log->flags));
 }
 
 static int
@@ -156,6 +176,14 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		log->qthreshold = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_QTHRESHOLD]));
 		e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
 	}
+	if (tb[NFTA_LOG_LEVEL]) {
+		log->level = ntohl(mnl_attr_get_u32(tb[NFTA_LOG_LEVEL]));
+		e->flags |= (1 << NFT_EXPR_LOG_LEVEL);
+	}
+	if (tb[NFTA_LOG_FLAGS]) {
+		log->flags = ntohl(mnl_attr_get_u32(tb[NFTA_LOG_FLAGS]));
+		e->flags |= (1 << NFT_EXPR_LOG_FLAGS);
+	}
 
 	return 0;
 }
@@ -165,7 +193,7 @@ static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	const char *prefix;
-	uint32_t snaplen;
+	uint32_t snaplen, level, flags;
 	uint16_t group, qthreshold;
 
 	prefix = nft_jansson_parse_str(root, "prefix", err);
@@ -184,6 +212,14 @@ static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_t *root,
 				  &qthreshold, err) == 0)
 		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, qthreshold);
 
+	if (nft_jansson_parse_val(root, "level", NFT_TYPE_U32, &level,
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOG_LEVEL, level);
+
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &flags,
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOG_FLAGS, flags);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -197,7 +233,7 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
 {
 #ifdef XML_PARSING
 	const char *prefix;
-	uint32_t snaplen;
+	uint32_t snaplen, level;
 	uint16_t group, qthreshold;
 
 	prefix = nft_mxml_str_parse(tree, "prefix", MXML_DESCEND_FIRST,
@@ -218,6 +254,16 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
 			       err) == 0)
 		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, qthreshold);
 
+	if (nft_mxml_num_parse(tree, "level", MXML_DESCEND_FIRST, BASE_DEC,
+			       &level, NFT_TYPE_U16, NFT_XML_MAND,
+			       err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOG_LEVEL, level);
+
+	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
+			       &flags, NFT_TYPE_U16, NFT_XML_MAND,
+			       err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOG_FLAGS, flags);
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -225,14 +271,27 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
 #endif
 }
 
-static int nft_rule_expr_log_snprintf_default(char *buf, size_t len,
+static int nft_rule_expr_log_snprintf_default(char *buf, size_t size,
 					      struct nft_rule_expr *e)
 {
 	struct nft_expr_log *log = nft_expr_data(e);
+	int ret, offset = 0, len = size;
+
+	ret = snprintf(buf, len, "prefix %s ", log->prefix);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	return snprintf(buf, len, "prefix '%s' group %u snaplen %u"
-				  "qthreshold %u ",
-			log->prefix, log->group, log->snaplen, log->qthreshold);
+	if (e->flags & (1 << NFT_EXPR_LOG_GROUP)) {
+		ret = snprintf(buf + offset, len,
+			       "group %u snaplen %u qthreshold %u",
+			       log->group, log->snaplen, log->qthreshold);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else if (e->flags & (1 << NFT_EXPR_LOG_LEVEL)) {
+		ret = snprintf(buf + offset, len, "level %u flags %u",
+			       log->level, log->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 
 static int nft_rule_expr_log_snprintf_xml(char *buf, size_t size,
@@ -261,6 +320,16 @@ static int nft_rule_expr_log_snprintf_xml(char *buf, size_t size,
 			       log->qthreshold);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
+	if (e->flags & (1 << NFT_EXPR_LOG_LEVEL)) {
+		ret = snprintf(buf + offset, len, "<level>%u</level>",
+			       log->level);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LOG_FLAGS)) {
+		ret = snprintf(buf + offset, len, "<flags>%u</flags>",
+			       log->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
@@ -291,6 +360,16 @@ static int nft_rule_expr_log_snprintf_json(char *buf, size_t len,
 			       log->qthreshold);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
+	if (e->flags & (1 << NFT_EXPR_LOG_LEVEL)) {
+		ret = snprintf(buf + offset, len, "\"level\":%u,",
+			       log->level);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LOG_FLAGS)) {
+		ret = snprintf(buf + offset, len, "\"flags\":%u,",
+			       log->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 	/* Remove the last comma characther */
 	if (offset > 0)
 		offset--;
-- 
1.7.10.4

