From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] src: cleanup in mxml and jansson regarding set_id
 parsing
Date: Fri, 10 Oct 2014 21:43:44 +0200
Message-ID: <20141010194344.31948.59069.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, alvaroneay@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45976 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753961AbaJJTny (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:43:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jansson.c: In function 'nft_jansson_expr_parse':
jansson.c:212:6: warning: pointer targets in passing argument 3 of 'nft_set_lookup_id' differ in signedness [-Wpointer-sign]
In file included from jansson.c:10:0:
./internal.h:95:5: note: expected 'uint32_t *' but argument is of type 'int *'
jansson.c:195:18: warning: unused variable 'set_cur' [-Wunused-variable]
mxml.c: In function 'nft_mxml_expr_parse':
mxml.c:97:6: warning: pointer targets in passing argument 3 of 'nft_set_lookup_id' differ in signedness [-Wpointer-sign]
In file included from mxml.c:12:0:
internal.h:95:5: note: expected 'uint32_t *' but argument is of type 'int *'
mxml.c:68:18: warning: unused variable 'set_cur' [-Wunused-variable]

Spotted with: gcc (Debian 4.7.2-5) 4.7.2

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/jansson.c |    4 ++--
 src/mxml.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/jansson.c b/src/jansson.c
index 728de12..4c7968a 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -192,8 +192,8 @@ struct nft_rule_expr *nft_jansson_expr_parse(json_t *root,
 {
 	struct nft_rule_expr *e;
 	const char *type;
-	struct nft_set *set_cur = NULL;
-	int ret, set_id;
+	uint32_t set_id;
+	int ret;
 
 	type = nft_jansson_parse_str(root, "type", err);
 	if (type == NULL)
diff --git a/src/mxml.c b/src/mxml.c
index 22d482f..a97d380 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -65,8 +65,8 @@ struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 	struct nft_rule_expr *e;
 	const char *expr_name;
 	char *xml_text;
-	struct nft_set *set_cur = NULL;
-	int ret, set_id;
+	uint32_t set_id;
+	int ret;
 
 	expr_name = mxmlElementGetAttr(node, "type");
 	if (expr_name == NULL) {

