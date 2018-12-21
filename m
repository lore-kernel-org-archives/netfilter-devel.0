From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 33/37] netfilter: conntrack: add mnemonics for sysctl table
Date: Fri, 21 Dec 2018 01:28:37 +0100
Message-ID: <20181221002841.28587-34-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its a bit hard to see what table[3] really lines up with, so add
human-readable mnemonics and use them for initialisation.

This makes it easier to see e.g. which sysctls are not exported to
unprivileged userns.

objdiff shows no changes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index feeff346f946..f9fa825ddc62 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -532,36 +532,45 @@ nf_conntrack_hash_sysctl(struct ctl_table *table, int write,
 
 static struct ctl_table_header *nf_ct_netfilter_header;
 
+enum nf_ct_sysctl_index {
+	NF_SYSCTL_CT_MAX,
+	NF_SYSCTL_CT_COUNT,
+	NF_SYSCTL_CT_BUCKETS,
+	NF_SYSCTL_CT_CHECKSUM,
+	NF_SYSCTL_CT_LOG_INVALID,
+	NF_SYSCTL_CT_EXPECT_MAX,
+};
+
 static struct ctl_table nf_ct_sysctl_table[] = {
-	{
+	[NF_SYSCTL_CT_MAX] = {
 		.procname	= "nf_conntrack_max",
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
+	[NF_SYSCTL_CT_COUNT] = {
 		.procname	= "nf_conntrack_count",
 		.data		= &init_net.ct.count,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
-	{
+	[NF_SYSCTL_CT_BUCKETS] = {
 		.procname       = "nf_conntrack_buckets",
 		.data           = &nf_conntrack_htable_size_user,
 		.maxlen         = sizeof(unsigned int),
 		.mode           = 0644,
 		.proc_handler   = nf_conntrack_hash_sysctl,
 	},
-	{
+	[NF_SYSCTL_CT_CHECKSUM] = {
 		.procname	= "nf_conntrack_checksum",
 		.data		= &init_net.ct.sysctl_checksum,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
+	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
 		.data		= &init_net.ct.sysctl_log_invalid,
 		.maxlen		= sizeof(unsigned int),
@@ -570,7 +579,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.extra1		= &log_invalid_proto_min,
 		.extra2		= &log_invalid_proto_max,
 	},
-	{
+	[NF_SYSCTL_CT_EXPECT_MAX] = {
 		.procname	= "nf_conntrack_expect_max",
 		.data		= &nf_ct_expect_max,
 		.maxlen		= sizeof(int),
@@ -600,16 +609,16 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	if (!table)
 		goto out_kmemdup;
 
-	table[1].data = &net->ct.count;
-	table[3].data = &net->ct.sysctl_checksum;
-	table[4].data = &net->ct.sysctl_log_invalid;
+	table[NF_SYSCTL_CT_COUNT].data = &net->ct.count;
+	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
+	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 
 	/* Don't export sysctls to unprivileged users */
 	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
+		table[NF_SYSCTL_CT_MAX].procname = NULL;
 
 	if (!net_eq(&init_net, net))
-		table[2].mode = 0444;
+		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 
 	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
 	if (!net->ct.sysctl_header)
-- 
2.11.0
