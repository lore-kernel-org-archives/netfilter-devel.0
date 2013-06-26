From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 20/21] nat: xml: rename node type to nat_type
Date: Wed, 26 Jun 2013 13:37:20 +0200
Message-ID: <20130626113720.23511.39084.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54712 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752189Ab3FZLh2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:28 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch renames the node <type> to a more explicit <nat_type>.

This will prevent in the future from confusing other <type> nodes from other exprs.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/nat.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index 378d053..b81fd81 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -228,8 +228,8 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
-	/* Get and set <type>. Mandatory */
-	node = mxmlFindElement(tree, tree, "type", NULL, NULL,
+	/* Get and set <nat_type>. Mandatory */
+	node = mxmlFindElement(tree, tree, "nat_type", NULL, NULL,
 			       MXML_DESCEND_FIRST);
 	if (node == NULL) {
 		mxmlDelete(tree);
@@ -334,11 +334,11 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 
 	/* Is a mandatory element. Provide a default, even empty */
 	if (nat->type == NFT_NAT_SNAT)
-		ret = snprintf(buf, len, "<type>snat</type>");
+		ret = snprintf(buf, len, "<nat_type>snat</nat_type>");
 	else if (nat->type == NFT_NAT_DNAT)
-		ret = snprintf(buf, len, "<type>dnat</type>");
+		ret = snprintf(buf, len, "<nat_type>dnat</nat_type>");
 	else
-		ret = snprintf(buf, len, "<type/>");
+		ret = snprintf(buf, len, "<nat_type/>");
 
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 

