From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] expr: log: Do not print unset values in json
Date: Tue,  3 Jun 2014 17:23:47 +0200
Message-ID: <1401809027-18846-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38994 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaFCPX7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:23:59 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so6988296wgh.27
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 08:23:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changes in the parse and the snprint functions to omit unset values.

Also, Fix an unnecessary comma after key-value pair type if there
are not more key-value pairs.

Example:
"expr":[{"type":"log",}]
                    ^^^

If It uses this rule:
nft add rule ip test output log

It gets this json file:

[...]
"expr":[{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]
[...]

Now, That rule creates this json file without null values:

"expr":[{"type":"log"}]


Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/log.c | 57 +++++++++++++++++++++++++++++++++++----------------------
 src/rule.c     |  6 ++++++
 2 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index fda353b..30f325a 100644
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
@@ -282,14 +274,35 @@ static int nft_rule_expr_log_snprintf_xml(char *buf, size_t size,
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
+	if (offset > 0 ) {
+		buf[offset-1] = '\0';
+		return offset-1;
+	}
+	return offset;
 }
 
 
diff --git a/src/rule.c b/src/rule.c
index ac88abb..7ccbce3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -816,6 +816,12 @@ static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 		ret = expr->ops->snprintf(buf+offset, len, type, flags, expr);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+		if (ret == 0) {
+			buf[offset-1] = '\0';
+			offset--;
+			len--;
+		}
+
 		ret = snprintf(buf+offset, len, "},");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-- 
2.0.0.rc2

