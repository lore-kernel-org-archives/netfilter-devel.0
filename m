From: Ana Rey <anarey@gmail.com>
Subject: [PATCH v2 1/2] src: expr: log: Code refactoring to use nft_rule_expr_set_* functions
Date: Mon,  2 Jun 2014 12:11:32 +0200
Message-ID: <1401703893-17050-2-git-send-email-anarey@gmail.com>
References: <1401703893-17050-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:52271 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaFBKLo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:11:44 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so4989594wes.1
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2014 03:11:42 -0700 (PDT)
In-Reply-To: <1401703893-17050-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Code refactoring to use nft_rule_expr_set_* in parse functions.

This change was supported by Arturo Borrero Gonzalez.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/log.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index a61a8d3..bf18b42 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -133,6 +133,9 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
 {
 	struct nft_expr_log *log = nft_expr_data(e);
 	struct nlattr *tb[NFTA_LOG_MAX+1] = {};
+	const char *prefix;
+	uint32_t snaplen;
+	uint16_t uval16;
 
 	if (mnl_attr_parse_nested(attr, nft_rule_expr_log_cb, tb) < 0)
 		return -1;
@@ -141,20 +144,20 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
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
+		uval16 = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));
+		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, uval16);
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
+		uval16 = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_QTHRESHOLD]));
+		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, uval16);
 	}
 
 	return 0;
@@ -211,30 +214,25 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
 				    NFT_XML_MAND, err);
 	if (prefix == NULL)
 		return -1;
-
-	log->prefix = strdup(prefix);
-	e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
+	nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
 
 	if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
 			       &log->group, NFT_TYPE_U16, NFT_XML_MAND,
 			       err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LOG_GROUP);
+	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, log->group);
 
 	if (nft_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
 			       &log->snaplen, NFT_TYPE_U32, NFT_XML_MAND,
 			       err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
+	nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, log->snaplen);
 
 	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST,
 			       BASE_DEC, &log->qthreshold,
 			       NFT_TYPE_U16, NFT_XML_MAND, err) != 0)
 		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
+	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, log->qthreshold);
 
 	return 0;
 #else
-- 
2.0.0.rc2

