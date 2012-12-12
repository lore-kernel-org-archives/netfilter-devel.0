From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2002/11=5D=20netfilter=3A=20nf=5Ftables=3A=20revert=20commit=202a3c360f?=
Date: Wed, 12 Dec 2012 19:47:32 +0100
Message-ID: <1355338061-5517-3-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63169 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2LLSrr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:47 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Commit 2a3c360f (netfilter: nf_tables: Add missing policy for NFTA_CHAI=
N_USE)
added NFTA_CHAIN_USE to the nft_chain_policy. This is useless since the
NFTA_CHAIN_USE attribute is only sent by the kernel, never received.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 Datei ge=C3=A4ndert, 1 Zeile entfernt(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 70ca084..63d71e7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -496,7 +496,6 @@ static const struct nla_policy nft_chain_policy[NFT=
A_CHAIN_MAX + 1] =3D {
 	[NFTA_CHAIN_TABLE]	=3D { .type =3D NLA_STRING },
 	[NFTA_CHAIN_HOOK]	=3D { .type =3D NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	=3D { .type =3D NLA_U32 },
-	[NFTA_CHAIN_USE]	=3D { .type =3D NLA_U32 },
 	[NFTA_CHAIN_NEW_NAME]	=3D { .type =3D NLA_STRING,
 				    .len =3D NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_CHAIN_TYPE]	=3D { .type =3D NLA_NUL_STRING },
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
