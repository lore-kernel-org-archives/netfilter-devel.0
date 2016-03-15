From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/4 v5] libnftnl: rule: Change the "userdata" attribute to use new TLV buffer
Date: Tue, 15 Mar 2016 21:28:05 +0100
Message-ID: <1458073687-23870-2-git-send-email-carlosfg@riseup.net>
References: <1458073687-23870-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:53879 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934932AbcCOU3c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 16:29:32 -0400
In-Reply-To: <1458073687-23870-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now is it possible to store multiple variable length user data into a r=
ule.
Modify XML and JSON parsers to support this new feature.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/json.h  |   7 ++
 include/utils.h |   2 +
 include/xml.h   |   6 ++
 src/jansson.c   |  66 +++++++++++++++
 src/mxml.c      |  72 ++++++++++++++++
 src/rule.c      | 249 ++++++++++++++++++++++++++++++++++++++++++++++++=
++------
 src/utils.c     |  44 ++++++++++
 7 files changed, 420 insertions(+), 26 deletions(-)

diff --git a/include/json.h b/include/json.h
index bd70cec..2526a5b 100644
--- a/include/json.h
+++ b/include/json.h
@@ -3,6 +3,7 @@
=20
 #ifdef JSON_PARSING
 #include <jansson.h>
+#include <libnftnl/udata.h>
 #include <stdbool.h>
 #include "common.h"
=20
@@ -51,6 +52,12 @@ int nftnl_jansson_parse_elem(struct nftnl_set *s, js=
on_t *tree,
=20
 int nftnl_data_reg_json_parse(union nftnl_data_reg *reg, json_t *data,
 			    struct nftnl_parse_err *err);
+
+struct nftnl_udata_buf *nftnl_jansson_udata_parse(json_t *attr_array,
+						  json_t *root,
+						  struct nftnl_parse_err *err,
+						  struct nftnl_set_list *set_list);
+
 #else
 #define json_t void
 #endif
diff --git a/include/utils.h b/include/utils.h
index 0087dbb..1bbabff 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -69,6 +69,8 @@ enum nftnl_type {
 int nftnl_strtoi(const char *string, int base, void *number, enum nftn=
l_type type);
 int nftnl_get_value(enum nftnl_type type, void *val, void *out);
=20
+char *str2value(const char *str, size_t strlen);
+
 const char *nftnl_verdict2str(uint32_t verdict);
 int nftnl_str2verdict(const char *verdict, int *verdict_num);
=20
diff --git a/include/xml.h b/include/xml.h
index 7b33a83..b23b318 100644
--- a/include/xml.h
+++ b/include/xml.h
@@ -4,6 +4,7 @@
 #ifdef XML_PARSING
 #include <mxml.h>
 #include "common.h"
+#include <libnftnl/udata.h>
=20
 #define NFTNL_XML_MAND 0
 #define NFTNL_XML_OPT (1 << 0)
@@ -51,6 +52,11 @@ int nftnl_mxml_set_parse(mxml_node_t *tree, struct n=
ftnl_set *s,
=20
 int nftnl_data_reg_xml_parse(union nftnl_data_reg *reg, mxml_node_t *t=
ree,
 			   struct nftnl_parse_err *err);
+
+struct nftnl_udata_buf *nftnl_mxml_udata_parse(mxml_node_t *rootn,
+					       uint32_t mxml_flags,
+					       uint16_t flags,
+					       struct nftnl_parse_err *err);
 #else
 #define mxml_node_t void
 #endif
diff --git a/src/jansson.c b/src/jansson.c
index 3476ed2..8cc8f9a 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -19,6 +19,7 @@
 #include <libnftnl/set.h>
=20
 #include <libnftnl/expr.h>
+#include <libnftnl/udata.h>
 #include <linux/netfilter/nf_tables.h>
=20
 #ifdef JSON_PARSING
@@ -276,4 +277,69 @@ int nftnl_jansson_set_elem_parse(struct nftnl_set_=
elem *e, json_t *root,
=20
 	return 0;
 }
+
+static int nftnl_jansson_udata_attr_parse(struct nftnl_udata_buf *buf,
+					  json_t *root,
+					  struct nftnl_parse_err *err,
+					  struct nftnl_set_list *set_list)
+{
+	const char *value_str;
+	char *value =3D NULL;
+	uint8_t type;
+	uint8_t len;
+	int ret;
+
+	ret =3D nftnl_jansson_parse_val(root, "type", NFTNL_TYPE_U8, &type, e=
rr);
+	if (ret !=3D 0)
+		return 0;
+
+	ret =3D nftnl_jansson_parse_val(root, "length", NFTNL_TYPE_U8, &len, =
err);
+	if (ret !=3D 0)
+		return 0;
+
+	value_str =3D nftnl_jansson_parse_str(root, "value", err);
+	if (ret !=3D 0)
+		return 0;
+
+	if (strlen(value_str) !=3D 2 * len)
+		return 0;
+
+	value =3D str2value(value_str, 2 * len);
+	if (!value) {
+		err->error =3D NFTNL_PARSE_EBADTYPE;
+		err->node_name =3D "value";
+		errno =3D ERANGE;
+		return 0;
+	}
+
+	if (!nftnl_udata_put(buf, type, len, (void *)value))
+		ret =3D 0;
+
+	free(value);
+	return 1;
+}
+
+struct nftnl_udata_buf *nftnl_jansson_udata_parse(json_t *attr_array,
+						  json_t *root,
+						  struct nftnl_parse_err *err,
+						  struct nftnl_set_list *set_list)
+{
+	struct nftnl_udata_buf *buf =3D NULL;
+	json_t *jattr;
+	int i;
+
+	buf =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN);
+	if (!buf) {
+		free(buf);
+		return NULL;
+	}
+
+	for (i =3D 0; (jattr =3D json_array_get(attr_array, i)); ++i) {
+		if (!nftnl_jansson_udata_attr_parse(buf, jattr, err, set_list))
+			return NULL;
+	}
+
+	return buf;
+}
+
 #endif
diff --git a/src/mxml.c b/src/mxml.c
index 51dbf1b..ae04eb1 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -20,6 +20,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/udata.h>
=20
 #ifdef XML_PARSING
 mxml_node_t *nftnl_mxml_build_tree(const void *data, const char *treen=
ame,
@@ -229,4 +230,75 @@ int nftnl_mxml_family_parse(mxml_node_t *tree, con=
st char *node_name,
=20
 	return family;
 }
+
+static int nftnl_mxml_udata_attr_parse(struct nftnl_udata_buf *buf,
+				       mxml_node_t *tree,
+				       uint32_t mxml_flags, uint16_t flags,
+				       struct nftnl_parse_err *err)
+{
+	uint8_t len;
+	uint8_t type;
+	const char *value_str;
+	char *value =3D NULL;
+
+	if (nftnl_mxml_num_parse(tree, "type", mxml_flags, BASE_DEC, &type,
+				 NFTNL_TYPE_U8, flags, err) < 0)
+		return 0;
+
+	if (nftnl_mxml_num_parse(tree, "length", mxml_flags, BASE_DEC, &len,
+				 NFTNL_TYPE_U8, flags, err) < 0)
+		return 0;
+
+	value_str =3D nftnl_mxml_str_parse(tree, "value", mxml_flags, flags, =
err);
+	if (!value_str)
+		return 0;
+
+	if (strlen(value_str) !=3D 2 * len)
+		return 0;
+
+	value =3D str2value(value_str, 2 * len);
+	if (!value) {
+		err->error =3D NFTNL_PARSE_EBADTYPE;
+		err->node_name =3D "value";
+		errno =3D ERANGE;
+		return 0;
+	}
+
+	if (!nftnl_udata_put(buf, type, len, (void *)value))
+		return 0;
+
+	free(value);
+	return 1;
+}
+
+struct nftnl_udata_buf *nftnl_mxml_udata_parse(mxml_node_t *rootn,
+					       uint32_t mxml_flags,
+					       uint16_t flags,
+					       struct nftnl_parse_err *err)
+{
+		mxml_node_t *attrn;
+		struct nftnl_udata_buf *buf;
+
+		buf =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN);
+		if (!buf) {
+			free(buf);
+			return NULL;
+		}
+
+		/* Iterate over attributes */
+		for (
+			attrn =3D mxmlFindElement(rootn, rootn, "attr", NULL,
+						NULL, mxml_flags);
+			attrn;
+			attrn =3D mxmlFindElement(attrn, rootn, "attr", NULL,
+						NULL, mxml_flags)
+		) {
+			if (!nftnl_mxml_udata_attr_parse(buf, attrn, mxml_flags,
+							 flags, err))
+				return NULL;
+		}
+
+	return buf;
+}
+
 #endif
diff --git a/src/rule.c b/src/rule.c
index 3a32bf6..5ae3e0b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -28,6 +28,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/set.h>
 #include <libnftnl/expr.h>
+#include <libnftnl/udata.h>
=20
 struct nftnl_rule {
 	struct list_head head;
@@ -38,10 +39,7 @@ struct nftnl_rule {
 	const char	*chain;
 	uint64_t	handle;
 	uint64_t	position;
-	struct {
-			void		*data;
-			uint32_t	len;
-	} user;
+	struct nftnl_udata_buf	*userdata;
 	struct {
 			uint32_t	flags;
 			uint32_t	proto;
@@ -50,6 +48,15 @@ struct nftnl_rule {
 	struct list_head expr_list;
 };
=20
+static size_t nftnl_rule_snprintf_data2str(char *buf, size_t size,
+					   const void *data, size_t datalen);
+static size_t nftnl_rule_snprintf_default_udata(char *buf, size_t size=
,
+						const struct nftnl_udata *attr);
+static size_t nftnl_rule_snprintf_xml_attr(char *buf, size_t size,
+					   const struct nftnl_udata *attr);
+static size_t nftnl_rule_snprintf_json_attr(char *buf, size_t size,
+					    const struct nftnl_udata *attr);
+
 struct nftnl_rule *nftnl_rule_alloc(void)
 {
 	struct nftnl_rule *r;
@@ -75,6 +82,8 @@ void nftnl_rule_free(struct nftnl_rule *r)
 		xfree(r->table);
 	if (r->chain !=3D NULL)
 		xfree(r->chain);
+	if (r->flags & (1 << NFTNL_RULE_USERDATA))
+		nftnl_udata_free(r->userdata);
=20
 	xfree(r);
 }
@@ -162,8 +171,14 @@ void nftnl_rule_set_data(struct nftnl_rule *r, uin=
t16_t attr,
 		r->position =3D *((uint64_t *)data);
 		break;
 	case NFTNL_RULE_USERDATA:
-		r->user.data =3D (void *)data;
-		r->user.len =3D data_len;
+		if (r->flags & (1 << NFTNL_RULE_USERDATA))
+			nftnl_udata_free(r->userdata);
+		r->userdata =3D nftnl_udata_alloc(data_len);
+		if (!r->userdata) {
+			perror("nftnl_rule_set_data - userdata");
+			return;
+		}
+		nftnl_udata_copy_data(r->userdata, data, data_len);
 		break;
 	}
 	r->flags |=3D (1 << attr);
@@ -221,8 +236,8 @@ const void *nftnl_rule_get_data(const struct nftnl_=
rule *r, uint16_t attr,
 		*data_len =3D sizeof(uint64_t);
 		return &r->position;
 	case NFTNL_RULE_USERDATA:
-		*data_len =3D r->user.len;
-		return r->user.data;
+		*data_len =3D nftnl_udata_len(r->userdata);
+		return (void *)nftnl_udata_data(r->userdata);
 	}
 	return NULL;
 }
@@ -288,8 +303,9 @@ void nftnl_rule_nlmsg_build_payload(struct nlmsghdr=
 *nlh, struct nftnl_rule *r)
 	if (r->flags & (1 << NFTNL_RULE_POSITION))
 		mnl_attr_put_u64(nlh, NFTA_RULE_POSITION, htobe64(r->position));
 	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
-		mnl_attr_put(nlh, NFTA_RULE_USERDATA, r->user.len,
-			     r->user.data);
+		mnl_attr_put(nlh, NFTA_RULE_USERDATA,
+			     nftnl_udata_len(r->userdata),
+			     nftnl_udata_data(r->userdata));
 	}
=20
 	if (!list_empty(&r->expr_list)) {
@@ -447,19 +463,20 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr =
*nlh, struct nftnl_rule *r)
 		r->flags |=3D (1 << NFTNL_RULE_POSITION);
 	}
 	if (tb[NFTA_RULE_USERDATA]) {
+		uint16_t udata_size;
+
 		const void *udata =3D
 			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]);
=20
-		if (r->user.data)
-			xfree(r->user.data);
+		udata_size =3D mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
=20
-		r->user.len =3D mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
-
-		r->user.data =3D malloc(r->user.len);
-		if (r->user.data =3D=3D NULL)
+		if (r->flags & (1 << NFTNL_RULE_USERDATA))
+			nftnl_udata_free(r->userdata);
+		r->userdata =3D nftnl_udata_alloc(udata_size);
+		if (!r->userdata)
 			return -1;
+		nftnl_udata_copy_data(r->userdata, udata, udata_size);
=20
-		memcpy(r->user.data, udata, r->user.len);
 		r->flags |=3D (1 << NFTNL_RULE_USERDATA);
 	}
=20
@@ -481,6 +498,7 @@ int nftnl_jansson_parse_rule(struct nftnl_rule *r, =
json_t *tree,
 	uint64_t uval64;
 	uint32_t uval32;
 	int i, family;
+	struct nftnl_udata_buf *buf;
=20
 	root =3D nftnl_jansson_get_node(tree, "rule", err);
 	if (root =3D=3D NULL)
@@ -557,6 +575,17 @@ int nftnl_jansson_parse_rule(struct nftnl_rule *r,=
 json_t *tree,
 		nftnl_rule_add_expr(r, e);
 	}
=20
+	array =3D json_object_get(root, "userdata");
+	if (array) {
+		buf =3D nftnl_jansson_udata_parse(array, root, err, set_list);
+		if (!buf)
+			goto err;
+
+		nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
+				    nftnl_udata_data(buf),
+				    nftnl_udata_len(buf));
+	}
+
 	return 0;
 err:
 	return -1;
@@ -596,6 +625,7 @@ int nftnl_mxml_rule_parse(mxml_node_t *tree, struct=
 nftnl_rule *r,
 	struct nftnl_expr *e;
 	const char *table, *chain;
 	int family;
+	struct nftnl_udata_buf *buf;
=20
 	family =3D nftnl_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST=
,
 				       NFTNL_XML_MAND, err);
@@ -649,6 +679,18 @@ int nftnl_mxml_rule_parse(mxml_node_t *tree, struc=
t nftnl_rule *r,
 		nftnl_rule_add_expr(r, e);
 	}
=20
+	node =3D mxmlFindElement(tree, tree, "userdata", NULL, NULL,
+			       MXML_DESCEND);
+	if (node) {
+		buf =3D nftnl_mxml_udata_parse(node, MXML_DESCEND, r->flags, err);
+		if (!buf)
+			return -1;
+
+		nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
+				    nftnl_udata_data(buf),
+				    nftnl_udata_len(buf));
+	}
+
 	return 0;
 }
 #endif
@@ -711,6 +753,21 @@ int nftnl_rule_parse_file(struct nftnl_rule *r, en=
um nftnl_parse_type type,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_parse_file, nft_rule_parse_file);
=20
+static size_t nftnl_rule_snprintf_data2str(char *buf, size_t size,
+					   const void *data, size_t datalen)
+{
+	int i;
+	size_t ret, len =3D size, offset =3D 0;
+	const unsigned char *str =3D data;
+
+	for (i =3D 0; i < datalen; i++) {
+		ret =3D snprintf(buf + offset, len, "%02X", str[i]);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
 static int nftnl_rule_snprintf_json(char *buf, size_t size, struct nft=
nl_rule *r,
 					 uint32_t type, uint32_t flags)
 {
@@ -783,7 +840,34 @@ static int nftnl_rule_snprintf_json(char *buf, siz=
e_t size, struct nftnl_rule *r
 	}
 	/* Remove comma from last element */
 	offset--;
-	ret =3D snprintf(buf+offset, len, "]}}");
+	ret =3D snprintf(buf + offset, len, "]");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
+		const struct nftnl_udata *attr;
+
+		ret =3D snprintf(buf + offset, len, ",\"userdata\":[");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		nftnl_udata_for_each(r->userdata, attr) {
+			ret =3D nftnl_rule_snprintf_json_attr(buf + offset, len,
+							    attr);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+			ret =3D snprintf(buf + offset, len, ",");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+		/* delete last comma */
+		buf[offset - 1] =3D '\0';
+		offset--;
+		size--;
+		len++;
+
+		ret =3D snprintf(buf + offset, len, "]");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf + offset, len, "}}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return offset;
@@ -849,17 +933,123 @@ static int nftnl_rule_snprintf_xml(char *buf, si=
ze_t size, struct nftnl_rule *r,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	}
+
+	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
+		const struct nftnl_udata *attr;
+
+		ret =3D snprintf(buf + offset, len, "<userdata>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		nftnl_udata_for_each(r->userdata, attr) {
+			ret =3D snprintf(buf + offset, len, "<attr>");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+			ret =3D nftnl_rule_snprintf_xml_attr(buf + offset, len,
+							   attr);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+			ret =3D snprintf(buf + offset, len, "</attr>");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret =3D snprintf(buf + offset, len, "</userdata>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	ret =3D snprintf(buf+offset, len, "</rule>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return offset;
 }
=20
+static size_t nftnl_rule_snprintf_xml_attr(char *buf, size_t size,
+					   const struct nftnl_udata *attr)
+{
+	size_t ret, len =3D size, offset =3D 0;
+
+	uint8_t atype =3D nftnl_udata_attr_type(attr);
+	uint8_t alen  =3D nftnl_udata_attr_len(attr);
+	void   *aval  =3D nftnl_udata_attr_value(attr);
+
+	/* type */
+	ret =3D snprintf(buf + offset, len, "<type>%d</type>", atype);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* len */
+	ret =3D snprintf(buf + offset, len, "<length>%d</length>", alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* value */
+	ret =3D snprintf(buf + offset, len, "<value>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D nftnl_rule_snprintf_data2str(buf + offset, len, aval, alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf + offset, len, "</value>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static size_t nftnl_rule_snprintf_json_attr(char *buf, size_t size,
+					    const struct nftnl_udata *attr)
+{
+	size_t ret, len =3D size, offset =3D 0;
+
+	uint8_t atype =3D nftnl_udata_attr_type(attr);
+	uint8_t alen  =3D nftnl_udata_attr_len(attr);
+	void   *aval  =3D nftnl_udata_attr_value(attr);
+
+	/* type */
+	ret =3D snprintf(buf + offset, len, "{\"type\":%d,", atype);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* len */
+	ret =3D snprintf(buf + offset, len, "\"length\":%d,", alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* value */
+	ret =3D snprintf(buf + offset, len, "\"value\":\"");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D nftnl_rule_snprintf_data2str(buf + offset, len, aval, alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf + offset, len, "\"}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static size_t nftnl_rule_snprintf_default_udata(char *buf, size_t size=
,
+						const struct nftnl_udata *attr)
+{
+	size_t ret, len =3D size, offset =3D 0;
+
+	uint8_t atype =3D nftnl_udata_attr_type(attr);
+	uint8_t alen  =3D nftnl_udata_attr_len(attr);
+	void   *aval  =3D nftnl_udata_attr_value(attr);
+
+	/* type */
+	ret =3D snprintf(buf + offset, len, "{%d:\"", atype);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* value */
+	ret =3D nftnl_rule_snprintf_data2str(buf + offset, len, aval, alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf + offset, len, "\"}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
 static int nftnl_rule_snprintf_default(char *buf, size_t size, struct =
nftnl_rule *r,
 				     uint32_t type, uint32_t flags)
 {
 	struct nftnl_expr *expr;
-	int ret, len =3D size, offset =3D 0, i;
+	int ret, len =3D size, offset =3D 0;
=20
 	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
 		ret =3D snprintf(buf+offset, len, "%s ",
@@ -905,21 +1095,28 @@ static int nftnl_rule_snprintf_default(char *buf=
, size_t size, struct nftnl_rule
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
-	if (r->user.len) {
-		ret =3D snprintf(buf+offset, len, "  userdata =3D { ");
+	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
+		const struct nftnl_udata *attr;
+
+		ret =3D snprintf(buf + offset, len, "  userdata =3D { ");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-		for (i =3D 0; i < r->user.len; i++) {
-			char *c =3D r->user.data;
+		nftnl_udata_for_each(r->userdata, attr) {
+			ret =3D nftnl_rule_snprintf_default_udata(buf + offset,
+								len, attr);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-			ret =3D snprintf(buf+offset, len, "%c",
-				       isalnum(c[i]) ? c[i] : 0);
+			ret =3D snprintf(buf + offset, len, ",");
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
+		/* delete last comma */
+		buf[offset - 1] =3D '\0';
+		offset--;
+		size--;
+		len++;
=20
 		ret =3D snprintf(buf+offset, len, " }\n");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
 	}
=20
 	return offset;
diff --git a/src/utils.c b/src/utils.c
index ba36bc4..0e08693 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -139,6 +139,50 @@ int nftnl_strtoi(const char *string, int base, voi=
d *out, enum nftnl_type type)
 	return ret;
 }
=20
+static int hex2char(char *out, char c)
+{
+	/* numbers */
+	if (c >=3D '0' && c <=3D '9')
+		*out =3D c - '0';
+	/* lowercase characters */
+	else if (c >=3D 'a' && c <=3D 'z')
+		*out =3D c - 'a' + 10;
+	/* uppercase characters */
+	else if (c >=3D 'A' && c <=3D 'Z')
+		*out =3D c - 'A' + 10;
+	else {
+		errno =3D EINVAL;
+		return 0;
+	}
+
+	return 1;
+}
+
+char *str2value(const char *str, size_t strlen)
+{
+	char *value;
+	size_t i;
+	char d0;
+	char d1;
+
+	value =3D malloc(strlen / 2);
+	if (!value)
+		return NULL;
+
+	for (i =3D 0; i < strlen / 2; i++) {
+		if (!hex2char(&d0, str[2 * i + 0]) ||
+		    !hex2char(&d1, str[2 * i + 1])
+		) {
+			free(value);
+			return NULL;
+		}
+
+		value[i] =3D d0 * 16 + d1;
+	}
+
+	return value;
+}
+
 const char *nftnl_verdict2str(uint32_t verdict)
 {
 	switch (verdict) {
--=20
2.7.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
