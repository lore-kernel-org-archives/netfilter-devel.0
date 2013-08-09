From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 06/13] json: bitwise: add missing node len
Date: Fri, 09 Aug 2013 13:13:00 +0200
Message-ID: <20130809111300.29819.10398.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41174 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:13:09 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj13so1515654wib.11
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:13:08 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

I have added the len node in bitwise which was missing

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/bitwise.c  |    5 +++--
 src/expr/data_reg.c |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index edc5a39..6c86acb 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -238,8 +238,9 @@ nft_rule_expr_bitwise_snprintf_json(char *buf, size=
_t size,
 	int len =3D size, offset =3D 0, ret;
=20
 	ret =3D snprintf(buf, len, "\"sreg\" : %u, "
-				"\"dreg\" : %u, ",
-		       bitwise->sreg, bitwise->dreg);
+				"\"dreg\" : %u, "
+				"\"len\" : %u, ",
+		       bitwise->sreg, bitwise->dreg, bitwise->len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	ret =3D snprintf(buf+offset, len, "\"mask\" : {");
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 825e474..4c354ef 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -250,10 +250,10 @@ nft_data_reg_value_snprintf_json(char *buf, size_=
t size,
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
=20
-		ret =3D snprintf(buf+offset, len, "\"");
+		ret =3D snprintf(buf+offset, len, "\", ");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
-
+	offset -=3D 2;
 	ret =3D snprintf(buf+offset, len, "}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
