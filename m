From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/7] jansson: Add helper function for building the
 tree
Date: Wed, 31 Jul 2013 15:20:59 +0200
Message-ID: <20130731132058.29730.38608.stgit@Ph0enix>
References: <20130731132051.29730.53717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56204 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3GaNVC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:21:02 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so601136wgg.16
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2013 06:21:01 -0700 (PDT)
In-Reply-To: <20130731132051.29730.53717.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add a helper function for parsing and return the jansson tree

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/internal.h |    1 +
 src/jansson.c  |   19 +++++++++++++++++++
 src/table.c    |   14 +++-----------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/src/internal.h b/src/internal.h
index a8ae431..d1c7690 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -45,6 +45,7 @@ int nft_jansson_value_parse_val(json_t *root, const c=
har *tag,
 				  int type, void *out);
 const char *nft_jansson_value_parse_str(json_t *root, const char *tag)=
;
 bool nft_jansson_node_exist(json_t *root, const char *tag);
+json_t *nft_jansson_get_root(char *json, const char *tag, json_error_t=
 *err);
 #endif
=20
 const char *nft_family2str(uint32_t family);
diff --git a/src/jansson.c b/src/jansson.c
index cc68ae0..4c778d9 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -71,4 +71,23 @@ bool nft_jansson_node_exist(json_t *root, const char=
 *tag)
 {
 	return json_object_get(root, tag) !=3D NULL;
 }
+
+json_t *nft_jansson_get_root(char *json, const char *tag, json_error_t=
 *err)
+{
+	json_t *root;
+
+	root =3D json_loadb(json, strlen(json), 0, err);
+	if (root =3D=3D NULL) {
+		errno =3D EINVAL;
+		return NULL;
+	}
+
+	root =3D json_object_get(root, tag);
+	if (root =3D=3D NULL) {
+		errno =3D EINVAL;
+		return NULL;
+	}
+
+	return root;
+}
 #endif
diff --git a/src/table.c b/src/table.c
index 1f4fe76..526f3e7 100644
--- a/src/table.c
+++ b/src/table.c
@@ -290,17 +290,9 @@ static int nft_table_json_parse(struct nft_table *=
t, char *json)
 	const char *str;
 	int family;
=20
-	root =3D json_loadb(json, strlen(json), 0, &error);
-	if (!root) {
-		errno =3D EINVAL;
-		goto err;
-	}
-
-	root =3D json_object_get(root, "table");
-	if (root =3D=3D NULL) {
-		errno =3D EINVAL;
-		goto err;
-	}
+	root =3D nft_jansson_get_root(json, "table", &error);
+	if (root =3D=3D NULL)
+		return -1;
=20
 	str =3D nft_jansson_value_parse_str(root, "name");
 	if (str =3D=3D NULL)

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
