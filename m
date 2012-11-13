From: pablo@netfilter.org
Subject: [PATCH] netfilter: nf_tables: add support for dormant tables
Date: Tue, 13 Nov 2012 17:33:19 +0100
Message-ID: <1352824399-3641-2-git-send-email-pablo@netfilter.org>
References: <1352824399-3641-1-git-send-email-pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48441 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab2KMQdk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:33:40 -0500
In-Reply-To: <1352824399-3641-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Dormant tables are those whose chains are not registered, thus, they
are not active. You can change the state of a dormant table via
NFT_MSG_NEWTABLE messages. Using this operation you can wake up a
table, so their chains are registered.

This provides atomicity at chain level. Thus, the rule-set of one
chain is applied at once, avoiding any possible intermediate state
in every chain. Still, the chains that belongs to a table are
registered consecutively. This also allows you to have inactive
tables in the kernel.

Atomicity at table level is desired, eg. to ensure that the INPUT and
OUTPUT chains of the filter table are loaded at once. However,
it still does not avoid possible temporary inconsistent configurations
for inter-dependant rules located in different tables. During the
loading stage, the connection tracking system also opens the door
to allow unwanted connections if the iptables stateful rule-set is
loaded having existing established flows.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |   10 ++++
 include/net/netfilter/nf_tables.h   |    2 +
 net/netfilter/nf_tables_api.c       |   90 +++++++++++++++++++++++++++++++++--
 3 files changed, 98 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1242e62..a3989fd 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -55,9 +55,19 @@ enum nft_hook_attributes {
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
 
+/**
+ * enum nft_table_flags - nf_tables table flags
+ *
+ * @NFT_TABLE_F_DORMANT: this table is not active
+ */
+enum nft_table_flags {
+	NFT_TABLE_F_DORMANT	= 0x1,
+};
+
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
+	NFTA_TABLE_FLAGS,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0916685..2301b74 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -396,12 +396,14 @@ extern unsigned int nft_do_chain(const struct nf_hook_ops *ops,
  *	@list: used internally
  *	@chains: chains in the table
  *	@sets: sets in the table
+ *	@flags: table flag (see enum nft_table_flags)
  *	@name: name of the table
  */
 struct nft_table {
 	struct list_head		list;
 	struct list_head		chains;
 	struct list_head		sets;
+	u16				flags;
 	char				name[];
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8d5aab4..f701dc0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -153,6 +153,7 @@ static int nf_tables_chain_type_lookup(const struct nft_af_info *afi,
 
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 	[NFTA_TABLE_NAME]	= { .type = NLA_STRING },
+	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nf_tables_fill_table_info(struct sk_buff *skb, u32 pid, u32 seq,
@@ -173,7 +174,8 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nfmsg->version		= NFNETLINK_V0;
 	nfmsg->res_id		= 0;
 
-	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name))
+	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
+	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)))
 		goto nla_put_failure;
 
 	return nlmsg_end(skb, nlh);
@@ -295,6 +297,74 @@ err:
 	return err;
 }
 
+static int nf_tables_table_enable(struct nft_table *table)
+{
+	struct nft_chain *chain;
+	int err, i = 0;
+
+	list_for_each_entry(chain, &table->chains, list) {
+		err = nf_register_hook(&nft_base_chain(chain)->ops);
+		if (err < 0)
+			goto err;
+
+		i++;
+	}
+	return 0;
+err:
+	list_for_each_entry(chain, &table->chains, list) {
+		if (i-- <= 0)
+			break;
+
+		nf_unregister_hook(&nft_base_chain(chain)->ops);
+	}
+	return err;
+}
+
+static int nf_tables_table_disable(struct nft_table *table)
+{
+	struct nft_chain *chain;
+
+	list_for_each_entry(chain, &table->chains, list)
+		nf_unregister_hook(&nft_base_chain(chain)->ops);
+
+	return 0;
+}
+
+static int nf_tables_updtable(struct sock *nlsk, struct sk_buff *skb,
+			      const struct nlmsghdr *nlh,
+			      const struct nlattr * const nla[],
+			      struct nft_af_info *afi, struct nft_table *table)
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	int family = nfmsg->nfgen_family, ret = 0;
+
+	if (nla[NFTA_TABLE_FLAGS]) {
+		__be32 flags;
+
+		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
+		if (flags & ~NFT_TABLE_F_DORMANT)
+			return -EINVAL;
+
+		if ((flags & NFT_TABLE_F_DORMANT) &&
+		    !(table->flags & NFT_TABLE_F_DORMANT)) {
+			ret = nf_tables_table_disable(table);
+			if (ret >= 0)
+				table->flags |= NFT_TABLE_F_DORMANT;
+		} else if (!(flags & NFT_TABLE_F_DORMANT) &&
+			   table->flags & NFT_TABLE_F_DORMANT) {
+			ret = nf_tables_table_enable(table);
+			if (ret >= 0)
+				table->flags &= ~NFT_TABLE_F_DORMANT;
+		}
+		if (ret < 0)
+			goto err;
+	}
+
+	nf_tables_table_notify(skb, nlh, table, NFT_MSG_NEWTABLE, family);
+err:
+	return ret;
+}
+
 static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -322,7 +392,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 			return -EEXIST;
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
-		return 0;
+		return nf_tables_updtable(nlsk, skb, nlh, nla, afi, table);
 	}
 
 	table = kzalloc(sizeof(*table) + nla_len(name), GFP_KERNEL);
@@ -333,6 +403,16 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 
+	if (nla[NFTA_TABLE_FLAGS]) {
+		__be32 flags;
+
+		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
+		if (flags & ~NFT_TABLE_F_DORMANT)
+			return -EINVAL;
+
+		table->flags |= flags;
+	}
+
 	list_add_tail(&table->list, &afi->tables);
 	nf_tables_table_notify(skb, nlh, table, NFT_MSG_NEWTABLE, family);
 	return 0;
@@ -775,7 +855,8 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 
 	list_add_tail(&chain->list, &table->chains);
 
-	if (chain->flags & NFT_BASE_CHAIN) {
+	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
+	    chain->flags & NFT_BASE_CHAIN) {
 		err = nf_register_hook(&nft_base_chain(chain)->ops);
 		if (err < 0) {
 			kfree(basechain);
@@ -815,7 +896,8 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 
 	list_del(&chain->list);
 
-	if (chain->flags & NFT_BASE_CHAIN)
+	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
+	    chain->flags & NFT_BASE_CHAIN)
 		nf_unregister_hook(&nft_base_chain(chain)->ops);
 
 	nf_tables_chain_notify(skb, nlh, table, chain, NFT_MSG_DELCHAIN,
-- 
1.7.10.4

