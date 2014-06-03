From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v4 2/3] expr: log: Use nft_rule_expr_set_* in the xml parsing code
Date: Tue,  3 Jun 2014 12:41:55 +0200
Message-ID: <1401792116-17742-3-git-send-email-anarey@gmail.com>
References: <1401792116-17742-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63011 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaFCKmJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:42:09 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so6159087wiv.15
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:42:08 -0700 (PDT)
In-Reply-To: <1401792116-17742-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

Signed-off-by: Ana Rey <anarey@gmail.com>
Suggested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/log.c | 49 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index eaba1d6..392bb14 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -133,6 +133,10 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
 {
 	struct nft_expr_log *log = nft_expr_data(e);
 	struct nlattr *tb[NFTA_LOG_MAX+1] = {};
+	const char *prefix;
+	uint32_t snaplen;
+	uint16_t group;
+	uint16_t qthreshold;
 
 	if (mnl_attr_parse_nested(attr, nft_rule_expr_log_cb, tb) < 0)
 		return -1;
@@ -141,20 +145,20 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		if (log->prefix)
 			xfree(log->prefix);
 
-		log->prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
-		e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
+		prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
+		nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
 	}
 	if (tb[NFTA_LOG_GROUP]) {
-		log->group = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));
-		e->flags |= (1 << NFT_EXPR_LOG_GROUP);
+		group = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));
+		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, group);
 	}
 	if (tb[NFTA_LOG_SNAPLEN]) {
-		log->snaplen = ntohl(mnl_attr_get_u32(tb[NFTA_LOG_SNAPLEN]));
-		e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
+		snaplen = ntohl(mnl_attr_get_u32(tb[NFTA_LOG_SNAPLEN]));
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
 	}
 	if (tb[NFTA_LOG_QTHRESHOLD]) {
-		log->qthreshold = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_QTHRESHOLD]));
-		e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
+		qthreshold = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_QTHRESHOLD]));
+		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, qthreshold);
 	}
 
 	return 0;
@@ -205,37 +209,32 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
 				       struct nft_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nft_expr_log *log = nft_expr_data(e);
 	const char *prefix;
+	uint32_t snaplen;
+	uint16_t group;
+	uint16_t qthreshold;
 
 	prefix = nft_mxml_str_parse(tree, "prefix", MXML_DESCEND_FIRST,
 				    NFT_XML_MAND, err);
 	if (prefix == NULL)
 		return -1;
-
-	log->prefix = strdup(prefix);
-	e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
+	nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
 
 	if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
-			       &log->group, NFT_TYPE_U16, NFT_XML_MAND,
-			       err) != 0)
+			       &group, NFT_TYPE_U16, NFT_XML_MAND, err) < 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LOG_GROUP);
+	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, group);
 
 	if (nft_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
-			       &log->snaplen, NFT_TYPE_U32, NFT_XML_MAND,
-			       err) != 0)
+			       &snaplen, NFT_TYPE_U32, NFT_XML_MAND, err) < 0)
 		return -1;
+	nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
 
-	e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
-
-	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST,
-			       BASE_DEC, &log->qthreshold,
-			       NFT_TYPE_U16, NFT_XML_MAND, err) != 0)
+	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST, BASE_DEC,
+			       &qthreshold, NFT_TYPE_U16, NFT_XML_MAND,
+			       err) < 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
+	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, qthreshold);
 
 	return 0;
 #else
-- 
2.0.0.rc2

