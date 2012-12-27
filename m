From: kaber@trash.net
Subject: =?a?q?=5BPATCH=202/3=5D=20netfilter=3A=20nf=5Ftables=3A=20include=20NLM=5FF=5FAPPEND=20in=20rule=20dumps?=
Date: Thu, 27 Dec 2012 07:43:27 +0100
Message-ID: <1356590608-25829-3-git-send-email-kaber@trash.net>
References: <1356590608-25829-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59080 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2L0Gnj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:43:39 -0500
In-Reply-To: <1356590608-25829-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Since the rule database is ordered, include NLM_F_APPEND in rule dumps.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 Datei ge=C3=A4ndert, 2 Zeilen hinzugef=C3=BCgt(+), 1 Zeile entfernt(=
-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 27f7155..801ead5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1236,7 +1236,8 @@ static int nf_tables_dump_rules(struct sk_buff *s=
kb,
 						       sizeof(cb->args) - sizeof(cb->args[0]));
 					if (nf_tables_fill_rule_info(skb, NETLINK_CB(cb->skb).portid,
 								      cb->nlh->nlmsg_seq,
-								      NFT_MSG_NEWRULE, NLM_F_MULTI,
+								      NFT_MSG_NEWRULE,
+								      NLM_F_MULTI | NLM_F_APPEND,
 								      afi->family, table, chain, rule) < 0)
 						goto done;
 cont:
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
