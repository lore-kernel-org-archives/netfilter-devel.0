From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2004/11=5D=20netfilter=3A=20nf=5Ftables=3A=20move=20policy=20to=20struct=20nft=5Fbase=5Fchain?=
Date: Wed, 12 Dec 2012 19:47:34 +0100
Message-ID: <1355338061-5517-5-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63174 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2LLSrt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:49 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Non-base-chains can not have a policy, so move the policy member
to struct nft_base_chain. Also return an error when trying to add
a policy to a non-base-chain.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nf_tables_api.c     | 26 +++++++++++++++-----------
 net/netfilter/nf_tables_core.c    |  2 +-
 3 Dateien ge=C3=A4ndert, 19 Zeilen hinzugef=C3=BCgt(+), 13 Zeilen entf=
ernt(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/=
nf_tables.h
index 86fd951..d1a8e9e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -355,7 +355,6 @@ struct nft_chain {
 	struct list_head		rules;
 	struct list_head		list;
 	u8				flags;
-	u8				policy;
 	u16				use;
 	u16				level;
 	char				name[NFT_CHAIN_MAXNAMELEN];
@@ -372,11 +371,14 @@ enum nft_chain_type {
  *	struct nft_base_chain - nf_tables base chain
  *
  *	@ops: netfilter hook ops
+ *	@type: chain type
+ *	@policy: default policy
  *	@chain: the chain
  */
 struct nft_base_chain {
 	struct nf_hook_ops		ops;
 	enum nft_chain_type		type;
+	u8				policy;
 	struct nft_chain		chain;
 };
=20
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 9768881..11502db 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -531,8 +531,11 @@ static int nf_tables_fill_chain_info(struct sk_buf=
f *skb, u32 portid, u32 seq,
 		goto nla_put_failure;
=20
 	if (chain->flags & NFT_BASE_CHAIN) {
-		const struct nf_hook_ops *ops =3D &nft_base_chain(chain)->ops;
-		struct nlattr *nest =3D nla_nest_start(skb, NFTA_CHAIN_HOOK);
+		const struct nft_base_chain *basechain =3D nft_base_chain(chain);
+		const struct nf_hook_ops *ops =3D &basechain->ops;
+		struct nlattr *nest;
+
+		nest =3D nla_nest_start(skb, NFTA_CHAIN_HOOK);
 		if (nest =3D=3D NULL)
 			goto nla_put_failure;
 		if (nla_put_be32(skb, NFTA_HOOK_HOOKNUM, htonl(ops->hooknum)))
@@ -541,7 +544,8 @@ static int nf_tables_fill_chain_info(struct sk_buff=
 *skb, u32 portid, u32 seq,
 			goto nla_put_failure;
 		nla_nest_end(skb, nest);
=20
-		if (nla_put_be32(skb, NFTA_CHAIN_POLICY, htonl(chain->policy)))
+		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
+				 htonl(basechain->policy)))
 			goto nla_put_failure;
=20
 		if (nla_put_string(skb, NFTA_CHAIN_TYPE,
@@ -682,7 +686,7 @@ err:
 }
=20
 static int
-nf_tables_chain_policy(struct nft_chain *chain, const struct nlattr *a=
ttr)
+nf_tables_chain_policy(struct nft_base_chain *chain, const struct nlat=
tr *attr)
 {
 	switch (ntohl(nla_get_be32(attr))) {
 	case NF_DROP:
@@ -776,8 +780,10 @@ static int nf_tables_newchain(struct sock *nlsk, s=
truct sk_buff *skb,
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return nf_tables_mvchain(skb, nlh, table, chain, nla);
=20
-		if ((chain->flags & NFT_BASE_CHAIN) && nla[NFTA_CHAIN_POLICY]) {
-			return nf_tables_chain_policy(chain,
+		if (nla[NFTA_CHAIN_POLICY]) {
+			if (!(chain->flags & NFT_BASE_CHAIN))
+				return -EOPNOTSUPP;
+			return nf_tables_chain_policy(nft_base_chain(chain),
 						      nla[NFTA_CHAIN_POLICY]);
 		}
 		return 0;
@@ -830,23 +836,21 @@ static int nf_tables_newchain(struct sock *nlsk, =
struct sk_buff *skb,
 		if (afi->hooks[ops->hooknum])
 			ops->hook =3D afi->hooks[ops->hooknum];
=20
-		chain->policy =3D NF_ACCEPT;
 		chain->flags |=3D NFT_BASE_CHAIN;
=20
 		if (nla[NFTA_CHAIN_POLICY]) {
-			err =3D nf_tables_chain_policy(chain,
+			err =3D nf_tables_chain_policy(basechain,
 						     nla[NFTA_CHAIN_POLICY]);
 			if (err < 0) {
 				kfree(basechain);
 				return err;
 			}
-		}
+		} else
+			basechain->policy =3D NF_ACCEPT;
 	} else {
 		chain =3D kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain =3D=3D NULL)
 			return -ENOMEM;
-
-		chain->policy =3D NF_ACCEPT;
 	}
=20
 	INIT_LIST_HEAD(&chain->rules);
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_c=
ore.c
index 65e5385..a860769 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -136,7 +136,7 @@ next_rule:
 		goto next_rule;
 	}
=20
-	return chain->policy;
+	return nft_base_chain(chain)->policy;
 }
 EXPORT_SYMBOL_GPL(nft_do_chain);
=20
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
