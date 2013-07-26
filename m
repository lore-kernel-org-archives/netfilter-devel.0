From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] set: XML parse
Date: Fri, 26 Jul 2013 11:47:09 +0200
Message-ID: <20130726094451.951.8098.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34013 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752550Ab3GZJrU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:47:20 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BD96E51EEA5
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 09:47:17 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aIi1ui2tJSND for <netfilter-devel@vger.kernel.org>;
	Fri, 26 Jul 2013 11:47:11 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id C1CBF51EDBA
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 11:47:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sets are now parsed, following this previous snprintf pattern:

<set name=3D"xx" table=3D"xx" version=3D"xx">
	<set_flags>uint32_t</set_flags>
	<key_type>uint32_t</key_type>
	<key_len>size_t</key_len>
	<data_type>uint32_t</data_type>
	<data_len>size_t</data_len>
	<set_elem>
		<set_elem_flags>uint32_t</set_elem_flags>
		<set_elem_key>
			<data_reg type=3D"value">
				<len></len>
				<dataN></dataN>
			</data_reg>
		</set_elem_key>
		<set_elem_data>
			<data_reg type=3D"xx">
				[...]
			</data_reg>
		</set_elem_data>
	</set_elem>
</set>


Signed-off-by: Arturo Borrero Gonz=C3=A1lez <arturo.borrero.glez@gmail.=
com>
---
v1: initial version.
v2: - let helper version set errno.
    - Move set_elem parsing to a helper function.
    - <set_elem_data> is now optional.
    - realistic testsfiles, also with IPv6 data.

 tests/nft-parsing-test.c  |   10 ++++++++++
 tests/xmlfiles/73-set.xml |   36 ++++++++++++++++++++++++++++++++++++
 tests/xmlfiles/74-set.xml |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)
 create mode 100644 tests/xmlfiles/73-set.xml
 create mode 100644 tests/xmlfiles/74-set.xml

diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 6023d50..4fc3a8d 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -52,6 +52,14 @@ struct nft_set *nft_set_list_iter_cur(struct nft_set=
_list_iter *iter);
 struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter)=
;
 void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
=20
+enum nft_set_parse_type {
+	NFT_SET_PARSE_NONE	=3D 0,
+	NFT_SET_PARSE_XML,
+	NFT_SET_PARSE_MAX,
+};
+
+int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type, cha=
r *data);
+
 /*
  * Set elements
  */
@@ -94,6 +102,7 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghd=
r *nlh, struct nft_set_elem
=20
 int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_se=
t_elem *s);
=20
+int nft_set_elem_parse(struct nft_set_elem *e, enum nft_set_parse_type=
 type, char *data);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem =
*s, uint32_t type, uint32_t flags);
=20
 int nft_set_elem_foreach(struct nft_set *s, int (*cb)(struct nft_set_e=
lem *e, void *data), void *data);
diff --git a/src/internal.h b/src/internal.h
index 47cd635..1970c9c 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -36,6 +36,7 @@ union nft_data_reg;
 int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name, =
union nft_data_reg *data_reg);
 int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name, uint3=
2_t mxml_flags, int base, void *number, enum nft_type type);
 const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_nam=
e, uint32_t mxml_flags);
+struct nft_set_elem *nft_mxml_set_elem_parse(mxml_node_t *node);
 #endif
=20
 #ifdef JSON_PARSING
diff --git a/src/libnftables.map b/src/libnftables.map
index f2084d9..614c705 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -120,6 +120,7 @@ global:
   nft_set_nlmsg_build_hdr;
   nft_set_nlmsg_build_payload;
   nft_set_nlmsg_parse;
+  nft_set_parse;
   nft_set_snprintf;
=20
   nft_set_list_alloc;
@@ -149,6 +150,7 @@ global:
   nft_set_elem_nlmsg_build_hdr;
   nft_set_elem_nlmsg_build_payload;
   nft_set_elem_nlmsg_parse;
+  nft_set_elem_parse;
   nft_set_elem_snprintf;
=20
   nft_set_elems_nlmsg_build_payload;
diff --git a/src/mxml.c b/src/mxml.c
index f812bf6..84514da 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <libnftables/rule.h>
 #include <libnftables/expr.h>
+#include <libnftables/set.h>
=20
 #ifdef XML_PARSING
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node)
@@ -165,4 +166,49 @@ const char *nft_mxml_str_parse(mxml_node_t *tree, =
const char *node_name,
 	return strdup(node->child->value.opaque);
 }
=20
+struct nft_set_elem *nft_mxml_set_elem_parse(mxml_node_t *node)
+{
+	mxml_node_t *save;
+	char *set_elem_str;
+	struct nft_set_elem *elem;
+
+	if (node =3D=3D NULL)
+		goto einval;
+
+	if (strcmp(node->value.opaque, "set_elem") !=3D 0)
+		goto einval;
+
+	elem =3D nft_set_elem_alloc();
+	if (elem =3D=3D NULL)
+		goto enomem;
+
+	/* This is a hack for mxml to print just the current node */
+	save =3D node->next;
+	node->next =3D NULL;
+
+	set_elem_str =3D mxmlSaveAllocString(node, MXML_NO_CALLBACK);
+	node->next =3D save;
+
+	if (set_elem_str =3D=3D NULL) {
+		free(elem);
+		goto enomem;
+	}
+
+	if (nft_set_elem_parse(elem, NFT_SET_PARSE_XML,
+			       set_elem_str) !=3D 0) {
+		free(set_elem_str);
+		free(elem);
+		return NULL;
+	}
+
+	free(set_elem_str);
+
+	return elem;
+einval:
+	errno =3D EINVAL;
+	return NULL;
+enomem:
+	errno =3D ENOMEM;
+	return NULL;
+}
 #endif
diff --git a/src/set.c b/src/set.c
index ef15527..891bd08 100644
--- a/src/set.c
+++ b/src/set.c
@@ -16,6 +16,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <netinet/in.h>
+#include <limits.h>
+#include <errno.h>
=20
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -301,6 +303,141 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nl=
h, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
=20
+static int nft_set_xml_parse(struct nft_set *s, char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree;
+	mxml_node_t *node =3D NULL;
+	struct nft_set_elem *elem;
+	int version;
+	int family;
+	char *family_str;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	if (strcmp(tree->value.opaque, "set") !=3D 0)
+		goto err;
+
+	if (mxmlElementGetAttr(tree, "version") =3D=3D NULL)
+		goto err;
+
+	if (nft_strtoi(mxmlElementGetAttr(tree, "version"), 10, &version,
+		       NFT_TYPE_U64) !=3D 0)
+		goto err;
+
+	if (version !=3D NFT_SET_XML_VERSION)
+		goto err;
+
+	if (mxmlElementGetAttr(tree, "name") =3D=3D NULL)
+		goto err;
+
+	if (s->name)
+		free(s->name);
+
+	s->name =3D strdup(mxmlElementGetAttr(tree, "name"));
+	s->flags |=3D (1 << NFT_SET_ATTR_NAME);
+
+	if (mxmlElementGetAttr(tree, "table") =3D=3D NULL)
+		goto err;
+
+	if (s->table)
+		free(s->table);
+
+	s->table =3D strdup(mxmlElementGetAttr(tree, "table"));
+	s->flags |=3D (1 << NFT_SET_ATTR_TABLE);
+
+	family_str =3D (char *)nft_mxml_str_parse(tree, "family",
+						MXML_DESCEND_FIRST);
+	if (family_str =3D=3D NULL)
+		goto err;
+
+	family =3D nft_str2family(family_str);
+
+	if (family < 0)
+		goto err;
+
+	s->family =3D family;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_FAMILY);
+
+	if (nft_mxml_num_parse(tree, "set_flags", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->set_flags, NFT_TYPE_U32) !=3D 0)
+		goto err;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_FLAGS);
+
+
+	if (nft_mxml_num_parse(tree, "key_type", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->key_type, NFT_TYPE_U32) !=3D 0)
+		goto err;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_KEY_TYPE);
+
+	if (nft_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->key_type, NFT_TYPE_U32) !=3D 0)
+		goto err;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_KEY_LEN);
+
+	if (nft_mxml_num_parse(tree, "data_type", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->data_type, NFT_TYPE_U32) !=3D 0)
+		goto err;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_DATA_TYPE);
+
+	if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->data_len, NFT_TYPE_U32) !=3D 0)
+		goto err;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_DATA_LEN);
+
+	/* Iterate over each <set_elem> */
+	for (node =3D mxmlFindElement(tree, tree, "set_elem", NULL,
+				    NULL, MXML_DESCEND);
+		node !=3D NULL;
+		node =3D mxmlFindElement(node, tree, "set_elem", NULL,
+				       NULL, MXML_DESCEND)) {
+
+		elem =3D nft_mxml_set_elem_parse(node);
+		if (elem =3D=3D NULL)
+			goto err;
+
+		list_add_tail(&elem->head, &s->element_list);
+	}
+
+	mxmlDelete(tree);
+	return 0;
+err:
+	mxmlDelete(tree);
+	return -1;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type, cha=
r *data)
+{
+	int ret;
+
+	switch (type) {
+	case NFT_SET_PARSE_XML:
+		ret =3D nft_set_xml_parse(s, data);
+		break;
+	default:
+		ret =3D -1;
+		errno =3D EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_set_parse);
+
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_se=
t *s,
 				  uint32_t type, uint32_t flags)
 {
diff --git a/src/set_elem.c b/src/set_elem.c
index 4adba91..5325373 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -16,6 +16,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <netinet/in.h>
+#include <errno.h>
=20
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -374,8 +375,90 @@ int nft_set_elems_nlmsg_parse(const struct nlmsghd=
r *nlh, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_elems_nlmsg_parse);
=20
+static int nft_set_elem_xml_parse(struct nft_set_elem *e, char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree;
+	mxml_node_t *node;
+	int set_elem_data;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	if (strcmp(tree->value.opaque, "set_elem") !=3D 0) {
+		errno =3D EINVAL;
+		goto err;
+	}
+
+	if (nft_mxml_num_parse(tree, "set_elem_flags", MXML_DESCEND_FIRST,
+			       BASE_DEC, &e->set_elem_flags,
+			       NFT_TYPE_U32) !=3D 0)
+		goto err;
+
+	e->flags |=3D (1 << NFT_SET_ELEM_ATTR_FLAGS);
+
+	if (nft_mxml_data_reg_parse(tree, "set_elem_key",
+				    &e->key) !=3D DATA_VALUE)
+		goto err;
+
+	e->flags |=3D (1 << NFT_SET_ELEM_ATTR_KEY);
+
+	/* <set_elem_data> is not mandatory */
+	node =3D mxmlFindElement(tree, tree, "set_elem_data", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node !=3D NULL && node->child !=3D NULL) {
+		set_elem_data =3D nft_mxml_data_reg_parse(tree, "set_elem_data",
+							&e->data);
+		switch (set_elem_data) {
+		case DATA_VALUE:
+			e->flags |=3D (1 << NFT_SET_ELEM_ATTR_DATA);
+			break;
+		case DATA_VERDICT:
+			e->flags |=3D (1 << NFT_SET_ELEM_ATTR_VERDICT);
+			break;
+		case DATA_CHAIN:
+			e->flags |=3D (1 << NFT_SET_ELEM_ATTR_CHAIN);
+			break;
+		default:
+			goto err;
+		}
+	}
+
+	mxmlDelete(tree);
+	return 0;
+
+err:
+	mxmlDelete(tree);
+	return -1;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+int nft_set_elem_parse(struct nft_set_elem *e,
+		       enum nft_set_parse_type type, char *data) {
+	int ret;
+
+	switch (type) {
+	case NFT_SET_PARSE_XML:
+		ret =3D nft_set_elem_xml_parse(e, data);
+		break;
+	default:
+		errno =3D EOPNOTSUPP;
+		ret =3D -1;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_set_elem_parse);
+
 static int nft_set_elem_snprintf_json(char *buf, size_t size,
-				       struct nft_set_elem *e, uint32_t flags)
+				      struct nft_set_elem *e, uint32_t flags)
 {
 	int ret, len =3D size, offset =3D 0, type =3D -1;
=20
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 83a627c..0734f07 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -9,6 +9,7 @@
 #include <libnftables/table.h>
 #include <libnftables/chain.h>
 #include <libnftables/rule.h>
+#include <libnftables/set.h>
=20
 #ifdef XML_PARSING
 #include <mxml.h>
@@ -62,6 +63,7 @@ static int test_xml(const char *filename)
 	struct nft_table *t =3D NULL;
 	struct nft_chain *c =3D NULL;
 	struct nft_rule *r =3D NULL;
+	struct nft_set *s =3D NULL;
 	FILE *fp;
 	mxml_node_t *tree =3D NULL;;
 	char *xml =3D NULL;
@@ -102,6 +104,14 @@ static int test_xml(const char *filename)
=20
 			nft_rule_free(r);
 		}
+	} else if (strcmp(tree->value.opaque, "set") =3D=3D 0) {
+		s =3D nft_set_alloc();
+		if (s !=3D NULL) {
+			if (nft_set_parse(s, NFT_SET_PARSE_XML, xml) =3D=3D 0)
+				ret =3D 0;
+
+			nft_set_free(s);
+		}
 	}
=20
 	return ret;
diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
new file mode 100644
index 0000000..debcc27
--- /dev/null
+++ b/tests/xmlfiles/73-set.xml
@@ -0,0 +1,36 @@
+<set name=3D"set0" table=3D"filter" version=3D"0">
+	<family>ip</family>
+	<set_flags>0</set_flags>
+	<key_type>0</key_type>
+	<key_len>0</key_len>
+	<data_type>0</data_type>
+	<data_len>0</data_len>
+	<set_elem>
+		<set_elem_flags>0</set_elem_flags>
+		<set_elem_key>
+			<data_reg type=3D"value">
+				<len>4</len>
+				<data0>0x0300a8c0</data0>
+			</data_reg>
+		</set_elem_key>
+	</set_elem>
+	<set_elem>
+		<set_elem_flags>0</set_elem_flags>
+		<set_elem_key>
+			<data_reg type=3D"value">
+				<len>4</len>
+				<data0>0x0200a8c0</data0>
+			</data_reg>
+		</set_elem_key>
+	</set_elem>
+	<set_elem>
+		<set_elem_flags>0</set_elem_flags>
+		<set_elem_key>
+			<data_reg type=3D"value">
+				<len>4</len>
+				<data0>0x0100a8c0</data0>
+			</data_reg>
+		</set_elem_key>
+	</set_elem>
+</set>
+<!-- nft add rule ip filter test ip daddr { 192.168.0.1, 192.168.0.2, =
192.168.0.3 } tcp dport 443 counter accept -->
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
new file mode 100644
index 0000000..1ebb548
--- /dev/null
+++ b/tests/xmlfiles/74-set.xml
@@ -0,0 +1,33 @@
+<set name=3D"set0" table=3D"filter" version=3D"0">
+	<family>ip6</family>
+	<set_flags>0</set_flags>
+	<key_type>0</key_type>
+	<key_len>0</key_len>
+	<data_type>0</data_type>
+	<data_len>0</data_len>
+	<set_elem>
+		<set_elem_flags>0</set_elem_flags>
+		<set_elem_key>
+			<data_reg type=3D"value">
+				<len>16</len>
+				<data0>0xc09a002a</data0>
+				<data1>0x2700cac1</data1>
+				<data2>0x00000000</data2>
+				<data3>0x70010000</data3>
+			</data_reg>
+		</set_elem_key>
+	</set_elem>
+	<set_elem>
+		<set_elem_flags>0</set_elem_flags>
+		<set_elem_key>
+			<data_reg type=3D"value">
+				<len>16</len>
+				<data0>0xc09a002a</data0>
+				<data1>0x2700cac1</data1>
+				<data2>0x00000000</data2>
+				<data3>0x50010000</data3>
+			</data_reg>
+		</set_elem_key>
+	</set_elem>
+</set>
+<!-- nft add rule ip6 filter test ip6 daddr { 2a00:9ac0:c1ca:27::150, =
2a00:9ac0:c1ca:27::170, } counter accept -->

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
