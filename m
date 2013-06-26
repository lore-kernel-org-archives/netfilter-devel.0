From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 07/21] nat: xml: change IP range node names
Date: Wed, 26 Jun 2013 13:37:04 +0200
Message-ID: <20130626113704.23511.18557.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54671 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817Ab3FZLhM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:12 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes the name of XML nodes from <sreg_addr_min_v4> to <sreg_addr_min>,
and <sreg_addr_max_v4> to <sreg_addr_max>, as they are protocol-independent.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/nat.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index f38011a..7d83154 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -262,8 +262,8 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 	nat->family = nft_str2family(node->child->value.opaque);
 	e->flags |= (1 << NFT_EXPR_NAT_FAMILY);
 
-	/* Get and set <sreg_addr_min_v4>. Not mandatory */
-	node = mxmlFindElement(tree, tree, "sreg_addr_min_v4", NULL, NULL,
+	/* Get and set <sreg_addr_min>. Not mandatory */
+	node = mxmlFindElement(tree, tree, "sreg_addr_min", NULL, NULL,
 			       MXML_DESCEND);
 	if (node != NULL) {
 		tmp = strtoull(node->child->value.opaque, &endptr, 10);
@@ -276,8 +276,8 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 		e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MIN);
 	}
 
-	/* Get and set <sreg_addr_max_v4>. Not mandatory */
-	node = mxmlFindElement(tree, tree, "sreg_addr_max_v4", NULL, NULL,
+	/* Get and set <sreg_addr_max>. Not mandatory */
+	node = mxmlFindElement(tree, tree, "sreg_addr_max", NULL, NULL,
 			       MXML_DESCEND);
 	if (node != NULL) {
 		tmp = strtoull(node->child->value.opaque, &endptr, 10);
@@ -348,8 +348,8 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
 		ret = snprintf(buf+offset, len,
-				"<sreg_addr_min_v4>%u</sreg_addr_min_v4>"
-				"<sreg_addr_max_v4>%u</sreg_addr_max_v4>",
+				"<sreg_addr_min>%u</sreg_addr_min>"
+				"<sreg_addr_max>%u</sreg_addr_max>",
 			       nat->sreg_addr_min, nat->sreg_addr_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}

