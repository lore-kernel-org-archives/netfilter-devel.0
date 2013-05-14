From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v4] src: support for XML parsing
Date: Tue, 14 May 2013 16:51:16 +0200
Message-ID: <20130514145049.6008.84412.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49261 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932327Ab3ENOv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 10:51:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds capabilities for parsing a XML table/chain/rule

Some points to note:
	* the XML data is case sensitive (so <chain>asd</chain> !=3D <chain>AS=
D</chain> !=3D <CHAIN>asd</CHAIN>)
	* all exported functions will receive a XML and return an object (aka =
table|chain|rule)
	* To compile the lib with XML parsing support, run './configure --with=
-xml-parsing'
	* XML parsing is done with libmxml (http://minixml.org). XML parsing d=
epends on this external lib.

NOTE: expr/target and expr/match binary data are ignored.

Some code examples/test cases will be added to libnftables in a future =
patch.

Signed-off-by: Arturo Borrero Gonz=C3=A1lez <arturo.borrero.glez@gmail.=
com>
---
Changes since previous versions of this patch:
 * Conditional support for XML parsing (libmxml)
 * Improved validation of parsed numerical values

 Make_global.am              |    2=20
 configure.ac                |    7 +
 include/libnftables/chain.h |    7 +
 include/libnftables/rule.h  |    7 +
 include/libnftables/table.h |    7 +
 src/chain.c                 |  186 ++++++++++++++++++++++++++++++++
 src/expr/bitwise.c          |  110 +++++++++++++++++++
 src/expr/cmp.c              |   94 ++++++++++++++++
 src/expr/counter.c          |   61 +++++++++++
 src/expr/data_reg.c         |  249 +++++++++++++++++++++++++++++++++++=
+++++++-
 src/expr/immediate.c        |  100 +++++++++++++++++
 src/expr/lookup.c           |   77 +++++++++++++
 src/expr/match.c            |   58 ++++++++++
 src/expr/meta.c             |   65 +++++++++++
 src/expr/nat.c              |  126 ++++++++++++++++++++++
 src/expr/payload.c          |   87 +++++++++++++++
 src/expr/target.c           |   61 +++++++++++
 src/expr_ops.h              |    1=20
 src/internal.h              |    4 +
 src/libnftables.map         |    3 +
 src/rule.c                  |  183 ++++++++++++++++++++++++++++++++
 src/table.c                 |   92 ++++++++++++++++
 22 files changed, 1583 insertions(+), 4 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 1654f10..8205938 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -20,5 +20,5 @@
 #
 LIBVERSION=3D0:0:0
=20
-AM_CPPFLAGS =3D ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_C=
=46LAGS}
+AM_CPPFLAGS =3D ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_C=
=46LAGS} ${LIBMXML_CFLAGS}
 AM_CFLAGS =3D ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 01c170a..0eec5bd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,6 +14,10 @@ m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])]=
)
=20
 dnl Dependencies
 PKG_CHECK_MODULES([LIBMNL], [libmnl >=3D 1.0.0])
+AC_ARG_WITH([xml-parsing], AS_HELP_STRING([--with-xml-parsing], [XML p=
arsing support]))
+AS_IF([test "x$with_xml_parsing" =3D "xyes"], [
+	PKG_CHECK_MODULES([LIBXML], [mxml >=3D 2.6])
+])
=20
 AC_PROG_CC
 AM_PROG_CC_C_O
@@ -26,6 +30,9 @@ case "$host" in
 esac
=20
 regular_CPPFLAGS=3D"-D_FILE_OFFSET_BITS=3D64 -D_REENTRANT"
+AS_IF([test "x$with_xml_parsing" =3D "xyes"], [
+	regular_CPPFLAGS=3D"$regular_CPPFLAGS -DXML_PARSING"
+])
 regular_CFLAGS=3D"-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wshadow -Wstrict-prototypes \
 	-Wformat=3D2 -pipe"
diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index a7f6a50..7b21719 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -44,6 +44,13 @@ enum {
 	NFT_CHAIN_O_XML,
 };
=20
+enum nft_chain_parse_type {
+	NFT_CHAIN_PARSE_NONE	=3D 0,
+	NFT_CHAIN_PARSE_XML,
+	NFT_CHAIN_PARSE_MAX
+};
+
+int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type typ=
e, char *data);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, ui=
nt32_t type, uint32_t flags);
=20
 struct nlmsghdr *nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, ui=
nt16_t family, uint16_t type, uint32_t seq);
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 50944cd..1dc817a 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -43,6 +43,13 @@ enum {
 	NFT_RULE_O_XML,
 };
=20
+enum nft_rule_parse_type {
+	NFT_RULE_PARSE_NONE	=3D 0,
+	NFT_RULE_PARSE_XML,
+	NFT_RULE_PARSE_MAX,
+};
+
+int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, =
char *data);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint=
32_t type, uint32_t flags);
=20
 struct nlmsghdr *nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uin=
t16_t family, uint16_t type, uint32_t seq);
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index c50650f..612e1ad 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -31,6 +31,13 @@ enum {
 	NFT_TABLE_O_XML,
 };
=20
+enum nft_table_parse_type {
+	NFT_TABLE_PARSE_NONE	=3D 0,
+	NFT_TABLE_PARSE_XML,
+	NFT_TABLE_PARSE_MAX,
+};
+
+int nft_table_parse(struct nft_table *t, enum nft_table_parse_type typ=
e, char *data);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, ui=
nt32_t type, uint32_t flags);
=20
 struct nlmsghdr *nft_table_nlmsg_build_hdr(char *buf, uint16_t cmd, ui=
nt16_t family, uint16_t type, uint32_t seq);
diff --git a/src/chain.c b/src/chain.c
index 44a0e66..b7f38d7 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -446,6 +446,192 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nft_chain *c)
 }
 EXPORT_SYMBOL(nft_chain_nlmsg_parse);
=20
+static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	char *endptr =3D NULL;
+	uint64_t utmp;
+	int64_t tmp;
+
+	/* NOTE: all XML nodes are mandatory */
+
+	/* Load the tree */
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	/* Get and set <chain name=3D"xxx" ... >*/
+	if (mxmlElementGetAttr(tree, "name") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	strncpy(c->name, mxmlElementGetAttr(tree, "name"),
+		NFT_CHAIN_MAXNAMELEN);
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_NAME);
+
+	/* Get and set <chain handle=3D"x" ... >*/
+	if (mxmlElementGetAttr(tree, "handle") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	utmp =3D strtoull(mxmlElementGetAttr(tree, "handle"), &endptr, 10);
+	if (utmp =3D=3D UINT64_MAX || utmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	c->handle =3D (uint64_t)utmp;
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_HANDLE);
+
+	/* Get and set <chain bytes=3D"x" ... >*/
+	if (mxmlElementGetAttr(tree, "bytes") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoull(mxmlElementGetAttr(tree, "bytes"), &endptr, 10);
+	if (utmp =3D=3D UINT64_MAX || utmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	c->bytes =3D (uint64_t)utmp;
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_BYTES);
+
+	/* Get and set <chain packets=3D"x" ... > */
+	if (mxmlElementGetAttr(tree, "packets") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoull(mxmlElementGetAttr(tree, "packets"), &endptr, 10);
+	if (utmp =3D=3D UINT64_MAX || utmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	c->packets =3D (uint64_t)utmp;
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_PACKETS);
+
+	/* Ignore <properties> node */
+	node =3D mxmlFindElement(tree, tree, "properties", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+
+	/* Get and set <type> */
+	node =3D mxmlFindElement(tree, tree, "type", NULL, NULL, MXML_DESCEND=
);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (c->type)
+		free(c->type);
+
+	c->type =3D strdup(node->child->value.opaque);
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_TYPE);
+
+	/* Get and set <table> */
+	node =3D mxmlFindElement(tree, tree, "table", NULL, NULL,	MXML_DESCEN=
D);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	if (c->table)
+		free(c->table);
+
+	c->table =3D strdup(node->child->value.opaque);
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_TABLE);
+
+	/* Get and set <prio> */
+	node =3D mxmlFindElement(tree, tree, "prio", NULL, NULL, MXML_DESCEND=
);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoll(node->child->value.opaque, &endptr, 10);
+	if (tmp > INT32_MAX || tmp < INT32_MIN || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(&c->prio, &tmp, sizeof(c->prio));
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_PRIO);
+
+	/* Ignore <use> (cannot be set)*/
+	node =3D mxmlFindElement(tree, tree, "use", NULL, NULL, MXML_DESCEND)=
;
+
+	/* Get and set <hooknum> */
+	node =3D mxmlFindElement(tree, tree, "hooknum", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (utmp > UINT32_MAX || utmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(&c->hooknum, &utmp, sizeof(c->hooknum));
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_HOOKNUM);
+
+	/* Get and set <policy> */
+	node =3D mxmlFindElement(tree, tree, "policy", NULL, NULL, MXML_DESCE=
ND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (utmp > UINT32_MAX || utmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	c->policy =3D (uint32_t)utmp;
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_POLICY);
+
+	/* Get and set <family> */
+	node =3D mxmlFindElement(tree, tree, "family", NULL, NULL, MXML_DESCE=
ND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (utmp > UINT8_MAX || utmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	c->family =3D (uint32_t)utmp;
+	c->flags |=3D (1 << NFT_CHAIN_ATTR_FAMILY);
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type typ=
e,
+		    char *data)
+{
+	int ret;
+
+	switch (type) {
+	case NFT_CHAIN_PARSE_XML:
+		ret =3D nft_chain_xml_parse(c, data);
+		break;
+	default:
+		ret =3D -1;
+		errno =3D EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_chain_parse);
+
 static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_c=
hain *c)
 {
 	return snprintf(buf, size,
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index ddcf6a7..f11f6a7 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -196,6 +196,115 @@ nft_rule_expr_bitwise_parse(struct nft_rule_expr =
*e, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_bitwise *bitwise =3D (struct nft_expr_bitwise *)e;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	uint64_t tmp;
+	union nft_data_reg data_regtmp;
+	char *endptr =3D NULL;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("bitwise", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* get and set <sreg> */
+	node =3D mxmlFindElement(tree, tree, "sreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	bitwise->sreg =3D (uint32_t)tmp;
+	e->flags |=3D (1 << NFT_EXPR_BITWISE_SREG);
+
+	/* get and set <dreg> */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL, MXML_DESCEND=
);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	bitwise->dreg =3D (uint32_t)tmp;
+	e->flags |=3D (1 << NFT_EXPR_BITWISE_DREG);
+
+	/* Get and set <mask> */
+	node =3D mxmlFindElement(tree, tree, "mask", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* hack for mxmSaveAllocString to print just the current node */
+	save =3D node->next;
+	node->next =3D NULL;
+	if (nft_data_reg_xml_parse(&data_regtmp,
+			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	node->next =3D save;
+
+	memcpy(&bitwise->mask.val, data_regtmp.val, data_regtmp.len);
+	bitwise->mask.len =3D data_regtmp.len;
+	e->flags |=3D (1 << NFT_EXPR_BITWISE_MASK);
+
+	/* Get and set <xor> */
+	node =3D mxmlFindElement(tree, tree, "xor", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* hack for mxmSaveAllocString to print just the current node */
+	save =3D node->next;
+	node->next =3D NULL;
+	if (nft_data_reg_xml_parse(&data_regtmp,
+			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(&bitwise->xor.val, data_regtmp.val, data_regtmp.len);
+	bitwise->xor.len =3D data_regtmp.len;
+	e->flags |=3D (1 << NFT_EXPR_BITWISE_XOR);
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 				   struct nft_expr_bitwise *bitwise)
 {
@@ -280,4 +389,5 @@ struct expr_ops expr_ops_bitwise =3D {
 	.parse		=3D nft_rule_expr_bitwise_parse,
 	.build		=3D nft_rule_expr_bitwise_build,
 	.snprintf	=3D nft_rule_expr_bitwise_snprintf,
+	.xml_parse	=3D nft_rule_expr_bitwise_xml_parse,
 };
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 3de849a..616cfc5 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -166,6 +166,97 @@ static char *expr_cmp_str[] =3D {
 	[NFT_CMP_GTE]	=3D "gte",
 };
=20
+static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, char *=
xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_cmp *cmp =3D (struct nft_expr_cmp *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	union nft_data_reg data_regtmp;
+	uint64_t tmp;
+	char *endptr;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("cmp", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <sreg>. Is not mandatory */
+	node =3D mxmlFindElement(tree, tree, "sreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		cmp->sreg =3D (uint8_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_CMP_SREG);
+	}
+
+	/* Get and set <op>. Is not mandatory*/
+	node =3D mxmlFindElement(tree, tree, "op", NULL, NULL, MXML_DESCEND);
+	if (node !=3D NULL) {
+		if (strcmp(node->child->value.opaque, "eq") =3D=3D 0) {
+			cmp->op =3D NFT_CMP_EQ;
+		} else if (strcmp(node->child->value.opaque, "neq") =3D=3D 0) {
+			cmp->op =3D NFT_CMP_NEQ;
+		} else if (strcmp(node->child->value.opaque, "lt") =3D=3D 0) {
+			cmp->op =3D NFT_CMP_LT;
+		} else if (strcmp(node->child->value.opaque, "lte") =3D=3D 0) {
+			cmp->op =3D NFT_CMP_LTE;
+		} else if (strcmp(node->child->value.opaque, "gt") =3D=3D 0) {
+			cmp->op =3D NFT_CMP_GT;
+		} else if (strcmp(node->child->value.opaque, "gte") =3D=3D 0) {
+			cmp->op =3D NFT_CMP_GTE;
+		} else {
+			/* If <op> is present, a valid value is mandatory */
+			mxmlDelete(tree);
+			return -1;
+		}
+		e->flags |=3D (1 << NFT_EXPR_CMP_OP);
+	}
+
+	/* Get and set <cmpdata>. Is not mandatory */
+	node =3D mxmlFindElement(tree, tree, "cmpdata", NULL, NULL,
+			       MXML_DESCEND);
+	if (node !=3D NULL) {
+		/* hack for mxmSaveAllocString to print just the current node */
+		save =3D node->next;
+		node->next =3D NULL;
+
+		if (nft_data_reg_xml_parse(&data_regtmp,
+			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		node->next =3D save;
+
+		memcpy(&cmp->data.val, data_regtmp.val, data_regtmp.len);
+		cmp->data.len =3D data_regtmp.len;
+		e->flags |=3D (1 << NFT_EXPR_CMP_DATA);
+	}
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int
 nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr=
_cmp *cmp)
 {
@@ -227,4 +318,7 @@ struct expr_ops expr_ops_cmp =3D {
 	.parse		=3D nft_rule_expr_cmp_parse,
 	.build		=3D nft_rule_expr_cmp_build,
 	.snprintf	=3D nft_rule_expr_cmp_snprintf,
+#ifdef XML_PARSING
+	.xml_parse	=3D nft_rule_expr_cmp_xml_parse,
+#endif
 };
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 550d56d..e52e0f0 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -126,6 +126,66 @@ nft_rule_expr_counter_parse(struct nft_rule_expr *=
e, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, char *xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_counter *ctr =3D (struct nft_expr_counter *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	char *endptr;
+	uint64_t tmp;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("counter", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* get and set <pkts>. Is not mandatory*/
+	node =3D mxmlFindElement(tree, tree, "pkts", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp =3D=3D UINT64_MAX || tmp < 0 || *endptr ) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		ctr->pkts =3D (uint64_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_CTR_PACKETS);
+	}
+
+	/* get and set <bytes> */
+	node =3D mxmlFindElement(tree, tree, "bytes", NULL, NULL,
+			       MXML_DESCEND);
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp =3D=3D UINT64_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		ctr->bytes =3D (uint64_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_CTR_BYTES);
+	}
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
@@ -153,4 +213,5 @@ struct expr_ops expr_ops_counter =3D {
 	.parse		=3D nft_rule_expr_counter_parse,
 	.build		=3D nft_rule_expr_counter_build,
 	.snprintf	=3D nft_rule_expr_counter_snprintf,
+	.xml_parse	=3D nft_rule_expr_counter_xml_parse,
 };
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 78c7d49..dfdc7d4 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <string.h>
+#include <limits.h>
 #include <arpa/inet.h>
=20
 #include <libmnl/libmnl.h>
@@ -23,9 +24,250 @@
 #include "data_reg.h"
 #include "internal.h"
=20
-static int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
-					   union nft_data_reg *reg,
-					   uint32_t flags)
+static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, cha=
r *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	char *endptr;
+	long int tmp;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	node =3D mxmlFindElement(tree, tree, "data_reg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and validate <data_reg type=3D"verdict" >*/
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp(mxmlElementGetAttr(tree, "type"), "verdict") !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <verdict> */
+	node =3D mxmlFindElement(tree, tree, "verdict", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoll(node->child->value.opaque, &endptr, 10);
+	if (tmp > INT_MAX || tmp < INT_MIN || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	reg->verdict =3D tmp;
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char =
*xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	node =3D mxmlFindElement(tree, tree, "data_reg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and validate <data_reg type=3D"chain" >*/
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp(mxmlElementGetAttr(tree, "type"), "chain") !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <chain> */
+	node =3D mxmlFindElement(tree, tree, "chain", NULL, NULL, MXML_DESCEN=
D);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* no max len value to validate? */
+	if (strlen(node->child->value.opaque) < 1) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (reg->chain)
+		free(reg->chain);
+
+	reg->chain =3D strdup(node->child->value.opaque);
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char =
*xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	int i, len;
+	int64_t tmp;
+	uint64_t utmp;
+	char *endptr;
+	char node_name[6];
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	node =3D mxmlFindElement(tree, tree, "data_reg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/*
+	* <data_reg type=3D"value">
+	*    <len>4</len>
+	*    <data0>0xc09a002a</data0>
+	*    <data1>0x2700cac1</data1>
+	*    <data2>0x00000000</data2>
+	*    <data3>0x08000000</data3>
+	* </data_reg>
+	*/
+
+	/* Get and validate <data_reg type=3D"value" ... >*/
+	if (mxmlElementGetAttr(node, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp(mxmlElementGetAttr(node, "type"), "value") !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get <len> */
+	node =3D mxmlFindElement(tree, tree, "len", NULL, NULL, MXML_DESCEND)=
;
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoll(node->child->value.opaque, &endptr, 10);
+	if (tmp > INT64_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	/* maybe also (len < 1 || len > 4) */
+	len =3D tmp;
+
+	/* Get and set <dataN> */
+	for (i =3D 0; i < len; i++) {
+		sprintf(node_name, "data%d", i);
+
+		node =3D mxmlFindElement(tree, tree, node_name, NULL,
+				       NULL, MXML_DESCEND);
+		if (node =3D=3D NULL) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		utmp =3D strtoull(node->child->value.opaque, &endptr, 16);
+		if (utmp =3D=3D UINT64_MAX || utmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+		reg->val[i] =3D tmp;
+	}
+
+	reg->len =3D sizeof(reg->val);
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK)=
;
+
+	if (tree =3D=3D NULL)
+		return -1;
+
+	node =3D mxmlFindElement(tree, tree, "data_reg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get <data_reg type=3D"xxx" ... >*/
+	if (mxmlElementGetAttr(node, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Select what type of parsing is needed */
+	if (strcmp(mxmlElementGetAttr(node, "type"), "value") =3D=3D 0) {
+		mxmlDelete(tree);
+		return nft_data_reg_value_xml_parse(reg, xml);
+	} else if (strcmp(mxmlElementGetAttr(node, "type"), "verdict") =3D=3D=
 0) {
+		mxmlDelete(tree);
+		return nft_data_reg_verdict_xml_parse(reg, xml);
+	} else if (strcmp(mxmlElementGetAttr(node, "type"), "chain") =3D=3D 0=
) {
+		mxmlDelete(tree);
+		return nft_data_reg_chain_xml_parse(reg, xml);
+	}
+
+	mxmlDelete(tree);
+#else
+	errno =3D EOPNOTSUPP;
+#endif
+	return -1;
+}
+
+static
+int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
+				    union nft_data_reg *reg, uint32_t flags)
 {
 	int len =3D size, offset =3D 0, ret, i, j;
 	uint8_t *tmp;
@@ -251,3 +493,4 @@ int nft_parse_data(union nft_data_reg *data, struct=
 nlattr *attr, int *type)
=20
 	return ret;
 }
+
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 10f7793..ff7806c 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -196,6 +196,105 @@ nft_rule_expr_immediate_parse(struct nft_rule_exp=
r *e, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, char *xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_immediate *imm =3D (struct nft_expr_immediate *)e->da=
ta;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	union nft_data_reg data_regtmp;
+	uint64_t tmp;
+	char *endptr;
+
+	/* load the tree */
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("immediate", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <dreg>. Is mandatory */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	imm->dreg =3D (uint32_t)tmp;
+	e->flags |=3D (1 << NFT_EXPR_IMM_DREG);
+
+	/* Get and set <immdata>. Is mandatory */
+	node =3D mxmlFindElement(tree, tree, "immdata", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* hack for mxmSaveAllocString to print just the current node */
+	save =3D node->next;
+	node->next =3D NULL;
+
+	if (nft_data_reg_xml_parse(&data_regtmp,
+			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	node->next =3D save;
+
+	/* data_reg type switch */
+	node =3D mxmlFindElement(tree, tree, "data_reg", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (mxmlElementGetAttr(node, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp(mxmlElementGetAttr(node, "type"), "value") =3D=3D 0) {
+		memcpy(&imm->data.val, data_regtmp.val, data_regtmp.len);
+		imm->data.len =3D data_regtmp.len;
+		e->flags |=3D (1 << NFT_EXPR_IMM_DATA);
+	} else if (strcmp(mxmlElementGetAttr(node, "type"), "verdict") =3D=3D=
 0) {
+		imm->data.verdict =3D data_regtmp.verdict;
+		e->flags |=3D (1 << NFT_EXPR_IMM_VERDICT);
+	} else if (strcmp(mxmlElementGetAttr(node, "type"), "chain") =3D=3D 0=
) {
+		if (imm->data.chain)
+			free(imm->data.chain);
+
+		imm->data.chain =3D strdup(data_regtmp.chain);
+		e->flags |=3D (1 << NFT_EXPR_IMM_CHAIN);
+	}
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
 				     struct nft_rule_expr *e, uint32_t flags)
 {
@@ -282,4 +381,5 @@ struct expr_ops expr_ops_immediate =3D {
 	.parse		=3D nft_rule_expr_immediate_parse,
 	.build		=3D nft_rule_expr_immediate_build,
 	.snprintf	=3D nft_rule_expr_immediate_snprintf,
+	.xml_parse	=3D nft_rule_expr_immediate_xml_parse,
 };
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 1046615..ebc93e1 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -151,6 +151,82 @@ nft_rule_expr_lookup_parse(struct nft_rule_expr *e=
, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, char *xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_lookup *lookup =3D (struct nft_expr_lookup *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	uint64_t tmp;
+	char *endptr;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("lookup", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* get and set <set>. Is mandatory */
+	node =3D mxmlFindElement(tree, tree, "set", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(lookup->set_name, node->child->value.opaque, IFNAMSIZ);
+	lookup->set_name[IFNAMSIZ-1] =3D '\0';
+	e->flags |=3D (1 << NFT_EXPR_LOOKUP_SET);
+
+	/* get and set <sreg>. Is mandatory */
+	node =3D mxmlFindElement(tree, tree, "sreg", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	lookup->sreg =3D (uint32_t)tmp;
+	e->flags |=3D (1 << NFT_EXPR_LOOKUP_SREG);
+
+	/* get and set <dreg>. Isn't mandatory */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL,
+			       MXML_DESCEND);
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		lookup->dreg =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_LOOKUP_DREG);
+	}
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
 				  struct nft_expr_lookup *l)
 {
@@ -202,4 +278,5 @@ struct expr_ops expr_ops_lookup =3D {
 	.parse		=3D nft_rule_expr_lookup_parse,
 	.build		=3D nft_rule_expr_lookup_build,
 	.snprintf	=3D nft_rule_expr_lookup_snprintf,
+	.xml_parse	=3D nft_rule_expr_lookup_xml_parse,
 };
diff --git a/src/expr/match.c b/src/expr/match.c
index 57c5ab9..500d72c 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -184,6 +184,63 @@ static int nft_rule_expr_match_parse(struct nft_ru=
le_expr *e, struct nlattr *att
 	return 0;
 }
=20
+static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, char=
 *xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_match *mt =3D (struct nft_expr_match *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	uint64_t tmp;
+	char *endptr;
+
+	/* load the tree */
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("match", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* get and set <name>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "name", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node !=3D NULL) {
+		memcpy(mt->name, node->child->value.opaque,
+		       XT_EXTENSION_MAXNAMELEN);
+		mt->name[XT_EXTENSION_MAXNAMELEN-1] =3D '\0';
+		e->flags |=3D (1 << NFT_EXPR_MT_NAME);
+	}
+
+	/* get and set <rev>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "rev", NULL, NULL, MXML_DESCEND)=
;
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		mt->rev =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_MT_REV);
+	}
+
+	/* mt->info is ignored until other solution is reached */
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 					    struct nft_expr_match *mt)
 {
@@ -235,4 +292,5 @@ struct expr_ops expr_ops_match =3D {
 	.parse		=3D nft_rule_expr_match_parse,
 	.build		=3D nft_rule_expr_match_build,
 	.snprintf	=3D nft_rule_expr_match_snprintf,
+	.xml_parse =3D nft_rule_expr_match_xml_parse,
 };
diff --git a/src/expr/meta.c b/src/expr/meta.c
index bfc1aa6..c5aa3e5 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -125,6 +125,70 @@ nft_rule_expr_meta_parse(struct nft_rule_expr *e, =
struct nlattr *attr)
 	return 0;
 }
=20
+static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, char =
*xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_meta *meta =3D (struct nft_expr_meta *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	uint64_t tmp;
+	char *endptr;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("meta", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <dreg>. Is mandatory */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	meta->dreg =3D (uint8_t)tmp;
+	e->flags |=3D (1 << NFT_EXPR_META_DREG);
+
+	/* Get and set <key>. Is mandatory */
+	node =3D mxmlFindElement(tree, tree, "key", NULL, NULL, MXML_DESCEND)=
;
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	meta->key =3D (uint8_t)tmp;
+	e->flags |=3D (1 << NFT_EXPR_META_KEY);
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int
 nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
@@ -154,4 +218,5 @@ struct expr_ops expr_ops_meta =3D {
 	.parse		=3D nft_rule_expr_meta_parse,
 	.build		=3D nft_rule_expr_meta_build,
 	.snprintf	=3D nft_rule_expr_meta_snprintf,
+	.xml_parse =3D nft_rule_expr_meta_xml_parse,
 };
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 56212a7..7c6cfd9 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -14,6 +14,7 @@
=20
 #include <stdio.h>
 #include <stdint.h>
+#include <limits.h>
 #include <arpa/inet.h>
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nf_tables.h>
@@ -201,6 +202,130 @@ nft_rule_expr_nat_build(struct nlmsghdr *nlh, str=
uct nft_rule_expr *e)
 				 htonl(nat->sreg_proto_max));
 }
=20
+
+static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *=
xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_nat *nat =3D (struct nft_expr_nat *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	uint64_t tmp;
+	char *endptr;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("nat", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <type>. Mandatory */
+	node =3D mxmlFindElement(tree, tree, "type", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp(node->child->value.opaque, "NFT_NAT_SNAT") =3D=3D 0) {
+		nat->type =3D NFT_NAT_SNAT;
+	} else if (strcmp(node->child->value.opaque, "NFT_NAT_DNAT") =3D=3D 0=
) {
+		nat->type =3D NFT_NAT_DNAT;
+	} else {
+		mxmlDelete(tree);
+		return -1;
+	}
+	e->flags |=3D (1 << NFT_EXPR_NAT_TYPE);
+
+	/* Get and set <family>. Mandatory */
+	node =3D mxmlFindElement(tree, tree, "family", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp(node->child->value.opaque, "AF_INET") =3D=3D 0) {
+		nat->family =3D AF_INET;
+	} else if (strcmp(node->child->value.opaque, "AF_INET6") =3D=3D 0) {
+		nat->family =3D AF_INET6;
+	} else {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags |=3D (1 << NFT_EXPR_NAT_FAMILY);
+
+	/* Get and set <sreg_addr_min_v4>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "sreg_addr_min_v4", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		nat->sreg_addr_min =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_NAT_REG_ADDR_MIN);
+	}
+
+	/* Get and set <sreg_addr_max_v4>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "sreg_addr_max_v4", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		nat->sreg_addr_max =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_NAT_REG_ADDR_MAX);
+	}
+
+	/* Get and set <sreg_proto_min>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "sreg_proto_min", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		nat->sreg_proto_min =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_NAT_REG_PROTO_MIN);
+	}
+
+	/* Get and set <sreg_proto_max>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "sreg_proto_max", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		nat->sreg_proto_max =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_NAT_REG_PROTO_MAX);
+	}
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int
 nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 				struct nft_rule_expr *e)
@@ -305,4 +430,5 @@ struct expr_ops expr_ops_nat =3D {
 	.parse		=3D nft_rule_expr_nat_parse,
 	.build		=3D nft_rule_expr_nat_build,
 	.snprintf	=3D nft_rule_expr_nat_snprintf,
+	.xml_parse	=3D nft_rule_expr_nat_xml_parse,
 };
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 091078b..c01c29b 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -13,6 +13,7 @@
=20
 #include <stdio.h>
 #include <stdint.h>
+#include <limits.h>
 #include <arpa/inet.h>
=20
 #include <libmnl/libmnl.h>
@@ -165,6 +166,91 @@ nft_rule_expr_payload_parse(struct nft_rule_expr *=
e, struct nlattr *attr)
 }
=20
 static int
+nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, char *xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_payload *payload =3D (struct nft_expr_payload *)e->da=
ta;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	uint64_t tmp;
+	char *endptr;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("payload", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <dreg>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		payload->dreg =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_PAYLOAD_DREG);
+	}
+
+	/* Get and set <base>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "base", NULL, NULL, MXML_DESCEND=
);
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		payload->base =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_PAYLOAD_BASE);
+	}
+
+	/* Get and set <offset>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "offset", NULL, NULL,
+			       MXML_DESCEND);
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		payload->offset =3D (unsigned int)tmp;
+		e->flags |=3D (1 << NFT_EXPR_PAYLOAD_OFFSET);
+	}
+
+	/* Get and set <len>. Not mandatory */
+	node =3D mxmlFindElement(tree, tree, "len", NULL, NULL, MXML_DESCEND)=
;
+	if (node !=3D NULL) {
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		payload->len =3D (unsigned int)tmp;
+		e->flags |=3D (1 << NFT_EXPR_PAYLOAD_LEN);
+	}
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int
 nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
@@ -197,4 +283,5 @@ struct expr_ops expr_ops_payload =3D {
 	.parse		=3D nft_rule_expr_payload_parse,
 	.build		=3D nft_rule_expr_payload_build,
 	.snprintf	=3D nft_rule_expr_payload_snprintf,
+	.xml_parse	=3D nft_rule_expr_payload_xml_parse,
 };
diff --git a/src/expr/target.c b/src/expr/target.c
index d3de8e8..595115c 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -184,6 +184,66 @@ static int nft_rule_expr_target_parse(struct nft_r=
ule_expr *e, struct nlattr *at
 	return 0;
 }
=20
+static int
+nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, char *xml)
+{
+#ifdef XML_PARSING
+	struct nft_expr_target *tg =3D (struct nft_expr_target *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	uint64_t tmp;
+	char *endptr;
+
+	/* load the tree */
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	if (mxmlElementGetAttr(tree, "type") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp("target", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <name>. Optional */
+	node =3D mxmlFindElement(tree, tree, "name", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node !=3D NULL) {
+		memcpy(tg->name, node->child->value.opaque,
+					XT_EXTENSION_MAXNAMELEN);
+		tg->name[XT_EXTENSION_MAXNAMELEN-1] =3D '\0';
+		e->flags |=3D (1 << NFT_EXPR_TG_NAME);
+	}
+
+	/* Get and set <rev>. Optional */
+	node =3D mxmlFindElement(tree, tree, "rev", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		errno =3D 0;
+		tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		tg->rev =3D (uint32_t)tmp;
+		e->flags |=3D (1 << NFT_EXPR_TG_REV);
+	}
+
+	/* tg->info is ignored until other solution is reached */
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static
 int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 				struct nft_expr_target *tg)
@@ -235,4 +295,5 @@ struct expr_ops expr_ops_target =3D {
 	.parse		=3D nft_rule_expr_target_parse,
 	.build		=3D nft_rule_expr_target_build,
 	.snprintf	=3D nft_rule_expr_target_snprintf,
+	.xml_parse	=3D nft_rule_expr_target_xml_parse,
 };
diff --git a/src/expr_ops.h b/src/expr_ops.h
index d6e4ec9..ff4c648 100644
--- a/src/expr_ops.h
+++ b/src/expr_ops.h
@@ -17,6 +17,7 @@ struct expr_ops {
 	int 	(*parse)(struct nft_rule_expr *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, struct nft_rule_expr *e);
 	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags,=
 struct nft_rule_expr *e);
+	int	(*xml_parse)(struct nft_rule_expr *e, char *xml);
 };
=20
 struct expr_ops *nft_expr_ops_lookup(const char *name);
diff --git a/src/internal.h b/src/internal.h
index f5717ed..b3c3642 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -13,6 +13,10 @@
=20
 #include <stdint.h>
=20
+#ifdef XML_PARSING
+#include <mxml.h>
+#endif
+
 struct expr_ops;
=20
 struct nft_rule_expr {
diff --git a/src/libnftables.map b/src/libnftables.map
index 957e3b6..41afdfb 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -6,6 +6,7 @@ global:
   nft_table_attr_get;
   nft_table_attr_set_u32;
   nft_table_attr_get_u32;
+  nft_table_parse;
   nft_table_snprintf;
   nft_table_nlmsg_build_hdr;
   nft_table_nlmsg_build_payload;
@@ -28,6 +29,7 @@ global:
   nft_chain_attr_get_s32;
   nft_chain_attr_get_u64;
   nft_chain_attr_get_str;
+  nft_chain_parse;
   nft_chain_snprintf;
   nft_chain_nlmsg_build_hdr;
   nft_chain_nlmsg_build_payload;
@@ -51,6 +53,7 @@ global:
   nft_rule_attr_get_u32;
   nft_rule_attr_get_u64;
   nft_rule_attr_get_str;
+  nft_rule_parse;
   nft_rule_snprintf;
   nft_rule_nlmsg_build_hdr;
   nft_rule_nlmsg_build_payload;
diff --git a/src/rule.c b/src/rule.c
index 3945676..edc1a04 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -437,6 +437,189 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nft_rule *r)
 }
 EXPORT_SYMBOL(nft_rule_nlmsg_parse);
=20
+static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	struct nft_rule_expr *e;
+	struct expr_ops *ops;
+	char *endptr =3D NULL;
+	uint64_t tmp;
+
+	/* Load the tree */
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	/* get and set <rule ... family=3DX ... > */
+	if (mxmlElementGetAttr(tree, "family") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(mxmlElementGetAttr(tree, "family"), &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->family =3D (uint8_t)tmp;
+	r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
+
+	/* get and set <rule ... table=3DX ...> */
+	if (mxmlElementGetAttr(tree, "table") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (r->table)
+		free(r->table);
+
+	r->table =3D strdup(mxmlElementGetAttr(tree, "table"));
+
+	/* get and set <rule ... chain=3DX ...> */
+	if (mxmlElementGetAttr(tree, "chain") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (r->chain)
+		free(r->chain);
+
+	r->chain =3D strdup(mxmlElementGetAttr(tree, "chain"));
+	r->flags |=3D (1 << NFT_RULE_ATTR_CHAIN);
+
+	/* get and set <rule ... handle=3DX ...> */
+	if (mxmlElementGetAttr(tree, "handle") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(mxmlElementGetAttr(tree, "handle"), &endptr, 10);
+	if (tmp =3D=3D UINT64_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->handle =3D (uint64_t)tmp;
+	r->flags |=3D (1 << NFT_RULE_ATTR_HANDLE);
+
+	/* get and set <rule_flags> */
+	node =3D mxmlFindElement(tree, tree, "rule_flags", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->rule_flags =3D (uint32_t)tmp;
+	r->flags |=3D (1 << NFT_RULE_ATTR_FLAGS);
+
+	/* get and set <compat_proto> */
+	node =3D mxmlFindElement(tree, tree, "compat_proto", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->compat.proto =3D (uint32_t)tmp;
+	r->flags |=3D (1 << NFT_RULE_ATTR_COMPAT_PROTO);
+
+	/* get and set <compat_flags> */
+	node =3D mxmlFindElement(tree, tree, "compat_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->compat.flags =3D (uint32_t)tmp;
+	r->flags |=3D (1 << NFT_RULE_ATTR_COMPAT_FLAGS);
+
+	/* Iterating over <expr> */
+	for (node =3D mxmlFindElement(tree, tree, "expr", "type",
+				    NULL, MXML_DESCEND);
+		node !=3D NULL;
+		node =3D mxmlFindElement(node, tree, "expr", "type",
+				       NULL, MXML_DESCEND)) {
+
+		if (mxmlElementGetAttr(node, "type") =3D=3D NULL) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		ops =3D nft_expr_ops_lookup(mxmlElementGetAttr(node, "type"));
+		if (ops =3D=3D NULL) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		e =3D nft_rule_expr_alloc(mxmlElementGetAttr(node, "type"));
+		if (e =3D=3D NULL) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		/* This is a hack for mxml to print just the current node */
+		save =3D node->next;
+		node->next =3D NULL;
+
+		if (ops->xml_parse(e,
+				   mxmlSaveAllocString(node,
+						MXML_NO_CALLBACK)) !=3D 0) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		nft_rule_add_expr(r, e);
+
+		node->next =3D save;
+		save =3D NULL;
+	}
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, =
char *data)
+{
+	int ret;
+
+	switch (type) {
+	case NFT_RULE_PARSE_XML:
+		ret =3D nft_rule_xml_parse(r, data);
+		break;
+	default:
+		ret =3D -1;
+		errno =3D EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_rule_parse);
+
 static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_ru=
le *r,
 				 uint32_t type, uint32_t flags)
 {
diff --git a/src/table.c b/src/table.c
index 8adaba8..56f3567 100644
--- a/src/table.c
+++ b/src/table.c
@@ -13,6 +13,7 @@
 #include <time.h>
 #include <endian.h>
 #include <stdint.h>
+#include <limits.h>
 #include <stdlib.h>
 #include <string.h>
 #include <netinet/in.h>
@@ -182,6 +183,97 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nft_table *t)
 }
 EXPORT_SYMBOL(nft_table_nlmsg_parse);
=20
+static int nft_table_xml_parse(struct nft_table *t, char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	char *endptr =3D NULL;
+	uint64_t tmp;
+
+	/* NOTE: all XML nodes are mandatory */
+
+	/* Load the tree */
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL)
+		return -1;
+
+	/* Get and set the name of the table */
+	if (mxmlElementGetAttr(tree, "name") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (t->name)
+		free(t->name);
+
+	t->name =3D strdup(mxmlElementGetAttr(tree, "name"));
+	t->flags |=3D (1 << NFT_TABLE_ATTR_NAME);
+
+	/* Ignore <properties> node */
+	node =3D mxmlFindElement(tree, tree, "properties", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+
+	/* Get the and set <family> node */
+	node =3D mxmlFindElement(tree, tree, "family", NULL, NULL, MXML_DESCE=
ND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || *endptr || tmp < 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	t->family =3D (uint32_t)tmp;
+	t->flags |=3D (1 << NFT_TABLE_ATTR_FAMILY);
+
+	/* Get and set <table_flags> */
+	node =3D mxmlFindElement(tree, tree, "table_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || *endptr || tmp < 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	t->table_flags =3D (uint32_t)tmp;
+	t->flags |=3D (1 << NFT_TABLE_ATTR_FLAGS);
+
+	mxmlDelete(tree);
+	return 0;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+int nft_table_parse(struct nft_table *t, enum nft_table_parse_type typ=
e,
+		    char *data)
+{
+	int ret;
+
+	switch (type) {
+	case NFT_TABLE_PARSE_XML:
+		ret =3D nft_table_xml_parse(t, data);
+		break;
+	default:
+		ret =3D -1;
+		errno =3D EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_table_parse);
+
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_t=
able *t)
 {
 	return snprintf(buf, size,

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
