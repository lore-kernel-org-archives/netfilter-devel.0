From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v4 1/3] expr: log: Rename variables in nft_rule_expr_log_json_parse functions
Date: Tue,  3 Jun 2014 12:41:54 +0200
Message-ID: <1401792116-17742-2-git-send-email-anarey@gmail.com>
References: <1401792116-17742-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48159 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaFCKmH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:42:07 -0400
Received: by mail-wg0-f51.google.com with SMTP id x13so6546182wgg.10
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:42:06 -0700 (PDT)
In-Reply-To: <1401792116-17742-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Renames some variables for code readability reasons.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/log.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index a61a8d3..eaba1d6 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -166,7 +166,8 @@ static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_t *root,
 #ifdef JSON_PARSING
 	const char *prefix;
 	uint32_t snaplen;
-	uint16_t uval16;
+	uint16_t group;
+	uint16_t qthreshold;
 
 	prefix = nft_jansson_parse_str(root, "prefix", err);
 	if (prefix == NULL)
@@ -174,11 +175,11 @@ static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_t *root,
 
 	nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
 
-	if (nft_jansson_parse_val(root, "group", NFT_TYPE_U16, &uval16,
+	if (nft_jansson_parse_val(root, "group", NFT_TYPE_U16, &group,
 				  err) < 0)
 		return -1;
 
-	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, uval16);
+	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, group);
 
 	if (nft_jansson_parse_val(root, "snaplen", NFT_TYPE_U32, &snaplen,
 				  err) < 0)
@@ -187,10 +188,10 @@ static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_t *root,
 	nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
 
 	if (nft_jansson_parse_val(root, "qthreshold", NFT_TYPE_U16,
-				  &uval16, err) < 0)
+				  &qthreshold, err) < 0)
 		return -1;
 
-	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, uval16);
+	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, qthreshold);
 
 	return 0;
 #else
-- 
2.0.0.rc2

