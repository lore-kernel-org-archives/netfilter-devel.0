From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 09/13] expr: cmp: add nft_str2cmp function
Date: Fri, 09 Aug 2013 13:13:45 +0200
Message-ID: <20130809111345.29819.80871.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46230 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILNz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:13:55 -0400
Received: by mail-wg0-f51.google.com with SMTP id a12so3398572wgh.6
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:13:54 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add function that will be use in the JSON parser

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/cmp.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 291ebcd..8ca4cb5 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -154,12 +154,32 @@ static char *expr_cmp_str[] =3D {
 	[NFT_CMP_GTE]	=3D "gte",
 };
=20
+static inline int nft_str2cmp(const char *op)
+{
+	if (strcmp(op, "eq") =3D=3D 0)
+		return NFT_CMP_EQ;
+	else if (strcmp(op, "neq") =3D=3D 0)
+		return NFT_CMP_NEQ;
+	else if (strcmp(op, "lt") =3D=3D 0)
+		return NFT_CMP_LT;
+	else if (strcmp(op, "lte") =3D=3D 0)
+		return NFT_CMP_LTE;
+	else if (strcmp(op, "gt") =3D=3D 0)
+		return NFT_CMP_GT;
+	else if (strcmp(op, "gte") =3D=3D 0)
+		return NFT_CMP_GTE;
+	else {
+		errno =3D EINVAL;
+		return -1;
+	}
+}
+
 static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree)
 {
 #ifdef XML_PARSING
 	struct nft_expr_cmp *cmp =3D nft_expr_data(e);
 	const char *op;
-	int32_t reg;
+	int32_t reg, op_value;
=20
 	reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
 	if (reg < 0)
@@ -172,21 +192,11 @@ static int nft_rule_expr_cmp_xml_parse(struct nft=
_rule_expr *e, mxml_node_t *tre
 	if (op =3D=3D NULL)
 		return -1;
=20
-	if (strcmp(op, "eq") =3D=3D 0)
-		cmp->op =3D NFT_CMP_EQ;
-	else if (strcmp(op, "neq") =3D=3D 0)
-		cmp->op =3D NFT_CMP_NEQ;
-	else if (strcmp(op, "lt") =3D=3D 0)
-		cmp->op =3D NFT_CMP_LT;
-	else if (strcmp(op, "lte") =3D=3D 0)
-		cmp->op =3D NFT_CMP_LTE;
-	else if (strcmp(op, "gt") =3D=3D 0)
-		cmp->op =3D NFT_CMP_GT;
-	else if (strcmp(op, "gte") =3D=3D 0)
-		cmp->op =3D NFT_CMP_GTE;
-	else
+	op_value =3D nft_str2cmp(op);
+	if (op_value < 0)
 		return -1;
=20
+	cmp->op =3D op_value;
 	e->flags |=3D (1 << NFT_EXPR_CMP_OP);
=20
 	if (nft_mxml_data_reg_parse(tree, "cmpdata",

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
