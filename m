From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2001/11=5D=20netfilter=3A=20nf=5Ftables=3A=20rename=20pid=20variables=20to=20portid?=
Date: Wed, 12 Dec 2012 19:47:31 +0100
Message-ID: <1355338061-5517-2-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63168 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2LLSrr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:47 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Use consistent naming for portids.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 59 ++++++++++++++++++++++-------------=
--------
 1 Datei ge=C3=A4ndert, 30 Zeilen hinzugef=C3=BCgt(+), 29 Zeilen entfer=
nt(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 2253593..70ca084 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -156,7 +156,7 @@ static const struct nla_policy nft_table_policy[NFT=
A_TABLE_MAX + 1] =3D {
 	[NFTA_TABLE_FLAGS]	=3D { .type =3D NLA_U32 },
 };
=20
-static int nf_tables_fill_table_info(struct sk_buff *skb, u32 pid, u32=
 seq,
+static int nf_tables_fill_table_info(struct sk_buff *skb, u32 portid, =
u32 seq,
 				     int event, int family,
 				     const struct nft_table *table)
 {
@@ -164,10 +164,10 @@ static int nf_tables_fill_table_info(struct sk_bu=
ff *skb, u32 pid, u32 seq,
 	struct nfgenmsg *nfmsg;
=20
 	event |=3D NFNL_SUBSYS_NFTABLES << 8;
-	nlh =3D nlmsg_put(skb, pid, seq, event, sizeof(struct nfgenmsg), 0);
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), 0=
);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
-	nlh->nlmsg_flags	=3D pid ? NLM_F_MULTI : 0;
+	nlh->nlmsg_flags	=3D portid ? NLM_F_MULTI : 0;
=20
 	nfmsg =3D nlmsg_data(nlh);
 	nfmsg->nfgen_family	=3D family;
@@ -191,7 +191,7 @@ static int nf_tables_table_notify(const struct sk_b=
uff *oskb,
 				  int event, int family)
 {
 	struct sk_buff *skb;
-	u32 pid =3D oskb ? NETLINK_CB(oskb).portid : 0;
+	u32 portid =3D oskb ? NETLINK_CB(oskb).portid : 0;
 	u32 seq =3D nlh ? nlh->nlmsg_seq : 0;
 	struct net *net =3D oskb ? sock_net(oskb->sk) : &init_net;
 	bool report;
@@ -206,17 +206,17 @@ static int nf_tables_table_notify(const struct sk=
_buff *oskb,
 	if (skb =3D=3D NULL)
 		goto err;
=20
-	err =3D nf_tables_fill_table_info(skb, pid, seq, event, family, table=
);
+	err =3D nf_tables_fill_table_info(skb, portid, seq, event, family, ta=
ble);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
 	}
=20
-	err =3D nfnetlink_send(skb, net, pid, NFNLGRP_NFTABLES, report,
+	err =3D nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
 			     GFP_KERNEL);
 err:
 	if (err < 0)
-		nfnetlink_set_err(net, pid, NFNLGRP_NFTABLES, err);
+		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
 	return err;
 }
=20
@@ -507,7 +507,7 @@ static const struct nla_policy nft_hook_policy[NFTA=
_HOOK_MAX + 1] =3D {
 	[NFTA_HOOK_PRIORITY]	=3D { .type =3D NLA_U32 },
 };
=20
-static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 pid, u32=
 seq,
+static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 portid, =
u32 seq,
 				     int event, int family,
 				     const struct nft_table *table,
 				     const struct nft_chain *chain)
@@ -516,10 +516,10 @@ static int nf_tables_fill_chain_info(struct sk_bu=
ff *skb, u32 pid, u32 seq,
 	struct nfgenmsg *nfmsg;
=20
 	event |=3D NFNL_SUBSYS_NFTABLES << 8;
-	nlh =3D nlmsg_put(skb, pid, seq, event, sizeof(struct nfgenmsg), 0);
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), 0=
);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
-	nlh->nlmsg_flags	=3D pid ? NLM_F_MULTI : 0;
+	nlh->nlmsg_flags	=3D portid ? NLM_F_MULTI : 0;
=20
 	nfmsg =3D nlmsg_data(nlh);
 	nfmsg->nfgen_family	=3D family;
@@ -567,7 +567,7 @@ static int nf_tables_chain_notify(const struct sk_b=
uff *oskb,
 				  int event, int family)
 {
 	struct sk_buff *skb;
-	u32 pid =3D oskb ? NETLINK_CB(oskb).portid : 0;
+	u32 portid =3D oskb ? NETLINK_CB(oskb).portid : 0;
 	u32 seq =3D nlh ? nlh->nlmsg_seq : 0;
 	struct net *net =3D oskb ? sock_net(oskb->sk) : &init_net;
 	bool report;
@@ -582,18 +582,18 @@ static int nf_tables_chain_notify(const struct sk=
_buff *oskb,
 	if (skb =3D=3D NULL)
 		goto err;
=20
-	err =3D nf_tables_fill_chain_info(skb, pid, seq, event, family, table=
,
+	err =3D nf_tables_fill_chain_info(skb, portid, seq, event, family, ta=
ble,
 					chain);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
 	}
=20
-	err =3D nfnetlink_send(skb, net, pid, NFNLGRP_NFTABLES, report,
+	err =3D nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
 			     GFP_KERNEL);
 err:
 	if (err < 0)
-		nfnetlink_set_err(net, pid, NFNLGRP_NFTABLES, err);
+		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
 	return err;
 }
=20
@@ -1130,7 +1130,7 @@ static const struct nla_policy nft_rule_policy[NF=
TA_RULE_MAX + 1] =3D {
 	[NFTA_RULE_EXPRESSIONS]	=3D { .type =3D NLA_NESTED },
 };
=20
-static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 pid, u32 =
seq,
+static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u=
32 seq,
 				    int event, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
@@ -1142,10 +1142,10 @@ static int nf_tables_fill_rule_info(struct sk_b=
uff *skb, u32 pid, u32 seq,
 	struct nlattr *list;
=20
 	event |=3D NFNL_SUBSYS_NFTABLES << 8;
-	nlh =3D nlmsg_put(skb, pid, seq, event, sizeof(struct nfgenmsg), 0);
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), 0=
);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
-	nlh->nlmsg_flags	=3D pid ? NLM_F_MULTI : 0;
+	nlh->nlmsg_flags	=3D portid ? NLM_F_MULTI : 0;
=20
 	nfmsg =3D nlmsg_data(nlh);
 	nfmsg->nfgen_family	=3D family;
@@ -1187,7 +1187,7 @@ static int nf_tables_rule_notify(const struct sk_=
buff *oskb,
 				 int event, int family)
 {
 	struct sk_buff *skb;
-	u32 pid =3D NETLINK_CB(oskb).portid;
+	u32 portid =3D NETLINK_CB(oskb).portid;
 	u32 seq =3D nlh->nlmsg_seq;
 	struct net *net =3D sock_net(oskb->sk);
 	bool report;
@@ -1202,18 +1202,18 @@ static int nf_tables_rule_notify(const struct s=
k_buff *oskb,
 	if (skb =3D=3D NULL)
 		goto err;
=20
-	err =3D nf_tables_fill_rule_info(skb, pid, seq, event,
+	err =3D nf_tables_fill_rule_info(skb, portid, seq, event,
 				       family, table, chain, rule);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
 	}
=20
-	err =3D nfnetlink_send(skb, net, pid, NFNLGRP_NFTABLES, report,
+	err =3D nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
 			     GFP_KERNEL);
 err:
 	if (err < 0)
-		nfnetlink_set_err(net, pid, NFNLGRP_NFTABLES, err);
+		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
 	return err;
 }
=20
@@ -1643,11 +1643,12 @@ static int nf_tables_fill_set(struct sk_buff *s=
kb, const struct nft_ctx *ctx,
 {
 	struct nfgenmsg *nfmsg;
 	struct nlmsghdr *nlh;
-	u32 pid =3D NETLINK_CB(ctx->skb).portid;
+	u32 portid =3D NETLINK_CB(ctx->skb).portid;
 	u32 seq =3D ctx->nlh->nlmsg_seq;
=20
 	event |=3D NFNL_SUBSYS_NFTABLES << 8;
-	nlh =3D nlmsg_put(skb, pid, seq, event, sizeof(struct nfgenmsg), flag=
s);
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
+			flags);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
=20
@@ -1687,7 +1688,7 @@ static int nf_tables_set_notify(const struct nft_=
ctx *ctx,
 				int event)
 {
 	struct sk_buff *skb;
-	u32 pid =3D NETLINK_CB(ctx->skb).portid;
+	u32 portid =3D NETLINK_CB(ctx->skb).portid;
 	struct net *net =3D sock_net(ctx->skb->sk);
 	bool report;
 	int err;
@@ -1707,11 +1708,11 @@ static int nf_tables_set_notify(const struct nf=
t_ctx *ctx,
 		goto err;
 	}
=20
-	err =3D nfnetlink_send(skb, net, pid, NFNLGRP_NFTABLES, report,
+	err =3D nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
 			     GFP_KERNEL);
 err:
 	if (err < 0)
-		nfnetlink_set_err(net, pid, NFNLGRP_NFTABLES, err);
+		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
 	return err;
 }
=20
@@ -2113,7 +2114,7 @@ static int nf_tables_dump_set(struct sk_buff *skb=
, struct netlink_callback *cb)
 	struct nfgenmsg *nfmsg;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
-	u32 pid, seq;
+	u32 portid, seq;
 	int event, err;
=20
 	nfmsg =3D nlmsg_data(cb->nlh);
@@ -2132,10 +2133,10 @@ static int nf_tables_dump_set(struct sk_buff *s=
kb, struct netlink_callback *cb)
=20
 	event  =3D NFT_MSG_NEWSETELEM;
 	event |=3D NFNL_SUBSYS_NFTABLES << 8;
-	pid    =3D NETLINK_CB(cb->skb).portid;
+	portid =3D NETLINK_CB(cb->skb).portid;
 	seq    =3D cb->nlh->nlmsg_seq;
=20
-	nlh =3D nlmsg_put(skb, pid, seq, event, sizeof(struct nfgenmsg),
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
 			NLM_F_MULTI);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
