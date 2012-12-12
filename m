From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2009/11=5D=20netfilter=3A=20nf=5Ftables=3A=20return=20error=20for=20rule=20change=20request?=
Date: Wed, 12 Dec 2012 19:47:39 +0100
Message-ID: <1355338061-5517-10-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2LLSrw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:52 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

We only support full replacement, not change of a rule.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 Datei ge=C3=A4ndert, 1 Zeile hinzugef=C3=BCgt(+), 1 Zeile entfernt(-=
)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index bacd417..c91f638 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1372,7 +1372,7 @@ static int nf_tables_newrule(struct sock *nlsk, s=
truct sk_buff *skb,
 			old_rule =3D rule;
 			rule =3D NULL;
 		} else
-			return 0;
+			return -EOPNOTSUPP;
 	} else {
 		if (!create)
 			return -EINVAL;
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
