From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 13/13] jansson: Add nft_jansson_family function
Date: Fri, 09 Aug 2013 13:14:46 +0200
Message-ID: <20130809111446.29819.79492.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64813 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILO5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:14:57 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj13so1518080wib.5
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:14:56 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Refactor some existing code with the new function nft_jansson_family

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/chain.c    |   10 ++--------
 src/internal.h |    1 +
 src/jansson.c  |   18 ++++++++++++++++++
 src/table.c    |    9 ++-------
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index e2e6f90..a6d99ca 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -517,14 +517,8 @@ static int nft_chain_json_parse(struct nft_chain *=
c, char *json)
=20
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, uval64);
=20
-	valstr =3D nft_jansson_value_parse_str(root, "family");
-
-	if (valstr =3D=3D NULL)
-		goto err;
-
-	val32 =3D nft_str2family(valstr);
-	if (val32 =3D=3D -1)
-		goto err;
+	if (nft_jansson_parse_family(root, &val32) !=3D 0)
+		return -1;
=20
 	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, val32);
=20
diff --git a/src/internal.h b/src/internal.h
index 17d1286..62eb3c5 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -49,6 +49,7 @@ int nft_jansson_value_parse_val(json_t *root, const c=
har *tag,
 const char *nft_jansson_value_parse_str(json_t *root, const char *tag)=
;
 bool nft_jansson_node_exist(json_t *root, const char *tag);
 json_t *nft_jansson_get_root(char *json, const char *tag, json_error_t=
 *err);
+int nft_jansson_parse_family(json_t *root, void *out);
 #endif
=20
 const char *nft_family2str(uint32_t family);
diff --git a/src/jansson.c b/src/jansson.c
index 4c778d9..cc3ab23 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -90,4 +90,22 @@ json_t *nft_jansson_get_root(char *json, const char =
*tag, json_error_t *err)
=20
 	return root;
 }
+int nft_jansson_parse_family(json_t *root, void *out)
+{
+	const char *str;
+	int family;
+
+	str =3D nft_jansson_value_parse_str(root, "family");
+	if (str =3D=3D NULL)
+		return -1;
+
+	family =3D nft_str2family(str);
+	if (family < 0) {
+		errno =3D EINVAL;
+		return -1;
+	}
+
+	memcpy(out, &family, sizeof(family));
+	return 0;
+}
 #endif
diff --git a/src/table.c b/src/table.c
index 18d9077..1fa0dac 100644
--- a/src/table.c
+++ b/src/table.c
@@ -285,13 +285,8 @@ static int nft_table_json_parse(struct nft_table *=
t, char *json)
=20
 	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, strdup(str));
=20
-	str =3D nft_jansson_value_parse_str(root, "family");
-	if (str =3D=3D NULL)
-		goto err;
-
-	family =3D nft_str2family(str);
-	if (family < 0)
-		goto err;
+	if (nft_jansson_parse_family(root, &family) !=3D 0)
+		return -1;
=20
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
