From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 3/5] src: xml: set errno to EINVAL when invalid
	parsing
Date: Mon, 03 Jun 2013 22:44:54 +0200
Message-ID: <20130603204453.27713.8807.stgit@nfdev.cica.es>
References: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42348 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757698Ab3FCUo5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:44:57 -0400
In-Reply-To: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch sets errno to EINVAL when the XML parsing fails due to a bad format, a missing node or something.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c |  141 +++++++++++++++++++++++++----------------------------------
 src/rule.c  |  129 ++++++++++++++++++++++--------------------------------
 src/table.c |   58 ++++++++++--------------
 3 files changed, 137 insertions(+), 191 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 71d84a9..8dc9a49 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -467,73 +467,61 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 
 	/* Load the tree */
 	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree == NULL)
+	if (tree == NULL) {
+		errno = EINVAL;
 		return -1;
+	}
 
 	/* Validate this is a <chain> node */
-	if (strcmp(tree->value.opaque, "chain") != 0) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (strcmp(tree->value.opaque, "chain") != 0)
+		goto err;
 
 	/* Validate version */
-	if (mxmlElementGetAttr(tree, "version") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "version") == NULL)
+		goto err;
+
 	tmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
-	if (tmp == LLONG_MAX || *endptr || tmp != NFT_CHAIN_XML_VERSION) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp == LLONG_MAX || *endptr || tmp != NFT_CHAIN_XML_VERSION)
+		goto err;
 
 	/* Get and set <chain name="xxx" ... >*/
-	if (mxmlElementGetAttr(tree, "name") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "name") == NULL)
+		goto err;
+
 	strncpy(c->name, mxmlElementGetAttr(tree, "name"),
 		NFT_CHAIN_MAXNAMELEN);
 	c->flags |= (1 << NFT_CHAIN_ATTR_NAME);
 
 	/* Get and set <chain handle="x" ... >*/
-	if (mxmlElementGetAttr(tree, "handle") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "handle") == NULL)
+		goto err;
 
 	utmp = strtoull(mxmlElementGetAttr(tree, "handle"), &endptr, 10);
-	if (utmp == UINT64_MAX || utmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (utmp == UINT64_MAX || utmp < 0 || *endptr)
+		goto err;
 
 	c->handle = utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_HANDLE);
 
 	/* Get and set <chain bytes="x" ... >*/
-	if (mxmlElementGetAttr(tree, "bytes") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "bytes") == NULL)
+		goto err;
+
 	utmp = strtoull(mxmlElementGetAttr(tree, "bytes"), &endptr, 10);
-	if (utmp == UINT64_MAX || utmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (utmp == UINT64_MAX || utmp < 0 || *endptr)
+		goto err;
+
 	c->bytes = utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_BYTES);
 
 	/* Get and set <chain packets="x" ... > */
-	if (mxmlElementGetAttr(tree, "packets") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "packets") == NULL)
+		goto err;
+
 	utmp = strtoull(mxmlElementGetAttr(tree, "packets"), &endptr, 10);
-	if (utmp == UINT64_MAX || utmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (utmp == UINT64_MAX || utmp < 0 || *endptr)
+		goto err;
+
 	c->packets = utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_PACKETS);
 
@@ -543,10 +531,8 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 
 	/* Get and set <type> */
 	node = mxmlFindElement(tree, tree, "type", NULL, NULL, MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
 
 	if (c->type)
 		free(c->type);
@@ -556,10 +542,9 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 
 	/* Get and set <table> */
 	node = mxmlFindElement(tree, tree, "table", NULL, NULL,	MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
+
 	if (c->table)
 		free(c->table);
 
@@ -568,15 +553,12 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 
 	/* Get and set <prio> */
 	node = mxmlFindElement(tree, tree, "prio", NULL, NULL, MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
+
 	tmp = strtoll(node->child->value.opaque, &endptr, 10);
-	if (tmp > INT32_MAX || tmp < INT32_MIN || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp > INT32_MAX || tmp < INT32_MIN || *endptr)
+		goto err;
 
 	memcpy(&c->prio, &tmp, sizeof(c->prio));
 	c->flags |= (1 << NFT_CHAIN_ATTR_PRIO);
@@ -587,51 +569,48 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 	/* Get and set <hooknum> */
 	node = mxmlFindElement(tree, tree, "hooknum", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
+
 	utmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (utmp > UINT32_MAX || utmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (utmp > UINT32_MAX || utmp < 0 || *endptr)
+		goto err;
 
 	memcpy(&c->hooknum, &utmp, sizeof(c->hooknum));
 	c->flags |= (1 << NFT_CHAIN_ATTR_HOOKNUM);
 
 	/* Get and set <policy> */
 	node = mxmlFindElement(tree, tree, "policy", NULL, NULL, MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
+
 	utmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (utmp > UINT32_MAX || utmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (utmp > UINT32_MAX || utmp < 0 || *endptr)
+		goto err;
 
 	c->policy = (uint32_t)utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_POLICY);
 
 	/* Get and set <family> */
 	node = mxmlFindElement(tree, tree, "family", NULL, NULL, MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
+
 	utmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (utmp > UINT8_MAX || utmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (utmp > UINT8_MAX || utmp < 0 || *endptr)
+		goto err;
 
 	c->family = (uint32_t)utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_FAMILY);
 
 	mxmlDelete(tree);
 	return 0;
+
+err:
+	/* The XML format is invalid */
+	errno = EINVAL;
+	mxmlDelete(tree);
+	return -1;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
diff --git a/src/rule.c b/src/rule.c
index a91d21d..21593e3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -452,46 +452,37 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 
 	/* Load the tree */
 	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree == NULL)
+	if (tree == NULL) {
+		errno = EINVAL;
 		return -1;
+	}
 
 	/* validate this is a <rule> node */
-	if (strcmp(tree->value.opaque, "rule") != 0) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (strcmp(tree->value.opaque, "rule") != 0)
+		goto err;
 
 	/* validate XML version <rule ... version=X ... > */
-	if (mxmlElementGetAttr(tree, "version") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "version") == NULL)
+		goto err;
+
 	tmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
-	if (tmp == LLONG_MAX || *endptr || tmp != NFT_RULE_XML_VERSION) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp == LLONG_MAX || *endptr || tmp != NFT_RULE_XML_VERSION)
+		goto err;
 
 	/* get and set <rule ... family=X ... > */
-	if (mxmlElementGetAttr(tree, "family") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "family") == NULL)
+		goto err;
 
 	tmp = strtoull(mxmlElementGetAttr(tree, "family"), &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp > UINT8_MAX || tmp < 0 || *endptr)
+		goto err;
 
 	r->family = (uint8_t)tmp;
 	r->flags |= (1 << NFT_RULE_ATTR_FAMILY);
 
 	/* get and set <rule ... table=X ...> */
-	if (mxmlElementGetAttr(tree, "table") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "table") == NULL)
+		goto err;
 
 	if (r->table)
 		free(r->table);
@@ -500,10 +491,8 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	r->flags |= (1 << NFT_RULE_ATTR_TABLE);
 
 	/* get and set <rule ... chain=X ...> */
-	if (mxmlElementGetAttr(tree, "chain") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "chain") == NULL)
+		goto err;
 
 	if (r->chain)
 		free(r->chain);
@@ -512,15 +501,12 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	r->flags |= (1 << NFT_RULE_ATTR_CHAIN);
 
 	/* get and set <rule ... handle=X ...> */
-	if (mxmlElementGetAttr(tree, "handle") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "handle") == NULL)
+		goto err;
+
 	tmp = strtoull(mxmlElementGetAttr(tree, "handle"), &endptr, 10);
-	if (tmp == UINT64_MAX || tmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp == UINT64_MAX || tmp < 0 || *endptr)
+		goto err;
 
 	r->handle = tmp;
 	r->flags |= (1 << NFT_RULE_ATTR_HANDLE);
@@ -528,15 +514,12 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	/* get and set <rule_flags> */
 	node = mxmlFindElement(tree, tree, "rule_flags", NULL, NULL,
 			       MXML_DESCEND_FIRST);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
+
 	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
+		goto err;
 
 	r->rule_flags = (uint32_t)tmp;
 	r->flags |= (1 << NFT_RULE_ATTR_FLAGS);
@@ -544,15 +527,12 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	/* get and set <compat_proto> */
 	node = mxmlFindElement(tree, tree, "compat_proto", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
+
 	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
+		goto err;
 
 	r->compat.proto = (uint32_t)tmp;
 	r->flags |= (1 << NFT_RULE_ATTR_COMPAT_PROTO);
@@ -560,15 +540,12 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	/* get and set <compat_flags> */
 	node = mxmlFindElement(tree, tree, "compat_flags", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
+
 	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
+		goto err;
 
 	r->compat.flags = (uint32_t)tmp;
 	r->flags |= (1 << NFT_RULE_ATTR_COMPAT_FLAGS);
@@ -580,22 +557,16 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 		node = mxmlFindElement(node, tree, "expr", "type",
 				       NULL, MXML_DESCEND)) {
 
-		if (mxmlElementGetAttr(node, "type") == NULL) {
-			mxmlDelete(tree);
-			return -1;
-		}
+		if (mxmlElementGetAttr(node, "type") == NULL)
+			goto err;
 
 		ops = nft_expr_ops_lookup(mxmlElementGetAttr(node, "type"));
-		if (ops == NULL) {
-			mxmlDelete(tree);
-			return -1;
-		}
+		if (ops == NULL)
+			goto err;
 
 		e = nft_rule_expr_alloc(mxmlElementGetAttr(node, "type"));
-		if (e == NULL) {
-			mxmlDelete(tree);
-			return -1;
-		}
+		if (e == NULL)
+			goto err;
 
 		/* This is a hack for mxml to print just the current node */
 		save = node->next;
@@ -603,10 +574,8 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 
 		if (ops->xml_parse(e,
 				   mxmlSaveAllocString(node,
-						MXML_NO_CALLBACK)) != 0) {
-			mxmlDelete(tree);
-			return -1;
-		}
+						MXML_NO_CALLBACK)) != 0)
+			goto err;
 
 		nft_rule_add_expr(r, e);
 
@@ -616,6 +585,12 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
+
+err:
+	/* When the XML parsing is invalid */
+	errno = EINVAL;
+	mxmlDelete(tree);
+	return -1;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
diff --git a/src/table.c b/src/table.c
index fd6ed5d..feb12a5 100644
--- a/src/table.c
+++ b/src/table.c
@@ -209,32 +209,26 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 
 	/* Load the tree */
 	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree == NULL)
+	if (tree == NULL) {
+		errno = EINVAL;
 		return -1;
+	}
 
 	/* Validate this is a <table> node */
-	if (strcmp(tree->value.opaque, "table") != 0) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (strcmp(tree->value.opaque, "table") != 0)
+		goto err;
 
 	/* Check the version of the XML */
-	if (mxmlElementGetAttr(tree, "version") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "version") == NULL)
+		goto err;
 
 	stmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
-	if (stmp == LLONG_MAX || *endptr || stmp != NFT_TABLE_XML_VERSION) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (stmp == LLONG_MAX || *endptr || stmp != NFT_TABLE_XML_VERSION)
+		goto err;
 
 	/* Get and set the name of the table */
-	if (mxmlElementGetAttr(tree, "name") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (mxmlElementGetAttr(tree, "name") == NULL)
+		goto err;
 
 	if (t->name)
 		free(t->name);
@@ -248,16 +242,12 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 
 	/* Get the and set <family> node */
 	node = mxmlFindElement(tree, tree, "family", NULL, NULL, MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
 
 	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || *endptr || tmp < 0) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp > UINT32_MAX || *endptr || tmp < 0)
+		goto err;
 
 	t->family = (uint32_t)tmp;
 	t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
@@ -265,22 +255,24 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 	/* Get and set <table_flags> */
 	node = mxmlFindElement(tree, tree, "table_flags", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node == NULL)
+		goto err;
 
 	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || *endptr || tmp < 0) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (tmp > UINT32_MAX || *endptr || tmp < 0)
+		goto err;
 
 	t->table_flags = (uint32_t)tmp;
 	t->flags |= (1 << NFT_TABLE_ATTR_FLAGS);
 
 	mxmlDelete(tree);
 	return 0;
+
+err:
+	/* when the parsing fails */
+	errno = EINVAL;
+	mxmlDelete(tree);
+	return -1;
 #else
 	errno = EOPNOTSUPP;
 	return -1;

