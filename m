From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2] libnftnl: rule: Change the "userdata" attribute to use new TLV buffer.
Date: Sat, 20 Feb 2016 23:43:53 +0100
Message-ID: <1456008234-26845-2-git-send-email-carlosfg@riseup.net>
References: <1456008234-26845-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:46494 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbcBTWoI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Feb 2016 17:44:08 -0500
In-Reply-To: <1456008234-26845-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now is it possible to store multiple variable length user data into a r=
ule.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/rule.c | 158 ++++++++++++++++++++++++++++++++++++++++++++++++++---=
--------
 1 file changed, 130 insertions(+), 28 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 3a32bf6..4e6f375 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -28,6 +28,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/set.h>
 #include <libnftnl/expr.h>
+#include <libnftnl/attr.h>
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
+	struct nftnl_attrbuf	*userdata;
 	struct {
 			uint32_t	flags;
 			uint32_t	proto;
@@ -50,6 +48,14 @@ struct nftnl_rule {
 	struct list_head expr_list;
 };
=20
+static void nftnl_rule_parse_userdata(const struct nftnl_attrbuf *attr=
buf,
+				      const struct nftnl_attr *tb[]);
+static size_t nftnl_rule_snprintf_data2str(char *buf, size_t size,
+					   const void *data, size_t datalen);
+static size_t nftnl_rule_snprintf_userdata(char *buf, size_t size,
+					   const struct nftnl_attr *tb[],
+					   enum nftnl_attr_data_type dtype);
+
 struct nftnl_rule *nftnl_rule_alloc(void)
 {
 	struct nftnl_rule *r;
@@ -75,6 +81,8 @@ void nftnl_rule_free(struct nftnl_rule *r)
 		xfree(r->table);
 	if (r->chain !=3D NULL)
 		xfree(r->chain);
+	if (r->flags & (1 << NFTNL_RULE_USERDATA))
+		nftnl_attrbuf_free(r->userdata);
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
+		(r->userdata =3D nftnl_attrbuf_alloc(data_len));
+		if (!r->userdata) {
+			perror("nftnl_rule_set_data - userdata");
+			exit(EXIT_FAILURE);
+		}
+		nftnl_attrbuf_copy_data(r->userdata, data, data_len);
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
+		*data_len =3D nftnl_attrbuf_get_len(r->userdata);
+		return (void *)nftnl_attrbuf_get_data(r->userdata);
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
+			     nftnl_attrbuf_get_len(r->userdata),
+			     nftnl_attrbuf_get_data(r->userdata));
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
+		(r->userdata =3D nftnl_attrbuf_alloc(udata_size));
+		if (!r->userdata)
 			return -1;
+		nftnl_attrbuf_copy_data(r->userdata, udata, udata_size);
=20
-		memcpy(r->user.data, udata, r->user.len);
 		r->flags |=3D (1 << NFTNL_RULE_USERDATA);
 	}
=20
@@ -757,6 +768,29 @@ static int nftnl_rule_snprintf_json(char *buf, siz=
e_t size, struct nftnl_rule *r
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
+	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
+		const struct nftnl_attr *tb[NFTNL_ATTR_TYPE_MAX+1] =3D {NULL};
+
+		nftnl_rule_parse_userdata(r->userdata, tb);
+
+		ret =3D snprintf(buf+offset, len, "\"userdata\":[");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (tb[NFTNL_ATTR_TYPE_COMMENT]) {
+			ret =3D snprintf(buf+offset, len, "{\"comment\":\"");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			ret =3D nftnl_rule_snprintf_userdata(buf+offset, size, tb,
+						NFTNL_ATTR_TYPE_COMMENT);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			ret =3D snprintf(buf+offset, len, "\"}");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret =3D snprintf(buf+offset, len, "],\n");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	}
+
 	ret =3D snprintf(buf+offset, len, "\"expr\":[");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
@@ -855,11 +889,76 @@ static int nftnl_rule_snprintf_xml(char *buf, siz=
e_t size, struct nftnl_rule *r,
 	return offset;
 }
=20
+static int nftnl_rule_parse_userdata_cb(const struct nftnl_attr *attr,
+					void *data)
+{
+	const struct nftnl_attr **tb =3D data;
+	uint8_t type =3D nftnl_attr_get_type(attr);
+	uint8_t len =3D nftnl_attr_get_len(attr);
+	unsigned char *value =3D nftnl_attr_get_value(attr);
+
+	/* Validation */
+	switch (type) {
+	case NFTNL_ATTR_TYPE_COMMENT:
+		if (value[len-1] !=3D '\0')
+			return NFTNL_CB_ERROR;
+	default:
+		return NFTNL_CB_ERROR;
+	};
+
+	tb[type] =3D attr;
+	return NFTNL_CB_OK;
+}
+
+static void nftnl_rule_parse_userdata(const struct nftnl_attrbuf *attr=
buf,
+				      const struct nftnl_attr *tb[])
+{
+	if (nftnl_attr_parse(attrbuf, nftnl_rule_parse_userdata_cb, tb)
+		!=3D NFTNL_CB_OK
+	) {
+		fprintf(stderr, "Error parsing rule userdata\n");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static size_t nftnl_rule_snprintf_data2str(char *buf, size_t size,
+					   const void *data, size_t datalen)
+{
+	int i;
+	size_t ret, len =3D size, offset =3D 0;
+	const char *c =3D data;
+
+	for (i =3D 0; i < datalen; i++) {
+		ret =3D snprintf(buf+offset, len, "%c",
+			       isprint(c[i]) ? c[i] : '?');
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static size_t nftnl_rule_snprintf_userdata(char *buf, size_t size,
+					   const struct nftnl_attr *tb[],
+					   enum nftnl_attr_data_type dtype)
+{
+	size_t ret, offset =3D 0;
+
+	ret =3D nftnl_rule_snprintf_data2str(
+		buf,
+		size,
+		nftnl_attr_get_value(tb[dtype]),
+		nftnl_attr_get_len(tb[dtype])-1
+	);
+	SNPRINTF_BUFFER_SIZE(ret, size, size, offset);
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
@@ -905,20 +1004,23 @@ static int nftnl_rule_snprintf_default(char *buf=
, size_t size, struct nftnl_rule
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
-	if (r->user.len) {
-		ret =3D snprintf(buf+offset, len, "  userdata =3D { ");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-		for (i =3D 0; i < r->user.len; i++) {
-			char *c =3D r->user.data;
+	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
+		const struct nftnl_attr *tb[NFTNL_ATTR_TYPE_MAX+1] =3D {NULL};
+
+		nftnl_rule_parse_userdata(r->userdata, tb);
=20
-			ret =3D snprintf(buf+offset, len, "%c",
-				       isalnum(c[i]) ? c[i] : 0);
+		if (tb[NFTNL_ATTR_TYPE_COMMENT]) {
+			ret =3D snprintf(buf+offset, len, "  userdata =3D { ");
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
=20
-		ret =3D snprintf(buf+offset, len, " }\n");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			ret =3D nftnl_rule_snprintf_userdata(buf+offset, size, tb,
+						NFTNL_ATTR_TYPE_COMMENT);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+			ret =3D snprintf(buf+offset, len, " }\n");
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
=20
 	}
=20
--=20
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
