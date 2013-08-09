From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 05/13] expr: ct: optional output in ct
Date: Fri, 09 Aug 2013 13:12:46 +0200
Message-ID: <20130809111246.29819.71948.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42512 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILMz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:12:55 -0400
Received: by mail-wi0-f174.google.com with SMTP id j17so1516172wiw.7
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:12:54 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Display direction and key if available

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/ct.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 99448c6..f86fd4d 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -226,6 +226,30 @@ err:
 }
=20
 static int
+nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr=
 *e)
+{
+	int ret, len =3D size, offset =3D 0;
+	struct nft_expr_ct *ct =3D nft_expr_data(e);
+
+	ret =3D snprintf(buf, size, "\"dreg\" : %u", ct->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
+		ret =3D snprintf(buf+offset, size, ", \"key\" : \"%s\"",
+						ctkey2str(ct->key));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_CT_DIR)) {
+		ret =3D snprintf(buf+offset, size, ", \"dir\" : %u", ct->dir);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+
+}
+
+static int
 nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
 {
@@ -241,10 +265,7 @@ nft_rule_expr_ct_snprintf(char *buf, size_t len, u=
int32_t type,
 					  "<dir>%u</dir>",
 				ct->dreg, ctkey2str(ct->key), ct->dir);
 	case NFT_RULE_O_JSON:
-		return snprintf(buf, len, "\"dreg\" : %u, "
-					  "\"key\" : \"%s\", "
-					  "\"dir\" : %u",
-				ct->dreg, ctkey2str(ct->key), ct->dir);
+		return nft_expr_ct_snprintf_json(buf, len, e);
 	default:
 		break;
 	}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
