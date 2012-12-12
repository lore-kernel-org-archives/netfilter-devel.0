From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2003/11=5D=20netfilter=3A=20nf=5Ftables=3A=20move=20hgenerator=20from=20chain=20to=20table?=
Date: Wed, 12 Dec 2012 19:47:33 +0100
Message-ID: <1355338061-5517-4-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63171 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab2LLSrs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:48 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

With 48 bits rule handles, there's no risk of overflowing even when the
handles are unique per table and not per chain. Save a few bytes in the
chain structure and move the hgenerator to the table.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h | 4 ++--
 net/netfilter/nf_tables_api.c     | 8 ++++----
 2 Dateien ge=C3=A4ndert, 6 Zeilen hinzugef=C3=BCgt(+), 6 Zeilen entfer=
nt(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/=
nf_tables.h
index 99c500f..86fd951 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -349,7 +349,6 @@ enum nft_chain_flags {
  *	@flags: bitmask of enum nft_chain_flags
  *	@use: number of jump references to this chain
  *	@level: length of longest path to this chain
- *	@hgenerator: handle generator state
  *	@name: name of the chain
  */
 struct nft_chain {
@@ -359,7 +358,6 @@ struct nft_chain {
 	u8				policy;
 	u16				use;
 	u16				level;
-	u64				hgenerator;
 	char				name[NFT_CHAIN_MAXNAMELEN];
 };
=20
@@ -400,12 +398,14 @@ extern unsigned int nft_do_chain(const struct nf_=
hook_ops *ops,
  *	@chains: chains in the table
  *	@sets: sets in the table
  *	@flags: table flag (see enum nft_table_flags)
+ *	@hgenerator: handle generator state
  *	@name: name of the table
  */
 struct nft_table {
 	struct list_head		list;
 	struct list_head		chains;
 	struct list_head		sets;
+	u64				hgenerator;
 	u16				flags;
 	char				name[];
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 63d71e7..9768881 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1116,9 +1116,9 @@ static struct nft_rule *nf_tables_rule_lookup(con=
st struct nft_chain *chain,
 	return __nf_tables_rule_lookup(chain, be64_to_cpu(nla_get_be64(nla)))=
;
 }
=20
-static inline u64 nf_tables_rule_alloc_handle(struct nft_chain *chain)
+static inline u64 nf_tables_rule_alloc_handle(struct nft_table *table)
 {
-	return ++chain->hgenerator;
+	return ++table->hgenerator;
 }
=20
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] =3D =
{
@@ -1338,7 +1338,7 @@ static int nf_tables_newrule(struct sock *nlsk, s=
truct sk_buff *skb,
 {
 	const struct nfgenmsg *nfmsg =3D nlmsg_data(nlh);
 	const struct nft_af_info *afi;
-	const struct nft_table *table;
+	struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *old_rule =3D NULL;
 	struct nft_expr_info info[NFT_RULE_MAXEXPRS];
@@ -1383,7 +1383,7 @@ static int nf_tables_newrule(struct sock *nlsk, s=
truct sk_buff *skb,
 				return 0;
 		}
 	} else
-		handle =3D nf_tables_rule_alloc_handle(chain);
+		handle =3D nf_tables_rule_alloc_handle(table);
=20
 	if (handle =3D=3D 0)
 		return -EINVAL;
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
