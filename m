From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] Add code for testing the new functions for
 exporting rules to JSON Format
Date: Thu, 13 Jun 2013 20:50:30 +0200
Message-ID: <20130613185030.423.58859.stgit@Ph0enix>
References: <20130613184810.423.11555.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43477 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759106Ab3FMSud (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:50:33 -0400
Received: by mail-wg0-f43.google.com with SMTP id z11so893913wgg.10
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2013 11:50:32 -0700 (PDT)
Received: from [127.0.1.1] (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id k10sm33305640wia.4.2013.06.13.11.50.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 13 Jun 2013 11:50:31 -0700 (PDT)
In-Reply-To: <20130613184810.423.11555.stgit@Ph0enix>
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
