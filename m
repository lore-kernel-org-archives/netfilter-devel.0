From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/4] set: Add json parser support
Date: Tue, 27 Aug 2013 20:10:47 +0200
Message-ID: <20130827181046.9399.66265.stgit@Ph0enix>
References: <20130827181037.9399.30579.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:50587 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3H0SLK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:11:10 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so4366348wes.13
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2013 11:11:09 -0700 (PDT)
In-Reply-To: <20130827181037.9399.30579.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add function for parsing set in format JSON.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/libnftables/set.h |    1=20
 src/internal.h            |    1=20
 src/jansson.c             |   37 +++++++++++++++++
 src/set.c                 |   99 +++++++++++++++++++++++++++++++++++++=
++++++++
 4 files changed, 138 insertions(+)

diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index c55718c..9526ae1 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -55,6 +55,7 @@ void nft_set_list_iter_destroy(struct nft_set_list_it=
er *iter);
 enum nft_set_parse_type {
 	NFT_SET_PARSE_NONE	=3D 0,
 	NFT_SET_PARSE_XML,
+	NFT_SET_PARSE_JSON,
 	NFT_SET_PARSE_MAX,
 };
=20
diff --git a/src/internal.h b/src/internal.h
index 6698962..2a36543 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -58,6 +58,7 @@ struct nft_rule_expr *nft_jansson_expr_parse(json_t *=
root);
 union nft_data_reg;
 int nft_jansson_data_reg_parse(json_t *root, const char *tag,
 			       union nft_data_reg *data_reg);
+int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root);
 #endif
=20
 const char *nft_family2str(uint32_t family);
diff --git a/src/jansson.c b/src/jansson.c
index 682b74b..04146e2 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -16,6 +16,7 @@
 #include <errno.h>
 #include <string.h>
 #include "expr_ops.h"
+#include <libnftables/set.h>
=20
 #include <libnftables/expr.h>
 #include <linux/netfilter/nf_tables.h>
@@ -210,4 +211,40 @@ int nft_jansson_data_reg_parse(json_t *root, const=
 char *tag,
 		return -1;
 	}
 }
+
+int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root)
+{
+	uint32_t uval32;
+	int set_elem_data;
+
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32) < 0)
+		return -1;
+
+	nft_set_elem_attr_set_u32(e, NFT_SET_ELEM_ATTR_FLAGS, uval32);
+
+	if (nft_jansson_data_reg_parse(root, "key", &e->key) !=3D DATA_VALUE)
+		return -1;
+
+	e->flags |=3D (1 << NFT_SET_ELEM_ATTR_KEY);
+
+	if (nft_jansson_node_exist(root, "data")) {
+		set_elem_data =3D nft_jansson_data_reg_parse(root, "data",
+							   &e->data);
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
+			return -1;
+		}
+	}
+
+	return 0;
+}
 #endif
diff --git a/src/set.c b/src/set.c
index 3617265..1168b54 100644
--- a/src/set.c
+++ b/src/set.c
@@ -303,6 +303,102 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nl=
h, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
=20
+static int nft_set_json_parse(struct nft_set *s, const char *json)
+{
+#ifdef JSON_PARSING
+	json_t *root, *node, *array, *json_elem;
+	json_error_t error;
+	uint32_t uval32;
+	int family, i;
+	const char *valstr;
+	struct nft_set_elem *elem;
+
+	node =3D nft_jansson_create_root(json, &error);
+	if (node =3D=3D NULL)
+		return -1;
+
+	root =3D nft_jansson_get_node(node, "set");
+	if (root =3D=3D NULL)
+		return -1;
+
+	valstr =3D nft_jansson_parse_str(root, "name");
+	if (valstr =3D=3D NULL)
+		return -1;
+
+	nft_set_attr_set_str(s, NFT_SET_ATTR_NAME, valstr);
+
+	valstr =3D nft_jansson_parse_str(root, "table");
+	if (valstr =3D=3D NULL)
+		return -1;
+
+	nft_set_attr_set_str(s, NFT_SET_ATTR_TABLE, valstr);
+
+	if (nft_jansson_parse_val(root, "flags", NFT_TYPE_U32, &uval32) < 0)
+		return -1;
+
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_FLAGS, uval32);
+
+	if (nft_jansson_parse_family(root, &family) < 0)
+		return -1;
+
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_FAMILY, family);
+
+	if (nft_jansson_parse_val(root, "key_type", NFT_TYPE_U32, &uval32) < =
0)
+		return -1;
+
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_TYPE, uval32);
+
+	if (nft_jansson_parse_val(root, "key_len", NFT_TYPE_U32, &uval32) < 0=
)
+		return -1;
+
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_LEN, uval32);
+
+	if (nft_jansson_node_exist(root, "data_type")) {
+		if (nft_jansson_parse_val(root, "data_type", NFT_TYPE_U32,
+					  &uval32) < 0)
+			goto err;
+
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_TYPE, uval32);
+	}
+
+	if (nft_jansson_node_exist(root, "data_len")) {
+		if (nft_jansson_parse_val(root, "data_len", NFT_TYPE_U32,
+					  &uval32) < 0)
+			goto err;
+
+		nft_set_attr_set_u32(s, NFT_SET_ATTR_DATA_LEN, uval32);
+	}
+
+	if (nft_jansson_node_exist(root, "set_elem")) {
+		array =3D json_object_get(root, "set_elem");
+		for (i =3D 0; i < json_array_size(array); i++) {
+			elem =3D nft_set_elem_alloc();
+			if (elem =3D=3D NULL)
+				goto err;
+
+			json_elem =3D json_array_get(array, i);
+			if (json_elem =3D=3D NULL)
+				goto err;
+
+			if (nft_set_elem_json_parse(elem, json_elem) < 0)
+				goto err;
+
+			list_add_tail(&elem->head, &s->element_list);
+		}
+
+	}
+
+	nft_jansson_free_root(node);
+	return 0;
+err:
+	nft_jansson_free_root(node);
+	return -1;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 {
 #ifdef XML_PARSING
@@ -415,6 +511,9 @@ int nft_set_parse(struct nft_set *s, enum nft_set_p=
arse_type type,
 	case NFT_SET_PARSE_XML:
 		ret =3D nft_set_xml_parse(s, data);
 		break;
+	case NFT_SET_PARSE_JSON:
+		ret =3D nft_set_json_parse(s, data);
+		break;
 	default:
 		ret =3D -1;
 		errno =3D EOPNOTSUPP;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
