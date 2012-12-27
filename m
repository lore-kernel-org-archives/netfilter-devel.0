From: kaber@trash.net
Subject: =?a?q?=5BPATCH=203/3=5D=20netfilter=3A=20nf=5Ftables=3A=20check=20for=20duplicate=20names=20on=20chain=20rename?=
Date: Thu, 27 Dec 2012 07:43:28 +0100
Message-ID: <1356590608-25829-4-git-send-email-kaber@trash.net>
References: <1356590608-25829-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59083 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2L0Gnk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:43:40 -0500
In-Reply-To: <1356590608-25829-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 12 ++++++++----
 1 Datei ge=C3=A4ndert, 8 Zeilen hinzugef=C3=BCgt(+), 4 Zeilen entfernt=
(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 801ead5..ccb7d07 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -746,13 +746,14 @@ static int nf_tables_newchain(struct sock *nlsk, =
struct sk_buff *skb,
 		return PTR_ERR(table);
=20
 	chain =3D NULL;
+	name =3D nla[NFTA_CHAIN_NAME];
+
 	if (nla[NFTA_CHAIN_HANDLE]) {
 		handle =3D be64_to_cpu(nla_get_be64(nla[NFTA_CHAIN_HANDLE]));
 		chain =3D nf_tables_chain_lookup_byhandle(table, handle);
 		if (IS_ERR(chain))
 			return PTR_ERR(chain);
 	} else {
-		name =3D nla[NFTA_CHAIN_NAME];
 		chain =3D nf_tables_chain_lookup(table, name);
 		if (IS_ERR(chain)) {
 			if (PTR_ERR(chain) !=3D -ENOENT)
@@ -767,6 +768,10 @@ static int nf_tables_newchain(struct sock *nlsk, s=
truct sk_buff *skb,
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
=20
+		if (nla[NFTA_CHAIN_HANDLE] && name &&
+		    !IS_ERR(nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME])))
+			return -EEXIST;
+
 		if (nla[NFTA_CHAIN_POLICY]) {
 			if (!(chain->flags & NFT_BASE_CHAIN))
 				return -EOPNOTSUPP;
@@ -777,9 +782,8 @@ static int nf_tables_newchain(struct sock *nlsk, st=
ruct sk_buff *skb,
 				return err;
 		}
=20
-		if (nla[NFTA_CHAIN_HANDLE] && nla[NFTA_CHAIN_NAME])
-			nla_strlcpy(chain->name, nla[NFTA_CHAIN_NAME],
-				    NFT_CHAIN_MAXNAMELEN);
+		if (nla[NFTA_CHAIN_HANDLE] && name)
+			nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
=20
 		goto notify;
 	}
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
