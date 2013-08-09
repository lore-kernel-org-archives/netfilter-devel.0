From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 01/13] src: expr: missing commas in json output
 support
Date: Fri, 09 Aug 2013 13:11:48 +0200
Message-ID: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:47644 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967445Ab3HILMA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:12:00 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so2591364wes.12
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:11:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Added missing commas in json output support

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/meta.c |    2 +-
 src/expr/nat.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index ac01732..8f163f6 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -208,7 +208,7 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len, =
uint32_t type,
 				meta->dreg, meta_key2str(meta->key));
 	case NFT_RULE_O_JSON:
 		return snprintf(buf, len, "\"dreg\" : %u, "
-					  "\"key\" : %s",
+					  "\"key\" : \"%s\"",
 				meta->dreg, meta_key2str(meta->key));
 	default:
 		break;
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 4b7ec27..654d4d7 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -262,7 +262,7 @@ nft_rule_expr_nat_snprintf_json(char *buf, size_t s=
ize,
 	if (nat->type =3D=3D NFT_NAT_SNAT)
 		ret =3D snprintf(buf, len, "\"nat_type\" : \"snat\", ");
 	else if (nat->type =3D=3D NFT_NAT_DNAT)
-		ret =3D snprintf(buf, len, "\nat_type\" : \"dnat\", ");
+		ret =3D snprintf(buf, len, "\"nat_type\" : \"dnat\", ");
=20
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
