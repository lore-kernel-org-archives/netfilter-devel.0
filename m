From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 34/37] netfilter: conntrack: merge acct and helper sysctl table with main one
Date: Fri, 21 Dec 2018 01:28:38 +0100
Message-ID: <20181221002841.28587-35-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Needless copy&paste, just handle all in one.  Next patch will handle
acct and timestamp, which have similar functions.

Intentionally leaves cruft behind, will be cleaned up in a followup
patch.

The obsolete sysctl pointers in netns_ct struct are left in place and
removed in a single change, as changes to netns trigger rebuild of
almost all files.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_acct.c       | 65 +--------------------------------
 net/netfilter/nf_conntrack_helper.c     | 64 +-------------------------------
 net/netfilter/nf_conntrack_standalone.c | 21 ++++++++++-
 3 files changed, 22 insertions(+), 128 deletions(-)

diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index a7ad0e19e0de..89c58946ec61 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -25,83 +25,20 @@ static bool nf_ct_acct __read_mostly;
 module_param_named(acct, nf_ct_acct, bool, 0644);
 MODULE_PARM_DESC(acct, "Enable connection tracking flow accounting.");
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table acct_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_acct",
-		.data		= &init_net.ct.sysctl_acct,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{}
-};
-#endif /* CONFIG_SYSCTL */
-
 static const struct nf_ct_ext_type acct_extend = {
 	.len	= sizeof(struct nf_conn_acct),
 	.align	= __alignof__(struct nf_conn_acct),
 	.id	= NF_CT_EXT_ACCT,
 };
 
-#ifdef CONFIG_SYSCTL
-static int nf_conntrack_acct_init_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = kmemdup(acct_sysctl_table, sizeof(acct_sysctl_table),
-			GFP_KERNEL);
-	if (!table)
-		goto out;
-
-	table[0].data = &net->ct.sysctl_acct;
-
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
-
-	net->ct.acct_sysctl_header = register_net_sysctl(net, "net/netfilter",
-							 table);
-	if (!net->ct.acct_sysctl_header) {
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
-static void nf_conntrack_acct_fini_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = net->ct.acct_sysctl_header->ctl_table_arg;
-	unregister_net_sysctl_table(net->ct.acct_sysctl_header);
-	kfree(table);
-}
-#else
-static int nf_conntrack_acct_init_sysctl(struct net *net)
-{
-	return 0;
-}
-
-static void nf_conntrack_acct_fini_sysctl(struct net *net)
-{
-}
-#endif
-
 int nf_conntrack_acct_pernet_init(struct net *net)
 {
 	net->ct.sysctl_acct = nf_ct_acct;
-	return nf_conntrack_acct_init_sysctl(net);
+	return 0;
 }
 
 void nf_conntrack_acct_pernet_fini(struct net *net)
 {
-	nf_conntrack_acct_fini_sysctl(net);
 }
 
 int nf_conntrack_acct_init(void)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index e24b762ffa1d..8b6fab94501d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -42,67 +42,6 @@ module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
 MODULE_PARM_DESC(nf_conntrack_helper,
 		 "Enable automatic conntrack helper assignment (default 0)");
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table helper_sysctl_table[] = {
-	{
-		.procname	= "nf_conntrack_helper",
-		.data		= &init_net.ct.sysctl_auto_assign_helper,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{}
-};
-
-static int nf_conntrack_helper_init_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = kmemdup(helper_sysctl_table, sizeof(helper_sysctl_table),
-			GFP_KERNEL);
-	if (!table)
-		goto out;
-
-	table[0].data = &net->ct.sysctl_auto_assign_helper;
-
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
-
-	net->ct.helper_sysctl_header =
-		register_net_sysctl(net, "net/netfilter", table);
-
-	if (!net->ct.helper_sysctl_header) {
-		pr_err("nf_conntrack_helper: can't register to sysctl.\n");
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
-static void nf_conntrack_helper_fini_sysctl(struct net *net)
-{
-	struct ctl_table *table;
-
-	table = net->ct.helper_sysctl_header->ctl_table_arg;
-	unregister_net_sysctl_table(net->ct.helper_sysctl_header);
-	kfree(table);
-}
-#else
-static int nf_conntrack_helper_init_sysctl(struct net *net)
-{
-	return 0;
-}
-
-static void nf_conntrack_helper_fini_sysctl(struct net *net)
-{
-}
-#endif /* CONFIG_SYSCTL */
-
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
 static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
@@ -537,12 +476,11 @@ int nf_conntrack_helper_pernet_init(struct net *net)
 {
 	net->ct.auto_assign_helper_warned = false;
 	net->ct.sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
-	return nf_conntrack_helper_init_sysctl(net);
+	return 0;
 }
 
 void nf_conntrack_helper_pernet_fini(struct net *net)
 {
-	nf_conntrack_helper_fini_sysctl(net);
 }
 
 int nf_conntrack_helper_init(void)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f9fa825ddc62..9e2d9d5d824d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -539,6 +539,8 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_CHECKSUM,
 	NF_SYSCTL_CT_LOG_INVALID,
 	NF_SYSCTL_CT_EXPECT_MAX,
+	NF_SYSCTL_CT_ACCT,
+	NF_SYSCTL_CT_HELPER,
 };
 
 static struct ctl_table nf_ct_sysctl_table[] = {
@@ -586,6 +588,20 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	[NF_SYSCTL_CT_ACCT] = {
+		.procname	= "nf_conntrack_acct",
+		.data		= &init_net.ct.sysctl_acct,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	[NF_SYSCTL_CT_HELPER] = {
+		.procname	= "nf_conntrack_helper",
+		.data		= &init_net.ct.sysctl_auto_assign_helper,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
@@ -614,8 +630,11 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->user_ns != &init_user_ns) {
 		table[NF_SYSCTL_CT_MAX].procname = NULL;
+		table[NF_SYSCTL_CT_ACCT].procname = NULL;
+		table[NF_SYSCTL_CT_HELPER].procname = NULL;
+	}
 
 	if (!net_eq(&init_net, net))
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
-- 
2.11.0
