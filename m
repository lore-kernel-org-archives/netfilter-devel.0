From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 11/13] expr: payload: add nft_str2base function
Date: Fri, 09 Aug 2013 13:14:16 +0200
Message-ID: <20130809111415.29819.19869.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62670 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILO1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:14:27 -0400
Received: by mail-wi0-f179.google.com with SMTP id hr7so1513625wib.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:14:26 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add function that will be use in the JSON parser

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/payload.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/src/expr/payload.c b/src/expr/payload.c
index 34aee90..e32ae1b 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -13,6 +13,7 @@
=20
 #include <stdio.h>
 #include <stdint.h>
+#include <string.h>
 #include <limits.h>
 #include <arpa/inet.h>
 #include <errno.h>
@@ -178,13 +179,27 @@ nft_rule_expr_payload_snprintf_json(char *buf, si=
ze_t len, uint32_t flags,
 	return offset;
 }
=20
+static inline int nft_str2base(const char *base)
+{
+	if (strcmp(base, "link") =3D=3D 0)
+		return NFT_PAYLOAD_LL_HEADER;
+	else if (strcmp(base, "network") =3D=3D 0)
+		return NFT_PAYLOAD_NETWORK_HEADER;
+	else if (strcmp(base, "transport") =3D=3D 0)
+		return NFT_PAYLOAD_TRANSPORT_HEADER;
+	else {
+		errno =3D EINVAL;
+		return -1;
+	}
+}
+
 static int
 nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *=
tree)
 {
 #ifdef XML_PARSING
 	struct nft_expr_payload *payload =3D nft_expr_data(e);
 	const char *base_str;
-	int32_t reg;
+	int32_t reg, base;
=20
 	reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
 	if (reg < 0)
@@ -197,14 +212,10 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_e=
xpr *e, mxml_node_t *tree)
 	if (base_str =3D=3D NULL)
 		return -1;
=20
-	if (strcmp(base_str, "link") =3D=3D 0)
-		payload->base =3D NFT_PAYLOAD_LL_HEADER;
-	else if (strcmp(base_str, "network") =3D=3D 0)
-		payload->base =3D NFT_PAYLOAD_NETWORK_HEADER;
-	else if (strcmp(base_str, "transport") =3D=3D 0)
-		payload->base =3D NFT_PAYLOAD_TRANSPORT_HEADER;
-	else
-		goto err;
+	base =3D nft_str2base(base_str);
+
+	if (base < 0)
+		return -1;
=20
 	e->flags |=3D (1 << NFT_EXPR_PAYLOAD_BASE);
=20
@@ -220,9 +231,6 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_exp=
r *e, mxml_node_t *tree)
=20
 	e->flags |=3D (1 << NFT_EXPR_PAYLOAD_LEN);
 	return 0;
-err:
-	errno =3D EINVAL;
-	return -1;
 #else
 	errno =3D EOPNOTSUPP;
 	return -1;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
