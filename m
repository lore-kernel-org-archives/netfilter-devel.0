From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2005/11=5D=20netfilter=3A=20nf=5Ftables=3A=20send=20notifications=20for=20base=20chain=20policy=20changes?=
Date: Wed, 12 Dec 2012 19:47:35 +0100
Message-ID: <1355338061-5517-6-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab2LLSrt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:49 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

=46ix missing netlink notification for policy changes.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 10 ++++++----
 1 Datei ge=C3=A4ndert, 6 Zeilen hinzugef=C3=BCgt(+), 4 Zeilen entfernt=
(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 11502db..4b36b0a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -783,10 +783,12 @@ static int nf_tables_newchain(struct sock *nlsk, =
struct sk_buff *skb,
 		if (nla[NFTA_CHAIN_POLICY]) {
 			if (!(chain->flags & NFT_BASE_CHAIN))
 				return -EOPNOTSUPP;
-			return nf_tables_chain_policy(nft_base_chain(chain),
-						      nla[NFTA_CHAIN_POLICY]);
+			err =3D nf_tables_chain_policy(nft_base_chain(chain),
+						     nla[NFTA_CHAIN_POLICY]);
+			if (err < 0)
+				return err;
 		}
-		return 0;
+		goto notify;
 	}
=20
 	if (nla[NFTA_CHAIN_HOOK]) {
@@ -866,7 +868,7 @@ static int nf_tables_newchain(struct sock *nlsk, st=
ruct sk_buff *skb,
 			return err;
 		}
 	}
-
+notify:
 	nf_tables_chain_notify(skb, nlh, table, chain, NFT_MSG_NEWCHAIN,
 			       family);
 	return 0;
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
