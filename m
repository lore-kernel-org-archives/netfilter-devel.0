From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/2] mxml: add optional/mandatory flag to
	nft_mxml_reg_parse
Date: Wed, 15 Jan 2014 11:42:17 +0100
Message-ID: <20140115104217.14095.79271.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@nefilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43279 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750920AbaAOKm3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:42:29 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id DF50451ED6E
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 10:42:25 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zwMSU3I5+rTg for <netfilter-devel@vger.kernel.org>;
	Wed, 15 Jan 2014 11:42:20 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 1927251ED5B
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 11:42:19 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are some cases where a reg is not mandatory, for example:
 * dreg in lookup
 * dreg/sreg in meta (last version)

So, lets change the function nft_mxml_reg_parse() to add
an optional/mandatory flag.

dreg in lookup is optional as stated at:
 net/netfilter/nft_lookup.c:nft_lookup_init()

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/bitwise.c   |   10 +++++-----
 src/expr/byteorder.c |   11 ++++++-----
 src/expr/cmp.c       |    7 ++++---
 src/expr/ct.c        |    6 +++---
 src/expr/exthdr.c    |    6 +++---
 src/expr/immediate.c |    6 +++---
 src/expr/lookup.c    |   17 ++++++++---------
 src/expr/meta.c      |    6 +++---
 src/expr/nat.c       |   18 +++++++++---------
 src/expr/payload.c   |    7 ++++---
 src/internal.h       |    3 ++-
 src/mxml.c           |   24 ++++++++++++++----------
 12 files changed, 64 insertions(+), 57 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 3c4f644..e57c244 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -231,17 +231,17 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
-	int32_t reg;
+	uint32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	bitwise->sreg = reg;
 	e->flags |= (1 << NFT_EXPR_BITWISE_SREG);
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	bitwise->dreg = reg;
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index d6beba3..49ae38f 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -246,17 +246,18 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #ifdef XML_PARSING
 	struct nft_expr_byteorder *byteorder = nft_expr_data(e);
 	const char *op;
-	int32_t reg, ntoh;
+	int32_t ntoh;
+	uint32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	byteorder->sreg = reg;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_SREG);
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND, NFT_XML_MAND,
+			       err) != 0)
 		return -1;
 
 	byteorder->dreg = reg;
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index b5c694a..ebd3e5c 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -217,10 +217,11 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 #ifdef XML_PARSING
 	struct nft_expr_cmp *cmp = nft_expr_data(e);
 	const char *op;
-	int32_t reg, op_value;
+	int32_t op_value;
+	uint32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	cmp->sreg = reg;
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 7e20464..97f9dcc 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -233,12 +233,12 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 #ifdef XML_PARSING
 	struct nft_expr_ct *ct = nft_expr_data(e);
 	const char *key_str;
-	int32_t reg;
 	int key;
 	uint8_t dir;
+	uint32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	ct->dreg = reg;
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index d9e293a..0bf1de3 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -240,11 +240,11 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #ifdef XML_PARSING
 	struct nft_expr_exthdr *exthdr = nft_expr_data(e);
 	const char *exthdr_type;
-	int32_t reg;
 	int type;
+	uint32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	exthdr->dreg = reg;
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 3ae4082..db7b958 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -224,10 +224,10 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #ifdef XML_PARSING
 	struct nft_expr_immediate *imm = nft_expr_data(e);
 	int datareg_type;
-	int32_t reg;
+	uint32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	imm->dreg = reg;
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index b0aadf2..546066a 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -180,7 +180,7 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #ifdef XML_PARSING
 	struct nft_expr_lookup *lookup = nft_expr_data(e);
 	const char *set_name;
-	int32_t reg;
+	uint32_t reg;
 
 	set_name = nft_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
@@ -191,19 +191,18 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 	lookup->set_name[IFNAMSIZ-1] = '\0';
 	e->flags |= (1 << NFT_EXPR_LOOKUP_SET);
 
-	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "sreg", &reg, MXML_DESCEND,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	lookup->sreg = reg;
 	e->flags |= (1 << NFT_EXPR_LOOKUP_SREG);
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND, err);
-	if (reg < 0)
-		return -1;
-
-	lookup->dreg = reg;
-	e->flags |= (1 << NFT_EXPR_LOOKUP_DREG);
+	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND,
+			       NFT_XML_OPT, err) == 0) {
+		lookup->dreg = reg;
+		e->flags |= (1 << NFT_EXPR_LOOKUP_DREG);
+	}
 
 	return 0;
 #else
diff --git a/src/expr/meta.c b/src/expr/meta.c
index fb62bfd..1b5c904 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -197,11 +197,11 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 #ifdef XML_PARSING
 	struct nft_expr_meta *meta = nft_expr_data(e);
 	const char *key_str;
-	int32_t reg;
 	int key;
+	uint32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) < 0)
                 return -1;
 
 	meta->dreg = reg;
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 34a977a..65b35ea 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -261,8 +261,8 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 #ifdef XML_PARSING
 	struct nft_expr_nat *nat = nft_expr_data(e);
 	const char *nat_type;
-	int32_t reg;
 	int family, nat_type_value;
+	uint32_t reg;
 
 	nat_type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
@@ -286,29 +286,29 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	nat->family = family;
 	e->flags |= (1 << NFT_EXPR_NAT_FAMILY);
 
-	reg = nft_mxml_reg_parse(tree, "sreg_addr_min", MXML_DESCEND, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "sreg_addr_min", &reg,
+			       MXML_DESCEND, NFT_XML_MAND, err) != 0)
 		return -1;
 
 	nat->sreg_addr_min = reg;
 	e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MIN);
 
-	reg = nft_mxml_reg_parse(tree, "sreg_addr_max", MXML_DESCEND, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "sreg_addr_max", &reg,
+			       MXML_DESCEND, NFT_XML_MAND, err) != 0)
 		return -1;
 
 	nat->sreg_addr_max = reg;
 	e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MAX);
 
-	reg = nft_mxml_reg_parse(tree, "sreg_proto_min", MXML_DESCEND, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "sreg_proto_min", &reg,
+			       MXML_DESCEND, NFT_XML_MAND, err) != 0)
 		return -1;
 
 	nat->sreg_proto_min = reg;
 	e->flags |= (1 << NFT_EXPR_NAT_REG_PROTO_MIN);
 
-	reg = nft_mxml_reg_parse(tree, "sreg_proto_max", MXML_DESCEND, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "sreg_proto_max", &reg,
+			       MXML_DESCEND, NFT_XML_MAND, err) != 0)
 		return -1;
 
 	nat->sreg_proto_max = reg;
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 2c1ef04..d64b097 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -242,10 +242,11 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 #ifdef XML_PARSING
 	struct nft_expr_payload *payload = nft_expr_data(e);
 	const char *base_str;
-	int32_t reg, base;
+	int32_t base;
+	uint32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST, err);
-	if (reg < 0)
+	if (nft_mxml_reg_parse(tree, "dreg", &reg, MXML_DESCEND_FIRST,
+			       NFT_XML_MAND, err) != 0)
 		return -1;
 
 	payload->dreg = reg;
diff --git a/src/internal.h b/src/internal.h
index d3c58a2..ab12cec 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -51,7 +51,8 @@ mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
 				 struct nft_parse_err *err, enum nft_parse_input input);
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 					  struct nft_parse_err *err);
-int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags,
+int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t *reg,
+		       uint32_t mxmlflags, uint32_t flags,
 		       struct nft_parse_err *err);
 union nft_data_reg;
 int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
diff --git a/src/mxml.c b/src/mxml.c
index ddbd01b..4988502 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -99,30 +99,34 @@ err:
 	return NULL;
 }
 
-int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags,
+int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t *reg,
+		       uint32_t mxmlflags, uint32_t flags,
 		       struct nft_parse_err *err)
 {
 	mxml_node_t *node;
-	uint64_t val;
 
-	node = mxmlFindElement(tree, tree, reg_name, NULL, NULL, flags);
+	node = mxmlFindElement(tree, tree, reg_name, NULL, NULL, mxmlflags);
 	if (node == NULL) {
-		err->error = NFT_PARSE_EMISSINGNODE;
-		errno = EINVAL;
-		goto err;
+		if (!(flags & NFT_XML_OPT)) {
+			err->error = NFT_PARSE_EMISSINGNODE;
+			errno = EINVAL;
+			goto err;
+		}
+		return -1;
 	}
 
-	if (nft_strtoi(node->child->value.opaque, BASE_DEC, &val,
-		       NFT_TYPE_U64) != 0) {
+	if (nft_strtoi(node->child->value.opaque, BASE_DEC, reg,
+		       NFT_TYPE_U32) != 0) {
 		err->error = NFT_PARSE_EBADTYPE;
 		goto err;
 	}
 
-	if (val > NFT_REG_MAX) {
+	if (*reg > NFT_REG_MAX) {
 		errno = ERANGE;
 		goto err;
 	}
-	return val;
+
+	return 0;
 err:
 	err->node_name = reg_name;
 	return -1;

