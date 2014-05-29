From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/2] src: expr: log: Do not print unset values in xml.
Date: Thu, 29 May 2014 13:26:40 +0200
Message-ID: <1401362800-30749-3-git-send-email-anarey@gmail.com>
References: <1401362800-30749-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47136 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbaE2L07 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 07:26:59 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so224630wgg.25
        for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2014 04:26:58 -0700 (PDT)
In-Reply-To: <1401362800-30749-1-git-send-email-anarey@gmail.com>
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
 src/expr/log.c | 56 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index a61a8d3..cd259d4 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -209,32 +209,25 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
 
 	prefix = nft_mxml_str_parse(tree, "prefix", MXML_DESCEND_FIRST,
 				    NFT_XML_MAND, err);
-	if (prefix == NULL)
-		return -1;
-
-	log->prefix = strdup(prefix);
-	e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
+	if (prefix != NULL) {
+		log->prefix = strdup(prefix);
+		e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
+	}
 
 	if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
 			       &log->group, NFT_TYPE_U16, NFT_XML_MAND,
-			       err) != 0)
-		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LOG_GROUP);
+			       err) >= 0)
+		e->flags |= (1 << NFT_EXPR_LOG_GROUP);
 
 	if (nft_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
 			       &log->snaplen, NFT_TYPE_U32, NFT_XML_MAND,
-			       err) != 0)
-		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
+			       err) >= 0)
+		e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
 
 	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST,
 			       BASE_DEC, &log->qthreshold,
-			       NFT_TYPE_U16, NFT_XML_MAND, err) != 0)
-		return -1;
-
-	e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
+			       NFT_TYPE_U16, NFT_XML_MAND, err) >= 0)
+		e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
 
 	return 0;
 #else
@@ -256,14 +249,31 @@ static int nft_rule_expr_log_snprintf_default(char *buf, size_t len,
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
+		}
+
+	return offset;
 }
 
 static int nft_rule_expr_log_snprintf_json(char *buf, size_t len,
-- 
2.0.0.rc2

