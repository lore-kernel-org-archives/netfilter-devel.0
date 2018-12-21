From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 35/37] netfilter: conntrack: merge ecache and timestamp sysctl tables with main one
Date: Fri, 21 Dec 2018 01:28:39 +0100
Message-ID: <20181221002841.28587-36-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Similar to previous change, this time for eache and timestamp.
Unlike helper and acct, these can be disabled at build time, so they
need ifdef guards.

Next patch will remove a few (now obsolete) functions.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ecache.c     | 65 +--------------------------------
 net/netfilter/nf_conntrack_standalone.c | 33 +++++++++++++++++
 net/netfilter/nf_conntrack_timestamp.c  | 65 +--------------------------------
 3 files changed, 35 insertions(+), 128 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index c11822a7d2bf..75118b75aa50 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -336,85 +336,22 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table event_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_events",
-		.data		= &init_net.ct.sysctl_events,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{}
-};
-#endif /* CONFIG_SYSCTL */
-
 static const struct nf_ct_ext_type event_extend = {
 	.len	= sizeof(struct nf_conntrack_ecache),
 	.align	= __alignof__(struct nf_conntrack_ecache),
 	.id	= NF_CT_EXT_ECACHE,
 };
 
-#ifdef CONFIG_SYSCTL
-static int nf_conntrack_event_init_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = kmemdup(event_sysctl_table, sizeof(event_sysctl_table),
-			GFP_KERNEL);
-	if (!table)
-		goto out;
-
-	table[0].data = &net->ct.sysctl_events;
-
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
-
-	net->ct.event_sysctl_header =
-		register_net_sysctl(net, "net/netfilter", table);
-	if (!net->ct.event_sysctl_header) {
-		pr_err("can't register to sysctl\n");
-		goto out_register;
-	}
-	return 0;
-
-out_register:
-	kfree(table);
-out:
-	return -ENOMEM;
-}
-
-static void nf_conntrack_event_fini_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = net->ct.event_sysctl_header->ctl_table_arg;
-	unregister_net_sysctl_table(net->ct.event_sysctl_header);
-	kfree(table);
-}
-#else
-static int nf_conntrack_event_init_sysctl(struct net *net)
-{
-	return 0;
-}
-
-static void nf_conntrack_event_fini_sysctl(struct net *net)
-{
-}
-#endif /* CONFIG_SYSCTL */
-
 int nf_conntrack_ecache_pernet_init(struct net *net)
 {
 	net->ct.sysctl_events = nf_ct_events;
 	INIT_DELAYED_WORK(&net->ct.ecache_dwork, ecache_work);
-	return nf_conntrack_event_init_sysctl(net);
+	return 0;
 }
 
 void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
 	cancel_delayed_work_sync(&net->ct.ecache_dwork);
-	nf_conntrack_event_fini_sysctl(net);
 }
 
 int nf_conntrack_ecache_init(void)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9e2d9d5d824d..b6177fd73304 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -541,6 +541,12 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_EXPECT_MAX,
 	NF_SYSCTL_CT_ACCT,
 	NF_SYSCTL_CT_HELPER,
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	NF_SYSCTL_CT_EVENTS,
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	NF_SYSCTL_CT_TIMESTAMP,
+#endif
 };
 
 static struct ctl_table nf_ct_sysctl_table[] = {
@@ -602,6 +608,24 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	[NF_SYSCTL_CT_EVENTS] = {
+		.procname	= "nf_conntrack_events",
+		.data		= &init_net.ct.sysctl_events,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	[NF_SYSCTL_CT_TIMESTAMP] = {
+		.procname	= "nf_conntrack_timestamp",
+		.data		= &init_net.ct.sysctl_tstamp,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{ }
 };
 
@@ -628,12 +652,21 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_COUNT].data = &net->ct.count;
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	table[NF_SYSCTL_CT_EVENTS].data = &net->ct.sysctl_events;
+#endif
 
 	/* Don't export sysctls to unprivileged users */
 	if (net->user_ns != &init_user_ns) {
 		table[NF_SYSCTL_CT_MAX].procname = NULL;
 		table[NF_SYSCTL_CT_ACCT].procname = NULL;
 		table[NF_SYSCTL_CT_HELPER].procname = NULL;
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+		table[NF_SYSCTL_CT_TIMESTAMP].procname = NULL;
+#endif
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+		table[NF_SYSCTL_CT_EVENTS].procname = NULL;
+#endif
 	}
 
 	if (!net_eq(&init_net, net))
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index 56766cb26e40..bae151d93bea 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -22,83 +22,20 @@ static bool nf_ct_tstamp __read_mostly;
 module_param_named(tstamp, nf_ct_tstamp, bool, 0644);
 MODULE_PARM_DESC(tstamp, "Enable connection tracking flow timestamping.");
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table tstamp_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_timestamp",
-		.data		= &init_net.ct.sysctl_tstamp,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{}
-};
-#endif /* CONFIG_SYSCTL */
-
 static const struct nf_ct_ext_type tstamp_extend = {
 	.len	= sizeof(struct nf_conn_tstamp),
 	.align	= __alignof__(struct nf_conn_tstamp),
 	.id	= NF_CT_EXT_TSTAMP,
 };
 
-#ifdef CONFIG_SYSCTL
-static int nf_conntrack_tstamp_init_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = kmemdup(tstamp_sysctl_table, sizeof(tstamp_sysctl_table),
-			GFP_KERNEL);
-	if (!table)
-		goto out;
-
-	table[0].data = &net->ct.sysctl_tstamp;
-
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
-
-	net->ct.tstamp_sysctl_header = register_net_sysctl(net,	"net/netfilter",
-							   table);
-	if (!net->ct.tstamp_sysctl_header) {
-		pr_err("can't register to sysctl\n");
-		goto out_register;
-	}
-	return 0;
-
-out_register:
-	kfree(table);
-out:
-	return -ENOMEM;
-}
-
-static void nf_conntrack_tstamp_fini_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = net->ct.tstamp_sysctl_header->ctl_table_arg;
-	unregister_net_sysctl_table(net->ct.tstamp_sysctl_header);
-	kfree(table);
-}
-#else
-static int nf_conntrack_tstamp_init_sysctl(struct net *net)
-{
-	return 0;
-}
-
-static void nf_conntrack_tstamp_fini_sysctl(struct net *net)
-{
-}
-#endif
-
 int nf_conntrack_tstamp_pernet_init(struct net *net)
 {
 	net->ct.sysctl_tstamp = nf_ct_tstamp;
-	return nf_conntrack_tstamp_init_sysctl(net);
+	return 0;
 }
 
 void nf_conntrack_tstamp_pernet_fini(struct net *net)
 {
-	nf_conntrack_tstamp_fini_sysctl(net);
 }
 
 int nf_conntrack_tstamp_init(void)
-- 
2.11.0
