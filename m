From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/2] set: XML parse
Date: Thu, 25 Jul 2013 22:20:39 +0200
Message-ID: <20130725202038.21531.87739.stgit@nfdev.cica.es>
References: <20130725202033.21531.41100.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47080 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756969Ab3GYUUs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:20:48 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id CE60A51EDBE
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 20:20:46 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dyi8dRLkx-i0 for <netfilter-devel@vger.kernel.org>;
	Thu, 25 Jul 2013 22:20:41 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 3390951EE82
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 22:20:41 +0200 (CEST)
In-Reply-To: <20130725202033.21531.41100.stgit@nfdev.cica.es>
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
 include/libnftables/set.h |    9 ++
 src/libnftables.map       |    2 +
 src/mxml.c                |    2 -
 src/set.c                 |  174 +++++++++++++++++++++++++++++++++++++=
++++++++
 src/set_elem.c            |   85 +++++++++++++++++++++-
 tests/nft-parsing-test.c  |   10 +++
 tests/xmlfiles/36-set.xml |   51 +++++++++++++
 7 files changed, 328 insertions(+), 5 deletions(-)
 create mode 100644 tests/xmlfiles/36-set.xml

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
index f812bf6..3d6ada4 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -111,7 +111,7 @@ int nft_mxml_data_reg_parse(mxml_node_t *tree, cons=
t char *node_name,
 	}
=20
 	node =3D mxmlFindElement(node, node, "data_reg", NULL, NULL,
-			       MXML_DESCEND);
+			       MXML_DESCEND_FIRST);
 	if (node =3D=3D NULL || node->child =3D=3D NULL) {
 		errno =3D EINVAL;
 		goto err;
diff --git a/src/set.c b/src/set.c
index ef15527..5e1f8ed 100644
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
@@ -301,6 +303,178 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nl=
h, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
=20
+static int nft_set_xml_parse(struct nft_set *s, char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree =3D NULL;
+	mxml_node_t *node =3D NULL;
+	mxml_node_t *save =3D NULL;
+	char *set_elem_str =3D NULL;
+	struct nft_set_elem *elem;
+	int version;
+	int family;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	if (strcmp(tree->value.opaque, "set") !=3D 0)
+		goto einval;
+
+	if (mxmlElementGetAttr(tree, "version") =3D=3D NULL)
+		goto einval;
+
+	if (nft_strtoi(mxmlElementGetAttr(tree, "version"), 10, &version,
+		       NFT_TYPE_U64) !=3D 0)
+		goto err;
+
+	if (version !=3D NFT_SET_XML_VERSION)
+		goto einval;
+
+	if (mxmlElementGetAttr(tree, "name") =3D=3D NULL)
+		goto einval;
+
+	if (s->name)
+		free(s->name);
+
+	s->name =3D strdup(mxmlElementGetAttr(tree, "name"));
+	s->flags |=3D (1 << NFT_SET_ATTR_NAME);
+
+	if (mxmlElementGetAttr(tree, "table") =3D=3D NULL)
+		goto einval;
+
+	if (s->table)
+		free(s->table);
+
+	s->table =3D strdup(mxmlElementGetAttr(tree, "table"));
+	s->flags |=3D (1 << NFT_SET_ATTR_TABLE);
+
+	node =3D mxmlFindElement(tree, tree, "family", NULL, NULL,
+			       MXML_DESCEND_FIRST);
+	if (node =3D=3D NULL)
+		goto einval;
+
+	if (node->child =3D=3D NULL)
+		goto einval;
+
+	family =3D nft_str2family(node->child->value.opaque);
+
+	if (family < 0)
+		goto eafnosupport;
+
+	s->family =3D family;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_FAMILY);
+
+	if (nft_mxml_num_parse(tree, "set_flags", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->set_flags, NFT_TYPE_U32) !=3D 0)
+		goto einval;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_FLAGS);
+
+
+	if (nft_mxml_num_parse(tree, "key_type", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->key_type, NFT_TYPE_U32) !=3D 0)
+		goto einval;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_KEY_TYPE);
+
+	if (nft_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->key_type, NFT_TYPE_U32) !=3D 0)
+		goto einval;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_KEY_LEN);
+
+	if (nft_mxml_num_parse(tree, "data_type", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->data_type, NFT_TYPE_U32) !=3D 0)
+		goto einval;
+
+	s->flags |=3D (1 << NFT_SET_ATTR_DATA_TYPE);
+
+	if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST,
+			       BASE_DEC, &s->data_len, NFT_TYPE_U32) !=3D 0)
+		goto einval;
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
+		elem =3D nft_set_elem_alloc();
+		if (elem =3D=3D NULL)
+			goto enomem;
+
+		/* This is a hack for mxml to print just the current node */
+		save =3D node->next;
+		node->next =3D NULL;
+
+		set_elem_str =3D mxmlSaveAllocString(node, MXML_NO_CALLBACK);
+		if (set_elem_str =3D=3D NULL) {
+			free(elem);
+			goto enomem;
+		}
+
+		if (nft_set_elem_parse(elem, NFT_SET_PARSE_XML,
+				       set_elem_str) !=3D 0) {
+			printf("nft_set_elem_parse err: %s\n", set_elem_str);
+			free(set_elem_str);
+			free(elem);
+			goto err;
+		}
+
+		node->next =3D save;
+		free(set_elem_str);
+
+		list_add_tail(&elem->head, &s->element_list);
+	}
+
+	mxmlDelete(tree);
+	return 0;
+einval:
+	errno =3D EINVAL;
+	mxmlDelete(tree);
+	return -1;
+eafnosupport:
+	errno =3D EAFNOSUPPORT;
+	mxmlDelete(tree);
+	return -1;
+enomem:
+	errno =3D ENOMEM;
+	mxmlDelete(tree);
+	return -1;
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
index 4adba91..724c312 100644
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
@@ -374,8 +375,83 @@ int nft_set_elems_nlmsg_parse(const struct nlmsghd=
r *nlh, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_elems_nlmsg_parse);
=20
+static int nft_set_elem_xml_parse(struct nft_set_elem *e, char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree =3D NULL;
+	int set_elem_data;
+
+	tree =3D mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree =3D=3D NULL) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	if (strcmp(tree->value.opaque, "set_elem") !=3D 0)
+		goto einval;
+
+	if (nft_mxml_num_parse(tree, "set_elem_flags", MXML_DESCEND_FIRST,
+			       BASE_DEC, &e->set_elem_flags,
+			       NFT_TYPE_U32) !=3D 0)
+		goto einval;
+
+	e->flags |=3D (1 << NFT_SET_ELEM_ATTR_FLAGS);
+
+	if (nft_mxml_data_reg_parse(tree, "set_elem_key",
+				    &e->key) !=3D DATA_VALUE)
+		goto einval;
+
+	e->flags |=3D (1 << NFT_SET_ELEM_ATTR_KEY);
+
+	set_elem_data =3D nft_mxml_data_reg_parse(tree, "set_elem_data",
+						&e->data);
+	switch (set_elem_data) {
+	case DATA_VALUE:
+		e->flags |=3D (1 << NFT_SET_ELEM_ATTR_DATA);
+		break;
+	case DATA_VERDICT:
+		e->flags |=3D (1 << NFT_SET_ELEM_ATTR_VERDICT);
+		break;
+	case DATA_CHAIN:
+		e->flags |=3D (1 << NFT_SET_ELEM_ATTR_CHAIN);
+		break;
+	default:
+		goto einval;
+	}
+
+	mxmlDelete(tree);
+	return 0;
+
+einval:
+	errno =3D EINVAL;
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
@@ -414,8 +490,9 @@ static int nft_set_elem_snprintf_json(char *buf, si=
ze_t size,
 	return offset;
 }
=20
-static int nft_set_elem_snprintf_default(char *buf, size_t size,
-					 struct nft_set_elem *e)
+static
+int nft_set_elem_snprintf_default(char *buf, size_t size,
+				  struct nft_set_elem *e, uint32_t flags)
 {
 	int ret, len =3D size, offset =3D 0, i;
=20
@@ -505,7 +582,7 @@ int nft_set_elem_snprintf(char *buf, size_t size, s=
truct nft_set_elem *e,
 {
 	switch(type) {
 	case NFT_SET_O_DEFAULT:
-		return nft_set_elem_snprintf_default(buf, size, e);
+		return nft_set_elem_snprintf_default(buf, size, e, flags);
 	case NFT_SET_O_XML:
 		return nft_set_elem_snprintf_xml(buf, size, e, flags);
 	case NFT_SET_O_JSON:
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 4fe60c3..c75d97b 100644
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
@@ -21,6 +22,7 @@ static int test_xml(const char *filename)
 	struct nft_table *t =3D NULL;
 	struct nft_chain *c =3D NULL;
 	struct nft_rule *r =3D NULL;
+	struct nft_set *s =3D NULL;
 	FILE *fp;
 	mxml_node_t *tree =3D NULL;;
 	char *xml =3D NULL;
@@ -61,6 +63,14 @@ static int test_xml(const char *filename)
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
diff --git a/tests/xmlfiles/36-set.xml b/tests/xmlfiles/36-set.xml
new file mode 100644
index 0000000..71ca189
--- /dev/null
+++ b/tests/xmlfiles/36-set.xml
@@ -0,0 +1,51 @@
+<set name=3D"set1" table=3D"filter" version=3D"0">
+	<family>ip</family>
+	<set_flags>6</set_flags>
+	<key_type>0</key_type>
+	<key_len>12</key_len>
+	<data_type>0</data_type>
+	<data_len>12</data_len>
+	<set_elem>
+		<set_elem_flags>1</set_elem_flags>
+		<set_elem_key>
+			<data_reg type=3D"value">
+				<len>4</len>
+				<data0>0xffaabbdd</data0>
+			</data_reg>
+		</set_elem_key>
+		<set_elem_data>
+			<data_reg type=3D"verdict">
+				<verdict>accept</verdict>
+			</data_reg>
+		</set_elem_data>
+	</set_elem>
+	<set_elem>
+		<set_elem_flags>1</set_elem_flags>
+		<set_elem_key>
+			<data_reg type=3D"value">
+				<len>4</len>
+				<data0>0xffaabb11</data0>
+			</data_reg>
+		</set_elem_key>
+		<set_elem_data>
+			<data_reg type=3D"chain">
+				<chain>test</chain>
+			</data_reg>
+		</set_elem_data>
+	</set_elem>
+	<set_elem>
+		<set_elem_flags>1</set_elem_flags>
+		<set_elem_key>
+			<data_reg type=3D"value">
+				<len>4</len>
+				<data0>0xffaabb11</data0>
+			</data_reg>
+		</set_elem_key>
+		<set_elem_data>
+			<data_reg type=3D"value">
+				<len>4</len>
+				<data0>0xcafecafe</data0>
+			</data_reg>
+		</set_elem_data>
+	</set_elem>
+</set>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
