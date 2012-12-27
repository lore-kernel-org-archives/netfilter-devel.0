From: kaber@trash.net
Subject: =?a?q?=5BPATCH=201/3=5D=20netfilter=3A=20nf=5Ftables=3A=20fix=20NLM=5FF=5FMULTI=20usage=20in=20netlink=20notifications?=
Date: Thu, 27 Dec 2012 07:43:26 +0100
Message-ID: <1356590608-25829-2-git-send-email-kaber@trash.net>
References: <1356590608-25829-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59079 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2L0Gni (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:43:38 -0500
In-Reply-To: <1356590608-25829-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

All requests contain a portid, but only dumps use multipart messages.
Have the caller pass the requested flags to nf_tables_fill_*_info()
instead of trying to deduce them based on the portid presence.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 28 +++++++++++++---------------
 1 Datei ge=C3=A4ndert, 13 Zeilen hinzugef=C3=BCgt(+), 15 Zeilen entfer=
nt(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index c4e4baa..27f7155 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -162,17 +162,16 @@ static const struct nla_policy nft_table_policy[N=
=46TA_TABLE_MAX + 1] =3D {
 };
=20
 static int nf_tables_fill_table_info(struct sk_buff *skb, u32 portid, =
u32 seq,
-				     int event, int family,
+				     int event, u32 flags, int family,
 				     const struct nft_table *table)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
=20
 	event |=3D NFNL_SUBSYS_NFTABLES << 8;
-	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), 0=
);
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), f=
lags);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
-	nlh->nlmsg_flags	=3D portid ? NLM_F_MULTI : 0;
=20
 	nfmsg =3D nlmsg_data(nlh);
 	nfmsg->nfgen_family	=3D family;
@@ -211,7 +210,8 @@ static int nf_tables_table_notify(const struct sk_b=
uff *oskb,
 	if (skb =3D=3D NULL)
 		goto err;
=20
-	err =3D nf_tables_fill_table_info(skb, portid, seq, event, family, ta=
ble);
+	err =3D nf_tables_fill_table_info(skb, portid, seq, event, 0, family,
+					table);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -247,7 +247,7 @@ static int nf_tables_dump_tables(struct sk_buff *sk=
b,
 			if (nf_tables_fill_table_info(skb,
 						      NETLINK_CB(cb->skb).portid,
 						      cb->nlh->nlmsg_seq,
-						      NFT_MSG_NEWTABLE,
+						      NFT_MSG_NEWTABLE, NLM_F_MULTI,
 						      afi->family, table) < 0)
 				goto done;
 cont:
@@ -290,7 +290,7 @@ static int nf_tables_gettable(struct sock *nlsk, st=
ruct sk_buff *skb,
 		return -ENOMEM;
=20
 	err =3D nf_tables_fill_table_info(skb2, NETLINK_CB(skb).portid,
-					nlh->nlmsg_seq, NFT_MSG_NEWTABLE,
+					nlh->nlmsg_seq, NFT_MSG_NEWTABLE, 0,
 					family, table);
 	if (err < 0)
 		goto err;
@@ -524,7 +524,7 @@ static const struct nla_policy nft_hook_policy[NFTA=
_HOOK_MAX + 1] =3D {
 };
=20
 static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 portid, =
u32 seq,
-				     int event, int family,
+				     int event, u32 flags, int family,
 				     const struct nft_table *table,
 				     const struct nft_chain *chain)
 {
@@ -532,10 +532,9 @@ static int nf_tables_fill_chain_info(struct sk_buf=
f *skb, u32 portid, u32 seq,
 	struct nfgenmsg *nfmsg;
=20
 	event |=3D NFNL_SUBSYS_NFTABLES << 8;
-	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), 0=
);
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), f=
lags);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
-	nlh->nlmsg_flags	=3D portid ? NLM_F_MULTI : 0;
=20
 	nfmsg =3D nlmsg_data(nlh);
 	nfmsg->nfgen_family	=3D family;
@@ -604,8 +603,8 @@ static int nf_tables_chain_notify(const struct sk_b=
uff *oskb,
 	if (skb =3D=3D NULL)
 		goto err;
=20
-	err =3D nf_tables_fill_chain_info(skb, portid, seq, event, family, ta=
ble,
-					chain);
+	err =3D nf_tables_fill_chain_info(skb, portid, seq, event, 0, family,
+					table, chain);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -642,7 +641,7 @@ static int nf_tables_dump_chains(struct sk_buff *sk=
b,
 					       sizeof(cb->args) - sizeof(cb->args[0]));
 				if (nf_tables_fill_chain_info(skb, NETLINK_CB(cb->skb).portid,
 							      cb->nlh->nlmsg_seq,
-							      NFT_MSG_NEWCHAIN,
+							      NFT_MSG_NEWCHAIN, NLM_F_MULTI,
 							      afi->family, table, chain) < 0)
 					goto done;
 cont:
@@ -692,7 +691,7 @@ static int nf_tables_getchain(struct sock *nlsk, st=
ruct sk_buff *skb,
 		return -ENOMEM;
=20
 	err =3D nf_tables_fill_chain_info(skb2, NETLINK_CB(skb).portid,
-					nlh->nlmsg_seq, NFT_MSG_NEWCHAIN,
+					nlh->nlmsg_seq, NFT_MSG_NEWCHAIN, 0,
 					family, table, chain);
 	if (err < 0)
 		goto err;
@@ -1141,7 +1140,6 @@ static int nf_tables_fill_rule_info(struct sk_buf=
f *skb, u32 portid, u32 seq,
 			flags);
 	if (nlh =3D=3D NULL)
 		goto nla_put_failure;
-	nlh->nlmsg_flags	=3D portid ? NLM_F_MULTI : 0;
=20
 	nfmsg =3D nlmsg_data(nlh);
 	nfmsg->nfgen_family	=3D family;
@@ -1238,7 +1236,7 @@ static int nf_tables_dump_rules(struct sk_buff *s=
kb,
 						       sizeof(cb->args) - sizeof(cb->args[0]));
 					if (nf_tables_fill_rule_info(skb, NETLINK_CB(cb->skb).portid,
 								      cb->nlh->nlmsg_seq,
-								      NFT_MSG_NEWRULE, 0,
+								      NFT_MSG_NEWRULE, NLM_F_MULTI,
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
