From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/4 v3] libnftnl: rule: Change the "userdata" attribute to use new TLV buffer
Date: Mon,  7 Mar 2016 18:10:42 +0100
Message-ID: <1457370643-14408-3-git-send-email-carlosfg@riseup.net>
References: <1457370643-14408-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49569 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbcCGRLI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 12:11:08 -0500
In-Reply-To: <1457370643-14408-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now is it possible to store multiple variable length user data into a r=
ule.
Modify XML and JSON parsers to support this new feature.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/json.h  |   7 ++
 include/utils.h |   2 +
 include/xml.h   |   5 ++
 src/jansson.c   |  41 +++++++++
 src/mxml.c      |  39 ++++++++
 src/rule.c      | 271 ++++++++++++++++++++++++++++++++++++++++++++++++=
++------
 src/utils.c     |  45 ++++++++++
 7 files changed, 384 insertions(+), 26 deletions(-)

diff --git a/include/json.h b/include/json.h
index bd70cec..68cf020 100644
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
+int nftnl_jansson_udata_parse(struct nftnl_udata_buf *buf,
+			      json_t *root,
+			      struct nftnl_parse_err *err,
+			      struct nftnl_set_list *set_list);
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
index 7b33a83..0dbe356 100644
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
@@ -51,6 +52,10 @@ int nftnl_mxml_set_parse(mxml_node_t *tree, struct n=
ftnl_set *s,
=20
 int nftnl_data_reg_xml_parse(union nftnl_data_reg *reg, mxml_node_t *t=
ree,
 			   struct nftnl_parse_err *err);
+
+int nftnl_mxml_udata_parse(struct nftnl_udata_buf *buf, mxml_node_t *t=
ree,
+			   uint32_t mxml_flags, uint16_t flags,
+			   struct nftnl_parse_err *err);
 #else
 #define mxml_node_t void
 #endif
diff --git a/src/jansson.c b/src/jansson.c
index 3476ed2..683df5a 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -19,6 +19,7 @@
 #include <libnftnl/set.h>
=20
 #include <libnftnl/expr.h>
+#include <libnftnl/attr.h>
 #include <linux/netfilter/nf_tables.h>
=20
 #ifdef JSON_PARSING
@@ -276,4 +277,44 @@ int nftnl_jansson_set_elem_parse(struct nftnl_set_=
elem *e, json_t *root,
=20
 	return 0;
 }
+
+int nftnl_jansson_udata_parse(struct nftnl_udata_buf *buf,
+			      json_t *root,
+			      struct nftnl_parse_err *err,
+			      struct nftnl_set_list *set_list)
+{
+	int ret =3D 0;
+	uint8_t type;
+	uint8_t len;
+	const char *value_str;
+	char *value =3D NULL;
+
+	ret =3D nftnl_jansson_parse_val(root, "type", NFTNL_TYPE_U8, &type, e=
rr);
+	if (ret !=3D 0)
+		return -1;
+
+	ret =3D nftnl_jansson_parse_val(root, "length", NFTNL_TYPE_U8, &len, =
err);
+	if (ret !=3D 0)
+		return -1;
+
+	value_str =3D nftnl_jansson_parse_str(root, "value", err);
+	if (ret !=3D 0)
+		return -1;
+
+	if (strlen(value_str) !=3D 2*len)
+		return -1;
+
+	value =3D str2value(value_str, 2*len);
+	if (!value) {
+		perror("nftnl_jansson_attr_parse");
+		return -1;
+	}
+
+	if (!nftnl_udata_put(buf, type, len, (void *)value))
+		ret =3D -1;
+
+	free(value);
+	return ret;
+}
+
 #endif
diff --git a/src/mxml.c b/src/mxml.c
index 51dbf1b..e54f49b 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -229,4 +229,43 @@ int nftnl_mxml_family_parse(mxml_node_t *tree, con=
st char *node_name,
=20
 	return family;
 }
+
+int nftnl_mxml_udata_parse(struct nftnl_udata_buf *buf, mxml_node_t *t=
ree,
+			   uint32_t mxml_flags, uint16_t flags,
+			   struct nftnl_parse_err *err)
+{
+	int ret =3D 0;
+	uint8_t len;
+	uint8_t type;
+	const char *value_str;
+	char *value =3D NULL;
+
+	if (nftnl_mxml_num_parse(tree, "type", mxml_flags, BASE_DEC, &type,
+				 NFTNL_TYPE_U8, flags, err) < 0)
+		return -1;
+
+	if (nftnl_mxml_num_parse(tree, "length", mxml_flags, BASE_DEC, &len,
+				 NFTNL_TYPE_U8, flags, err) < 0)
+		return -1;
+
+	value_str =3D nftnl_mxml_str_parse(tree, "value", mxml_flags, flags, =
err);
+	if (value_str =3D=3D NULL)
+		return -1;
+
+	if (strlen(value_str) !=3D 2*len)
+		return -1;
+
+	value =3D str2value(value_str, 2*len);
+	if (!value) {
+		perror("nftnl_mxml_attr_parse");
+		return -1;
+	}
+
+	if (!nftnl_udata_put(buf, type, len, (void *)value))
+		ret =3D -1;
+
+	free(value);
+	return ret;
+}
+
 #endif
diff --git a/src/rule.c b/src/rule.c
index 3a32bf6..9e1bdcc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -19,7 +19,6 @@
 #include <netinet/in.h>
 #include <errno.h>
 #include <inttypes.h>
-#include <ctype.h>
=20
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -28,6 +27,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/set.h>
 #include <libnftnl/expr.h>
+#include <libnftnl/udata.h>
=20
 struct nftnl_rule {
 	struct list_head head;
@@ -38,10 +38,7 @@ struct nftnl_rule {
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
@@ -50,6 +47,15 @@ struct nftnl_rule {
 	struct list_head expr_list;
 };
=20
+static size_t nftnl_rule_snprintf_data2str(char *buf, size_t size,
+					   const void *data, size_t datalen);
+static size_t nftnl_rule_snprintf_default_attr(char *buf, size_t size,
+					       const struct nftnl_udata *attr);
+static size_t nftnl_rule_snprintf_xml_attr(char *buf, size_t size,
+					   const struct nftnl_udata *attr);
+static size_t nftnl_rule_snprintf_json_attr(char *buf, size_t size,
+					    const struct nftnl_udata *attr);
+
 struct nftnl_rule *nftnl_rule_alloc(void)
 {
 	struct nftnl_rule *r;
@@ -75,6 +81,8 @@ void nftnl_rule_free(struct nftnl_rule *r)
 		xfree(r->table);
 	if (r->chain !=3D NULL)
 		xfree(r->chain);
+	if (r->flags & (1 << NFTNL_RULE_USERDATA))
+		nftnl_udata_free(r->userdata);
=20
 	xfree(r);
 }
@@ -162,8 +170,12 @@ void nftnl_rule_set_data(struct nftnl_rule *r, uin=
t16_t attr,
 		r->position =3D *((uint64_t *)data);
 		break;
 	case NFTNL_RULE_USERDATA:
-		r->user.data =3D (void *)data;
-		r->user.len =3D data_len;
+		(r->userdata =3D nftnl_udata_alloc(data_len));
+		if (!r->userdata) {
+			perror("nftnl_rule_set_data - userdata");
+			return;
+		}
+		nftnl_udata_copy_data(r->userdata, data, data_len);
 		break;
 	}
 	r->flags |=3D (1 << attr);
@@ -221,8 +233,8 @@ const void *nftnl_rule_get_data(const struct nftnl_=
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
@@ -288,8 +300,9 @@ void nftnl_rule_nlmsg_build_payload(struct nlmsghdr=
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
@@ -447,19 +460,17 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr =
*nlh, struct nftnl_rule *r)
 		r->flags |=3D (1 << NFTNL_RULE_POSITION);
 	}
 	if (tb[NFTA_RULE_USERDATA]) {
+		uint16_t udata_size;
 		const void *udata =3D
 			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]);
=20
-		if (r->user.data)
-			xfree(r->user.data);
-
-		r->user.len =3D mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
+		udata_size =3D mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
=20
-		r->user.data =3D malloc(r->user.len);
-		if (r->user.data =3D=3D NULL)
+		(r->userdata =3D nftnl_udata_alloc(udata_size));
+		if (!r->userdata)
 			return -1;
+		nftnl_udata_copy_data(r->userdata, udata, udata_size);
=20
-		memcpy(r->user.data, udata, r->user.len);
 		r->flags |=3D (1 << NFTNL_RULE_USERDATA);
 	}
=20
@@ -481,6 +492,7 @@ int nftnl_jansson_parse_rule(struct nftnl_rule *r, =
json_t *tree,
 	uint64_t uval64;
 	uint32_t uval32;
 	int i, family;
+	struct nftnl_udata_buf *buf;
=20
 	root =3D nftnl_jansson_get_node(tree, "rule", err);
 	if (root =3D=3D NULL)
@@ -557,6 +569,27 @@ int nftnl_jansson_parse_rule(struct nftnl_rule *r,=
 json_t *tree,
 		nftnl_rule_add_expr(r, e);
 	}
=20
+	array =3D json_object_get(root, "userdata");
+	if (array !=3D NULL) {
+		buf =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN);
+		if (!buf) {
+			perror("nftnl_jansson_parse_rule");
+			goto err;
+		}
+
+		for (i =3D 0; i < json_array_size(array); ++i) {
+			if (nftnl_jansson_udata_parse(buf,
+						      json_array_get(array, i),
+						      err,
+						      set_list) < 0)
+				goto err;
+		}
+
+		nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
+				    nftnl_udata_data(buf),
+				    nftnl_udata_len(buf));
+	}
+
 	return 0;
 err:
 	return -1;
@@ -592,7 +625,7 @@ int nftnl_mxml_rule_parse(mxml_node_t *tree, struct=
 nftnl_rule *r,
 			struct nftnl_parse_err *err,
 			struct nftnl_set_list *set_list)
 {
-	mxml_node_t *node;
+	mxml_node_t *node, *node_ud;
 	struct nftnl_expr *e;
 	const char *table, *chain;
 	int family;
@@ -649,6 +682,35 @@ int nftnl_mxml_rule_parse(mxml_node_t *tree, struc=
t nftnl_rule *r,
 		nftnl_rule_add_expr(r, e);
 	}
=20
+	node_ud =3D mxmlFindElement(tree, tree, "userdata", NULL, NULL,
+				  MXML_DESCEND);
+	if (node_ud) {
+		struct nftnl_udata_buf *buf;
+
+		buf =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN);
+		if (!buf) {
+			perror("nftnl_mxml_rule_parse");
+			return -1;
+		}
+
+		/* Iterate over attributes */
+		for (
+			node =3D mxmlFindElement(node_ud, node_ud, "attr", NULL,
+				NULL, MXML_DESCEND);
+			node !=3D NULL;
+			node =3D mxmlFindElement(node, node_ud, "attr", NULL,
+				NULL, MXML_DESCEND)
+		) {
+			if (nftnl_mxml_udata_parse(buf, node,
+					MXML_DESCEND_FIRST, r->flags, err) < 0)
+				return -1;
+		}
+
+		nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
+				    nftnl_udata_data(buf),
+				    nftnl_udata_len(buf));
+	}
+
 	return 0;
 }
 #endif
@@ -711,6 +773,21 @@ int nftnl_rule_parse_file(struct nftnl_rule *r, en=
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
+		ret =3D snprintf(buf+offset, len, "%02X", str[i]);
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
@@ -783,7 +860,34 @@ static int nftnl_rule_snprintf_json(char *buf, siz=
e_t size, struct nftnl_rule *r
 	}
 	/* Remove comma from last element */
 	offset--;
-	ret =3D snprintf(buf+offset, len, "]}}");
+	ret =3D snprintf(buf+offset, len, "]");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
+		const struct nftnl_udata *attr;
+
+		ret =3D snprintf(buf+offset, len, ",\"userdata\":[");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		nftnl_udata_for_each(r->userdata, attr) {
+			ret =3D nftnl_rule_snprintf_json_attr(buf+offset, len,
+							    attr);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+			ret =3D snprintf(buf+offset, len, ",");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+		/* delete last comma */
+		buf[offset-1] =3D '\0';
+		offset--;
+		size--;
+		len++;
+
+		ret =3D snprintf(buf+offset, len, "]");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset, len, "}}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return offset;
@@ -849,17 +953,123 @@ static int nftnl_rule_snprintf_xml(char *buf, si=
ze_t size, struct nftnl_rule *r,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	}
+
+	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
+		const struct nftnl_udata *attr;
+
+		ret =3D snprintf(buf+offset, len, "<userdata>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		nftnl_udata_for_each(r->userdata, attr) {
+			ret =3D snprintf(buf+offset, len, "<attr>");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+			ret =3D nftnl_rule_snprintf_xml_attr(buf+offset, len,
+							    attr);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+			ret =3D snprintf(buf+offset, len, "</attr>");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret =3D snprintf(buf+offset, len, "</userdata>");
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
+	ret =3D snprintf(buf+offset, len, "<type>%d</type>", atype);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* len */
+	ret =3D snprintf(buf+offset, len, "<length>%d</length>", alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* value */
+	ret =3D snprintf(buf+offset, len, "<value>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D nftnl_rule_snprintf_data2str(buf+offset, len, aval, alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "</value>");
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
+	ret =3D snprintf(buf+offset, len, "{\"type\":%d,", atype);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* len */
+	ret =3D snprintf(buf+offset, len, "\"length\":%d,", alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* value */
+	ret =3D snprintf(buf+offset, len, "\"value\":\"");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D nftnl_rule_snprintf_data2str(buf+offset, len, aval, alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static size_t nftnl_rule_snprintf_default_attr(char *buf, size_t size,
+					       const struct nftnl_udata *attr)
+{
+	size_t ret, len =3D size, offset =3D 0;
+
+	uint8_t atype =3D nftnl_udata_attr_type(attr);
+	uint8_t alen  =3D nftnl_udata_attr_len(attr);
+	void   *aval  =3D nftnl_udata_attr_value(attr);
+
+	/* type */
+	ret =3D snprintf(buf+offset, len, "{%d:\"", atype);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* value */
+	ret =3D nftnl_rule_snprintf_data2str(buf+offset, len, aval, alen);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, len, "\"}");
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
@@ -905,17 +1115,26 @@ static int nftnl_rule_snprintf_default(char *buf=
, size_t size, struct nftnl_rule
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
-	if (r->user.len) {
+
+	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
+		const struct nftnl_udata *attr;
+
 		ret =3D snprintf(buf+offset, len, "  userdata =3D { ");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-		for (i =3D 0; i < r->user.len; i++) {
-			char *c =3D r->user.data;
+		nftnl_udata_for_each(r->userdata, attr) {
+			ret =3D nftnl_rule_snprintf_default_attr(buf+offset,
+							       len, attr);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-			ret =3D snprintf(buf+offset, len, "%c",
-				       isalnum(c[i]) ? c[i] : 0);
+			ret =3D snprintf(buf+offset, len, ",");
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
+		/* delete last comma */
+		buf[offset-1] =3D '\0';
+		offset--;
+		size--;
+		len++;
=20
 		ret =3D snprintf(buf+offset, len, " }\n");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
diff --git a/src/utils.c b/src/utils.c
index ba36bc4..0cac4b6 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -139,6 +139,51 @@ int nftnl_strtoi(const char *string, int base, voi=
d *out, enum nftnl_type type)
 	return ret;
 }
=20
+static int hex2char(char *out, char c)
+{
+	/* numbers */
+	if (c >=3D 0x30 && c <=3D 0x39)
+		*out =3D c - 0x30;
+	/* lowercase characters */
+	else if (c >=3D 0x61 && c <=3D 0x66)
+		*out =3D c - 0x61 + 10;
+	/* uppercase characters */
+	else if (c >=3D 0x41 && c <=3D 0x46)
+		*out =3D c - 0x41 + 10;
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
+
+	value =3D (char *)malloc(strlen/2);
+	if (!value)
+		return NULL;
+
+	for (i =3D 0; i < strlen/2; i++) {
+		if (!hex2char(&d0, str[2*i + 0]) ||
+		    !hex2char(&d1, str[2*i + 1])
+		) {
+			free(value);
+			return NULL;
+		}
+
+		value[i] =3D d0*16 + d1;
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
