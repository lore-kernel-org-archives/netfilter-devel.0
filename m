From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 15/21] target&match: xml: don't print rev number
Date: Wed, 26 Jun 2013 13:37:14 +0200
Message-ID: <20130626113714.23511.27907.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54700 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032Ab3FZLhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:22 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The <rev> node is not printed/parsed anymore.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/match.c         |   18 +-----------------
 src/expr/target.c        |   20 +-------------------
 test/nft-rule-xml-add.sh |    6 ------
 3 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index 165d24d..7b4377f 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -190,8 +190,6 @@ static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, char *xml)
 	struct nft_expr_match *mt = (struct nft_expr_match *)e->data;
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
-	uint64_t tmp;
-	char *endptr;
 
 	/* load the tree */
 	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
@@ -218,19 +216,6 @@ static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, char *xml)
 		e->flags |= (1 << NFT_EXPR_MT_NAME);
 	}
 
-	/* get and set <rev>. Not mandatory */
-	node = mxmlFindElement(tree, tree, "rev", NULL, NULL, MXML_DESCEND);
-	if (node != NULL) {
-		tmp = strtoull(node->child->value.opaque, &endptr, 10);
-		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
-			mxmlDelete(tree);
-			return -1;
-		}
-
-		mt->rev = (uint32_t)tmp;
-		e->flags |= (1 << NFT_EXPR_MT_REV);
-	}
-
 	/* mt->info is ignored until other solution is reached */
 
 	mxmlDelete(tree);
@@ -247,8 +232,7 @@ static int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 	int ret, size=len;
 	int offset = 0;
 
-	ret = snprintf(buf, len, "<name>%s</name><rev>%u</rev>",
-				mt->name, mt->rev);
+	ret = snprintf(buf, len, "<name>%s</name>", mt->name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
diff --git a/src/expr/target.c b/src/expr/target.c
index 8c454a9..ed29f6d 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -191,8 +191,6 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, char *xml)
 	struct nft_expr_target *tg = (struct nft_expr_target *)e->data;
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
-	uint64_t tmp;
-	char *endptr;
 
 	/* load the tree */
 	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
@@ -219,21 +217,6 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, char *xml)
 		e->flags |= (1 << NFT_EXPR_TG_NAME);
 	}
 
-	/* Get and set <rev>. Optional */
-	node = mxmlFindElement(tree, tree, "rev", NULL, NULL,
-			       MXML_DESCEND);
-	if (node == NULL) {
-		errno = 0;
-		tmp = strtoull(node->child->value.opaque, &endptr, 10);
-		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
-			mxmlDelete(tree);
-			return -1;
-		}
-
-		tg->rev = (uint32_t)tmp;
-		e->flags |= (1 << NFT_EXPR_TG_REV);
-	}
-
 	/* tg->info is ignored until other solution is reached */
 
 	mxmlDelete(tree);
@@ -251,8 +234,7 @@ int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 	int ret, size=len;
 	int offset = 0;
 
-	ret = snprintf(buf, len, "<name>%s</name><rev>%u</rev>",
-			tg->name, tg->rev);
+	ret = snprintf(buf, len, "<name>%s</name>", tg->name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
diff --git a/test/nft-rule-xml-add.sh b/test/nft-rule-xml-add.sh
index 0bd08ff..322e70c 100755
--- a/test/nft-rule-xml-add.sh
+++ b/test/nft-rule-xml-add.sh
@@ -101,9 +101,6 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
   </expr>
   <expr type=\"match\">
     <name>state</name>
-    <rev>0</rev>
-    <info>
-    </info>
   </expr>
   <expr type=\"counter\">
     <pkts>123123</pkts>
@@ -111,9 +108,6 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
   </expr>
   <expr type=\"target\">
     <name>LOG</name>
-    <rev>0</rev>
-    <info>
-    </info>
   </expr>
 </rule>"
 

