From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf,v2] netfilter: nf_tables: release objects on netns destruction
Date: Wed,  9 Dec 2015 20:55:31 +0100
Message-ID: <1449690931-1617-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com, ben@decadent.org.uk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53366 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbbLITzk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 14:55:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E51551324D0
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 20:55:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D8641DA807
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 20:55:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E40D9DA803
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 20:55:34 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to release the existing objects on netns removal otherwise we
leak them. Chains are unregistered in first place to make sure no
packets are walking on our rules and sets anymore.

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Unregister chains in first place to make sure no packets are walking
    over rules and sets anymore.

 net/netfilter/nf_tables_api.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f1002dc..d6c3366 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4578,7 +4578,7 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-static int nf_tables_init_net(struct net *net)
+static int __net_init nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
 	INIT_LIST_HEAD(&net->nft.commit_list);
@@ -4586,8 +4586,49 @@ static int nf_tables_init_net(struct net *net)
 	return 0;
 }
 
+static void __net_exit nf_tables_exit_net(struct net *net)
+{
+	struct nft_table *table, *nt;
+	struct nft_chain *chain, *nc;
+	struct nft_rule *rule, *nr;
+	struct nft_set *set, *ns;
+	struct nft_af_info *afi;
+	struct nft_ctx ctx;
+
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
+	list_for_each_entry(afi, &net->nft.af_info, list) {
+		ctx.afi = afi;
+		list_for_each_entry_safe(table, nt, &afi->tables, list) {
+			list_for_each_entry(chain, &table->chains, list)
+				nf_tables_unregister_hooks(table, chain,
+							   afi->nops);
+			/* No packets are walking on these chains anymore. */
+			ctx.table = table;
+			list_for_each_entry(chain, &table->chains, list) {
+				ctx.chain = chain;
+				list_for_each_entry_safe(rule, nr, &chain->rules, list) {
+					list_del(&rule->list);
+					nf_tables_rule_destroy(&ctx, rule);
+				}
+			}
+			list_for_each_entry_safe(set, ns, &table->sets, list) {
+				list_del(&set->list);
+				nft_set_destroy(set);
+			}
+			list_for_each_entry_safe(chain, nc, &table->chains, list) {
+				list_del(&chain->list);
+				nf_tables_chain_destroy(chain);
+			}
+			list_del(&table->list);
+			nf_tables_table_destroy(&ctx);
+		}
+	}
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+}
+
 static struct pernet_operations nf_tables_net_ops = {
 	.init	= nf_tables_init_net,
+	.exit	= nf_tables_exit_net,
 };
 
 static int __init nf_tables_module_init(void)
-- 
2.1.4

