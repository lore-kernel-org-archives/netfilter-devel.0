From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/3] nat: xml: fix non-mandatory element
Date: Sat, 15 Jun 2013 03:16:10 +0200
Message-ID: <20130615011610.3778.37555.stgit@nfdev.cica.es>
References: <20130615011603.3778.67261.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54367 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752857Ab3FOBQM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:16:12 -0400
In-Reply-To: <20130615011603.3778.67261.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the node isn't present, this produces segfault.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/nat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index cd38e83..a76f5b5 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -258,7 +258,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 	/* Get and set <sreg_addr_min_v4>. Not mandatory */
 	node = mxmlFindElement(tree, tree, "sreg_addr_min_v4", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
+	if (node != NULL) {
 		tmp = strtoull(node->child->value.opaque, &endptr, 10);
 		if (tmp > UINT32_MAX || tmp < 0 || *endptr)
 			goto err;
@@ -270,7 +270,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 	/* Get and set <sreg_addr_max_v4>. Not mandatory */
 	node = mxmlFindElement(tree, tree, "sreg_addr_max_v4", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
+	if (node != NULL) {
 		tmp = strtoull(node->child->value.opaque, &endptr, 10);
 		if (tmp > UINT32_MAX || tmp < 0 || *endptr)
 			goto err;
@@ -282,7 +282,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 	/* Get and set <sreg_proto_min>. Not mandatory */
 	node = mxmlFindElement(tree, tree, "sreg_proto_min", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
+	if (node != NULL) {
 		tmp = strtoull(node->child->value.opaque, &endptr, 10);
 		if (tmp > UINT32_MAX || tmp < 0 || *endptr)
 			goto err;
@@ -294,7 +294,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 	/* Get and set <sreg_proto_max>. Not mandatory */
 	node = mxmlFindElement(tree, tree, "sreg_proto_max", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
+	if (node != NULL) {
 		tmp = strtoull(node->child->value.opaque, &endptr, 10);
 		if (tmp > UINT32_MAX || tmp < 0 || *endptr)
 			goto err;

