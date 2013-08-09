From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 07/13] src: json: delete unneeded JSON prefixes
Date: Fri, 09 Aug 2013 13:13:14 +0200
Message-ID: <20130809111314.29819.36371.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38398 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILNZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:13:25 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so3439062wgh.31
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:13:24 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

This patch changes some JSON nodes with prefixes like XML nodes

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/rule.c                    |    2 +-
 src/set_elem.c                |    6 +++---
 src/table.c                   |    4 ++--
 tests/jsonfiles/01-table.json |    2 +-
 tests/jsonfiles/02-table.json |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 41534bd..8a86f54 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -629,7 +629,7 @@ static int nft_rule_snprintf_json(char *buf, size_t=
 size, struct nft_rule *r,
 				(unsigned long long)r->handle);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, "\"rule_flags\" : %u, ",
+	ret =3D snprintf(buf+offset, len, "\"flags\" : %u, ",
 					r->rule_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
diff --git a/src/set_elem.c b/src/set_elem.c
index 73c100f..c3ac1da 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -469,10 +469,10 @@ static int nft_set_elem_snprintf_json(char *buf, =
size_t size,
 {
 	int ret, len =3D size, offset =3D 0, type =3D -1;
=20
-	ret =3D snprintf(buf, size, "\"set_elem_flags\": %u", e->set_elem_fla=
gs);
+	ret =3D snprintf(buf, size, "\"flags\": %u", e->set_elem_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, size, ",\"set_elem_key\": {");
+	ret =3D snprintf(buf+offset, size, ",\"key\": {");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &e->key,
@@ -490,7 +490,7 @@ static int nft_set_elem_snprintf_json(char *buf, si=
ze_t size,
 		type =3D DATA_VERDICT;
=20
 	if (type !=3D -1) {
-		ret =3D snprintf(buf+offset, size, ",\"set_elem_data\": {");
+		ret =3D snprintf(buf+offset, size, ",\"data\": {");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 		ret =3D nft_data_reg_snprintf(buf+offset, len, &e->data,
diff --git a/src/table.c b/src/table.c
index 85993eb..18d9077 100644
--- a/src/table.c
+++ b/src/table.c
@@ -295,7 +295,7 @@ static int nft_table_json_parse(struct nft_table *t=
, char *json)
=20
 	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
=20
-	if (nft_jansson_value_parse_val(root, "table_flags",
+	if (nft_jansson_value_parse_val(root, "flags",
 					NFT_TYPE_U32, &table_flag) =3D=3D -1)
 		goto err;
=20
@@ -340,7 +340,7 @@ static int nft_table_snprintf_json(char *buf, size_=
t size, struct nft_table *t)
 			"{\"table\" : {"
 			"\"name\" : \"%s\","
 			"\"family\" : \"%s\","
-			"\"table_flags\" : %d"
+			"\"flags\" : %d"
 			"}"
 			"}" ,
 			t->name, nft_family2str(t->family), t->table_flags);
diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.j=
son
index a5ba38b..b4fc91b 100644
--- a/tests/jsonfiles/01-table.json
+++ b/tests/jsonfiles/01-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter","family" : "ip","table_flags" : 0}}
+{"table" : {"name" : "filter","family" : "ip","flags" : 0}}
diff --git a/tests/jsonfiles/02-table.json b/tests/jsonfiles/02-table.j=
son
index f1171a1..01eff74 100644
--- a/tests/jsonfiles/02-table.json
+++ b/tests/jsonfiles/02-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter2","family" : "ip6","table_flags" : 0}}
+{"table" : {"name" : "filter2","family" : "ip6","flags" : 0}}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
