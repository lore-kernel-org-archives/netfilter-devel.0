From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/4 v3] libnftnl: set: Implement new buffer of TLV objects.
Date: Sat,  9 Jan 2016 00:41:01 +0100
Message-ID: <1452296461-1736-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51183 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbcAHXlT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 18:41:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions allow create a buffer (nftnl_attrbuf) of TLV objects
(nftnl_attr). It is inspired in libmnl/src/attr.c.

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
 include/libnftnl/set.h |  61 ++++++++++++
 include/set.h          |  23 +++++
 src/libnftnl.map       |  19 ++++
 src/set.c              | 248 +++++++++++++++++++++++++++++++++++++++++=
++++++--
 4 files changed, 341 insertions(+), 10 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 7a5a512..416e21b 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -278,4 +278,65 @@ void nft_set_elems_iter_destroy(struct nft_set_ele=
ms_iter *iter);
 int nft_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 					   struct nft_set_elems_iter *iter);
=20
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
+void nftnl_attrbuf_printf(const struct nftnl_attrbuf *attrbuf);
+size_t nftnl_attrbuf_len(const struct nftnl_attrbuf *attrbuf);
+size_t nftnl_attrbuf_size(const struct nftnl_attrbuf *attrbuf);
+void *nftnl_attrbuf_data(const struct nftnl_attrbuf *attrbuf);
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
+					uint8_t len, const void *data);
+
+/* TLV validation */
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
+int nftnl_attr_type_valid(const struct nftnl_attr *attr);
+int nftnl_attr_validate(const struct nftnl_attr *attr);
+int nftnl_attr_validate2(const struct nftnl_attr *attr, uint8_t exp_le=
n);
+
+/* TLV iterators */
+struct nftnl_attr *nftnl_attr_next(const struct nftnl_attr *attr);
+
+#define nftnl_attr_for_each(attr, attrbuf)                  \
+	for ((attr) =3D (struct nftnl_attr *)(attrbuf)->data; \
+	     (char *)(attrbuf)->tail > (char *)(attr);      \
+	     (attr) =3D nftnl_attr_next(attr))
+
+#define nftnl_attr_for_each_payload(attr, payload, payload_len) \
+	for ((attr) =3D (struct nftnl_attr *)(payload);           \
+	     (char *)(attr) - (char *)(payload) < (payload_len);\
+	     (attr) =3D nftnl_attr_next(attr))
+
+int nftnl_attr_payload_snprint(const void *payload, size_t payload_len=
,
+			       char *buf, int bsize);
+
 #endif /* _LIBNFTNL_SET_H_ */
diff --git a/include/set.h b/include/set.h
index 85bd389..48c9199 100644
--- a/include/set.h
+++ b/include/set.h
@@ -35,4 +35,27 @@ struct nftnl_expr;
 int nftnl_set_lookup_id(struct nftnl_expr *e, struct nftnl_set_list *s=
et_list,
 		      uint32_t *set_id);
=20
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
 #endif
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 2e193b7..f433845 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -336,6 +336,25 @@ global:
   nftnl_set_snprintf;
   nftnl_set_fprintf;
=20
+  nftnl_attrbuf_alloc;
+  nftnl_attrbuf_delete;
+  nftnl_attrbuf_free;
+  nftnl_attrbuf_printf;
+  nftnl_attrbuf_len;
+  nftnl_attrbuf_size;
+  nftnl_attrbuf_data;
+  nftnl_attr_get_type;
+  nftnl_attr_get_len;
+  nftnl_attr_get_value;
+  nftnl_attr_get_size;
+  nftnl_attr_put;
+  nftnl_attr_put_check;
+  nftnl_attr_type_valid;
+  nftnl_attr_validate;
+  nftnl_attr_validate2;
+  nftnl_attr_next;
+  nftnl_attr_payload_snprint;
+
   nftnl_set_list_alloc;
   nftnl_set_list_free;
   nftnl_set_list_add;
diff --git a/src/set.c b/src/set.c
index 315bced..ea41d05 100644
--- a/src/set.c
+++ b/src/set.c
@@ -28,6 +28,12 @@
 #include <libnftnl/set.h>
 #include <libnftnl/expr.h>
=20
+#define ATTRBUF_ENOUGH_SIZE(attrbuf, bufsize, attr_len) ( \
+	(bufsize) >=3D \
+		attr_len + \
+		sizeof(struct nftnl_attr) + \
+		nftnl_attrbuf_len(attrbuf))
+
 struct nftnl_set *nftnl_set_alloc(void)
 {
 	struct nftnl_set *s;
@@ -804,7 +810,6 @@ static int nftnl_set_snprintf_json(char *buf, size_=
t size, struct nftnl_set *s,
 				  uint32_t type, uint32_t flags)
 {
 	int len =3D size, offset =3D 0, ret;
-	int i;
 	struct nftnl_set_elem *elem;
=20
 	ret =3D snprintf(buf, len, "{\"set\":{");
@@ -861,18 +866,14 @@ static int nftnl_set_snprintf_json(char *buf, siz=
e_t size, struct nftnl_set *s,
 			       s->user.len);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-		ret =3D snprintf(buf + offset, len, ",\"userdata\":\"");
+		ret =3D snprintf(buf + offset, len, ",\"userdata\":[");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-		char *c =3D s->user.data;
-
-		for (i =3D 0; i < s->user.len; i++) {
-			ret =3D snprintf(buf + offset, len, "%c",
-				       isprint(c[i]) ? c[i] : ' ');
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
+		ret =3D nftnl_attr_payload_snprint(s->user.data, s->user.len,
+						 buf + offset, len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-		ret =3D snprintf(buf + offset, len, "\"");
+		ret =3D snprintf(buf + offset, len, "]");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
@@ -1270,3 +1271,230 @@ int nftnl_set_lookup_id(struct nftnl_expr *e,
 	*set_id =3D nftnl_set_get_u32(s, NFTNL_SET_ID);
 	return 1;
 }
+
+/* TLV */
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
+size_t nftnl_attrbuf_len(const struct nftnl_attrbuf *attrbuf)
+{
+	return (size_t)((char *)attrbuf->tail - (char *)attrbuf->data);
+}
+EXPORT_SYMBOL(nftnl_attrbuf_len);
+
+size_t nftnl_attrbuf_size(const struct nftnl_attrbuf *attrbuf)
+{
+	return (size_t)((char *)attrbuf->tail - (char *)attrbuf);
+}
+EXPORT_SYMBOL(nftnl_attrbuf_size);
+
+void *nftnl_attrbuf_data(const struct nftnl_attrbuf *attrbuf)
+{
+	return (void *)attrbuf->data;
+}
+EXPORT_SYMBOL(nftnl_attrbuf_data);
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
+					uint8_t len, const void *data)
+{
+	if (!ATTRBUF_ENOUGH_SIZE(attrbuf, bufsize, len))
+		return NULL;
+	return nftnl_attr_put(attrbuf, type, len, data);
+}
+EXPORT_SYMBOL(nftnl_attr_put_check);
+
+int nftnl_attr_type_valid(const struct nftnl_attr *attr)
+{
+	if (nftnl_attr_get_type(attr) > NFTNL_ATTR_TYPE_MAX) {
+		errno =3D EINVAL;
+		return -1;
+	}
+	return 1;
+}
+EXPORT_SYMBOL(nftnl_attr_type_valid);
+
+static const size_t nftnl_attr_data_type_len[MNL_TYPE_MAX] =3D {
+	[NFTNL_ATTR_TYPE_U8]	=3D sizeof(uint8_t),
+	[NFTNL_ATTR_TYPE_U16]	=3D sizeof(uint16_t),
+	[NFTNL_ATTR_TYPE_U32]	=3D sizeof(uint32_t),
+	[NFTNL_ATTR_TYPE_U64]	=3D sizeof(uint64_t),
+};
+
+int nftnl_attr_validate(const struct nftnl_attr *attr)
+{
+	int exp_len;
+
+	exp_len =3D nftnl_attr_data_type_len[nftnl_attr_get_type(attr)];
+	return nftnl_attr_validate2(attr, exp_len);
+}
+EXPORT_SYMBOL(nftnl_attr_validate);
+
+int nftnl_attr_validate2(const struct nftnl_attr *attr, uint8_t exp_le=
n)
+{
+	uint8_t type =3D nftnl_attr_get_type(attr);
+	uint8_t len =3D nftnl_attr_get_len(attr);
+
+	if (len !=3D exp_len) {
+		errno =3D ERANGE;
+		return -1;
+	}
+
+	switch (type) {
+	case MNL_TYPE_STRING:
+		if (len =3D=3D 0) {
+			errno =3D ERANGE;
+			return -1;
+		}
+		break;
+	default:
+		if (!nftnl_attr_type_valid(attr))
+			return -1;
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(nftnl_attr_validate2);
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
--=20
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
