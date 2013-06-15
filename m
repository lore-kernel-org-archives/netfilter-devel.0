From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] expr: bitwise: xml_parse: fix casting
Date: Sat, 15 Jun 2013 02:36:13 +0200
Message-ID: <20130615003613.27171.26876.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60748 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752497Ab3FOAgT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jun 2013 20:36:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not calling e->data when doing the casting causes memory corruption: segfault.

This was introduced at: 51370f0eedb1c8167ab2c340d2a53f0d9f02509c (src: add support for XML parsing)

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/bitwise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 9ebe3dc..1429483 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -200,7 +200,7 @@ static int
 nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
 {
 #ifdef XML_PARSING
-	struct nft_expr_bitwise *bitwise = (struct nft_expr_bitwise *)e;
+	struct nft_expr_bitwise *bitwise = (struct nft_expr_bitwise *)e->data;
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 	mxml_node_t *save = NULL;

