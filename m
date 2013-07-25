From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/6] table: json: Add Json parser support
Date: Thu, 25 Jul 2013 22:52:15 +0200
Message-ID: <20130725205215.26223.77001.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49039 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3GYUwX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:52:23 -0400
Received: by mail-wi0-f169.google.com with SMTP id c10so122007wiw.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 13:52:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add function for parsing tables in format JSON

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 configure.ac                |    9 ++++-
 include/libnftables/table.h |    1 +
 src/Makefile.am             |    3 +-
 src/internal.h              |   10 +++++
 src/jansson.c               |   79 +++++++++++++++++++++++++++++++++++=
++++++++
 src/table.c                 |   69 +++++++++++++++++++++++++++++++++++=
+++
 src/utils.c                 |   61 ++++++++++++++++++++-------------
 7 files changed, 206 insertions(+), 26 deletions(-)
 create mode 100644 src/jansson.c

diff --git a/configure.ac b/configure.ac
index c8075e9..834c0a3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -18,7 +18,10 @@ AC_ARG_WITH([xml-parsing], AS_HELP_STRING([--with-xm=
l-parsing], [XML parsing sup
 AS_IF([test "x$with_xml_parsing" =3D "xyes"], [
 	PKG_CHECK_MODULES([LIBXML], [mxml >=3D 2.6])
 ])
-
+AC_ARG_WITH([json-parsing], AS_HELP_STRING([--with-json-parsing], [JSO=
N parsing support]))
+AS_IF([test "x$with_json_parsing" =3D "xyes"], [
+	PKG_CHECK_MODULES([LIBJSON], [jansson >=3D 2.3])
+])
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_DISABLE_STATIC
@@ -33,6 +36,10 @@ regular_CPPFLAGS=3D"-D_FILE_OFFSET_BITS=3D64 -D_REEN=
TRANT"
 AS_IF([test "x$with_xml_parsing" =3D "xyes"], [
 	regular_CPPFLAGS=3D"$regular_CPPFLAGS -DXML_PARSING"
 ])
+
+AS_IF([test "x$with_json_parsing" =3D "xyes"], [
+	regular_CPPFLAGS=3D"$regular_CPPFLAGS -DJSON_PARSING"
+])
 regular_CFLAGS=3D"-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wshadow -Wstrict-prototypes \
 	-Wformat=3D2 -pipe"
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index f3f3e89..24ca374 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -40,6 +40,7 @@ enum {
 enum nft_table_parse_type {
 	NFT_TABLE_PARSE_NONE	=3D 0,
 	NFT_TABLE_PARSE_XML,
+	NFT_TABLE_PARSE_JSON,
 	NFT_TABLE_PARSE_MAX,
 };
=20
diff --git a/src/Makefile.am b/src/Makefile.am
index 6496511..51b40a2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,7 +1,7 @@
 include $(top_srcdir)/Make_global.am
 lib_LTLIBRARIES =3D libnftables.la
=20
-libnftables_la_LIBADD =3D ${LIBMNL_LIBS} ${LIBXML_LIBS}
+libnftables_la_LIBADD =3D ${LIBMNL_LIBS} ${LIBXML_LIBS} ${LIBJSON_LIBS=
}
 libnftables_la_LDFLAGS =3D -Wl,--version-script=3D$(srcdir)/libnftable=
s.map \
 			 -version-info $(LIBVERSION)
 libnftables_la_SOURCES =3D utils.c		\
@@ -11,6 +11,7 @@ libnftables_la_SOURCES =3D utils.c		\
 			 set.c			\
 			 set_elem.c		\
 			 mxml.c			\
+			 jansson.c		\
 			 expr.c			\
 			 expr_ops.c		\
 			 expr/bitwise.c		\
diff --git a/src/internal.h b/src/internal.h
index b846814..47cd635 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -12,6 +12,7 @@
 #include "linux_list.h"
=20
 #include <stdint.h>
+#include <stdbool.h>
=20
 #define BASE_DEC 10
 #define BASE_HEX 16
@@ -37,6 +38,14 @@ int nft_mxml_num_parse(mxml_node_t *tree, const char=
 *node_name, uint32_t mxml_f
 const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_nam=
e, uint32_t mxml_flags);
 #endif
=20
+#ifdef JSON_PARSING
+#include <jansson.h>
+int nft_jansson_value_parse_val(json_t *root, const char *tag,
+				  int type, void *out);
+const char *nft_jansson_value_parse_str(json_t *root, const char *tag)=
;
+bool nft_jansson_node_exist(json_t *root, const char *tag);
+#endif
+
 #define NFT_TABLE_XML_VERSION 0
 #define NFT_CHAIN_XML_VERSION 0
 #define NFT_RULE_XML_VERSION 0
@@ -51,6 +60,7 @@ int nft_str2family(const char *family);
 int nft_strtoi(const char *string, int base, void *number, enum nft_ty=
pe type);
 const char *nft_verdict2str(uint32_t verdict);
 int nft_str2verdict(const char *verdict);
+int nft_get_value(enum nft_type type, void *val, void *out);
=20
 struct expr_ops;
=20
diff --git a/src/jansson.c b/src/jansson.c
new file mode 100644
index 0000000..2b15240
--- /dev/null
+++ b/src/jansson.c
@@ -0,0 +1,79 @@
+/*
+ * (C) 2013 by =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, o=
r
+ * (at your option) any later version.
+ */
+
+#include <internal.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <arpa/inet.h>
+#include <errno.h>
+#include <string.h>
+
+#ifdef JSON_PARSING
+
+static int nft_jansson_load_int_node(json_t *root, const char *tag,
+				      json_int_t *val)
+{
+	json_t *node;
+
+	node =3D json_object_get(root, tag);
+	if (node =3D=3D NULL) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	if (!json_is_integer(node)) {
+		errno =3D ERANGE;
+		goto err;
+	}
+
+	*val =3D json_integer_value(node);
+
+	return 0;
+err:
+	return -1;
+}
+
+const char *nft_jansson_value_parse_str(json_t *root, const char *tag)
+{
+	json_t *node;
+	const char *val;
+
+	node =3D json_object_get(root, tag);
+	if (node =3D=3D NULL)
+		return NULL;
+
+	val =3D json_string_value(node);
+
+	return val;
+}
+
+int nft_jansson_value_parse_val(json_t *root, const char *tag, int typ=
e,
+				  void *out)
+{
+	json_int_t val;
+
+	if (nft_jansson_load_int_node(root, tag, &val) =3D=3D -1)
+		goto err;
+
+	if (nft_get_value(type, &val, out) =3D=3D -1)
+		goto err;
+
+	return 0;
+err:
+	errno =3D ERANGE;
+	return -1;
+}
+
+bool nft_jansson_node_exist(json_t *root, const char *tag)
+{
+	return json_object_get(root, tag) !=3D NULL;
+}
+#endif
diff --git a/src/table.c b/src/table.c
index d814668..65797e8 100644
--- a/src/table.c
+++ b/src/table.c
@@ -295,6 +295,72 @@ static int nft_table_xml_parse(struct nft_table *t=
, char *xml)
 #endif
 }
=20
+static int nft_table_json_parse(struct nft_table *t, char *json)
+{
+#ifdef JSON_PARSING
+	json_t *root;
+	json_error_t error;
+	uint64_t version;
+	uint32_t table_flag;
+	const char *str =3D NULL;
+
+	root =3D json_loadb(json, strlen(json), 0, &error);
+	if (!root) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	root =3D json_object_get(root, "table");
+	if (root =3D=3D NULL) {
+		errno =3D ERANGE;
+		return -1;
+	}
+
+	if (nft_jansson_value_parse_val(root, "version",
+					NFT_TYPE_U64, &version) =3D=3D -1)
+		goto err;
+
+	if (version !=3D NFT_TABLE_JSON_VERSION || version =3D=3D -1)
+		goto err;
+
+	str =3D nft_jansson_value_parse_str(root, "name");
+	if (str =3D=3D NULL)
+		goto err;
+
+	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, strdup(str));
+
+	root =3D json_object_get(root, "properties");
+	if (root =3D=3D NULL)
+		goto err;
+
+	str =3D nft_jansson_value_parse_str(root, "family");
+	if (str =3D=3D NULL)
+		goto err;
+
+	if (nft_str2family(str) < 0)
+		goto err;
+
+	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, nft_str2family(str))=
;
+
+	if (nft_jansson_value_parse_val(root, "table_flags",
+					NFT_TYPE_U32, &table_flag) =3D=3D -1)
+		goto err;
+
+	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, table_flag);
+
+	free(root);
+	return 0;
+err:
+	free(root);
+	errno =3D ERANGE;
+	return -1;
+
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 int nft_table_parse(struct nft_table *t, enum nft_table_parse_type typ=
e,
 		    char *data)
 {
@@ -304,6 +370,9 @@ int nft_table_parse(struct nft_table *t, enum nft_t=
able_parse_type type,
 	case NFT_TABLE_PARSE_XML:
 		ret =3D nft_table_xml_parse(t, data);
 		break;
+	case NFT_TABLE_PARSE_JSON:
+		ret =3D nft_table_json_parse(t, data);
+		break;
 	default:
 		ret =3D -1;
 		errno =3D EOPNOTSUPP;
diff --git a/src/utils.c b/src/utils.c
index ebd40b5..c6bf9ff 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -66,57 +66,70 @@ static struct {
 	[NFT_TYPE_S64]	=3D { .len =3D sizeof(int64_t), .min =3D INT64_MIN, .m=
ax =3D INT64_MAX },
 };
=20
-int nft_strtoi(const char *string, int base, void *out, enum nft_type =
type)
+
+int nft_get_value(enum nft_type type, void *val, void *out)
 {
-	int64_t sval =3D 0;
-	uint64_t uval =3D -1;
-	char *endptr;
+	int64_t sval;
+	uint64_t uval;
=20
 	switch (type) {
 	case NFT_TYPE_U8:
 	case NFT_TYPE_U16:
 	case NFT_TYPE_U32:
 	case NFT_TYPE_U64:
-		uval =3D strtoll(string, &endptr, base);
+		uval =3D *((uint64_t *)val);
+		if (uval > basetype[type].max) {
+			errno =3D ERANGE;
+			return -1;
+		}
+		memcpy(out, &uval, basetype[type].len);
 		break;
 	case NFT_TYPE_S8:
 	case NFT_TYPE_S16:
 	case NFT_TYPE_S32:
 	case NFT_TYPE_S64:
-		sval =3D strtoull(string, &endptr, base);
+		sval =3D *((int64_t *)val);
+		if (sval < basetype[type].min ||
+		    sval > (int64_t)basetype[type].max) {
+			errno =3D ERANGE;
+			return -1;
+		}
+		memcpy(out, &sval, basetype[type].len);
 		break;
-	default:
-		errno =3D EINVAL;
-		return -1;
 	}
=20
-	if (*endptr) {
-		errno =3D EINVAL;
-		return -1;
-	}
+	return 0;
+}
+
+int nft_strtoi(const char *string, int base, void *out, enum nft_type =
type)
+{
+	int64_t sval =3D 0;
+	uint64_t uval =3D -1;
+	char *endptr;
=20
 	switch (type) {
 	case NFT_TYPE_U8:
 	case NFT_TYPE_U16:
 	case NFT_TYPE_U32:
 	case NFT_TYPE_U64:
-		if (uval > basetype[type].max) {
-			errno =3D ERANGE;
-			return -1;
-		}
-		memcpy(out, &uval, basetype[type].len);
+		uval =3D strtoll(string, &endptr, base);
+		nft_get_value(type, &uval, out);
 		break;
 	case NFT_TYPE_S8:
 	case NFT_TYPE_S16:
 	case NFT_TYPE_S32:
 	case NFT_TYPE_S64:
-		if (sval < basetype[type].min ||
-		    sval > (int64_t)basetype[type].max) {
-			errno =3D ERANGE;
-			return -1;
-		}
-		memcpy(out, &sval, basetype[type].len);
+		sval =3D strtoull(string, &endptr, base);
+		nft_get_value(type, &sval, out);
 		break;
+	default:
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	if (*endptr) {
+		errno =3D EINVAL;
+		return -1;
 	}
=20
 	return 0;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
