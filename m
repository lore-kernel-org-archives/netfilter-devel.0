From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/4 v6] libnftnl: Implement new buffer of TLV objects
Date: Tue, 22 Mar 2016 20:46:24 +0100
Message-ID: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51427 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbcCVTql (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 15:46:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions allow to create a buffer (nftnl_udata_buf) of TLV objec=
ts
(nftnl_udata). It is inspired by libmnl/src/attr.c. It can be used to s=
tore
several variable length user data into an object.

Example usage:
	```
	struct nftnl_udata_buf *buf;
	struct nftnl_udata *attr;
	const char str[] =3D "Hello World!";

	buf =3D nftnl_udata_buf_alloc(UDATA_SIZE);
	if (!buf) {
		perror("OOM");
		exit(EXIT_FAILURE);
	}

	if (!nftnl_udata_put_strz(buf, MY_TYPE, str)) {
		perror("Can't put attribute \"%s\"", str);
		exit(EXIT_FAILURE);
	}

	nftnl_udata_for_each(buf, attr) {
		printf("%s\n", (char *)nftnl_udata_attr_value(attr));
	}

	nftnl_udata_buf_free(buf);
	```

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/Makefile.am          |   1 +
 include/libnftnl/Makefile.am |   1 +
 include/libnftnl/udata.h     |  54 ++++++++++++++++++
 include/udata.h              |  40 +++++++++++++
 src/Makefile.am              |   1 +
 src/libnftnl.map             |  16 ++++++
 src/udata.c                  | 131 +++++++++++++++++++++++++++++++++++=
++++++++
 7 files changed, 244 insertions(+)
 create mode 100644 include/libnftnl/udata.h
 create mode 100644 include/udata.h
 create mode 100644 src/udata.c

diff --git a/include/Makefile.am b/include/Makefile.am
index be9eb9b..9f55737 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -12,4 +12,5 @@ noinst_HEADERS =3D internal.h	\
 		 expr.h		\
 		 json.h		\
 		 set_elem.h	\
+		 udata.h	\
 		 utils.h
diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.a=
m
index 84f01b6..457ec95 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -7,4 +7,5 @@ pkginclude_HEADERS =3D batch.h		\
 		     set.h		\
 		     ruleset.h		\
 		     common.h		\
+		     udata.h		\
 		     gen.h
diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
new file mode 100644
index 0000000..166bb06
--- /dev/null
+++ b/include/libnftnl/udata.h
@@ -0,0 +1,54 @@
+#ifndef _LIBNFTNL_UDATA_H_
+#define _LIBNFTNL_UDATA_H_
+
+#include <stdio.h>
+#include <stdint.h>
+#include <stdbool.h>
+
+/*
+ * nftnl user data attributes API
+ */
+struct nftnl_udata;
+struct nftnl_udata_buf;
+
+/* nftnl_udata_buf */
+struct nftnl_udata_buf *nftnl_udata_buf_alloc(uint32_t data_size);
+void nftnl_udata_buf_free(struct nftnl_udata_buf *buf);
+uint32_t nftnl_udata_buf_len(const struct nftnl_udata_buf *buf);
+uint32_t nftnl_udata_buf_size(const struct nftnl_udata_buf *buf);
+void *nftnl_udata_buf_data(const struct nftnl_udata_buf *buf);
+void nftnl_udata_buf_put(struct nftnl_udata_buf *buf, const void *data=
,
+			 uint32_t len);
+struct nftnl_udata *nftnl_udata_start(const struct nftnl_udata_buf *bu=
f);
+struct nftnl_udata *nftnl_udata_end(const struct nftnl_udata_buf *buf)=
;
+
+/* putters */
+bool nftnl_udata_put(struct nftnl_udata_buf *buf, uint8_t type, uint32=
_t len,
+		     const void *value);
+bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
+			  const char *strz);
+
+/* nftnl_udata_attr */
+uint8_t nftnl_udata_attr_type(const struct nftnl_udata *attr);
+uint8_t nftnl_udata_attr_len(const struct nftnl_udata *attr);
+void *nftnl_udata_attr_value(const struct nftnl_udata *attr);
+
+/* iterator */
+struct nftnl_udata *nftnl_udata_attr_next(const struct nftnl_udata *at=
tr);
+
+#define nftnl_udata_for_each(buf, attr)                       \
+	for ((attr) =3D nftnl_udata_start(buf);                 \
+	     (char *)(nftnl_udata_end(buf)) > (char *)(attr); \
+	     (attr) =3D nftnl_udata_attr_next(attr))
+
+#define nftnl_udata_for_each_data(data, data_len, attr)  \
+	for ((attr) =3D (struct nftnl_udata *)(data);      \
+	     (char *)(data + data_len) > (char *)(attr); \
+	     (attr) =3D nftnl_udata_attr_next(attr))
+
+typedef int (*nftnl_udata_cb_t)(const struct nftnl_udata *attr,
+				void *data);
+int nftnl_udata_parse(const void *data, uint32_t data_len, nftnl_udata=
_cb_t cb,
+		      void *cb_data);
+
+#endif /* _LIBNFTNL_UDATA_H_ */
diff --git a/include/udata.h b/include/udata.h
new file mode 100644
index 0000000..407a3b9
--- /dev/null
+++ b/include/udata.h
@@ -0,0 +1,40 @@
+#ifndef _LIBNFTNL_UDATA_INTERNAL_H_
+#define _LIBNFTNL_UDATA_INTERNAL_H_
+
+#include <stdint.h>
+#include <stddef.h>
+
+/*
+ * TLV structures:
+ * nftnl_udata
+ *  <-------- HEADER --------> <------ PAYLOAD ------>
+ * +------------+-------------+- - - - - - - - - - - -+
+ * |    type    |     len     |         value         |
+ * |  (1 byte)  |   (1 byte)  |                       |
+ * +--------------------------+- - - - - - - - - - - -+
+ *  <-- sizeof(nftnl_udata) -> <-- nftnl_udata->len -->
+ */
+struct nftnl_udata {
+	uint8_t		type;
+	uint8_t		len;
+	unsigned char	value[];
+} __attribute__((__packed__));
+
+/*
+ *              +---------------------------------++
+ *              | data[]                          ||
+ *              |   ||                            ||
+ *              |   \/                            \/
+ *  +-------+-------+-------+-------+ ... +-------+- - - - - - -+
+ *  | size  |  end  |  TLV  |  TLV  |     |  TLV  |    Empty    |
+ *  +-------+-------+-------+-------+ ... +-------+- - - - - - -+
+ *                  |<---- nftnl_udata_len() ---->|
+ *                  |<----------- nftnl_udata_size() ---------->|
+ */
+struct nftnl_udata_buf {
+	uint32_t	size;
+	char		*end;
+	char		data[];
+};
+
+#endif /* _LIBNFTNL_UDATA_INTERNAL_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index a27e292..7e580e4 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -19,6 +19,7 @@ libnftnl_la_SOURCES =3D utils.c		\
 		      ruleset.c		\
 		      mxml.c		\
 		      jansson.c		\
+		      udata.c		\
 		      expr.c		\
 		      expr_ops.c	\
 		      expr/bitwise.c	\
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 2e193b7..b2e2326 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -512,4 +512,20 @@ LIBNFTNL_4.1 {
 	nftnl_trace_get_data;
=20
 	nftnl_trace_nlmsg_parse;
+
+	nftnl_udata_buf_alloc;
+	nftnl_udata_buf_free;
+	nftnl_udata_buf_len;
+	nftnl_udata_buf_size;
+	nftnl_udata_buf_data;
+	nftnl_udata_buf_put;
+	nftnl_udata_start;
+	nftnl_udata_end;
+	nftnl_udata_put;
+	nftnl_udata_put_strz;
+	nftnl_udata_attr_type;
+	nftnl_udata_attr_len;
+	nftnl_udata_attr_value;
+	nftnl_udata_attr_next;
+	nftnl_udata_parse;
 } LIBNFTNL_4;
diff --git a/src/udata.c b/src/udata.c
new file mode 100644
index 0000000..afe9057
--- /dev/null
+++ b/src/udata.c
@@ -0,0 +1,131 @@
+#include <libnftnl/udata.h>
+#include <udata.h>
+#include <utils.h>
+
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+
+struct nftnl_udata_buf *nftnl_udata_buf_alloc(uint32_t data_size)
+{
+	struct nftnl_udata_buf *buf;
+
+	buf =3D malloc(sizeof(struct nftnl_udata_buf) + data_size);
+	if (!buf)
+		return NULL;
+	buf->size =3D data_size;
+	buf->end =3D buf->data;
+
+	return buf;
+}
+EXPORT_SYMBOL(nftnl_udata_buf_alloc);
+
+void nftnl_udata_buf_free(struct nftnl_udata_buf *buf)
+{
+	free(buf);
+}
+EXPORT_SYMBOL(nftnl_udata_buf_free);
+
+uint32_t nftnl_udata_buf_len(const struct nftnl_udata_buf *buf)
+{
+	return (uint32_t)(buf->end - buf->data);
+}
+EXPORT_SYMBOL(nftnl_udata_buf_len);
+
+uint32_t nftnl_udata_buf_size(const struct nftnl_udata_buf *buf)
+{
+	return buf->size;
+}
+EXPORT_SYMBOL(nftnl_udata_buf_size);
+
+void *nftnl_udata_buf_data(const struct nftnl_udata_buf *buf)
+{
+	return (void *)buf->data;
+}
+EXPORT_SYMBOL(nftnl_udata_buf_data);
+
+void nftnl_udata_buf_put(struct nftnl_udata_buf *buf, const void *data=
,
+			 uint32_t len)
+{
+	memcpy(buf->data, data, len <=3D buf->size ? len : buf->size);
+	buf->end =3D buf->data + len;
+}
+EXPORT_SYMBOL(nftnl_udata_buf_put);
+
+struct nftnl_udata *nftnl_udata_start(const struct nftnl_udata_buf *bu=
f)
+{
+	return (struct nftnl_udata *)buf->data;
+}
+EXPORT_SYMBOL(nftnl_udata_start);
+
+struct nftnl_udata *nftnl_udata_end(const struct nftnl_udata_buf *buf)
+{
+	return (struct nftnl_udata *)buf->end;
+}
+EXPORT_SYMBOL(nftnl_udata_end);
+
+bool nftnl_udata_put(struct nftnl_udata_buf *buf, uint8_t type, uint32=
_t len,
+		     const void *value)
+{
+	struct nftnl_udata *attr;
+
+	if (buf->size < len + sizeof(struct nftnl_udata))
+		return false;
+
+	attr =3D (struct nftnl_udata *)buf->end;
+	attr->len  =3D len;
+	attr->type =3D type;
+	memcpy(attr->value, value, len);
+
+	buf->end =3D (char *)nftnl_udata_attr_next(attr);
+
+	return true;
+}
+EXPORT_SYMBOL(nftnl_udata_put);
+
+bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
+			  const char *strz)
+{
+	return nftnl_udata_put(buf, type, strlen(strz) + 1, strz);
+}
+EXPORT_SYMBOL(nftnl_udata_put_strz);
+
+uint8_t nftnl_udata_attr_type(const struct nftnl_udata *attr)
+{
+	return attr->type;
+}
+EXPORT_SYMBOL(nftnl_udata_attr_type);
+
+uint8_t nftnl_udata_attr_len(const struct nftnl_udata *attr)
+{
+	return attr->len;
+}
+EXPORT_SYMBOL(nftnl_udata_attr_len);
+
+void *nftnl_udata_attr_value(const struct nftnl_udata *attr)
+{
+	return (void *)attr->value;
+}
+EXPORT_SYMBOL(nftnl_udata_attr_value);
+
+struct nftnl_udata *nftnl_udata_attr_next(const struct nftnl_udata *at=
tr)
+{
+	return (struct nftnl_udata *)&attr->value[attr->len];
+}
+EXPORT_SYMBOL(nftnl_udata_attr_next);
+
+int nftnl_udata_parse(const void *data, uint32_t data_len, nftnl_udata=
_cb_t cb,
+		      void *cb_data)
+{
+	int ret =3D 0;
+	const struct nftnl_udata *attr;
+
+	nftnl_udata_for_each_data(data, data_len, attr) {
+		ret =3D cb(attr, cb_data);
+		if (ret <=3D 0)
+			return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nftnl_udata_parse);
--=20
2.7.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
