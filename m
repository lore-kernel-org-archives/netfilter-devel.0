From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/3] netfilter: xtables: add cluster match
Date: Wed, 28 Jan 2009 17:07:28 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901281658440.20921@fbirervta.pbzchgretzou.qr>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145848.7501.18129.stgit@Decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55098 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZA1QHb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:07:31 -0500
In-Reply-To: <20090128145848.7501.18129.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-01-28 15:58, Pablo Neira Ayuso wrote:

>This patch adds the iptables cluster match. This match can be used
>to deploy gateway and back-end load-sharing clusters. Assuming that
>all the nodes see all packets
> (see arptables mcmangle target and PKTTYPE iptables targets on how
>to do that), the cluster match decides if this node has to handle a
>packet given:

Is not this what CLUSTERIP is essentially supposed to do?

>
>	jhash(source IP) % nodeID == 0

>+struct xt_cluster_match_info {
>+	u_int16_t		total_nodes;
>+	u_int16_t		node_id;
>+	u_int32_t		hash_seed;
>+	char			proc_name[16];
>+	unsigned int		flags;

Ouch, don't use unfixated types like unsigned int.

>+config NETFILTER_XT_MATCH_CLUSTER
>+	tristate '"cluster" match support'
>+	depends on NETFILTER_ADVANCED
>+	---help---
>+	  This option allows you to build work-load-sharing clusters of
>+	  network servers/stateful firewalls without having a dedicated
>+	  load-balancing router/server/switch. Basically, this match returns
>+	  true when the packet must be handled by this cluster node. Thus,
>+	  all nodes see all packets and this match decides which node handles
>+	  what packets. The work-load sharing algorithm is based on source
>+	  address hashing.
>+
>+	  If you say Y here, try `iptables -m cluster --help` for
>+	  more information. See the PKTTYPE target and the mcmangle arptables
>+	  target on how to make your nodes see all packets. You can also have
>+	  a look at man iptables(8) for some examples on the usage.
>+
> endif # NETFILTER_XTABLES

Please keep the list alphabetical.

> endmenu
>diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
>index dd43ba9..29049e4 100644
>--- a/net/netfilter/Makefile
>+++ b/net/netfilter/Makefile
>@@ -90,6 +90,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
> obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
> obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
> obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
>+obj-$(CONFIG_NETFILTER_XT_MATCH_CLUSTER) += xt_cluster.o

Similarly.

>+struct xt_cluster_internal {
>+	unsigned long		node_mask;

In the back of my head I seem to remember a cpumask_t.

>+	struct proc_dir_entry	*proc;
>+	atomic_t		use;
>+};
>+
>+#ifdef CONFIG_PROC_FS
>+static void *xt_cluster_seq_start(struct seq_file *s, loff_t *pos)
>+{
>+	if (*pos == 0) {
>+		struct xt_cluster_internal *data =
>+			(struct xt_cluster_internal *)s->private;

Redundant cast ;)

>+static int xt_cluster_seq_show(struct seq_file *s, void *v)
>+{
>+	unsigned long *mask = (unsigned long *)v;

Same.

>+static struct seq_operations xt_cluster_seq_ops = {
static const struct ...

>+#define XT_CLUSTER_PROC_WRITELEN	10
>+
>+static ssize_t 
>+xt_cluster_write_proc(struct file *file, const char __user *input,
>+		      size_t size, loff_t *ofs)
>+{
>+	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
>+        struct xt_cluster_internal *info = pde->data;

  ^^

>+	char buffer[XT_CLUSTER_PROC_WRITELEN+1];
>+	unsigned int new_node_id;
>+
>+	if (copy_from_user(buffer, input, XT_CLUSTER_PROC_WRITELEN))
>+		return -EFAULT;
>+
>+	switch(*buffer) {
>+	case '+':
>+		new_node_id = simple_strtoul(buffer+1, NULL, 10);

Perhaps strict_strtoul would be preferred?

>+	case '-':
>+		new_node_id = simple_strtoul(buffer+1, NULL, 10);

>+static struct xt_match xt_cluster_match[] __read_mostly = {
>+	{
>+		.name		= "cluster",
>+		.family		= AF_INET,
>+		.match		= xt_cluster_mt,
>+		.checkentry	= xt_cluster_mt_checkentry,
>+		.destroy	= xt_cluster_mt_destroy,
>+		.matchsize	= sizeof(struct xt_cluster_match_info),
>+		.me		= THIS_MODULE,
>+	},
>+	{
>+		.name		= "cluster",
>+		.family		= AF_INET6,
>+		.match		= xt_cluster_mt,
>+		.checkentry	= xt_cluster_mt_checkentry,
>+		.destroy	= xt_cluster_mt_destroy,
>+		.matchsize	= sizeof(struct xt_cluster_match_info),
>+		.me		= THIS_MODULE,
>+	},
>+};

First, NFPROTO_IPV4 instead of AF_INET, and NFPROTO_IPV6 instead of
AF_INET6.
Since these are the same, too, they can be combined with
.family = NFPROTO_UNSPEC.

>+static int __init xt_cluster_mt_init(void)
>+{
>+	int ret;
>+
>+#ifdef CONFIG_PROC_FS
>+	proc_cluster = proc_mkdir("cluster", proc_net_netfilter);
>+	if (!proc_cluster)
>+		return -ENOMEM;
>+#endif
>+	ret = xt_register_matches(xt_cluster_match,
>+				  ARRAY_SIZE(xt_cluster_match));
>+	if (ret < 0)
>+		return ret;

When register_match fails, you still have to remove the proc directory.

>+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>+MODULE_LICENSE("GPL");
>+MODULE_DESCRIPTION("Xtables: xt_cluster match");

A better short-description would be nice (the user could have probably 
guessed already that xt_cluster.ko is a cluster match..),
maybe something like "cluster multicast filtering"?
