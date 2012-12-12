From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=2006/11=5D=20netfilter=3A=20nf=5Ftables=3A=20introduce=20chain=20handles=20and=20fix=20chain=20rename?=
Date: Wed, 12 Dec 2012 19:47:36 +0100
Message-ID: <1355338061-5517-7-git-send-email-kaber@trash.net>
References: <1355338061-5517-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63174 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab2LLSru (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:47:50 -0500
In-Reply-To: <1355338061-5517-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Add a chain handle as an alternative way to identify a chain for rename=
s.
The handle is constant, while the name might change.

Kill the NFTA_CHAIN_NEW_NAME attribute since netlink attributes are
supposed to be symetrical. Also fix netlink notification to not send
a DELCHAIN/NEWCHAIN message for renames but a simple NEWCHAIN with
the old handle and the new name.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter/nf_tables.h |   2 +-
 include/net/netfilter/nf_tables.h   |   2 +
 net/netfilter/nf_tables_api.c       | 100 ++++++++++++++++------------=
--------
 3 Dateien ge=C3=A4ndert, 48 Zeilen hinzugef=C3=BCgt(+), 56 Zeilen entf=
ernt(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfil=
ter/nf_tables.h
index 5a6eefe..7640290 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -75,11 +75,11 @@ enum nft_table_attributes {
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
 	NFTA_CHAIN_TABLE,
+	NFTA_CHAIN_HANDLE,
 	NFTA_CHAIN_NAME,
 	NFTA_CHAIN_HOOK,
 	NFTA_CHAIN_POLICY,
 	NFTA_CHAIN_USE,
-	NFTA_CHAIN_NEW_NAME,
 	NFTA_CHAIN_TYPE,
 	__NFTA_CHAIN_MAX
 };
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/=
nf_tables.h
index d1a8e9e..e7dc1da 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -346,6 +346,7 @@ enum nft_chain_flags {
  *
  *	@rules: list of rules in the chain
  *	@list: used internally
+ *	@handle: chain handle
  *	@flags: bitmask of enum nft_chain_flags
  *	@use: number of jump references to this chain
  *	@level: length of longest path to this chain
@@ -354,6 +355,7 @@ enum nft_chain_flags {
 struct nft_chain {
 	struct list_head		rules;
 	struct list_head		list;
+	u64				handle;
 	u8				flags;
 	u16				use;
 	u16				level;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 4b36b0a..bc4eb76 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -118,6 +118,11 @@ static struct nft_table *nf_tables_table_lookup(co=
nst struct nft_af_info *afi,
 	return ERR_PTR(-ENOENT);
 }
=20
+static inline u64 nf_tables_alloc_handle(struct nft_table *table)
+{
+	return ++table->hgenerator;
+}
+
 static struct nf_chain_type *chain_type[AF_MAX][NFT_CHAIN_T_MAX];
=20
 static int __nf_tables_chain_type_lookup(int family, const struct nlat=
tr *nla)
@@ -474,6 +479,19 @@ EXPORT_SYMBOL_GPL(nft_unregister_chain_type);
  * Chains
  */
=20
+static struct nft_chain *
+nf_tables_chain_lookup_byhandle(const struct nft_table *table, u64 han=
dle)
+{
+	struct nft_chain *chain;
+
+	list_for_each_entry(chain, &table->chains, list) {
+		if (chain->handle =3D=3D handle)
+			return chain;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
 static struct nft_chain *nf_tables_chain_lookup(const struct nft_table=
 *table,
 						const struct nlattr *nla)
 {
@@ -491,13 +509,12 @@ static struct nft_chain *nf_tables_chain_lookup(c=
onst struct nft_table *table,
 }
=20
 static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] =3D=
 {
+	[NFTA_CHAIN_HANDLE]	=3D { .type =3D NLA_U64 },
 	[NFTA_CHAIN_NAME]	=3D { .type =3D NLA_STRING,
 				    .len =3D NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_CHAIN_TABLE]	=3D { .type =3D NLA_STRING },
 	[NFTA_CHAIN_HOOK]	=3D { .type =3D NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	=3D { .type =3D NLA_U32 },
-	[NFTA_CHAIN_NEW_NAME]	=3D { .type =3D NLA_STRING,
-				    .len =3D NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_CHAIN_TYPE]	=3D { .type =3D NLA_NUL_STRING },
 };
=20
@@ -527,6 +544,8 @@ static int nf_tables_fill_chain_info(struct sk_buff=
 *skb, u32 portid, u32 seq,
=20
 	if (nla_put_string(skb, NFTA_CHAIN_TABLE, table->name))
 		goto nla_put_failure;
+	if (nla_put_be64(skb, NFTA_CHAIN_HANDLE, cpu_to_be64(chain->handle)))
+		goto nla_put_failure;
 	if (nla_put_string(skb, NFTA_CHAIN_NAME, chain->name))
 		goto nla_put_failure;
=20
@@ -701,58 +720,19 @@ nf_tables_chain_policy(struct nft_base_chain *cha=
in, const struct nlattr *attr)
 	return 0;
 }
=20
-static int nf_tables_mvchain(struct sk_buff *skb, const struct nlmsghd=
r *nlh,
-			     struct nft_table *table,
-			     struct nft_chain *chain,
-			     const struct nlattr * const nla[])
-{
-	const struct nfgenmsg *nfmsg =3D nlmsg_data(nlh);
-	int family =3D nfmsg->nfgen_family;
-	struct nft_chain *new_chain;
-	struct nft_chain old_chain;
-
-	if (!nla[NFTA_CHAIN_NEW_NAME])
-		return -EINVAL;
-
-	if (chain->flags & NFT_BASE_CHAIN)
-		return -EOPNOTSUPP;
-
-	new_chain =3D nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NEW_NAME])=
;
-	if (IS_ERR(new_chain)) {
-		if (PTR_ERR(new_chain) !=3D -ENOENT)
-			return PTR_ERR(new_chain);
-		new_chain =3D NULL;
-	}
-
-	if (new_chain !=3D NULL)
-		return -EEXIST;
-
-	new_chain =3D chain;
-
-	nla_strlcpy(old_chain.name,
-		    nla[NFTA_CHAIN_NAME], NFT_CHAIN_MAXNAMELEN);
-	nla_strlcpy(new_chain->name,
-		    nla[NFTA_CHAIN_NEW_NAME], NFT_CHAIN_MAXNAMELEN);
-
-	nf_tables_chain_notify(skb, nlh, table, &old_chain, NFT_MSG_DELCHAIN,
-			       family);
-	nf_tables_chain_notify(skb, nlh, table, new_chain, NFT_MSG_NEWCHAIN,
-			       family);
-	return 0;
-}
-
 static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
 {
 	const struct nfgenmsg *nfmsg =3D nlmsg_data(nlh);
-	const struct nlattr *name;
+	const struct nlattr * uninitialized_var(name);
 	const struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_base_chain *basechain =3D NULL;
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
 	int family =3D nfmsg->nfgen_family;
+	u64 handle =3D 0;
 	int err;
 	bool create;
=20
@@ -766,28 +746,42 @@ static int nf_tables_newchain(struct sock *nlsk, =
struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
=20
-	name =3D nla[NFTA_CHAIN_NAME];
-	chain =3D nf_tables_chain_lookup(table, name);
-	if (IS_ERR(chain)) {
-		if (PTR_ERR(chain) !=3D -ENOENT)
+	chain =3D NULL;
+	if (nla[NFTA_CHAIN_HANDLE]) {
+		handle =3D be64_to_cpu(nla_get_be64(nla[NFTA_CHAIN_HANDLE]));
+		chain =3D nf_tables_chain_lookup_byhandle(table, handle);
+		if (IS_ERR(chain))
 			return PTR_ERR(chain);
-		chain =3D NULL;
+	} else {
+		name =3D nla[NFTA_CHAIN_NAME];
+		chain =3D nf_tables_chain_lookup(table, name);
+		if (IS_ERR(chain)) {
+			if (PTR_ERR(chain) !=3D -ENOENT)
+				return PTR_ERR(chain);
+			chain =3D NULL;
+		}
 	}
=20
 	if (chain !=3D NULL) {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
-			return nf_tables_mvchain(skb, nlh, table, chain, nla);
+			return -EOPNOTSUPP;
=20
 		if (nla[NFTA_CHAIN_POLICY]) {
 			if (!(chain->flags & NFT_BASE_CHAIN))
 				return -EOPNOTSUPP;
+
 			err =3D nf_tables_chain_policy(nft_base_chain(chain),
 						     nla[NFTA_CHAIN_POLICY]);
 			if (err < 0)
 				return err;
 		}
+
+		if (nla[NFTA_CHAIN_HANDLE] && nla[NFTA_CHAIN_NAME])
+			nla_strlcpy(chain->name, nla[NFTA_CHAIN_NAME],
+				    NFT_CHAIN_MAXNAMELEN);
+
 		goto notify;
 	}
=20
@@ -856,6 +850,7 @@ static int nf_tables_newchain(struct sock *nlsk, st=
ruct sk_buff *skb,
 	}
=20
 	INIT_LIST_HEAD(&chain->rules);
+	chain->handle =3D nf_tables_alloc_handle(table);
 	nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
=20
 	list_add_tail(&chain->list, &table->chains);
@@ -1122,11 +1117,6 @@ static struct nft_rule *nf_tables_rule_lookup(co=
nst struct nft_chain *chain,
 	return __nf_tables_rule_lookup(chain, be64_to_cpu(nla_get_be64(nla)))=
;
 }
=20
-static inline u64 nf_tables_rule_alloc_handle(struct nft_table *table)
-{
-	return ++table->hgenerator;
-}
-
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] =3D =
{
 	[NFTA_RULE_TABLE]	=3D { .type =3D NLA_STRING },
 	[NFTA_RULE_CHAIN]	=3D { .type =3D NLA_STRING,
@@ -1389,7 +1379,7 @@ static int nf_tables_newrule(struct sock *nlsk, s=
truct sk_buff *skb,
 				return 0;
 		}
 	} else
-		handle =3D nf_tables_rule_alloc_handle(table);
+		handle =3D nf_tables_alloc_handle(table);
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
