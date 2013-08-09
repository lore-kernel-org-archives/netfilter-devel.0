From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 08/13] expr: bytecode: add nft_str2ntoh function
Date: Fri, 09 Aug 2013 13:13:31 +0200
Message-ID: <20130809111331.29819.861.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36475 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILNk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:13:40 -0400
Received: by mail-wg0-f43.google.com with SMTP id z12so3399613wgg.34
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:13:39 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add function that will be use in the JSON parser

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/byteorder.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 79ba439..c6c4b91 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -181,13 +181,25 @@ static char *expr_byteorder_str[] =3D {
 	[NFT_BYTEORDER_NTOH] =3D "ntoh",
 };
=20
+static inline int nft_str2ntoh(const char *op)
+{
+	if (strcmp(op, "ntoh") =3D=3D 0)
+		return NFT_BYTEORDER_NTOH;
+	else if (strcmp(op, "hton") =3D=3D 0)
+		return NFT_BYTEORDER_HTON;
+	else {
+		errno =3D EINVAL;
+		return -1;
+	}
+}
+
 static int
 nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t=
 *tree)
 {
 #ifdef XML_PARSING
 	struct nft_expr_byteorder *byteorder =3D nft_expr_data(e);
 	const char *op;
-	int32_t reg;
+	int32_t reg, ntoh;
=20
 	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
 	if (reg < 0)
@@ -207,15 +219,12 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule=
_expr *e, mxml_node_t *tree)
 	if (op =3D=3D NULL)
 		return -1;
=20
-	if (strcmp(op, "ntoh") =3D=3D 0)
-		byteorder->op =3D NFT_BYTEORDER_NTOH;
-	else if (strcmp(op, "hton") =3D=3D 0)
-		byteorder->op =3D NFT_BYTEORDER_HTON;
-	else {
-		errno =3D EINVAL;
+	ntoh =3D nft_str2ntoh(op);
+
+	if (ntoh < 0)
 		return -1;
-	}
=20
+	byteorder->op =3D ntoh;
 	e->flags |=3D (1 << NFT_EXPR_BYTEORDER_OP);
=20
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
