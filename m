From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 24/37] netfilter: nf_tables: Speed up selective rule dumps
Date: Fri, 21 Dec 2018 01:28:28 +0100
Message-ID: <20181221002841.28587-25-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

If just a table name was given, nf_tables_dump_rules() continued over
the list of tables even after a match was found. The simple fix is to
exit the loop if it reached the bottom and ctx->table was not NULL.

When iterating over the table's chains, the same problem as above
existed. But worse than that, if a chain name was given the hash table
wasn't used to find the corresponding chain. Fix this by introducing a
helper function iterating over a chain's rules (and taking care of the
cb->args handling), then introduce a shortcut to it if a chain name was
given.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 90 +++++++++++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 42487d01a3ed..200751a49745 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2291,15 +2291,52 @@ struct nft_rule_dump_ctx {
 	char *chain;
 };
 
+static int __nf_tables_dump_rules(struct sk_buff *skb,
+				  unsigned int *idx,
+				  struct netlink_callback *cb,
+				  const struct nft_table *table,
+				  const struct nft_chain *chain)
+{
+	struct net *net = sock_net(skb->sk);
+	unsigned int s_idx = cb->args[0];
+	const struct nft_rule *rule;
+	int rc = 1;
+
+	list_for_each_entry_rcu(rule, &chain->rules, list) {
+		if (!nft_is_active(net, rule))
+			goto cont;
+		if (*idx < s_idx)
+			goto cont;
+		if (*idx > s_idx) {
+			memset(&cb->args[1], 0,
+					sizeof(cb->args) - sizeof(cb->args[0]));
+		}
+		if (nf_tables_fill_rule_info(skb, net, NETLINK_CB(cb->skb).portid,
+					cb->nlh->nlmsg_seq,
+					NFT_MSG_NEWRULE,
+					NLM_F_MULTI | NLM_F_APPEND,
+					table->family,
+					table, chain, rule) < 0)
+			goto out_unfinished;
+
+		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+cont:
+		(*idx)++;
+	}
+	rc = 0;
+out_unfinished:
+	cb->args[0] = *idx;
+	return rc;
+}
+
 static int nf_tables_dump_rules(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	const struct nft_rule_dump_ctx *ctx = cb->data;
-	const struct nft_table *table;
+	struct nft_table *table;
 	const struct nft_chain *chain;
-	const struct nft_rule *rule;
-	unsigned int idx = 0, s_idx = cb->args[0];
+	unsigned int idx = 0;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 
@@ -2313,37 +2350,34 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 		if (ctx && ctx->table && strcmp(ctx->table, table->name) != 0)
 			continue;
 
-		list_for_each_entry_rcu(chain, &table->chains, list) {
-			if (ctx && ctx->chain &&
-			    strcmp(ctx->chain, chain->name) != 0)
-				continue;
+		if (ctx && ctx->chain) {
+			struct rhlist_head *list, *tmp;
 
-			list_for_each_entry_rcu(rule, &chain->rules, list) {
-				if (!nft_is_active(net, rule))
-					goto cont;
-				if (idx < s_idx)
-					goto cont;
-				if (idx > s_idx)
-					memset(&cb->args[1], 0,
-					       sizeof(cb->args) - sizeof(cb->args[0]));
-				if (nf_tables_fill_rule_info(skb, net, NETLINK_CB(cb->skb).portid,
-							      cb->nlh->nlmsg_seq,
-							      NFT_MSG_NEWRULE,
-							      NLM_F_MULTI | NLM_F_APPEND,
-							      table->family,
-							      table, chain, rule) < 0)
-					goto done;
-
-				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
-cont:
-				idx++;
+			list = rhltable_lookup(&table->chains_ht, ctx->chain,
+					       nft_chain_ht_params);
+			if (!list)
+				goto done;
+
+			rhl_for_each_entry_rcu(chain, tmp, list, rhlhead) {
+				if (!nft_is_active(net, chain))
+					continue;
+				__nf_tables_dump_rules(skb, &idx,
+						       cb, table, chain);
+				break;
 			}
+			goto done;
 		}
+
+		list_for_each_entry_rcu(chain, &table->chains, list) {
+			if (__nf_tables_dump_rules(skb, &idx, cb, table, chain))
+				goto done;
+		}
+
+		if (ctx && ctx->table)
+			break;
 	}
 done:
 	rcu_read_unlock();
-
-	cb->args[0] = idx;
 	return skb->len;
 }
 
-- 
2.11.0
