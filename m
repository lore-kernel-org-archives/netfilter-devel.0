From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 02/13] src: expr: missing curly braces in json
 output support
Date: Fri, 09 Aug 2013 13:12:05 +0200
Message-ID: <20130809111204.29819.32404.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37318 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967445Ab3HILMP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:12:15 -0400
Received: by mail-wg0-f47.google.com with SMTP id j13so3396840wgh.2
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:12:13 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Added missing curly braces in json output support

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/bitwise.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index f0a2eff..edc5a39 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -242,21 +242,21 @@ nft_rule_expr_bitwise_snprintf_json(char *buf, si=
ze_t size,
 		       bitwise->sreg, bitwise->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, "\"mask\" : ");
+	ret =3D snprintf(buf+offset, len, "\"mask\" : {");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
 				    NFT_RULE_O_JSON, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, ", \"xor\" : ");
+	ret =3D snprintf(buf+offset, len, "}, \"xor\" : {");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
 				    NFT_RULE_O_JSON, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	ret =3D snprintf(buf+offset, len, "\"");
+	ret =3D snprintf(buf+offset, len, "}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	return offset;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
