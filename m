From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] Add code for testing the new functions for
 exporting rules to JSON Format
Date: Thu, 27 Jun 2013 21:56:26 +0200
Message-ID: <20130627195626.13980.61479.stgit@Ph0enix>
References: <20130627194837.13980.68301.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36374 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3F0T4a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:56:30 -0400
Received: by mail-wi0-f170.google.com with SMTP id ey16so998805wid.1
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 12:56:28 -0700 (PDT)
In-Reply-To: <20130627194837.13980.68301.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-rule-get.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 5bf41f5..2404f27 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -54,8 +54,11 @@ int main(int argc, char *argv[])
 	struct nft_rule *t =3D NULL;
 	int ret;
=20
-	if (argc =3D=3D 2 && strcmp(argv[1], "xml") =3D=3D 0 )
+	if (argc =3D=3D 2 && strcmp(argv[1], "xml") =3D=3D 0 ){
 		type =3D NFT_RULE_O_XML;
+	}else if (argc =3D=3D 2 && strcmp(argv[1], "json") =3D=3D 0 ){
+		type =3D NFT_RULE_O_JSON;
+	}
=20
 	/* XXX requires table, chain and handle attributes for selective get =
*/
=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
