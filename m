From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/12] netfilter: exit_net cleanup check added
Date: Wed, 13 Dec 2017 19:45:10 +0100
Message-ID: <20171213184520.8193-3-pablo@netfilter.org>
References: <20171213184520.8193-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171213184520.8193-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

Be sure that lists initialized in net_init hook was return to initial
state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 1 +
 net/netfilter/nf_tables_api.c      | 7 +++++++
 net/netfilter/nfnetlink_log.c      | 5 +++++
 net/netfilter/nfnetlink_queue.c    | 5 +++++
 net/netfilter/x_tables.c           | 9 +++++++++
 5 files changed, 27 insertions(+)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 17b4ca562944..e35b8d074f06 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -819,6 +819,7 @@ static void clusterip_net_exit(struct net *net)
 	cn->procdir = NULL;
 #endif
 	nf_unregister_net_hook(net, &cip_arp_ops);
+	WARN_ON_ONCE(!list_empty(&cn->configs));
 }
 
 static struct pernet_operations clusterip_net_ops = {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d8327b43e4dc..10798b357481 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5847,6 +5847,12 @@ static int __net_init nf_tables_init_net(struct net *net)
 	return 0;
 }
 
+static void __net_exit nf_tables_exit_net(struct net *net)
+{
+	WARN_ON_ONCE(!list_empty(&net->nft.af_info));
+	WARN_ON_ONCE(!list_empty(&net->nft.commit_list));
+}
+
 int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
@@ -5917,6 +5923,7 @@ static void __nft_release_afinfo(struct net *net, struct nft_af_info *afi)
 
 static struct pernet_operations nf_tables_net_ops = {
 	.init	= nf_tables_init_net,
+	.exit	= nf_tables_exit_net,
 };
 
 static int __init nf_tables_module_init(void)
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index cad6498f10b0..1f511ed0fea3 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1093,10 +1093,15 @@ static int __net_init nfnl_log_net_init(struct net *net)
 
 static void __net_exit nfnl_log_net_exit(struct net *net)
 {
+	struct nfnl_log_net *log = nfnl_log_pernet(net);
+	unsigned int i;
+
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", net->nf.proc_netfilter);
 #endif
 	nf_log_unset(net, &nfulnl_logger);
+	for (i = 0; i < INSTANCE_BUCKETS; i++)
+		WARN_ON_ONCE(!hlist_empty(&log->instance_table[i]));
 }
 
 static struct pernet_operations nfnl_log_net_ops = {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a16356cacec3..c09b36755ed7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1512,10 +1512,15 @@ static int __net_init nfnl_queue_net_init(struct net *net)
 
 static void __net_exit nfnl_queue_net_exit(struct net *net)
 {
+	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
+	unsigned int i;
+
 	nf_unregister_queue_handler(net);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_queue", net->nf.proc_netfilter);
 #endif
+	for (i = 0; i < INSTANCE_BUCKETS; i++)
+		WARN_ON_ONCE(!hlist_empty(&q->instance_table[i]));
 }
 
 static void nfnl_queue_net_exit_batch(struct list_head *net_exit_list)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index a77dd514297c..55802e97f906 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1729,8 +1729,17 @@ static int __net_init xt_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit xt_net_exit(struct net *net)
+{
+	int i;
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+		WARN_ON_ONCE(!list_empty(&net->xt.tables[i]));
+}
+
 static struct pernet_operations xt_net_ops = {
 	.init = xt_net_init,
+	.exit = xt_net_exit,
 };
 
 static int __init xt_init(void)
-- 
2.11.0
