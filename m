From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/4] tests: remove unnecessary variable
 initialization
Date: Tue, 27 Aug 2013 20:10:37 +0200
Message-ID: <20130827181037.9399.30579.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64353 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3H0SLC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:11:02 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so4340697wes.33
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2013 11:11:01 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/nft-parsing-test.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index bf5b519..648ed36 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -155,12 +155,12 @@ static int test_json(const char *filename)
 {
 #ifdef JSON_PARSING
 	int ret =3D -1;
-	struct nft_table *t =3D NULL;
-	struct nft_chain *c =3D NULL;
-	struct nft_rule *r =3D NULL;
+	struct nft_table *t;
+	struct nft_chain *c;
+	struct nft_rule *r;
 	json_t *root;
 	json_error_t error;
-	char *json =3D NULL;
+	char *json;
=20
 	root =3D json_load_file(filename, 0, &error);
 	if (!root) {
@@ -222,13 +222,13 @@ static int test_xml(const char *filename)
 {
 #ifdef XML_PARSING
 	int ret =3D -1;
-	struct nft_table *t =3D NULL;
-	struct nft_chain *c =3D NULL;
-	struct nft_rule *r =3D NULL;
-	struct nft_set *s =3D NULL;
+	struct nft_table *t;
+	struct nft_chain *c;
+	struct nft_rule *r;
+	struct nft_set *s;
 	FILE *fp;
-	mxml_node_t *tree =3D NULL;;
-	char *xml =3D NULL;
+	mxml_node_t *tree;
+	char *xml;
=20
 	fp =3D fopen(filename, "r");
 	tree =3D mxmlLoadFile(NULL, fp, MXML_NO_CALLBACK);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
