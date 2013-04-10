From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 5/5] src: support for XML parsing
Date: Wed, 10 Apr 2013 18:40:18 +0200
Message-ID: <20130410164018.6303.33046.stgit@nfdev.cica.es>
References: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36356 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965071Ab3DJQkW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:40:22 -0400
In-Reply-To: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds capabilities for parsing a XML table/chain/rule

Some points to note:
	* the XML data is case sensitive (so <chain>asd</chain> !=3D <chain>AS=
D</chain> !=3D <CHAIN>asd</CHAIN>)
	* All XML nodes in each object must be present for the XML to be valid=
=2E
	(following the format as printed by already included snprintf function=
s)
	* The API functions will receive a XML and return an object (aka table=
|chain|rule)
	* If error, -1 is returned. 0 if not. (you know, easily check if the p=
arsing went OK).

Nice things you could achieve with this patch and all XML-related stuff=
 in libnftables:
	* Export the current ruleset (or just one object) in XML format.
	* Edit a ruleset in XML.
	* Validate a XML ruleset, or each object.
	* Import to kernel a XML ruleset, or each object.
	* Possibly (using third party apps), do some XML-to-Json and Json-to-X=
ML conversions.
	* Build even nicer stuff on top of it.

NOTE: expr/target and expr/match are working, but somewhat provisional.
Actually a binary format, hard to deal within XML (at least for me).

Some code examples/test cases will be added to libnftables in a future =
patch.

Signed-off-by: Arturo Borrero Gonz=C3=A1lez <arturo.borrero.glez@gmail.=
com>
---
 Make_global.am              |    2=20
 configure.ac                |    1=20
 include/libnftables/chain.h |    1=20
 include/libnftables/rule.h  |    1=20
 include/libnftables/table.h |    1=20
 src/chain.c                 |  182 +++++++++++++++++++++++++++++++
 src/expr/bitwise.c          |  126 ++++++++++++++++++++++
 src/expr/cmp.c              |  120 +++++++++++++++++++++
 src/expr/counter.c          |   81 ++++++++++++++
 src/expr/data_reg.c         |  249 +++++++++++++++++++++++++++++++++++=
++++++++
 src/expr/immediate.c        |  110 +++++++++++++++++++
 src/expr/lookup.c           |   90 ++++++++++++++++
 src/expr/match.c            |  132 +++++++++++++++++++++++
 src/expr/meta.c             |   77 +++++++++++++
 src/expr/nat.c              |  147 +++++++++++++++++++++++++
 src/expr/payload.c          |  109 +++++++++++++++++++
 src/expr/target.c           |  133 +++++++++++++++++++++++
 src/expr_ops.h              |    1=20
 src/libnftables.map         |    3 +
 src/rule.c                  |  178 +++++++++++++++++++++++++++++++
 src/table.c                 |   88 +++++++++++++++
 21 files changed, 1831 insertions(+), 1 deletion(-)

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
index 01c170a..523133f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,6 +14,7 @@ m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
=20
 dnl Dependencies
 PKG_CHECK_MODULES([LIBMNL], [libmnl >=3D 1.0.0])
+PKG_CHECK_MODULES([LIBMXML], [mxml >=3D 2.6])
=20
 AC_PROG_CC
 AM_PROG_CC_C_O
diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index a7f6a50..af51191 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -44,6 +44,7 @@ enum {
 	NFT_CHAIN_O_XML,
 };
=20
+int nft_chain_xml_parse(struct nft_chain *c, char *xml);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, ui=
nt32_t type, uint32_t flags);
=20
 struct nlmsghdr *nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, ui=
nt16_t family, uint16_t type, uint32_t seq);
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 50222c5..6eb7efc 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -43,6 +43,7 @@ enum {
 	NFT_RULE_O_XML,
 };
=20
+int nft_rule_xml_parse(struct nft_rule *r, char *xml);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint=
32_t type, uint32_t flags);
=20
 struct nlmsghdr *nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uin=
t16_t family, uint16_t type, uint32_t seq);
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index f367bb8..376749e 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -31,6 +31,7 @@ enum {
 	NFT_TABLE_O_XML,
 };
=20
+int nft_table_xml_parse(struct nft_table *t, char *xml);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, ui=
nt32_t type, uint32_t flags);
=20
 struct nlmsghdr *nft_table_nlmsg_build_hdr(char *buf, uint16_t cmd, ui=
nt16_t family, uint16_t type, uint32_t seq);
diff --git a/src/chain.c b/src/chain.c
index 4c111b6..b1126f5 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -20,6 +20,7 @@
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
+#include <mxml.h>
=20
 #include <libnftables/chain.h>
=20
@@ -446,6 +447,187 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nft_chain *c)
 }
 EXPORT_SYMBOL(nft_chain_nlmsg_parse);
=20
+int nft_chain_xml_parse(struct nft_chain *c, char *xml)
+{
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	char *endptr =3D NULL;
+	unsigned long long int utmp;
+	long int tmp;
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
+
+	/* Get and set <chain handle=3D"x" ... >*/
+	if (mxmlElementGetAttr(tree, "handle") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/*
+	* checking here (and followings):
+	*       dest type overflow,
+	*       strtoul overflow,
+	*       bad string
+	*/
+	errno =3D 0;
+	utmp =3D strtoull(mxmlElementGetAttr(tree, "handle"), &endptr, 10);
+	if (utmp > UINT64_MAX || utmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	c->handle =3D (uint64_t)utmp;
+
+	/* Get and set <chain bytes=3D"x" ... >*/
+	if (mxmlElementGetAttr(tree, "bytes") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoull(mxmlElementGetAttr(tree, "bytes"), &endptr, 10);
+	if (utmp > UINT64_MAX || utmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	c->bytes =3D (uint64_t)utmp;
+
+	/* Get and set <chain packets=3D"x" ... > */
+	if (mxmlElementGetAttr(tree, "packets") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoull(mxmlElementGetAttr(tree, "packets"), &endptr, 10);
+	if (utmp > UINT64_MAX || utmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	c->packets =3D (uint64_t)utmp;
+
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
+
+	/* Get and set <prio> */
+	node =3D mxmlFindElement(tree, tree, "prio", NULL, NULL, MXML_DESCEND=
);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtol(node->child->value.opaque, &endptr, 10);
+	if (tmp > INT32_MAX || tmp < INT32_MIN || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(&c->prio, &tmp, sizeof(c->prio));
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
+	utmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (utmp > UINT32_MAX || utmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(&c->hooknum, &utmp, sizeof(c->hooknum));
+
+	/* Get and set <policy> */
+	node =3D mxmlFindElement(tree, tree, "policy", NULL, NULL, MXML_DESCE=
ND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (utmp > UINT32_MAX || utmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	c->policy =3D (uint32_t)utmp;
+
+	/* Get and set <family> */
+	node =3D mxmlFindElement(tree, tree, "family", NULL, NULL, MXML_DESCE=
ND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (utmp > UINT8_MAX || utmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	c->family =3D (uint32_t)utmp;
+
+	/* Get and set <flags> */
+	node =3D mxmlFindElement(tree, tree, "flags", NULL, NULL, MXML_DESCEN=
D);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	utmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (utmp > UINT32_MAX || utmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	c->flags =3D (uint32_t)utmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+EXPORT_SYMBOL(nft_chain_xml_parse);
+
 static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_c=
hain *c)
 {
 	return snprintf(buf, size,
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 4376fa0..ef68042 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -22,6 +22,8 @@
 #include "data_reg.h"
 #include "expr_ops.h"
=20
+#include <mxml.h>
+
 struct nft_expr_bitwise {
 	enum nft_registers	sreg;
 	enum nft_registers	dreg;
@@ -195,6 +197,129 @@ nft_rule_expr_bitwise_parse(struct nft_rule_expr =
*e, struct nlattr *attr)
 	return ret;
 }
=20
+static int nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, ch=
ar *xml)
+{
+	struct nft_expr_bitwise *bitwise =3D (struct nft_expr_bitwise *)e->da=
ta;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	unsigned long int tmp;
+	union nft_data_reg data_regtmp;
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
+	if (strcmp("bitwise", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+
+	/* get and set <sreg> */
+	node =3D mxmlFindElement(tree, tree, "sreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/*
+	* Checking here (and followins)
+	*	dst type overflow
+	*	strtol overflow
+	*	bad number string
+	*/
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	bitwise->sreg =3D (uint32_t)tmp;
+
+	/* get and set <dreg> */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL, MXML_DESCEND=
);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	bitwise->dreg =3D (uint32_t)tmp;
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
+
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
+
+	/* get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags",
+			       NULL, NULL, MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
 static int
 nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 				   struct nft_rule_expr *e)
@@ -283,4 +408,5 @@ struct expr_ops expr_ops_bitwise =3D {
 	.parse		=3D nft_rule_expr_bitwise_parse,
 	.build		=3D nft_rule_expr_bitwise_build,
 	.snprintf	=3D nft_rule_expr_bitwise_snprintf,
+	.xml_parse	=3D nft_rule_expr_bitwise_xml_parse,
 };
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index e1e76a6..c91d90d 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -23,6 +23,8 @@
 #include "expr_ops.h"
 #include "data_reg.h"
=20
+#include <mxml.h>
+
 struct nft_expr_cmp {
 	union nft_data_reg	data;
 	uint8_t			sreg;	/* enum nft_registers */
@@ -166,6 +168,123 @@ static char *expr_cmp_str[] =3D {
 	[NFT_CMP_GTE]	=3D "gte",
 };
=20
+static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, char *=
xml)
+{
+	struct nft_expr_cmp *cmp =3D (struct nft_expr_cmp *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	union nft_data_reg data_regtmp;
+	unsigned int tmp;
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
+	if (strcmp("cmp", mxmlElementGetAttr(tree, "type")) !=3D 0) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/* Get and set <sreg> */
+	node =3D mxmlFindElement(tree, tree, "sreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	/*
+	* Checking here (and followings)
+	*	dst data type overflow
+	*	strtol overflow
+	*	bad number string
+	*/
+
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0)=
 {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	cmp->sreg =3D (uint8_t)tmp;
+
+	/* Get and set <op> */
+	node =3D mxmlFindElement(tree, tree, "op", NULL, NULL, MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	if (strcmp(node->child->value.opaque, "eq") =3D=3D 0) {
+		cmp->op =3D NFT_CMP_EQ;
+	} else if (strcmp(node->child->value.opaque, "neq") =3D=3D 0) {
+		cmp->op =3D NFT_CMP_NEQ;
+	} else if (strcmp(node->child->value.opaque, "lt") =3D=3D 0) {
+		cmp->op =3D NFT_CMP_LT;
+	} else if (strcmp(node->child->value.opaque, "lte") =3D=3D 0) {
+		cmp->op =3D NFT_CMP_LTE;
+	} else if (strcmp(node->child->value.opaque, "gt") =3D=3D 0) {
+		cmp->op =3D NFT_CMP_GT;
+	} else if (strcmp(node->child->value.opaque, "gte") =3D=3D 0) {
+		cmp->op =3D NFT_CMP_GTE;
+	} else {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags |=3D (1 << NFT_EXPR_CMP_OP);
+
+	/* Get and set <cmpdata> */
+	node =3D mxmlFindElement(tree, tree, "cmpdata", NULL, NULL,
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
+
+	node->next =3D save;
+
+	memcpy(&cmp->data.val, data_regtmp.val, data_regtmp.len);
+	cmp->data.len =3D data_regtmp.len;
+
+	/* Get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
+
 static int
 nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_rule=
_expr *e)
 {
@@ -232,4 +351,5 @@ struct expr_ops expr_ops_cmp =3D {
 	.parse		=3D nft_rule_expr_cmp_parse,
 	.build		=3D nft_rule_expr_cmp_build,
 	.snprintf	=3D nft_rule_expr_cmp_snprintf,
+	.xml_parse	=3D nft_rule_expr_cmp_xml_parse,
 };
diff --git a/src/expr/counter.c b/src/expr/counter.c
index ec6f637..9b39cc2 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -21,6 +21,8 @@
 #include <libnftables/rule.h>
 #include "expr_ops.h"
=20
+#include <mxml.h>
+
 struct nft_expr_counter {
 	uint64_t	pkts;
 	uint64_t	bytes;
@@ -125,6 +127,84 @@ nft_rule_expr_counter_parse(struct nft_rule_expr *=
e, struct nlattr *attr)
 	return 0;
 }
=20
+
+static
+int nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, char *xml=
)
+{
+	struct nft_expr_counter *ctr =3D (struct nft_expr_counter *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	char *endptr;
+	unsigned long long int tmp;
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
+	/* get and set <pkts> */
+	node =3D mxmlFindElement(tree, tree, "pkts", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT64_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	ctr->pkts =3D (uint64_t)tmp;
+
+	/* get and set <bytes> */
+	node =3D mxmlFindElement(tree, tree, "bytes", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT64_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	ctr->bytes =3D (uint64_t)tmp;
+
+	/* get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
+
 static int
 nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
@@ -155,4 +235,5 @@ struct expr_ops expr_ops_counter =3D {
 	.parse		=3D nft_rule_expr_counter_parse,
 	.build		=3D nft_rule_expr_counter_build,
 	.snprintf	=3D nft_rule_expr_counter_snprintf,
+	.xml_parse	=3D nft_rule_expr_counter_xml_parse,
 };
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index d7010ad..3f66452 100644
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
@@ -23,6 +24,253 @@
 #include "data_reg.h"
 #include "internal.h"
=20
+#include <mxml.h>
+
+static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, cha=
r *xml)
+{
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	char *endptr;
+	long int tmp;
+
+	/*
+	* <data_reg type=3D"verdict" >
+		<verdict>int</verdict>
+	* </data_reg>
+	*/
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
+	tmp =3D strtol(node->child->value.opaque, &endptr, 10);
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
+}
+
+static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char =
*xml)
+{
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+
+	/*
+	* <data_reg type=3D"chain" >
+		<chain>string</chain>
+	* </data_reg>
+	*/
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
+}
+
+static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char =
*xml)
+{
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	int i, len;
+	long int tmp;
+	unsigned long int utmp;
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
+	/*
+	* Checking here (and followings):
+	*	dest type overflow
+	*	strtol overflow
+	*	bad string
+	*/
+
+	errno =3D 0;
+	tmp =3D strtol(node->child->value.opaque, &endptr, 10);
+	if (tmp > INT_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0) {
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
+		utmp =3D strtoul(node->child->value.opaque, &endptr, 16);
+		if (utmp > UINT32_MAX || utmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
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
+}
+
+int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
+{
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
+	return -1;
+}
+
+
+
 static
 int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 				    union nft_data_reg *reg, uint32_t flags)
@@ -251,3 +499,4 @@ int nft_parse_data(union nft_data_reg *data, struct=
 nlattr *attr, int *type)
=20
 	return ret;
 }
+
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index d59f109..8fb1df8 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -22,6 +22,8 @@
 #include "expr_ops.h"
 #include "data_reg.h"
=20
+#include <mxml.h>
+
 struct nft_expr_immediate {
 	union nft_data_reg	data;
 	enum nft_registers	dreg;
@@ -195,6 +197,113 @@ nft_rule_expr_immediate_parse(struct nft_rule_exp=
r *e, struct nlattr *attr)
 	return ret;
 }
=20
+static
+int nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, char *x=
ml)
+{
+	struct nft_expr_immediate *imm =3D (struct nft_expr_immediate *)e->da=
ta;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	union nft_data_reg data_regtmp;
+	uint32_t tmp;
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
+	/* Get and set <dreg> */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	imm->dreg =3D (uint32_t)tmp;
+
+	/* Get and set <immdata> */
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
+	} else if (strcmp(mxmlElementGetAttr(node, "type"), "verdict") =3D=3D=
 0) {
+		imm->data.verdict =3D data_regtmp.verdict;
+	} else if (strcmp(mxmlElementGetAttr(node, "type"), "chain") =3D=3D 0=
) {
+		if (imm->data.chain)
+			free(imm->data.chain);
+
+		imm->data.chain =3D strdup(data_regtmp.chain);
+	}
+
+	/* Get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
 static int
 nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
 				     struct nft_rule_expr *e, uint32_t flags)
@@ -286,4 +395,5 @@ struct expr_ops expr_ops_immediate =3D {
 	.parse		=3D nft_rule_expr_immediate_parse,
 	.build		=3D nft_rule_expr_immediate_build,
 	.snprintf	=3D nft_rule_expr_immediate_snprintf,
+	.xml_parse	=3D nft_rule_expr_immediate_xml_parse,
 };
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 2abe82e..2a81465 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -22,6 +22,8 @@
 #include "data_reg.h"
 #include "expr_ops.h"
=20
+#include <mxml.h>
+
 #ifndef IFNAMSIZ
 #define IFNAMSIZ	16
 #endif
@@ -150,6 +152,93 @@ nft_rule_expr_lookup_parse(struct nft_rule_expr *e=
, struct nlattr *attr)
 	return ret;
 }
=20
+static int nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, cha=
r *xml)
+{
+	struct nft_expr_lookup *lookup =3D (struct nft_expr_lookup *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	unsigned long int tmp;
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
+	/* get and set <set> */
+	node =3D mxmlFindElement(tree, tree, "set", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(lookup->set_name, node->child->value.opaque, IFNAMSIZ);
+	lookup->set_name[IFNAMSIZ-1] =3D '\0';
+
+	/* get and set <sreg> */
+	node =3D mxmlFindElement(tree, tree, "sreg", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	lookup->sreg =3D (uint32_t)tmp;
+
+	/* get and set <dreg> */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	lookup->dreg =3D (uint32_t)tmp;
+
+	/* get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
 static int
 nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
 				  struct nft_rule_expr *e)
@@ -203,4 +292,5 @@ struct expr_ops expr_ops_lookup =3D {
 	.parse		=3D nft_rule_expr_lookup_parse,
 	.build		=3D nft_rule_expr_lookup_build,
 	.snprintf	=3D nft_rule_expr_lookup_snprintf,
+	.xml_parse	=3D nft_rule_expr_lookup_xml_parse,
 };
diff --git a/src/expr/match.c b/src/expr/match.c
index 9a2696e..8b67df7 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -25,6 +25,8 @@
 #include <libnftables/expr.h>
 #include <libnftables/rule.h>
=20
+#include <mxml.h>
+
 #include "expr_ops.h"
=20
 struct nft_expr_match {
@@ -184,6 +186,135 @@ static int nft_rule_expr_match_parse(struct nft_r=
ule_expr *e, struct nlattr *att
 	return 0;
 }
=20
+static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, char=
 *xml)
+{
+	struct nft_expr_match *mt =3D (struct nft_expr_match *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	uint8_t *info;
+	int i;
+	char node_name[6];
+	unsigned long int tmp;
+	uint32_t len;
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
+	/* get and set <name> */
+	node =3D mxmlFindElement(tree, tree, "name", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(mt->name, node->child->value.opaque, XT_EXTENSION_MAXNAMELEN);
+	mt->name[XT_EXTENSION_MAXNAMELEN-1] =3D '\0';
+
+	/* get and set <rev> */
+	node =3D mxmlFindElement(tree, tree, "rev", NULL, NULL, MXML_DESCEND)=
;
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	mt->rev =3D (uint32_t)tmp;
+
+	/* Get and set <info> */
+	node =3D mxmlFindElement(tree, tree, "info", NULL, NULL, MXML_DESCEND=
);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	node =3D mxmlFindElement(tree, tree, "len", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	len =3D (uint32_t)tmp;
+
+	/* parsing the binary data in multiple <dataN>0xff</dataN> */
+	info =3D (uint8_t *)malloc(len);
+	for (i =3D 0; i < len; i++) {
+		sprintf(node_name, "data%d", i);
+
+		node =3D mxmlFindElement(tree, tree, node_name,
+				       NULL, NULL, MXML_DESCEND);
+		if (node =3D=3D NULL) {
+			free(info);
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		tmp =3D strtoul(node->child->value.opaque, &endptr, 16);
+		if (tmp > UINT8_MAX || tmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+			free(info);
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		info[i] =3D (uint8_t)tmp;
+	}
+
+	if (mt->data)
+		free(mt->data);
+
+	mt->data =3D info;
+	free(info);
+	mt->data_len =3D len;
+
+	/* get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags",
+			       NULL, NULL, MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
+
 static
 int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 				struct nft_rule_expr *e)
@@ -240,4 +371,5 @@ struct expr_ops expr_ops_match =3D {
 	.parse		=3D nft_rule_expr_match_parse,
 	.build		=3D nft_rule_expr_match_build,
 	.snprintf	=3D nft_rule_expr_match_snprintf,
+	.xml_parse	=3D nft_rule_expr_match_xml_parse,
 };
diff --git a/src/expr/meta.c b/src/expr/meta.c
index e342a6d..20dcb07 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -21,6 +21,9 @@
 #include <libnftables/rule.h>
 #include "expr_ops.h"
=20
+#include <mxml.h>
+
+
 struct nft_expr_meta {
 	uint8_t			key;	/* enum nft_meta_keys */
 	uint8_t			dreg;	/* enum nft_registers */
@@ -125,6 +128,79 @@ nft_rule_expr_meta_parse(struct nft_rule_expr *e, =
struct nlattr *attr)
 	return 0;
 }
=20
+static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, char =
*xml)
+{
+	struct nft_expr_meta *meta =3D (struct nft_expr_meta *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	unsigned long int tmp;
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
+	/* Get and set <dreg> */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0)=
 {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	meta->dreg =3D (uint8_t)tmp;
+
+	/* Get and set <key> */
+	node =3D mxmlFindElement(tree, tree, "key", NULL, NULL, MXML_DESCEND)=
;
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0)=
 {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	meta->key =3D (uint8_t)tmp;
+
+	/* Get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags", NULL, NULL, MXML_D=
ESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
 static int
 nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
@@ -155,4 +231,5 @@ struct expr_ops expr_ops_meta =3D {
 	.parse		=3D nft_rule_expr_meta_parse,
 	.build		=3D nft_rule_expr_meta_build,
 	.snprintf	=3D nft_rule_expr_meta_snprintf,
+	.xml_parse	=3D nft_rule_expr_meta_xml_parse,
 };
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 382862a..b1b43cc 100644
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
@@ -21,6 +22,8 @@
 #include <libnftables/rule.h>
 #include "expr_ops.h"
=20
+#include <mxml.h>
+
 struct nft_expr_nat {
 	enum nft_registers sreg_addr_min;
 	enum nft_registers sreg_addr_max;
@@ -201,6 +204,149 @@ nft_rule_expr_nat_build(struct nlmsghdr *nlh, str=
uct nft_rule_expr *e)
 				 htonl(nat->sreg_proto_max));
 }
=20
+
+static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *=
xml)
+{
+	struct nft_expr_nat *nat =3D (struct nft_expr_nat *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	unsigned long int tmp;
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
+	/* Get and set <type> */
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
+
+	/* Get and set <family> */
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
+	/* Get and set <sreg_addr_min_v4> */
+	node =3D mxmlFindElement(tree, tree, "sreg_addr_min_v4", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) < 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	nat->sreg_addr_min =3D (uint32_t)tmp;
+
+	/* Get and set <sreg_addr_max_v4> */
+	node =3D mxmlFindElement(tree, tree, "sreg_addr_max_v4", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) < 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	nat->sreg_addr_max =3D (uint32_t)tmp;
+
+	/* Get and set <sreg_proto_min> */
+	node =3D mxmlFindElement(tree, tree, "sreg_proto_min", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) < 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	nat->sreg_proto_min =3D (uint32_t)tmp;
+
+	/* Get and set <sreg_proto_max> */
+	node =3D mxmlFindElement(tree, tree, "sreg_proto_max", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) < 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	nat->sreg_proto_max =3D (uint32_t)tmp;
+
+	/* Get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) < 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
+
 static int
 nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 				struct nft_rule_expr *e)
@@ -309,4 +455,5 @@ struct expr_ops expr_ops_nat =3D {
 	.parse		=3D nft_rule_expr_nat_parse,
 	.build		=3D nft_rule_expr_nat_build,
 	.snprintf	=3D nft_rule_expr_nat_snprintf,
+	.xml_parse	=3D nft_rule_expr_nat_xml_parse,
 };
diff --git a/src/expr/payload.c b/src/expr/payload.c
index b72be96..271ad36 100644
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
@@ -24,6 +25,8 @@
=20
 #include "expr_ops.h"
=20
+#include <mxml.h>
+
 struct nft_expr_payload {
 	enum nft_registers	dreg;
 	enum nft_payload_bases	base;
@@ -164,6 +167,111 @@ nft_rule_expr_payload_parse(struct nft_rule_expr =
*e, struct nlattr *attr)
 	return 0;
 }
=20
+static int nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, ch=
ar *xml)
+{
+	struct nft_expr_payload *payload =3D (struct nft_expr_payload *)e->da=
ta;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	unsigned long int tmp;
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
+	/* Get and set <dreg> */
+	node =3D mxmlFindElement(tree, tree, "dreg", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	payload->dreg =3D (uint32_t)tmp;
+
+	/* Get and set <base> */
+	node =3D mxmlFindElement(tree, tree, "base", NULL, NULL, MXML_DESCEND=
);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	payload->base =3D (uint32_t)tmp;
+
+	/* Get and set <offset> */
+	node =3D mxmlFindElement(tree, tree, "offset", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0) =
{
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	payload->offset =3D (unsigned int)tmp;
+
+	/* Get and set <len> */
+	node =3D mxmlFindElement(tree, tree, "len", NULL, NULL, MXML_DESCEND)=
;
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0) =
{
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	payload->len =3D (unsigned int)tmp;
+
+	/* Get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags",
+			       NULL, NULL, MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0) =
{
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+
 static int
 nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
@@ -198,4 +306,5 @@ struct expr_ops expr_ops_payload =3D {
 	.parse		=3D nft_rule_expr_payload_parse,
 	.build		=3D nft_rule_expr_payload_build,
 	.snprintf	=3D nft_rule_expr_payload_snprintf,
+	.xml_parse	=3D nft_rule_expr_payload_xml_parse,
 };
diff --git a/src/expr/target.c b/src/expr/target.c
index 5ceecce..ddc8513 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -27,6 +27,8 @@
=20
 #include "expr_ops.h"
=20
+#include <mxml.h>
+
 struct nft_expr_target {
 	char		name[XT_EXTENSION_MAXNAMELEN];
 	uint32_t	rev;
@@ -184,6 +186,136 @@ static int nft_rule_expr_target_parse(struct nft_=
rule_expr *e, struct nlattr *at
 	return 0;
 }
=20
+static int nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, cha=
r *xml)
+{
+	struct nft_expr_target *tg =3D (struct nft_expr_target *)e->data;
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	unsigned long int tmp;
+	uint8_t *info;
+	int i;
+	char *endptr;
+	char node_name[6];
+	uint32_t len;
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
+	/* Get and set <name> */
+	node =3D mxmlFindElement(tree, tree, "name", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	memcpy(tg->name, node->child->value.opaque, XT_EXTENSION_MAXNAMELEN);
+	tg->name[XT_EXTENSION_MAXNAMELEN-1] =3D '\0';
+
+	/* Get and set <rev> */
+	node =3D mxmlFindElement(tree, tree, "rev", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tg->rev =3D (uint32_t)tmp;
+
+	/* Get and set <info> */
+	node =3D mxmlFindElement(tree, tree, "info", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	node =3D mxmlFindElement(tree, tree, "len", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	len =3D (uint32_t)tmp;
+
+	/* parsing the binary data in multiple <dataN>0xff</dataN> */
+	info =3D (uint8_t *)malloc(len);
+	for (i =3D 0; i < len; i++) {
+		sprintf(node_name, "data%d", i);
+
+		node =3D mxmlFindElement(tree, tree, node_name,
+				       NULL, NULL, MXML_DESCEND);
+		if (node =3D=3D NULL) {
+			free(info);
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		tmp =3D strtoul(node->child->value.opaque, &endptr, 16);
+		if (tmp > UINT8_MAX || tmp < 0 || errno !=3D 0
+						|| strlen(endptr) > 0) {
+			free(info);
+			mxmlDelete(tree);
+			return -1;
+		}
+
+		info[i] =3D (uint8_t)tmp;
+	}
+
+	if (tg->data)
+		free(tg->data);
+
+	tg->data =3D info;
+	free(info);
+	tg->data_len =3D len;
+
+	/* Get and set <expr_flags> */
+	node =3D mxmlFindElement(tree, tree, "expr_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	e->flags =3D (uint32_t)tmp;
+
+
+	mxmlDelete(tree);
+	return 0;
+}
+
 static
 int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 				struct nft_rule_expr *e)
@@ -240,4 +372,5 @@ struct expr_ops expr_ops_target =3D {
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
diff --git a/src/libnftables.map b/src/libnftables.map
index 957e3b6..5913976 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -6,6 +6,7 @@ global:
   nft_table_attr_get;
   nft_table_attr_set_u32;
   nft_table_attr_get_u32;
+  nft_table_xml_parse;
   nft_table_snprintf;
   nft_table_nlmsg_build_hdr;
   nft_table_nlmsg_build_payload;
@@ -28,6 +29,7 @@ global:
   nft_chain_attr_get_s32;
   nft_chain_attr_get_u64;
   nft_chain_attr_get_str;
+  nft_chain_xml_parse;
   nft_chain_snprintf;
   nft_chain_nlmsg_build_hdr;
   nft_chain_nlmsg_build_payload;
@@ -51,6 +53,7 @@ global:
   nft_rule_attr_get_u32;
   nft_rule_attr_get_u64;
   nft_rule_attr_get_str;
+  nft_rule_xml_parse;
   nft_rule_snprintf;
   nft_rule_nlmsg_build_hdr;
   nft_rule_nlmsg_build_payload;
diff --git a/src/rule.c b/src/rule.c
index 6178e57..73d6401 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -27,6 +27,8 @@
 #include "linux_list.h"
 #include "expr_ops.h"
=20
+#include "mxml.h"
+
 struct nft_rule {
 	struct list_head head;
=20
@@ -437,6 +439,182 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nft_rule *r)
 }
 EXPORT_SYMBOL(nft_rule_nlmsg_parse);
=20
+int nft_rule_xml_parse(struct nft_rule *r, char *xml)
+{
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	struct nft_rule_expr *e;
+	struct expr_ops *ops;
+	char *endptr;
+	unsigned long long int tmp;
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
+	/*
+	* Checking here (and followings):
+	*	dest type overflow
+	*	strtol overflow
+	*	badformed number string
+	*/
+	errno =3D 0;
+	tmp =3D strtoull(mxmlElementGetAttr(tree, "family"), &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0)=
 {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->family =3D (uint8_t)tmp;
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
+
+	/* get and set <rule ... handle=3DX ...> */
+	if (mxmlElementGetAttr(tree, "handle") =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(mxmlElementGetAttr(tree, "handle"), &endptr, 10);
+	if (tmp > UINT64_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->handle =3D (uint64_t)tmp;
+
+	/* get and set <rule_flags> */
+	node =3D mxmlFindElement(tree, tree, "rule_flags", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->rule_flags =3D (uint32_t)tmp;
+
+	/* get and set <compat_proto> */
+	node =3D mxmlFindElement(tree, tree, "compat_proto", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->compat.proto =3D (uint32_t)tmp;
+
+	/* get and set <compat_flags> */
+	node =3D mxmlFindElement(tree, tree, "compat_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp =3D strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->compat.flags =3D (uint32_t)tmp;
+
+	/* get and set <flags> */
+	node =3D mxmlFindElement(tree, tree, "flags", NULL, NULL,	MXML_DESCEN=
D);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	r->flags =3D (uint32_t)tmp;
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
+		if (ops->xml_parse(e, mxmlSaveAllocString(node,
+				   MXML_NO_CALLBACK)) !=3D 0) {
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
+}
+EXPORT_SYMBOL(nft_rule_xml_parse);
+
 static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_ru=
le *r,
 				 uint32_t type, uint32_t flags)
 {
diff --git a/src/table.c b/src/table.c
index b47d623..759f9a8 100644
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
@@ -21,6 +22,8 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
=20
+#include <mxml.h>
+
 #include <libnftables/table.h>
=20
 struct nft_table {
@@ -182,6 +185,91 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nft_table *t)
 }
 EXPORT_SYMBOL(nft_table_nlmsg_parse);
=20
+int nft_table_xml_parse(struct nft_table *t, char *xml)
+{
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	char *endptr;
+	unsigned long int tmp;
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
+	/*
+	* checking here (and followings):
+	*	dest type overflow,
+	*	strtoul overflow,
+	*	bad string
+	*/
+	errno =3D 0;
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0)=
 {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	t->family =3D (uint32_t)tmp;
+
+	/* Get and set <table_flags> */
+	node =3D mxmlFindElement(tree, tree, "table_flags", NULL, NULL,
+			       MXML_DESCEND);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	t->table_flags =3D (uint32_t)tmp;
+
+	/* Get and st <flags> */
+	node =3D mxmlFindElement(tree, tree, "flags", NULL, NULL, MXML_DESCEN=
D);
+	if (node =3D=3D NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	tmp =3D strtoul(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || errno !=3D 0 || strlen(endptr) > 0=
) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	t->flags =3D (uint32_t)tmp;
+
+	mxmlDelete(tree);
+	return 0;
+}
+EXPORT_SYMBOL(nft_table_xml_parse);
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
