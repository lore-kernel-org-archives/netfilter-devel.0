From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 31/38] netfilter: nf_tables: avoid global info storage
Date: Fri, 20 Jul 2018 15:08:59 +0200
Message-ID: <20180720130906.27687-32-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This works because all accesses are currently serialized by nfnl
nf_tables subsys mutex.

If we want to have per-netns locking, we need to make this scratch
area pernetns or allocate it on demand.

This does the latter, its ~28kbyte but we can fallback to vmalloc
so it should be fine.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c16c481fc52a..68436edd9cdf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2454,8 +2454,6 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 
 #define NFT_RULE_MAXEXPRS	128
 
-static struct nft_expr_info *info;
-
 static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			     struct sk_buff *skb, const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[],
@@ -2463,6 +2461,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
+	struct nft_expr_info *info = NULL;
 	int family = nfmsg->nfgen_family;
 	struct nft_table *table;
 	struct nft_chain *chain;
@@ -2533,6 +2532,12 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	n = 0;
 	size = 0;
 	if (nla[NFTA_RULE_EXPRESSIONS]) {
+		info = kvmalloc_array(NFT_RULE_MAXEXPRS,
+				      sizeof(struct nft_expr_info),
+				      GFP_KERNEL);
+		if (!info)
+			return -ENOMEM;
+
 		nla_for_each_nested(tmp, nla[NFTA_RULE_EXPRESSIONS], rem) {
 			err = -EINVAL;
 			if (nla_type(tmp) != NFTA_LIST_ELEM)
@@ -2625,6 +2630,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 				list_add_rcu(&rule->list, &chain->rules);
 		}
 	}
+	kvfree(info);
 	chain->use++;
 
 	if (net->nft.validate_state == NFT_VALIDATE_DO)
@@ -2638,6 +2644,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		if (info[i].ops != NULL)
 			module_put(info[i].ops->type->owner);
 	}
+	kvfree(info);
 	return err;
 }
 
@@ -7203,29 +7210,19 @@ static int __init nf_tables_module_init(void)
 
 	nft_chain_filter_init();
 
-	info = kmalloc_array(NFT_RULE_MAXEXPRS, sizeof(struct nft_expr_info),
-			     GFP_KERNEL);
-	if (info == NULL) {
-		err = -ENOMEM;
-		goto err1;
-	}
-
 	err = nf_tables_core_module_init();
 	if (err < 0)
-		goto err2;
+		return err;
 
 	err = nfnetlink_subsys_register(&nf_tables_subsys);
 	if (err < 0)
-		goto err3;
+		goto err;
 
 	register_netdevice_notifier(&nf_tables_flowtable_notifier);
 
 	return register_pernet_subsys(&nf_tables_net_ops);
-err3:
+err:
 	nf_tables_core_module_exit();
-err2:
-	kfree(info);
-err1:
 	return err;
 }
 
@@ -7237,7 +7234,6 @@ static void __exit nf_tables_module_exit(void)
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	rcu_barrier();
 	nf_tables_core_module_exit();
-	kfree(info);
 }
 
 module_init(nf_tables_module_init);
-- 
2.11.0
