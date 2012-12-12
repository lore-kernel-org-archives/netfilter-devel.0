From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2011/11=5D=20netfilter=3A=20nf=5Ftables=3A=20include=20NLM=5FF=5FAPPEND/NLM=5FF=5FREPLACE=20flags=20in=20rule=20notification?=
Date: Wed, 12 Dec 2012 19:47:41 +0100
Message-ID: <1355338061-5517-12-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2LLSrx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:53 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Since the ruleset is ordered, userspace needs to know about NLM_F_APPEN=
D to
properly interpret a NEWRULE message. In case of replacement we usually=
 don't
send a DELX+NEWX message but a NEWX message with the NLM_F_REPLACE flag=
=2E

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++-----------
 1 Datei ge=C3=A4ndert, 10 Zeilen hinzugef=C3=BCgt(+), 11 Zeilen entfer=
nt(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index bbd463e..c4e4baa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1126,7 +1126,7 @@ static const struct nla_policy nft_rule_policy[NF=
TA_RULE_MAX + 1] =3D {
 };
=20
 static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u=
32 seq,
-				    int event, int family,
+				    int event, u32 flags, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
 				    const struct nft_rule *rule)
@@ -1137,7 +1137,8 @@ static int nf_tables_fill_rule_info(struct sk_buf=
f *skb, u32 portid, u32 seq,
 	struct nlattr *list;
=20
 	event |=3D NFNL_SUBSYS_NFTABLES << 8;
-	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), 0=
);
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
+			flags);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
 	nlh->nlmsg_flags	=3D portid ? NLM_F_MULTI : 0;
@@ -1179,7 +1180,7 @@ static int nf_tables_rule_notify(const struct sk_=
buff *oskb,
 				 const struct nft_table *table,
 				 const struct nft_chain *chain,
 				 const struct nft_rule *rule,
-				 int event, int family)
+				 int event, u32 flags, int family)
 {
 	struct sk_buff *skb;
 	u32 portid =3D NETLINK_CB(oskb).portid;
@@ -1197,7 +1198,7 @@ static int nf_tables_rule_notify(const struct sk_=
buff *oskb,
 	if (skb =3D=3D NULL)
 		goto err;
=20
-	err =3D nf_tables_fill_rule_info(skb, portid, seq, event,
+	err =3D nf_tables_fill_rule_info(skb, portid, seq, event, flags,
 				       family, table, chain, rule);
 	if (err < 0) {
 		kfree_skb(skb);
@@ -1237,7 +1238,7 @@ static int nf_tables_dump_rules(struct sk_buff *s=
kb,
 						       sizeof(cb->args) - sizeof(cb->args[0]));
 					if (nf_tables_fill_rule_info(skb, NETLINK_CB(cb->skb).portid,
 								      cb->nlh->nlmsg_seq,
-								      NFT_MSG_NEWRULE,
+								      NFT_MSG_NEWRULE, 0,
 								      afi->family, table, chain, rule) < 0)
 						goto done;
 cont:
@@ -1292,7 +1293,7 @@ static int nf_tables_getrule(struct sock *nlsk, s=
truct sk_buff *skb,
 		return -ENOMEM;
=20
 	err =3D nf_tables_fill_rule_info(skb2, NETLINK_CB(skb).portid,
-				       nlh->nlmsg_seq, NFT_MSG_NEWRULE,
+				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule);
 	if (err < 0)
 		goto err;
@@ -1415,9 +1416,6 @@ static int nf_tables_newrule(struct sock *nlsk, s=
truct sk_buff *skb,
=20
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
 		list_replace_rcu(&old_rule->list, &rule->list);
-
-		nf_tables_rule_notify(skb, nlh, table, chain, old_rule,
-				      NFT_MSG_DELRULE, nfmsg->nfgen_family);
 		nf_tables_rule_destroy(old_rule);
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		list_add_tail_rcu(&rule->list, &chain->rules);
@@ -1425,6 +1423,7 @@ static int nf_tables_newrule(struct sock *nlsk, s=
truct sk_buff *skb,
 		list_add_rcu(&rule->list, &chain->rules);
=20
 	nf_tables_rule_notify(skb, nlh, table, chain, rule, NFT_MSG_NEWRULE,
+			      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
 			      nfmsg->nfgen_family);
 	return 0;
=20
@@ -1470,7 +1469,7 @@ static int nf_tables_delrule(struct sock *nlsk, s=
truct sk_buff *skb,
 		list_del_rcu(&rule->list);
=20
 		nf_tables_rule_notify(skb, nlh, table, chain, rule,
-				      NFT_MSG_DELRULE, family);
+				      NFT_MSG_DELRULE, 0, family);
 		nf_tables_rule_destroy(rule);
 	} else {
 		/* Remove all rules in this chain */
@@ -1478,7 +1477,7 @@ static int nf_tables_delrule(struct sock *nlsk, s=
truct sk_buff *skb,
 			list_del_rcu(&rule->list);
=20
 			nf_tables_rule_notify(skb, nlh, table, chain, rule,
-					      NFT_MSG_DELRULE, family);
+					      NFT_MSG_DELRULE, 0, family);
 			nf_tables_rule_destroy(rule);
 		}
 	}
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
