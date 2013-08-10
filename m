From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] src: expr: use the function base2str in
 payload.
Date: Sat, 10 Aug 2013 21:40:39 +0200
Message-ID: <20130810194039.18629.89549.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42425 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3HJTks (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Aug 2013 15:40:48 -0400
Received: by mail-wg0-f48.google.com with SMTP id f12so4334525wgh.3
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Aug 2013 12:40:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Use base2str to refactor code in the function snprintf in payload.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/payload.c |   80 ++++++++++++++++----------------------------=
--------
 1 file changed, 24 insertions(+), 56 deletions(-)

diff --git a/src/expr/payload.c b/src/expr/payload.c
index d00988a..340a0d8 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -149,31 +149,31 @@ nft_rule_expr_payload_parse(struct nft_rule_expr =
*e, struct nlattr *attr)
 	return 0;
 }
=20
+static char *base2str_array[NFT_PAYLOAD_TRANSPORT_HEADER+1] =3D {
+	[NFT_PAYLOAD_LL_HEADER]		=3D "link",
+	[NFT_PAYLOAD_NETWORK_HEADER] 	=3D "network",
+	[NFT_PAYLOAD_TRANSPORT_HEADER]	=3D "transport",
+};
+
+static const char *base2str(enum nft_payload_bases base)
+{
+	if (base > NFT_PAYLOAD_TRANSPORT_HEADER)
+		return "unknown";
+
+	return base2str_array[base];
+}
+
 static int
 nft_rule_expr_payload_snprintf_json(char *buf, size_t len, uint32_t fl=
ags,
 				   struct nft_expr_payload *p)
 {
 	int size =3D len, offset =3D 0, ret;
=20
-	ret =3D snprintf(buf, len, "\"dreg\" : %u, \"offset\" : %u, \"len\" :=
 %u, ",
-					p->dreg, p->offset, p->len);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	switch (p->base) {
-	case NFT_PAYLOAD_LL_HEADER:
-		ret =3D snprintf(buf+offset, len, "\"base\" : \"link\"");
-		break;
-	case NFT_PAYLOAD_NETWORK_HEADER:
-		ret =3D snprintf(buf+offset, len, "\"base\" : \"network\"");
-		break;
-	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		ret =3D snprintf(buf+offset, len, "\"base\" : \"transport\"");
-		break;
-	default:
-		ret =3D snprintf(buf+offset, len, "\"base\" : \"unknown\"");
-		break;
-	}
-
+	ret =3D snprintf(buf, len, "\"dreg\" : %u, "
+				 "\"offset\" : %u, "
+				 "\"len\" : %u, "
+				 "\"base\" : \"%s\"",
+		       p->dreg, p->offset, p->len, base2str(p->base));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return offset;
@@ -243,48 +243,16 @@ nft_rule_expr_payload_snprintf_xml(char *buf, siz=
e_t len, uint32_t flags,
 {
 	int size =3D len, offset =3D 0, ret;
=20
-	ret =3D snprintf(buf, len, "<dreg>%u</dreg><offset>%u</offset>"
-		       "<len>%u</len>", p->dreg, p->offset, p->len);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	/* A default option is not provided.
-	 * The <base> node will be missing; Is not mandatory.
-	 */
-
-	switch (p->base) {
-	case NFT_PAYLOAD_LL_HEADER:
-		ret =3D snprintf(buf+offset, len, "<base>link</base>");
-		break;
-	case NFT_PAYLOAD_NETWORK_HEADER:
-		ret =3D snprintf(buf+offset, len, "<base>network</base>");
-		break;
-	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		ret =3D snprintf(buf+offset, len, "<base>transport</base>");
-		break;
-	default:
-		ret =3D snprintf(buf+offset, len, "<base>unknown</base>");
-		break;
-	}
-
+	ret =3D snprintf(buf, len, "<dreg>%u</dreg>"
+				 "<offset>%u</offset>"
+				 "<len>%u</len>"
+				 "<base>%s</base>",
+		       p->dreg, p->offset, p->len, base2str(p->base));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return offset;
 }
=20
-static char *base2str_array[NFT_PAYLOAD_TRANSPORT_HEADER+1] =3D {
-	[NFT_PAYLOAD_LL_HEADER]		=3D "link",
-	[NFT_PAYLOAD_NETWORK_HEADER] 	=3D "network",
-	[NFT_PAYLOAD_TRANSPORT_HEADER]	=3D "transport",
-};
-
-static const char *base2str(enum nft_payload_bases base)
-{
-	if (base > NFT_PAYLOAD_TRANSPORT_HEADER)
-		return "unknown";
-
-	return base2str_array[base];
-}
-
 static int
 nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
