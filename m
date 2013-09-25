From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/2] src: snprintf: fix buffer lengths
Date: Thu, 26 Sep 2013 00:13:08 +0200
Message-ID: <20130925221308.16997.11502.stgit@nfdev.cica.es>
References: <20130925221302.16997.17406.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34153 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755983Ab3IYWNR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:13:17 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 2168E51ED6B
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2013 22:13:16 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8zN1eKQYaaXZ for <netfilter-devel@vger.kernel.org>;
	Thu, 26 Sep 2013 00:13:10 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 462EC51ED81
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2013 00:13:10 +0200 (CEST)
In-Reply-To: <20130925221302.16997.17406.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use 'len' instead of 'size' as length of the buffer to print.

While at it, fix invalid JSON offset in snprintf for sets and some
other minor style issues, such as bad indentations.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c    |   20 +++++++++-----------
 src/expr/ct.c  |    6 +++---
 src/rule.c     |   12 +++++++-----
 src/set.c      |   32 +++++++++++++++++---------------
 src/set_elem.c |   22 +++++++++++-----------
 5 files changed, 47 insertions(+), 45 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 8c0d804..874116a 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -753,7 +753,7 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 {
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, size,
+	ret = snprintf(buf, len,
 		"{ \"chain\": {"
 			"\"name\": \"%s\","
 			"\"handle\": %"PRIu64","
@@ -768,7 +768,7 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
-		ret =  snprintf(buf+offset, size,
+		ret =  snprintf(buf+offset, len,
 				",\"type\": \"%s\","
 				"\"hooknum\": \"%s\","
 				"\"prio\": %d,"
@@ -778,9 +778,7 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size,
-		"}"
-		"}");
+	ret = snprintf(buf+offset, len, "}}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -790,14 +788,14 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 {
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, size, "<chain><name>%s</name>"
+	ret = snprintf(buf, len, "<chain><name>%s</name>"
 		       "<handle>%"PRIu64"</handle><bytes>%"PRIu64"</bytes>"
 		       "<packets>%"PRIu64"</packets><table>%s</table>",
 		       c->name, c->handle, c->bytes, c->packets, c->table);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
-		ret =  snprintf(buf+offset, size,
+		ret =  snprintf(buf+offset, len,
 				"<type>%s</type>"
 				"<hooknum>%s</hooknum>"
 				"<prio>%d</prio>"
@@ -807,7 +805,7 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size, "<family>%s</family></chain>",
+	ret = snprintf(buf+offset, len, "<family>%s</family></chain>",
 		       nft_family2str(c->family));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -819,12 +817,12 @@ static int nft_chain_snprintf_default(char *buf, size_t size,
 {
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, size, "%s %s %s",
-			nft_family2str(c->family), c->table, c->name);
+	ret = snprintf(buf, len, "%s %s %s",
+		       nft_family2str(c->family), c->table, c->name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {
-		ret = snprintf(buf+offset, size,
+		ret = snprintf(buf+offset, len,
 			       " type %s hook %s prio %d policy %s use %d "
 			       "packets %"PRIu64" bytes %"PRIu64"",
 			       c->type, nft_hooknum2str(c->family, c->hooknum),
diff --git a/src/expr/ct.c b/src/expr/ct.c
index ccefa1b..bf18c7e 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -279,17 +279,17 @@ nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
 	int ret, len = size, offset = 0;
 	struct nft_expr_ct *ct = nft_expr_data(e);
 
-	ret = snprintf(buf, size, "\"dreg\" : %u", ct->dreg);
+	ret = snprintf(buf, len, "\"dreg\" : %u", ct->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
-		ret = snprintf(buf+offset, size, ", \"key\" : \"%s\"",
+		ret = snprintf(buf+offset, len, ", \"key\" : \"%s\"",
 						ctkey2str(ct->key));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_CT_DIR)) {
-		ret = snprintf(buf+offset, size, ", \"dir\" : %u", ct->dir);
+		ret = snprintf(buf+offset, len, ", \"dir\" : %u", ct->dir);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
diff --git a/src/rule.c b/src/rule.c
index 5fd8814..550b325 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -705,7 +705,7 @@ static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 	int ret, len = size, offset = 0;
 	struct nft_rule_expr *expr;
 
-	ret = snprintf(buf, size,
+	ret = snprintf(buf, len,
 		       "{ \"rule\": { \"family\" : \"%s\", \"table\" : \"%s\", "
 		       "\"chain\"  : \"%s\", \"handle\" : %llu,",
 		       nft_family2str(r->family), r->table, r->chain,
@@ -759,7 +759,7 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 	int ret, len = size, offset = 0;
 	struct nft_rule_expr *expr;
 
-	ret = snprintf(buf, size, "<rule><family>%s</family>"
+	ret = snprintf(buf, len, "<rule><family>%s</family>"
 		       "<table>%s</table><chain>%s</chain>"
 		       "<handle>%llu</handle><flags>%u</flags>",
 		       nft_family2str(r->family), r->table, r->chain,
@@ -786,7 +786,8 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 				"<expr type=\"%s\">", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = nft_rule_expr_snprintf(buf+offset, size, expr, type, flags);
+		ret = nft_rule_expr_snprintf(buf+offset, len, expr,
+					     type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = snprintf(buf+offset, len, "</expr>");
@@ -805,7 +806,7 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 	struct nft_rule_expr *expr;
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, size, "%s %s %s %"PRIu64" %"PRIu64"\n",
+	ret = snprintf(buf, len, "%s %s %s %"PRIu64" %"PRIu64"\n",
 			nft_family2str(r->family), r->table, r->chain,
 			r->handle, r->position);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
@@ -814,7 +815,8 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 		ret = snprintf(buf+offset, len, "  [ %s ", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = nft_rule_expr_snprintf(buf+offset, size, expr, type, flags);
+		ret = nft_rule_expr_snprintf(buf+offset, len, expr,
+					     type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = snprintf(buf+offset, len, "]\n");
diff --git a/src/set.c b/src/set.c
index 530776d..7a9aedb 100644
--- a/src/set.c
+++ b/src/set.c
@@ -543,7 +543,7 @@ static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 	int len = size, offset = 0, ret;
 	struct nft_set_elem *elem;
 
-	ret = snprintf(buf, size, "{ \"set\": { \"name\": \"%s\","
+	ret = snprintf(buf, len, "{ \"set\": { \"name\": \"%s\","
 				  "\"table\": \"%s\","
 				  "\"flags\": %u,\"family\": \"%s\","
 				  "\"key_type\": %u,\"key_len\": %u",
@@ -553,7 +553,7 @@ static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 
 	if(s->flags & (1 << NFT_SET_ATTR_DATA_TYPE) &&
 	   s->flags & (1 << NFT_SET_ATTR_DATA_LEN)){
-		ret = snprintf(buf+offset, size,
+		ret = snprintf(buf+offset, len,
 				  ",\"data_type\": %u,\"data_len\": %u",
 			s->data_type, s->data_len);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
@@ -561,26 +561,28 @@ static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 
 	/* Empty set? Skip printinf of elements */
 	if (list_empty(&s->element_list)){
-		ret = snprintf(buf+offset, size, "}}");
+		ret = snprintf(buf+offset, len, "}}");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		return offset;
 	}
 
-	ret = snprintf(buf+offset, size, ",\"set_elem\": [");
+	ret = snprintf(buf+offset, len, ",\"set_elem\": [");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	list_for_each_entry(elem, &s->element_list, head) {
-		ret = snprintf(buf+offset, size, "{");
+		ret = snprintf(buf+offset, len, "{");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = nft_set_elem_snprintf(buf+offset, size, elem, type, flags);
+		ret = nft_set_elem_snprintf(buf+offset, len, elem, type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = snprintf(buf+offset, size, "}, ");
+		ret = snprintf(buf+offset, len, "}, ");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
+	/* Overwrite trailing ", " from last set_elem */
+	offset -= 2;
 
-	ret = snprintf(buf+offset-2, size, "]}}");
+	ret = snprintf(buf+offset, len, "]}}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -593,7 +595,7 @@ static int nft_set_snprintf_default(char *buf, size_t size, struct nft_set *s,
 	int len = size, offset = 0;
 	struct nft_set_elem *elem;
 
-	ret = snprintf(buf, size, "%s %s %x",
+	ret = snprintf(buf, len, "%s %s %x",
 			s->name, s->table, s->set_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -601,14 +603,14 @@ static int nft_set_snprintf_default(char *buf, size_t size, struct nft_set *s,
 	if (list_empty(&s->element_list))
 		return offset;
 
-	ret = snprintf(buf+offset, size, "\n");
+	ret = snprintf(buf+offset, len, "\n");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	list_for_each_entry(elem, &s->element_list, head) {
-		ret = snprintf(buf+offset, size, "\t");
+		ret = snprintf(buf+offset, len, "\t");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = nft_set_elem_snprintf(buf+offset, size, elem, type, flags);
+		ret = nft_set_elem_snprintf(buf+offset, len, elem, type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
@@ -622,7 +624,7 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 	int len = size, offset = 0;
 	struct nft_set_elem *elem;
 
-	ret = snprintf(buf, size, "<set><family>%s</family>"
+	ret = snprintf(buf, len, "<set><family>%s</family>"
 				  "<table>%s</table>"
 				  "<name>%s</name>"
 				  "<flags>%u</flags>"
@@ -637,13 +639,13 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 
 	if (!list_empty(&s->element_list)) {
 		list_for_each_entry(elem, &s->element_list, head) {
-			ret = nft_set_elem_snprintf(buf+offset, size, elem,
+			ret = nft_set_elem_snprintf(buf+offset, len, elem,
 						    NFT_SET_O_XML, flags);
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
 	}
 
-	ret = snprintf(buf+offset, size, "</set>");
+	ret = snprintf(buf+offset, len, "</set>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
diff --git a/src/set_elem.c b/src/set_elem.c
index 885893b..ba24c96 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -454,17 +454,17 @@ static int nft_set_elem_snprintf_json(char *buf, size_t size,
 {
 	int ret, len = size, offset = 0, type = -1;
 
-	ret = snprintf(buf, size, "\"flags\": %u", e->set_elem_flags);
+	ret = snprintf(buf, len, "\"flags\": %u", e->set_elem_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, size, ",\"key\": {");
+	ret = snprintf(buf+offset, len, ",\"key\": {");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = nft_data_reg_snprintf(buf+offset, len, &e->key,
 				    NFT_RULE_O_JSON, flags, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, size, "}");
+	ret = snprintf(buf+offset, len, "}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_SET_ELEM_ATTR_DATA))
@@ -475,14 +475,14 @@ static int nft_set_elem_snprintf_json(char *buf, size_t size,
 		type = DATA_VERDICT;
 
 	if (type != -1) {
-		ret = snprintf(buf+offset, size, ",\"data\": {");
+		ret = snprintf(buf+offset, len, ",\"data\": {");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_data_reg_snprintf(buf+offset, len, &e->data,
 				    NFT_RULE_O_JSON, flags, type);
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = snprintf(buf+offset, size, "}");
+		ret = snprintf(buf+offset, len, "}");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
@@ -494,7 +494,7 @@ static int nft_set_elem_snprintf_default(char *buf, size_t size,
 {
 	int ret, len = size, offset = 0, i;
 
-	ret = snprintf(buf, size, "element ");
+	ret = snprintf(buf, len, "element ");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	for (i = 0; i < div_round_up(e->key.len, sizeof(uint32_t)); i++) {
@@ -502,7 +502,7 @@ static int nft_set_elem_snprintf_default(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size, " : ");
+	ret = snprintf(buf+offset, len, " : ");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	for (i = 0; i < div_round_up(e->data.len, sizeof(uint32_t)); i++) {
@@ -530,7 +530,7 @@ static int nft_set_elem_snprintf_xml(char *buf, size_t size,
 				    NFT_RULE_O_XML, flags, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, size, "</key>");
+	ret = snprintf(buf+offset, len, "</key>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_SET_ELEM_ATTR_DATA))
@@ -541,18 +541,18 @@ static int nft_set_elem_snprintf_xml(char *buf, size_t size,
 		type = DATA_VERDICT;
 
 	if (type != DATA_NONE) {
-		ret = snprintf(buf+offset, size, "<data>");
+		ret = snprintf(buf+offset, len, "<data>");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_data_reg_snprintf(buf+offset, len, &e->data,
 					    NFT_RULE_O_XML, flags, type);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = snprintf(buf+offset, size, "</data>");
+		ret = snprintf(buf+offset, len, "</data>");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size, "</set_elem>");
+	ret = snprintf(buf+offset, len, "</set_elem>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;

