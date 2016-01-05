From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/4 v2] libnftnl: set: Implement new buffer of TLV objects.
Date: Tue,  5 Jan 2016 14:03:33 +0100
Message-ID: <1451999013-4313-2-git-send-email-carlosfg@riseup.net>
References: <1451999013-4313-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:44851 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbcAENLD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 08:11:03 -0500
In-Reply-To: <1451999013-4313-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions allow create a buffer (nftnl_attrbuf) of TLV objects
(nftnl_attr). It is inspired in libmnl/src/attr.c.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/libnftnl/set.h | 102 ++++++++++++++++++++
 include/set.h          |  23 +++++
 src/libnftnl.map       |  39 ++++++++
 src/set.c              | 246 +++++++++++++++++++++++++++++++++++++++++=
++++++--
 4 files changed, 400 insertions(+), 10 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 7a5a512..44f411b 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -278,4 +278,106 @@ void nft_set_elems_iter_destroy(struct nft_set_el=
ems_iter *iter);
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
+/*
+ * Compact
+ */
+struct nft_attr;
+struct nft_attrbuf;
+
+struct nft_attrbuf *nft_attrbuf_alloc(size_t size);
+void nft_attrbuf_delete(struct nft_attrbuf *attrbuf);
+void nft_attrbuf_free(struct nft_attrbuf *attrbuf);
+void nft_attrbuf_printf(const struct nft_attrbuf *attrbuf);
+size_t nft_attrbuf_len(const struct nft_attrbuf *attrbuf);
+size_t nft_attrbuf_size(const struct nft_attrbuf *attrbuf);
+void *nft_attrbuf_data(const struct nft_attrbuf *attrbuf);
+
+/* TLV attribute getters */
+uint8_t nft_attr_get_type(const struct nft_attr *attr);
+uint8_t nft_attr_get_len(const struct nft_attr *attr);
+void *nft_attr_get_value(const struct nft_attr *attr);
+uint16_t nft_attr_get_size(const struct nft_attr *attr);
+
+/* TLV attribute putters */
+struct nft_attr *nft_attr_put(struct nft_attrbuf *attrbuf,
+			      uint8_t type, uint8_t len, const void *data);
+struct nft_attr *nft_attr_put_check(struct nft_attrbuf *attrbuf,
+				    size_t bufsize, uint8_t type,
+				    uint8_t len, const void *data);
+
+/* TLV validation */
+int nft_attr_type_valid(const struct nft_attr *attr);
+int nft_attr_validate(const struct nft_attr *attr);
+int nft_attr_validate2(const struct nft_attr *attr, uint8_t exp_len);
+
+/* TLV iterators */
+struct nft_attr *nft_attr_next(const struct nft_attr *attr);
+
+#define nft_attr_for_each(attr, attrbuf) nftnl_attr_for_each(attr, att=
rbuf)
+#define nft_attr_for_each_payload(attr, payload, payload_len) \
+	nftnl_attr_for_each_payload(attr, payload, payload_len)
+
+int nft_attr_payload_snprint(const void *payload, size_t payload_len,
+			     char *buf, int bsize);
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
index 2e193b7..12dc24e 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -136,6 +136,25 @@ global:
   nft_set_snprintf;
   nft_set_fprintf;
=20
+  nft_attrbuf_alloc;
+  nft_attrbuf_delete;
+  nft_attrbuf_free;
+  nft_attrbuf_printf;
+  nft_attrbuf_len;
+  nft_attrbuf_size;
+  nft_attrbuf_data;
+  nft_attr_get_type;
+  nft_attr_get_len;
+  nft_attr_get_value;
+  nft_attr_get_size;
+  nft_attr_put;
+  nft_attr_put_check;
+  nft_attr_type_valid;
+  nft_attr_validate;
+  nft_attr_validate2;
+  nft_attr_next;
+  nft_attr_payload_snprint;
+
   nft_set_list_alloc;
   nft_set_list_free;
   nft_set_list_add;
@@ -336,6 +355,26 @@ global:
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
+
   nftnl_set_list_alloc;
   nftnl_set_list_free;
   nftnl_set_list_add;
diff --git a/src/set.c b/src/set.c
index 315bced..ca41eb0 100644
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
@@ -1270,3 +1271,228 @@ int nftnl_set_lookup_id(struct nftnl_expr *e,
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
+EXPORT_SYMBOL_ALIAS(nftnl_attrbuf_alloc, nft_attrbuf_alloc);
+
+void nftnl_attrbuf_delete(struct nftnl_attrbuf *attrbuf)
+{
+	attrbuf->tail =3D (struct nftnl_attr *)attrbuf->data;
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attrbuf_delete, nft_attrbuf_delete);
+
+void nftnl_attrbuf_free(struct nftnl_attrbuf *attrbuf)
+{
+	nftnl_attrbuf_delete(attrbuf);
+	free((void *)attrbuf);
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attrbuf_free, nft_attrbuf_free);
+
+size_t nftnl_attrbuf_len(const struct nftnl_attrbuf *attrbuf)
+{
+	return (size_t)((char *)attrbuf->tail - (char *)attrbuf->data);
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attrbuf_len, nft_attrbuf_len);
+
+size_t nftnl_attrbuf_size(const struct nftnl_attrbuf *attrbuf)
+{
+	return (size_t)((char *)attrbuf->tail - (char *)attrbuf);
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attrbuf_size, nft_attrbuf_size);
+
+void *nftnl_attrbuf_data(const struct nftnl_attrbuf *attrbuf)
+{
+	return (void *)attrbuf->data;
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attrbuf_data, nft_attrbuf_data);
+
+uint8_t nftnl_attr_get_type(const struct nftnl_attr *attr)
+{
+	return attr->type;
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attr_get_type, nft_attr_get_type);
+
+uint8_t nftnl_attr_get_len(const struct nftnl_attr *attr)
+{
+	return attr->len;
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attr_get_len, nft_attr_get_len);
+
+void *nftnl_attr_get_value(const struct nftnl_attr *attr)
+{
+	return (void *)attr->value;
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attr_get_value, nft_attr_get_value);
+
+uint16_t nftnl_attr_get_size(const struct nftnl_attr *attr)
+{
+	return (char *)nftnl_attr_next(attr) - (char *)attr;
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attr_get_size, nft_attr_get_size);
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
+EXPORT_SYMBOL_ALIAS(nftnl_attr_put, nft_attr_put);
+
+struct nftnl_attr *nftnl_attr_put_check(struct nftnl_attrbuf *attrbuf,
+					size_t bufsize, uint8_t type,
+					uint8_t len, const void *data)
+{
+	if (!ATTRBUF_ENOUGH_SIZE(attrbuf, bufsize, len))
+		return NULL;
+	return nftnl_attr_put(attrbuf, type, len, data);
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attr_put_check, nft_attr_put_check);
+
+int nftnl_attr_type_valid(const struct nftnl_attr *attr)
+{
+	if (nftnl_attr_get_type(attr) > NFTNL_ATTR_TYPE_MAX) {
+		errno =3D EINVAL;
+		return -1;
+	}
+	return 1;
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attr_type_valid, nft_attr_type_valid);
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
+EXPORT_SYMBOL_ALIAS(nftnl_attr_validate, nft_attr_validate);
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
+EXPORT_SYMBOL_ALIAS(nftnl_attr_validate2, nft_attr_validate2);
+
+struct nftnl_attr *nftnl_attr_next(const struct nftnl_attr *attr)
+{
+	return (struct nftnl_attr *)&attr->value[attr->len];
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attr_next, nft_attr_next);
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
+	/* delete last comma */
+	if (boffset)
+		boffset--;
+
+	return boffset;
+}
+EXPORT_SYMBOL_ALIAS(nftnl_attr_payload_snprint, nft_attr_payload_snpri=
nt);
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
