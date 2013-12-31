From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] src: rename the parameter tag to node_name in
 jansson function
Date: Tue, 31 Dec 2013 12:27:47 +0100
Message-ID: <20131231112747.11095.53072.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63962 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3LaL2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:28:35 -0500
Received: by mail-wg0-f51.google.com with SMTP id b13so10765937wgh.6
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Dec 2013 03:28:34 -0800 (PST)
Received: from [127.0.1.1] (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id f7sm27910685wjb.7.2013.12.31.03.28.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Dec 2013 03:28:33 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

I have changed this parameter for having consistence with the xml helpe=
r
function

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/internal.h |   18 ++++++++++--------
 src/jansson.c  |   34 ++++++++++++++++++----------------
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/src/internal.h b/src/internal.h
index a10d874..f975ad1 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -57,19 +57,21 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nf=
t_set *s);
=20
 #ifdef JSON_PARSING
 #include <jansson.h>
-int nft_jansson_parse_val(json_t *root, const char *tag, int type, voi=
d *out);
-const char *nft_jansson_parse_str(json_t *root, const char *tag);
-bool nft_jansson_node_exist(json_t *root, const char *tag);
+int nft_jansson_parse_val(json_t *root, const char *node_name, int typ=
e,
+			  void *out);
+const char *nft_jansson_parse_str(json_t *root, const char *node_name)=
;
+bool nft_jansson_node_exist(json_t *root, const char *node_name);
 json_t *nft_jansson_create_root(const char *json, json_error_t *err);
-json_t *nft_jansson_get_node(json_t *root, const char *tag);
+json_t *nft_jansson_get_node(json_t *root, const char *node_name);
 void nft_jansson_free_root(json_t *root);
 int nft_jansson_parse_family(json_t *root, void *out);
-int nft_jansson_str2num(json_t *root, const char *tag, int base, void =
*out,
-			enum nft_type type);
-int nft_jansson_parse_reg(json_t *root, const char *tag, int type, voi=
d *out);
+int nft_jansson_str2num(json_t *root, const char *node_name, int base,
+			void *out, enum nft_type type);
+int nft_jansson_parse_reg(json_t *root, const char *node_name, int typ=
e,
+			  void *out);
 struct nft_rule_expr *nft_jansson_expr_parse(json_t *root);
 union nft_data_reg;
-int nft_jansson_data_reg_parse(json_t *root, const char *tag,
+int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 			       union nft_data_reg *data_reg);
 struct nft_set_elem;
 int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root);
diff --git a/src/jansson.c b/src/jansson.c
index 04146e2..539f9ab 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -23,12 +23,12 @@
=20
 #ifdef JSON_PARSING
=20
-static int nft_jansson_load_int_node(json_t *root, const char *tag,
+static int nft_jansson_load_int_node(json_t *root, const char *node_na=
me,
 				      json_int_t *val)
 {
 	json_t *node;
=20
-	node =3D json_object_get(root, tag);
+	node =3D json_object_get(root, node_name);
 	if (node =3D=3D NULL) {
 		errno =3D EINVAL;
 		return -1;
@@ -43,12 +43,12 @@ static int nft_jansson_load_int_node(json_t *root, =
const char *tag,
 	return 0;
 }
=20
-const char *nft_jansson_parse_str(json_t *root, const char *tag)
+const char *nft_jansson_parse_str(json_t *root, const char *node_name)
 {
 	json_t *node;
 	const char *val;
=20
-	node =3D json_object_get(root, tag);
+	node =3D json_object_get(root, node_name);
 	if (node =3D=3D NULL) {
 		errno =3D EINVAL;
 		return NULL;
@@ -58,11 +58,12 @@ const char *nft_jansson_parse_str(json_t *root, con=
st char *tag)
 	return val;
 }
=20
-int nft_jansson_parse_val(json_t *root, const char *tag, int type, voi=
d *out)
+int nft_jansson_parse_val(json_t *root, const char *node_name, int typ=
e,
+			  void *out)
 {
 	json_int_t val;
=20
-	if (nft_jansson_load_int_node(root, tag, &val) =3D=3D -1)
+	if (nft_jansson_load_int_node(root, node_name, &val) =3D=3D -1)
 		return -1;
=20
 	if (nft_get_value(type, &val, out) =3D=3D -1)
@@ -71,9 +72,9 @@ int nft_jansson_parse_val(json_t *root, const char *t=
ag, int type, void *out)
 	return 0;
 }
=20
-bool nft_jansson_node_exist(json_t *root, const char *tag)
+bool nft_jansson_node_exist(json_t *root, const char *node_name)
 {
-	return json_object_get(root, tag) !=3D NULL;
+	return json_object_get(root, node_name) !=3D NULL;
 }
=20
 json_t *nft_jansson_create_root(const char *json, json_error_t *err)
@@ -89,11 +90,11 @@ json_t *nft_jansson_create_root(const char *json, j=
son_error_t *err)
 	return root;
 }
=20
-json_t *nft_jansson_get_node(json_t *root, const char *tag)
+json_t *nft_jansson_get_node(json_t *root, const char *node_name)
 {
 	json_t *node;
=20
-	node =3D json_object_get(root, tag);
+	node =3D json_object_get(root, node_name);
 	if (node =3D=3D NULL) {
 		errno =3D EINVAL;
 		return NULL;
@@ -126,9 +127,10 @@ int nft_jansson_parse_family(json_t *root, void *o=
ut)
 	return 0;
 }
=20
-int nft_jansson_parse_reg(json_t *root, const char *tag, int type, voi=
d *out)
+int nft_jansson_parse_reg(json_t *root, const char *node_name, int typ=
e,
+			  void *out)
 {
-	if (nft_jansson_parse_val(root, tag, type, out) < 0)
+	if (nft_jansson_parse_val(root, node_name, type, out) < 0)
 		return -1;
=20
 	if (*((uint32_t *)out) > NFT_REG_MAX){
@@ -139,12 +141,12 @@ int nft_jansson_parse_reg(json_t *root, const cha=
r *tag, int type, void *out)
 	return 0;
 }
=20
-int nft_jansson_str2num(json_t *root, const char *tag, int base,
+int nft_jansson_str2num(json_t *root, const char *node_name, int base,
 			void *out, enum nft_type type)
 {
 	const char *str;
=20
-	str =3D nft_jansson_parse_str(root, tag);
+	str =3D nft_jansson_parse_str(root, node_name);
 	if (str =3D=3D NULL)
 		return -1;
=20
@@ -170,14 +172,14 @@ struct nft_rule_expr *nft_jansson_expr_parse(json=
_t *root)
 	return ret < 0 ? NULL : e;
 }
=20
-int nft_jansson_data_reg_parse(json_t *root, const char *tag,
+int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 			       union nft_data_reg *data_reg)
 {
 	json_t *data;
 	const char *type;
 	int ret;
=20
-	data =3D json_object_get(root, tag);
+	data =3D json_object_get(root, node_name);
 	if (data =3D=3D NULL) {
 		errno =3D EINVAL;
 		return -1;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
