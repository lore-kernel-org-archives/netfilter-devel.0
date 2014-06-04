From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2] expr: log: Do not print unset values in json
Date: Wed,  4 Jun 2014 13:03:31 +0200
Message-ID: <1401879811-3254-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48603 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaFDLDr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:03:47 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so8372480wev.3
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jun 2014 04:03:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

Also, It fixes an unnecessary comma after key-value pair type.
This comma is not necessary if there is not more key-value pairs in this expr.

Example:
"expr":[{"type":"log"}]

If It uses this rule:
nft add rule ip test output log

It gets this json file:

[...]
{"expr":[{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}
[...]

Now, That rule creates this json file without null values:

{"expr":[{"type":"log"}]}

Signed-off-by: Ana Rey <anarey@gmail.com>
---

[Changes in v2]
* I improve a comment of code in src/rule.c
* I delete some unnecesary set to '\0' in the buffer
* I improve the text in the patch description

 src/expr/log.c | 56 ++++++++++++++++++++++++++++++++++----------------------
 src/rule.c     |  9 +++++++++
 2 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index fda353b..5aa1168 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -174,28 +174,20 @@ static int nft_rule_expr_log_json_parse(struct nft_rule_expr *e, json_t *root,
 	uint16_t qthreshold;
 
 	prefix = nft_jansson_parse_str(root, "prefix", err);
-	if (prefix == NULL)
-		return -1;
-
-	nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
+	if (prefix != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
 
 	if (nft_jansson_parse_val(root, "group", NFT_TYPE_U16, &group,
-				  err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, group);
+				  err) == 0)
+		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, group);
 
 	if (nft_jansson_parse_val(root, "snaplen", NFT_TYPE_U32, &snaplen,
-				  err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
 
 	if (nft_jansson_parse_val(root, "qthreshold", NFT_TYPE_U16,
-				  &qthreshold, err) < 0)
-		return -1;
-
-	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, qthreshold);
+				  &qthreshold, err) == 0)
+		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, qthreshold);
 
 	return 0;
 #else
@@ -282,14 +274,34 @@ static int nft_rule_expr_log_snprintf_xml(char *buf, size_t size,
 static int nft_rule_expr_log_snprintf_json(char *buf, size_t len,
 					   struct nft_rule_expr *e)
 {
+	int ret, size = len, offset = 0;
 	struct nft_expr_log *log = nft_expr_data(e);
 
-	return snprintf(buf, len, "\"prefix\":\"%s\","
-				  "\"group\":%u,"
-				  "\"snaplen\":%u,"
-				  "\"qthreshold\":%u",
-			log->prefix, log->group,
-			log->snaplen, log->qthreshold);
+        if (e->flags & (1 << NFT_EXPR_LOG_PREFIX)) {
+                ret = snprintf(buf+offset, len, "\"prefix\":\"%s\",",
+                               log->prefix);
+                SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+        }
+        if (e->flags & (1 << NFT_EXPR_LOG_GROUP)) {
+                ret = snprintf(buf+offset, len, "\"group\":%u,",
+                               log->group);
+                SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+        }
+        if (e->flags & (1 << NFT_EXPR_LOG_SNAPLEN)) {
+                ret = snprintf(buf+offset, len, "\"snaplen\":%u,",
+                               log->snaplen);
+                SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+        }
+        if (e->flags & (1 << NFT_EXPR_LOG_QTHRESHOLD)) {
+                ret = snprintf(buf+offset, len, "\"qthreshold\":%u,",
+                               log->qthreshold);
+                SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+        }
+	/* Remove the last comma characther */
+	if (offset > 0)
+		return offset-1;
+
+	return offset;
 }
 
 
diff --git a/src/rule.c b/src/rule.c
index ac88abb..88e9f71 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -816,6 +816,15 @@ static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 		ret = expr->ops->snprintf(buf+offset, len, type, flags, expr);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+		/*
+		 * Remove comma from the first element if there is type
+		 * key-value pair only. Example: "expr":[{"type":"log"}]
+		 */
+		if (ret == 0) {
+			offset--;
+			len--;
+		}
+
 		ret = snprintf(buf+offset, len, "},");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-- 
2.0.0.rc2

