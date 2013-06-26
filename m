From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 21/21] exthdr: xml: rename type node to exthdr_type
Date: Wed, 26 Jun 2013 13:37:21 +0200
Message-ID: <20130626113721.23511.76762.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54714 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752118Ab3FZLha (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:30 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch renames the <type> node in the exthdr expr to <exthdr_type>.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/exthdr.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 3cccc28..21b1d80 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -258,8 +258,9 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, char *xml)
 	exthdr->dreg = tmp;
 	e->flags |= (1 << NFT_EXPR_EXTHDR_DREG);
 
-	/* Get and set <type> */
-	node = mxmlFindElement(tree, tree, "type", NULL, NULL, MXML_DESCEND);
+	/* Get and set <exthdr_type> */
+	node = mxmlFindElement(tree, tree, "exthdr_type", NULL, NULL,
+			       MXML_DESCEND);
 	if (node == NULL) {
 		mxmlDelete(tree);
 		return -1;
@@ -323,7 +324,8 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
 	switch(type) {
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<type>%s</type><offset>%u</offset>"
+					  "<exthdr_type>%s</exthdr_type>"
+					  "<offset>%u</offset>"
 					  "<len>%u</len>",
 					exthdr->dreg,
 					exthdr_type2str(exthdr->type),

