From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/2] lookup: xml: conditional output of dreg
Date: Wed, 15 Jan 2014 11:42:22 +0100
Message-ID: <20140115104222.14095.22329.stgit@nfdev.cica.es>
References: <20140115104217.14095.79271.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@nefilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43281 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750920AbaAOKmb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:42:31 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 875B751ED5B
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 10:42:30 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bvzQQhWQqxGe for <netfilter-devel@vger.kernel.org>;
	Wed, 15 Jan 2014 11:42:25 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 7007851ED5E
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 11:42:25 +0100 (CET)
In-Reply-To: <20140115104217.14095.79271.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The dreg attribute is optional as stated at:
 net/netfilter/nf_lookup.c

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/lookup.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 546066a..0e53f58 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -213,41 +213,59 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 
 static int
 nft_rule_expr_lookup_snprintf_json(char *buf, size_t size,
-				  struct nft_expr_lookup *l)
+				   struct nft_rule_expr *e)
 {
 	int len = size, offset = 0, ret;
+	struct nft_expr_lookup *l = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "\"set\":\"%s\",\"sreg\":%u,\"dreg\":%u",
-			l->set_name, l->sreg, l->dreg);
+	ret = snprintf(buf, len, "\"set\":\"%s\",\"sreg\":%u",
+			l->set_name, l->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_DREG)) {
+		ret = snprintf(buf+offset, len, ",\"dreg\":%u", l->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
 
 static int
 nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
-				  struct nft_expr_lookup *l)
+				  struct nft_rule_expr *e)
 {
 	int len = size, offset = 0, ret;
+	struct nft_expr_lookup *l = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "<set>%s</set><sreg>%u</sreg><dreg>%u</dreg>",
-			l->set_name, l->sreg, l->dreg);
+	ret = snprintf(buf, len, "<set>%s</set><sreg>%u</sreg>",
+		       l->set_name, l->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_DREG)) {
+		ret = snprintf(buf+offset, len, "<dreg>%u</dreg>", l->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
 static int
 nft_rule_expr_lookup_snprintf_default(char *buf, size_t size,
-				      struct nft_expr_lookup *l)
+				      struct nft_rule_expr *e)
 {
 	int len = size, offset = 0, ret;
+	struct nft_expr_lookup *l = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "reg %u set %s dreg %u ",
-			l->sreg, l->set_name, l->dreg);
+	ret = snprintf(buf, len, "reg %u set %s ", l->sreg, l->set_name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+
+	if (e->flags & (1 << NFT_EXPR_LOOKUP_DREG)) {
+		ret = snprintf(buf+offset, len, "dreg %u ", l->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
@@ -255,15 +273,14 @@ static int
 nft_rule_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_lookup *lookup = nft_expr_data(e);
 
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_rule_expr_lookup_snprintf_default(buf, size, lookup);
+		return nft_rule_expr_lookup_snprintf_default(buf, size, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_lookup_snprintf_xml(buf, size, lookup);
+		return nft_rule_expr_lookup_snprintf_xml(buf, size, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_lookup_snprintf_json(buf, size, lookup);
+		return nft_rule_expr_lookup_snprintf_json(buf, size, e);
 	default:
 		break;
 	}

