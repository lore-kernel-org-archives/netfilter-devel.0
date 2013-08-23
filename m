From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] rule: complete print/parse position attr
Date: Fri, 23 Aug 2013 13:35:35 +0200
Message-ID: <20130823113535.2701.175.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60847 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755248Ab3HWLfp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:35:45 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id A9AB851ED18
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2013 11:35:42 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fCrCSBnw0G-x for <netfilter-devel@vger.kernel.org>;
	Fri, 23 Aug 2013 13:35:37 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 733A451ECD6
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2013 13:35:37 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do printf/parse of position attr in both XML and JSON.

Note that the position attr is optional as stated in net/netfilter/nf_tables_api.c

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/rule.c b/src/rule.c
index 98c2022..aca88d0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -538,6 +538,14 @@ static int nft_rule_json_parse(struct nft_rule *r, const char *json)
 		nft_rule_attr_set_u32(r, NFT_RULE_ATTR_COMPAT_FLAGS, uval32);
 	}
 
+	if (nft_jansson_node_exist(root, "position")) {
+		if (nft_jansson_value_parse_val(root, "position",
+						NFT_TYPE_U64, &uval64) == -1)
+			goto err;
+
+		nft_rule_attr_set_u64(r, NFT_RULE_ATTR_POSITION, uval64);
+	}
+
 	array = json_object_get(root, "expr");
 	if (array == NULL)
 		goto err;
@@ -636,6 +644,16 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 		r->flags |= (1 << NFT_RULE_ATTR_COMPAT_FLAGS);
 	}
 
+	node = mxmlFindElement(tree, tree, "position", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node != NULL && node->child != NULL) {
+		if (nft_strtoi(node->child->value.opaque, BASE_DEC,
+			       &r->position, NFT_TYPE_U64) != 0)
+			goto err;
+
+		r->flags |= (1 << NFT_RULE_ATTR_POSITION);
+	}
+
 	/* Iterating over <expr> */
 	for (node = mxmlFindElement(tree, tree, "expr", "type",
 				    NULL, MXML_DESCEND);
@@ -714,6 +732,13 @@ static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (r->flags & (1 << NFT_RULE_ATTR_POSITION)) {
+		ret = snprintf(buf+offset, len,
+			       "\"position\" : %"PRIu64", ",
+			       r->position);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	ret = snprintf(buf+offset, len, "\"expr\" : [");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -756,6 +781,13 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (r->flags & (1 << NFT_RULE_ATTR_POSITION)) {
+		ret = snprintf(buf+offset, len,
+			       "<position>%"PRIu64"</position>",
+			       r->position);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	list_for_each_entry(expr, &r->expr_list, head) {
 		ret = snprintf(buf+offset, len,
 				"<expr type=\"%s\">", expr->ops->name);

