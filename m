From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 08/21] byteorder: xml: op as string
Date: Wed, 26 Jun 2013 13:37:05 +0200
Message-ID: <20130626113705.23511.83384.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54675 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032Ab3FZLhO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:14 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes the numerical value of the XML byteorder's <op> node to a string representation.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/byteorder.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index c2f38a8..b0ba009 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -196,6 +196,11 @@ nft_rule_expr_byteorder_parse(struct nft_rule_expr *e, struct nlattr *attr)
 	return ret;
 }
 
+static char *expr_byteorder_str[] = {
+	[NFT_BYTEORDER_HTON] = "hton",
+	[NFT_BYTEORDER_NTOH] = "ntoh",
+};
+
 static int
 nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, char *xml)
 {
@@ -249,11 +254,13 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, char *xml)
 	if (node == NULL)
 		goto err;
 
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr)
+	if (strcmp(node->child->value.opaque, "ntoh") == 0)
+		byteorder->op = NFT_BYTEORDER_NTOH;
+	else if (strcmp(node->child->value.opaque, "hton") == 0)
+		byteorder->op = NFT_BYTEORDER_HTON;
+	else
 		goto err;
 
-	byteorder->op = tmp;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_OP);
 
 	node = mxmlFindElement(tree, tree, "len", NULL, NULL, MXML_DESCEND);
@@ -298,10 +305,11 @@ nft_rule_expr_byteorder_snprintf_xml(char *buf, size_t size,
 
 	ret = snprintf(buf, len, "<sreg>%u</sreg>"
 				 "<dreg>%u</dreg>"
-				 "<op>%u</op>"
+				 "<op>%s</op>"
 				 "<len>%u</len>"
 				 "<size>%u</size>",
-		       byteorder->sreg, byteorder->dreg, byteorder->op,
+		       byteorder->sreg, byteorder->dreg,
+		       expr_byteorder_str[byteorder->op],
 		       byteorder->len, byteorder->size);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -314,8 +322,9 @@ nft_rule_expr_byteorder_snprintf_default(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "sreg=%u dreg=%u op=%u len=%u size=%u ",
-		       byteorder->sreg, byteorder->dreg, byteorder->op,
+	ret = snprintf(buf, len, "sreg=%u dreg=%u op=%s len=%u size=%u ",
+		       byteorder->sreg, byteorder->dreg,
+		       expr_byteorder_str[byteorder->op],
 		       byteorder->len, byteorder->size);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 

