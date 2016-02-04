From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2] set: Implement new buffer of TLV objects.
Date: Thu,  4 Feb 2016 20:38:39 +0100
Message-ID: <1454614720-8126-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:60919 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966035AbcBDTi5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2016 14:38:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions allow to create a buffer (nftnl_attrbuf) of TLV objects
(nftnl_attr). It is inspired by libmnl/src/attr.c.

Example usage:
	```
	char print_buf[PBUF_SIZE];
	struct nftnl_attrbuf *attrbuf;
	const char str[] =3D "Hello World!";

	attrbuf =3D nftnl_attrbuf_alloc(ATTRBUF_SIZE);
	if (!nftnl_attr_put_check(attrbuf, ATTRBUF_SIZE, NFTNL_ATTR_TYPE_STRIN=
G,
				  strlen(str), str)) {
		fprintf(stderr, "Can't put attribute \"%s\"", str);
	}

	nftnl_attr_payload_snprint(nftnl_attrbuf_data(attrbuf),
				   nftnl_attrbuf_len(attrbuf),
				   print_buf, PBUF_SIZE);
	printf("attrbuf =3D { %s }\n", print_buf);

	free (attrbuf);
	```

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/Makefile.am          |   1 +
 include/attr.h               |  29 ++++++
 include/libnftnl/Makefile.am |   1 +
 include/libnftnl/attr.h      |  68 ++++++++++++++
 src/Makefile.am              |   1 +
 src/attr.c                   | 208 +++++++++++++++++++++++++++++++++++=
++++++++
 src/libnftnl.map             |  18 ++++
 7 files changed, 326 insertions(+)
 create mode 100644 include/attr.h
 create mode 100644 include/libnftnl/attr.h
 create mode 100644 src/attr.c

diff --git a/include/Makefile.am b/include/Makefile.am
index be9eb9b..785ec15 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -12,4 +12,5 @@ noinst_HEADERS =3D internal.h	\
 		 expr.h		\
 		 json.h		\
 		 set_elem.h	\
+		 attr.h		\
 		 utils.h
diff --git a/include/attr.h b/include/attr.h
new file mode 100644
index 0000000..8396211
--- /dev/null
+++ b/include/attr.h
@@ -0,0 +1,29 @@
+#ifndef _LIBNFTNL_ATTR_INTERNAL_H_
+#define _LIBNFTNL_ATTR_INTERNAL_H_
+
+#include <stdint.h>
+
+/*
+ * TLV structures:
+ * nftnl_attr
+ *  <-------- HEADER --------> <------ PAYLOAD ------>
+ * +------------+-------------+- - - - - - - - - - - -+
+ * |    type    |     len     |         value         |
+ * |  (1 byte)  |   (1 byte)  |                       |
+ * +--------------------------+- - - - - - - - - - - -+
+ *  <-- sizeof(nftnl_attr) --> <-- nftnl_attr->len -->
+ *  <------------- nftnl_attr_get_size() ------------>
+ */
+
+struct __attribute__((__packed__)) nftnl_attr {
+	uint8_t type;
+	uint8_t len;
+	unsigned char value[];
+};
+
+struct nftnl_attrbuf {
+	struct nftnl_attr *tail;
+	unsigned char data[];
+};
+
+#endif
diff --git a/include/libnftnl/Makefile.am b/include/libnftnl/Makefile.a=
m
index 84f01b6..a3a6fb3 100644
--- a/include/libnftnl/Makefile.am
+++ b/include/libnftnl/Makefile.am
@@ -7,4 +7,5 @@ pkginclude_HEADERS =3D batch.h		\
 		     set.h		\
 		     ruleset.h		\
 		     common.h		\
+		     attr.h		\
 		     gen.h
diff --git a/include/libnftnl/attr.h b/include/libnftnl/attr.h
new file mode 100644
index 0000000..e6e08f3
--- /dev/null
+++ b/include/libnftnl/attr.h
@@ -0,0 +1,68 @@
+#ifndef _LIBNFTNL_ATTR_H_
+#define _LIBNFTNL_ATTR_H_
+
+#include <stdio.h>
+#include <stdint.h>
+
+/*
+ * nftnl attributes API
+ */
+struct nftnl_attr;
+struct nftnl_attrbuf;
+
+/* nftnl_attrbuf */
+struct nftnl_attrbuf *nftnl_attrbuf_alloc(size_t size);
+void nftnl_attrbuf_delete(struct nftnl_attrbuf *attrbuf);
+void nftnl_attrbuf_free(struct nftnl_attrbuf *attrbuf);
+
+size_t nftnl_attrbuf_get_len(const struct nftnl_attrbuf *attrbuf);
+size_t nftnl_attrbuf_get_size(const struct nftnl_attrbuf *attrbuf);
+void *nftnl_attrbuf_get_data(const struct nftnl_attrbuf *attrbuf);
+void nftnl_attrbuf_set_data(struct nftnl_attrbuf *attrbuf, const void =
*data,
+			    size_t len);
+struct nftnl_attr *nftnl_attrbuf_get_head(const struct nftnl_attrbuf *=
attrbuf);
+struct nftnl_attr *nftnl_attrbuf_get_tail(const struct nftnl_attrbuf *=
attrbuf);
+
+/* TLV attribute getters */
+uint8_t nftnl_attr_get_type(const struct nftnl_attr *attr);
+uint8_t nftnl_attr_get_len(const struct nftnl_attr *attr);
+void *nftnl_attr_get_value(const struct nftnl_attr *attr);
+uint16_t nftnl_attr_get_size(const struct nftnl_attr *attr);
+
+/* TLV attribute putters */
+struct nftnl_attr *nftnl_attr_put(struct nftnl_attrbuf *attrbuf,
+				  uint8_t type, uint8_t len, const void *data);
+struct nftnl_attr *nftnl_attr_put_check(struct nftnl_attrbuf *attrbuf,
+					size_t bufsize, uint8_t type,
+					size_t len, const void *data);
+
+enum nftnl_attr_data_type {
+	NFTNL_ATTR_TYPE_UNSPEC,
+	NFTNL_ATTR_TYPE_U8,
+	NFTNL_ATTR_TYPE_U16,
+	NFTNL_ATTR_TYPE_U32,
+	NFTNL_ATTR_TYPE_U64,
+	NFTNL_ATTR_TYPE_STRING,
+	NFTNL_ATTR_TYPE_BINARY,
+	__NFTNL_ATTR_TYPE_MAX,
+};
+#define NFTNL_ATTR_TYPE_MAX (__NFTNL_ATTR_TYPE_MAX - 1)
+
+/* TLV iterators */
+struct nftnl_attr *nftnl_attr_next(const struct nftnl_attr *attr);
+
+#define nftnl_attr_for_each(attr, attrbuf)                           \
+	for ((attr) =3D (struct nftnl_attr *)                          \
+	     nftnl_attr_get_value(nftnl_attrbuf_data(attrbuf));      \
+	     (char *)(nftnl_attrbuf_tail(attrbuf)) > (char *)(attr); \
+	     (attr) =3D nftnl_attr_next(attr))
+
+#define nftnl_attr_for_each_payload(attr, payload, payload_len)  \
+	for ((attr) =3D (struct nftnl_attr *)(payload);            \
+	     (char *)(attr) - (char *)(payload) < (payload_len); \
+	     (attr) =3D nftnl_attr_next(attr))
+
+int nftnl_attr_payload_snprint(const void *payload, size_t payload_len=
,
+			       char *buf, int bsize);
+
+#endif /* _LIBNFTNL_ATTR_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index a27e292..621dd69 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -19,6 +19,7 @@ libnftnl_la_SOURCES =3D utils.c		\
 		      ruleset.c		\
 		      mxml.c		\
 		      jansson.c		\
+		      attr.c		\
 		      expr.c		\
 		      expr_ops.c	\
 		      expr/bitwise.c	\
diff --git a/src/attr.c b/src/attr.c
new file mode 100644
index 0000000..b9938d5
--- /dev/null
+++ b/src/attr.c
@@ -0,0 +1,208 @@
+#include <libnftnl/attr.h>
+#include <attr.h>
+#include <utils.h>
+
+#include <stdlib.h>
+#include <stdint.h>
+#include <errno.h>
+#include <ctype.h>
+
+
+struct nftnl_attrbuf *nftnl_attrbuf_alloc(size_t size)
+{
+	struct nftnl_attrbuf *attrbuf;
+
+	attrbuf =3D
+		(struct nftnl_attrbuf *)malloc(sizeof(struct nftnl_attrbuf) +
+					       size
+					      );
+	attrbuf->tail =3D (struct nftnl_attr *)attrbuf->data;
+
+	return attrbuf;
+}
+EXPORT_SYMBOL(nftnl_attrbuf_alloc);
+
+void nftnl_attrbuf_delete(struct nftnl_attrbuf *attrbuf)
+{
+	attrbuf->tail =3D (struct nftnl_attr *)attrbuf->data;
+}
+EXPORT_SYMBOL(nftnl_attrbuf_delete);
+
+void nftnl_attrbuf_free(struct nftnl_attrbuf *attrbuf)
+{
+	nftnl_attrbuf_delete(attrbuf);
+	free((void *)attrbuf);
+}
+EXPORT_SYMBOL(nftnl_attrbuf_free);
+
+size_t nftnl_attrbuf_get_len(const struct nftnl_attrbuf *attrbuf)
+{
+	return (size_t)((char *)attrbuf->tail - (char *)attrbuf->data);
+}
+EXPORT_SYMBOL(nftnl_attrbuf_get_len);
+
+size_t nftnl_attrbuf_get_size(const struct nftnl_attrbuf *attrbuf)
+{
+	return (size_t)((char *)attrbuf->tail - (char *)attrbuf);
+}
+EXPORT_SYMBOL(nftnl_attrbuf_get_size);
+
+struct nftnl_attr *nftnl_attrbuf_get_head(const struct nftnl_attrbuf *=
attrbuf)
+{
+	return (struct nftnl_attr *)attrbuf->data;
+}
+EXPORT_SYMBOL(nftnl_attrbuf_get_head);
+
+struct nftnl_attr *nftnl_attrbuf_get_tail(const struct nftnl_attrbuf *=
attrbuf)
+{
+	return attrbuf->tail;
+}
+EXPORT_SYMBOL(nftnl_attrbuf_get_tail);
+
+void *nftnl_attrbuf_get_data(const struct nftnl_attrbuf *attrbuf)
+{
+	return (void *)attrbuf->data;
+}
+EXPORT_SYMBOL(nftnl_attrbuf_get_data);
+
+void nftnl_attrbuf_set_data(struct nftnl_attrbuf *attrbuf, const void =
*data,
+			    size_t len)
+{
+	memcpy(attrbuf->data, data, len);
+	attrbuf->tail =3D (struct nftnl_attr *)(attrbuf->data + len);
+}
+EXPORT_SYMBOL(nftnl_attrbuf_set_data);
+
+uint8_t nftnl_attr_get_type(const struct nftnl_attr *attr)
+{
+	return attr->type;
+}
+EXPORT_SYMBOL(nftnl_attr_get_type);
+
+uint8_t nftnl_attr_get_len(const struct nftnl_attr *attr)
+{
+	return attr->len;
+}
+EXPORT_SYMBOL(nftnl_attr_get_len);
+
+void *nftnl_attr_get_value(const struct nftnl_attr *attr)
+{
+	return (void *)attr->value;
+}
+EXPORT_SYMBOL(nftnl_attr_get_value);
+
+uint16_t nftnl_attr_get_size(const struct nftnl_attr *attr)
+{
+	return (char *)nftnl_attr_next(attr) - (char *)attr;
+}
+EXPORT_SYMBOL(nftnl_attr_get_size);
+
+struct nftnl_attr *nftnl_attr_put(struct nftnl_attrbuf *attrbuf,
+				  uint8_t type, uint8_t len, const void *data)
+{
+	struct nftnl_attr *attr =3D attrbuf->tail;
+
+	attr->len  =3D len;
+	attr->type =3D type;
+	memcpy(attr->value, data, len);
+
+	attrbuf->tail =3D nftnl_attr_next(attr);
+
+	return attr;
+}
+EXPORT_SYMBOL(nftnl_attr_put);
+
+struct nftnl_attr *nftnl_attr_put_check(struct nftnl_attrbuf *attrbuf,
+					size_t bufsize, uint8_t type,
+					size_t len, const void *data)
+{
+	// Check if there is enough space
+	if (bufsize <
+		len +
+		sizeof(struct nftnl_attr) +
+		nftnl_attrbuf_get_len(attrbuf)
+	)
+		return NULL;
+
+	return nftnl_attr_put(attrbuf, type, len, data);
+}
+EXPORT_SYMBOL(nftnl_attr_put_check);
+
+struct nftnl_attr *nftnl_attr_next(const struct nftnl_attr *attr)
+{
+	return (struct nftnl_attr *)&attr->value[attr->len];
+}
+EXPORT_SYMBOL(nftnl_attr_next);
+
+static int __attr_snprint(const struct nftnl_attr *attr,
+			char *buf, size_t bsize)
+{
+	int i;
+	int written, blen, boffset;
+	uint8_t alen;
+	char *aval;
+
+	written =3D 0;
+	boffset =3D 0;
+	blen =3D bsize;
+	alen =3D nftnl_attr_get_len(attr);
+	aval =3D (char *)nftnl_attr_get_value(attr);
+
+
+	/* type */
+	written =3D snprintf(buf + boffset, blen, "{\"type\":%u,",
+			   nftnl_attr_get_type(attr));
+	SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+
+	/* len */
+	written =3D snprintf(buf + boffset, blen, "\"len\":%u,", alen);
+	SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+
+	/* value as string */
+	written =3D snprintf(buf + boffset, blen, "\"val\":");
+	SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+
+	written =3D snprintf(buf + boffset, blen, "\"");
+	SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+
+	for (i =3D 0; i < alen; i++) {
+		written =3D snprintf(buf + boffset, blen, "%c",
+				   isprint(aval[i]) ? aval[i] : ' ');
+		SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+	}
+
+	written =3D snprintf(buf + boffset, blen, "\"");
+	SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+
+	written =3D snprintf(buf + boffset, blen, "}");
+	SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+
+	return boffset;
+}
+
+int nftnl_attr_payload_snprint(const void *payload, size_t payload_len=
,
+			       char *buf, int bsize)
+{
+	struct nftnl_attr *attr;
+	int written, blen, boffset;
+
+	written =3D 0;
+	boffset =3D 0;
+	blen =3D bsize;
+
+	nftnl_attr_for_each_payload(attr, payload, payload_len) {
+		written =3D __attr_snprint(attr, buf + boffset, blen);
+		SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+
+		written =3D snprintf(buf + boffset, blen, ",");
+		SNPRINTF_BUFFER_SIZE(written, bsize, blen, boffset);
+	}
+	if (boffset) {
+		/* delete last comma */
+		boffset--;
+		*(buf + boffset) =3D '\0';
+	}
+
+	return boffset;
+}
+EXPORT_SYMBOL(nftnl_attr_payload_snprint);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 2e193b7..e1396b9 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -336,6 +336,24 @@ global:
   nftnl_set_snprintf;
   nftnl_set_fprintf;
=20
+  nftnl_attrbuf_alloc;
+  nftnl_attrbuf_delete;
+  nftnl_attrbuf_free;
+  nftnl_attrbuf_get_len;
+  nftnl_attrbuf_get_size;
+  nftnl_attrbuf_get_head;
+  nftnl_attrbuf_get_tail;
+  nftnl_attrbuf_get_data;
+  nftnl_attrbuf_set_data;
+  nftnl_attr_get_type;
+  nftnl_attr_get_len;
+  nftnl_attr_get_value;
+  nftnl_attr_get_size;
+  nftnl_attr_put;
+  nftnl_attr_put_check;
+  nftnl_attr_next;
+  nftnl_attr_payload_snprint;
+
   nftnl_set_list_alloc;
   nftnl_set_list_free;
   nftnl_set_list_add;
--=20
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
