From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 3/7] table: remove the properties node in Json
 output
Date: Wed, 31 Jul 2013 15:21:06 +0200
Message-ID: <20130731132105.29730.12385.stgit@Ph0enix>
References: <20130731132051.29730.53717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:46217 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3GaNVJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:21:09 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so591026wev.22
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2013 06:21:07 -0700 (PDT)
In-Reply-To: <20130731132051.29730.53717.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

I have removed the properties node from table because it's a node witho=
ut relevant information

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/table.c                   |   12 ++----------
 tests/jsonfiles/01-table.json |    2 +-
 tests/jsonfiles/02-table.json |    2 +-
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/src/table.c b/src/table.c
index 526f3e7..402e8c1 100644
--- a/src/table.c
+++ b/src/table.c
@@ -300,12 +300,6 @@ static int nft_table_json_parse(struct nft_table *=
t, char *json)
=20
 	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, strdup(str));
=20
-	root =3D json_object_get(root, "properties");
-	if (root =3D=3D NULL) {
-		errno =3D EINVAL;
-		goto err;
-	}
-
 	str =3D nft_jansson_value_parse_str(root, "family");
 	if (str =3D=3D NULL)
 		goto err;
@@ -360,10 +354,8 @@ static int nft_table_snprintf_json(char *buf, size=
_t size, struct nft_table *t)
 	return snprintf(buf, size,
 			"{\"table\" : {"
 			"\"name\" : \"%s\","
-			"\"properties\" : {"
-				"\"family\" : \"%s\","
-				"\"table_flags\" : %d"
-				"}"
+			"\"family\" : \"%s\","
+			"\"table_flags\" : %d"
 			"}"
 			"}" ,
 			t->name, nft_family2str(t->family), t->table_flags);
diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.j=
son
index 9afc014..a5ba38b 100644
--- a/tests/jsonfiles/01-table.json
+++ b/tests/jsonfiles/01-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter","properties" : {"family" : "ip","table_f=
lags" : 0}}}
+{"table" : {"name" : "filter","family" : "ip","table_flags" : 0}}
diff --git a/tests/jsonfiles/02-table.json b/tests/jsonfiles/02-table.j=
son
index b66ec52..f1171a1 100644
--- a/tests/jsonfiles/02-table.json
+++ b/tests/jsonfiles/02-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter2","properties" : {"family" : "ip6","table=
_flags" : 0}}}
+{"table" : {"name" : "filter2","family" : "ip6","table_flags" : 0}}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
