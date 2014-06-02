From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v3 2/2] src: expr: log: Do not print unset values in xml.
Date: Mon,  2 Jun 2014 14:06:10 +0200
Message-ID: <1401710770-23662-3-git-send-email-anarey@gmail.com>
References: <1401710770-23662-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58796 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBMGq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:06:46 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so5009414wgh.19
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2014 05:06:45 -0700 (PDT)
In-Reply-To: <1401710770-23662-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It changes the parse and the snprint functions to omit unset values.

If we used this rule:
ntt add rule ip test output log

We got this xml file:

<rule><family>ip</family>
<table>test</table>
<chain>output</chain>
<handle>88</handle>
<expr type="log">
	<prefix>(null)</prefix>
	<group>0</group>
	<snaplen>0</snaplen>
	<qthreshold>0</qthreshold>
</expr>
</rule>

And It was imposible import this file.

Now, That rule creates this xml file without null values:

<rule><family>ip</family>
<table>test</table>
<chain>output</chain>
<handle>88</handle>
<expr type="log">
</expr>
</rule>

and It's possible import this xml file.

Signed-off-by: Ana Rey <anarey@gmail.com>
---

[Changes in v3]
Fix wrong indentation.

[Changes in v2]
This patch has some changes that derive from the previous
"src: expr: log: Code refactoring to use nft_rule_expr_set_* functions"
patch.



 src/expr/log.c | 57 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index 0b7c646..12e9990 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -214,27 +214,25 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
 
 	prefix = nft_mxml_str_parse(tree, "prefix", MXML_DESCEND_FIRST,
 				    NFT_XML_MAND, err);
-	if (prefix == NULL)
-		return -1;
-	nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
+	if (prefix != NULL)
+		nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
 
 	if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
 			       &log->group, NFT_TYPE_U16, NFT_XML_MAND,
-			       err) != 0)
-		return -1;
-	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, log->group);
+			       err) == 0)
+		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, log->group);
 
 	if (nft_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
 			       &log->snaplen, NFT_TYPE_U32, NFT_XML_MAND,
-			       err) != 0)
-		return -1;
-	nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, log->snaplen);
-
-	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST,
-			       BASE_DEC, &log->qthreshold,
-			       NFT_TYPE_U16, NFT_XML_MAND, err) != 0)
-		return -1;
-	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, log->qthreshold);
+			       err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, log->snaplen);
+
+	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST, BASE_DEC,
+			       &log->qthreshold, NFT_TYPE_U16, NFT_XML_MAND,
+			       err) == 0) {
+		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD,
+				      log->qthreshold);
+	}
 
 	return 0;
 #else
@@ -256,14 +254,31 @@ static int nft_rule_expr_log_snprintf_default(char *buf, size_t len,
 static int nft_rule_expr_log_snprintf_xml(char *buf, size_t size,
 					  struct nft_rule_expr *e)
 {
+	int ret, len = size, offset = 0;
 	struct nft_expr_log *log = nft_expr_data(e);
 
-	return snprintf(buf, size, "<prefix>%s</prefix>"
-				   "<group>%u</group>"
-				   "<snaplen>%u</snaplen>"
-				   "<qthreshold>%u</qthreshold>",
-			log->prefix, log->group,
-			log->snaplen, log->qthreshold);
+	if (e->flags & (1 << NFT_EXPR_LOG_PREFIX)) {
+		ret = snprintf(buf+offset, len, "<prefix>%s</prefix>",
+			       log->prefix);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LOG_GROUP)) {
+		ret = snprintf(buf+offset, len, "<group>%u</group>",
+			       log->group);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LOG_SNAPLEN)) {
+		ret = snprintf(buf+offset, len, "<snaplen>%u</snaplen>",
+			       log->snaplen);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	if (e->flags & (1 << NFT_EXPR_LOG_QTHRESHOLD)) {
+		ret = snprintf(buf+offset, len, "<qthreshold>%u</qthreshold>",
+			       log->qthreshold);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 
 static int nft_rule_expr_log_snprintf_json(char *buf, size_t len,
-- 
2.0.0.rc2

