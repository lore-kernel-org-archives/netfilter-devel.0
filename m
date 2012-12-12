From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2010/11=5D=20netfilter=3A=20nf=5Ftables=3A=20return=20error=20for=20NLM=5FF=5FREPLACE=20without=20rule=20handle?=
Date: Wed, 12 Dec 2012 19:47:40 +0100
Message-ID: <1355338061-5517-11-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63174 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2LLSrw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:52 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Return an error when NLM_F_REPLACE is given without the handle of the
rule to replace.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 10 +++-------
 1 Datei ge=C3=A4ndert, 3 Zeilen hinzugef=C3=BCgt(+), 7 Zeilen entfernt=
(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index c91f638..bbd463e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1368,13 +1368,12 @@ static int nf_tables_newrule(struct sock *nlsk,=
 struct sk_buff *skb,
=20
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
-		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
+		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			old_rule =3D rule;
-			rule =3D NULL;
-		} else
+		else
 			return -EOPNOTSUPP;
 	} else {
-		if (!create)
+		if (!create || nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EINVAL;
 		handle =3D nf_tables_alloc_handle(table);
 	}
@@ -1415,9 +1414,6 @@ static int nf_tables_newrule(struct sock *nlsk, s=
truct sk_buff *skb,
 	}
=20
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		if (old_rule =3D=3D NULL)
-			goto err2;
-
 		list_replace_rcu(&old_rule->list, &rule->list);
=20
 		nf_tables_rule_notify(skb, nlh, table, chain, old_rule,
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
