From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH libnftables] Improved error handling and minor clean-up
Date: Wed,  8 Jan 2014 09:22:23 +0100
Message-ID: <1389169343-5705-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56699 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaAHIWh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:22:37 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so632850ead.24
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2014 00:22:36 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

XML parsing already fails when neither sreg nor dreg is sent. Add this behavior
to json_parse and meta_parse. Also, remove a redundant argument (flags) that was
passed to the snprintf-functions.

Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 src/expr/meta.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index 6899d69..45250f1 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -131,6 +131,8 @@ nft_rule_expr_meta_parse(struct nft_rule_expr *e, struct nlattr *attr)
 	} else if (tb[NFTA_META_SREG]) {
 		meta->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_META_SREG]));
 		e->flags |= (1 << NFT_EXPR_META_SREG);
+	} else {
+		return -1;
 	}
 
 	return 0;
@@ -203,6 +205,8 @@ static int nft_rule_expr_meta_json_parse(struct nft_rule_expr *e, json_t *root)
 			return -1;
 
 		nft_rule_expr_set_u32(e, NFT_EXPR_META_SREG, sreg);
+	} else {
+		return -1;
 	}
 
 	return 0;
@@ -254,7 +258,7 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 }
 
 static int
-nft_rule_expr_meta_snprintf_default(char *buf, size_t len, uint32_t flags,
+nft_rule_expr_meta_snprintf_default(char *buf, size_t len,
 				    struct nft_rule_expr *e)
 {
 	struct nft_expr_meta *meta = nft_expr_data(e);
@@ -268,7 +272,7 @@ nft_rule_expr_meta_snprintf_default(char *buf, size_t len, uint32_t flags,
 }
 
 static int
-nft_rule_expr_meta_snprintf_xml(char *buf, size_t len, uint32_t flags,
+nft_rule_expr_meta_snprintf_xml(char *buf, size_t len,
 				struct nft_rule_expr *e)
 {
 	struct nft_expr_meta *meta = nft_expr_data(e);
@@ -282,7 +286,7 @@ nft_rule_expr_meta_snprintf_xml(char *buf, size_t len, uint32_t flags,
 }
 
 static int
-nft_rule_expr_meta_snprintf_json(char *buf, size_t len, uint32_t flags,
+nft_rule_expr_meta_snprintf_json(char *buf, size_t len,
 				 struct nft_rule_expr *e)
 {
 	struct nft_expr_meta *meta = nft_expr_data(e);
@@ -302,14 +306,11 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 {
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_rule_expr_meta_snprintf_default(buf, len,
-							   flags, e);
+		return nft_rule_expr_meta_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_meta_snprintf_xml(buf, len,
-						       flags, e);
+		return nft_rule_expr_meta_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_meta_snprintf_json(buf, len,
-							flags, e);
+		return nft_rule_expr_meta_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
1.8.3.2

