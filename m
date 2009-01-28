From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: xtables: add cluster match
Date: Wed, 28 Jan 2009 15:58:48 +0100
Message-ID: <20090128145848.7501.18129.stgit@Decadence>
References: <20090128145801.7501.44459.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53909 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751302AbZA1O66 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:58:58 -0500
In-Reply-To: <20090128145801.7501.44459.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the iptables cluster match. This match can be used
to deploy gateway and back-end load-sharing clusters. Assuming that
all the nodes see all packets (see arptables mcmangle target and
PKTTYPE iptables targets on how to do that), the cluster match
decides if this node has to handle a packet given:

	jhash(source IP) % nodeID == 0

For related connections, the master conntrack is used. An example of
its use for a gateway cluster, in one of the cluster nodes:

iptables -I PREROUTING -t mangle -i eth1 -m cluster \
	--cluster-total-nodes 2 --cluster-local-node 1 \
	--cluster-proc-name eth1 -j MARK --set-mark 0xffff
iptables -A PREROUTING -t mangle -i eth1 \
	-m mark ! --mark 0xffff -j DROP
iptables -A PREROUTING -t mangle -i eth2 -m cluster \
	--cluster-total-nodes 2 --cluster-local-node 1 \
	--cluster-proc-name eth2 -j MARK --set-mark 0xffff
iptables -A PREROUTING -t mangle -i eth2 \
	-m mark ! --mark 0xffff -j DROP

And the following rule-set to make all nodes see all the packets:

arptables -I OUTPUT -o eth1 -j mcmangle --h-length 6 \
	--mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth1
arptables -I INPUT -i eth1 --h-length 6 \
	--destination-mac 01:00:5e:00:01:01 \
	-j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
arptables -I OUTPUT -o eth2 -j mcmangle --h-length 6 \
	--mc-mangle-mac 01:00:5e:00:01:02 --mc-mangle-dev eth2
arptables -I INPUT -i eth2 --h-length 6 \
	--destination-mac 01:00:5e:00:01:02 \
	-j mangle --mangle-mac-d 00:zz:yy:xx:5a:27

iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
	-j PKTTYPE --to-pkt-type unicast

In the case of TCP connections, pickup facility has to be disabled
to avoid marking TCP ACK packets coming in the reply direction as
valid.

echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose

The match also provides a /proc entry under:

/proc/sys/net/netfilter/cluster/$PROC_NAME

where PROC_NAME is set via --cluster-proc-name. This is useful to
include possible cluster reconfigurations via fail-over scripts.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/xt_cluster.h |   21 ++
 net/netfilter/Kconfig                |   17 ++
 net/netfilter/Makefile               |    1 
 net/netfilter/xt_cluster.c           |  333 ++++++++++++++++++++++++++++++++++
 4 files changed, 372 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_cluster.h
 create mode 100644 net/netfilter/xt_cluster.c

diff --git a/include/linux/netfilter/xt_cluster.h b/include/linux/netfilter/xt_cluster.h
new file mode 100644
index 0000000..85ab07f
--- /dev/null
+++ b/include/linux/netfilter/xt_cluster.h
@@ -0,0 +1,21 @@
+#ifndef _XT_CLUSTER_MATCH_H
+#define _XT_CLUSTER_MATCH_H
+
+struct proc_dir_entry;
+
+enum xt_cluster_flags {
+	XT_CLUSTER_F_INV = 0,
+};
+
+struct xt_cluster_match_info {
+	u_int16_t		total_nodes;
+	u_int16_t		node_id;
+	u_int32_t		hash_seed;
+	char			proc_name[16];
+	unsigned int		flags;
+
+	/* Used internally by the kernel */
+	void			*data __attribute__((aligned(8)));
+};
+
+#endif /* _XT_CLUSTER_MATCH_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9ed1ccf..33d37d9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -872,6 +872,23 @@ config NETFILTER_XT_MATCH_U32
 
 	  Details and examples are in the kernel module source.
 
+config NETFILTER_XT_MATCH_CLUSTER
+	tristate '"cluster" match support'
+	depends on NETFILTER_ADVANCED
+	---help---
+	  This option allows you to build work-load-sharing clusters of
+	  network servers/stateful firewalls without having a dedicated
+	  load-balancing router/server/switch. Basically, this match returns
+	  true when the packet must be handled by this cluster node. Thus,
+	  all nodes see all packets and this match decides which node handles
+	  what packets. The work-load sharing algorithm is based on source
+	  address hashing.
+
+	  If you say Y here, try `iptables -m cluster --help` for
+	  more information. See the PKTTYPE target and the mcmangle arptables
+	  target on how to make your nodes see all packets. You can also have
+	  a look at man iptables(8) for some examples on the usage.
+
 endif # NETFILTER_XTABLES
 
 endmenu
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index dd43ba9..29049e4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CLUSTER) += xt_cluster.o
 
 # IPVS
 obj-$(CONFIG_IP_VS) += ipvs/
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
new file mode 100644
index 0000000..998ba11
--- /dev/null
+++ b/net/netfilter/xt_cluster.c
@@ -0,0 +1,333 @@
+/*
+ * (C) 2008-2009 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as 
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/jhash.h>
+#include <linux/bitops.h>
+#include <linux/proc_fs.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/netfilter/xt_cluster.h>
+
+struct xt_cluster_internal {
+	unsigned long		node_mask;
+	struct proc_dir_entry	*proc;
+	atomic_t		use;
+};
+
+static inline u_int32_t nf_ct_orig_ipv4_src(const struct nf_conn *ct)
+{
+	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip;
+}
+
+static inline const void *nf_ct_orig_ipv6_src(const struct nf_conn *ct)
+{
+	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip6;
+}
+
+static inline u_int32_t
+xt_cluster_hash_ipv4(u_int32_t ip, const struct xt_cluster_match_info *info)
+{
+	return jhash_1word(ip, info->hash_seed);
+}
+
+static inline u_int32_t
+xt_cluster_hash_ipv6(const void *ip, const struct xt_cluster_match_info *info)
+{
+	return jhash2(ip, NF_CT_TUPLE_L3SIZE / sizeof(__u32), info->hash_seed);
+}
+
+static inline u_int32_t
+xt_cluster_hash(const struct nf_conn *ct,
+		const struct xt_cluster_match_info *info)
+{
+	u_int32_t hash = 0;
+
+	switch(nf_ct_l3num(ct)) {
+	case AF_INET:
+		hash = xt_cluster_hash_ipv4(nf_ct_orig_ipv4_src(ct), info);
+		break;
+	case AF_INET6:
+		hash = xt_cluster_hash_ipv6(nf_ct_orig_ipv6_src(ct), info);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+	return (((u64)hash * info->total_nodes) >> 32);
+}
+
+static bool
+xt_cluster_mt(const struct sk_buff *skb, const struct xt_match_param *par)
+{
+	const struct xt_cluster_match_info *info = par->matchinfo;
+	const struct xt_cluster_internal *internal = info->data;
+	const struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	unsigned long hash;
+	bool inv = !!(info->flags & XT_CLUSTER_F_INV);
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL)
+		return false;
+
+	if (ct == &nf_conntrack_untracked)
+		return false;
+
+	if (ct->master)
+		hash = xt_cluster_hash(ct->master, info);
+	else
+		hash = xt_cluster_hash(ct, info);
+
+	return test_bit(hash, &internal->node_mask) ^ inv;
+}
+
+#ifdef CONFIG_PROC_FS
+static void *xt_cluster_seq_start(struct seq_file *s, loff_t *pos)
+{
+	if (*pos == 0) {
+		struct xt_cluster_internal *data =
+			(struct xt_cluster_internal *)s->private;
+
+		return &data->node_mask;
+	} else {
+		*pos = 0;
+		return NULL;
+	}
+}
+
+static void *xt_cluster_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return NULL;
+}
+
+static void xt_cluster_seq_stop(struct seq_file *s, void *v) {}
+
+static int xt_cluster_seq_show(struct seq_file *s, void *v)
+{
+	unsigned long *mask = (unsigned long *)v;
+	seq_printf(s, "0x%.8lx\n", *mask);
+	return 0;
+}
+
+static struct seq_operations xt_cluster_seq_ops = {
+	.start	= xt_cluster_seq_start,
+	.next	= xt_cluster_seq_next,
+	.stop	= xt_cluster_seq_stop,
+	.show	= xt_cluster_seq_show
+};
+
+#define XT_CLUSTER_PROC_WRITELEN	10
+
+static ssize_t 
+xt_cluster_write_proc(struct file *file, const char __user *input,
+		      size_t size, loff_t *ofs)
+{
+	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+        struct xt_cluster_internal *info = pde->data;
+	char buffer[XT_CLUSTER_PROC_WRITELEN+1];
+	unsigned int new_node_id;
+
+	if (copy_from_user(buffer, input, XT_CLUSTER_PROC_WRITELEN))
+		return -EFAULT;
+
+	switch(*buffer) {
+	case '+':
+		new_node_id = simple_strtoul(buffer+1, NULL, 10);
+		if (!new_node_id || new_node_id > sizeof(info->node_mask)*8)
+			return -EIO;
+		printk(KERN_NOTICE "cluster: adding node %u\n", new_node_id);
+		set_bit(new_node_id-1, &info->node_mask);
+		break;
+	case '-':
+		new_node_id = simple_strtoul(buffer+1, NULL, 10);
+		if (!new_node_id || new_node_id > sizeof(info->node_mask)*8)
+			return -EIO;
+		printk(KERN_NOTICE "cluster: deleting node %u\n", new_node_id);
+		clear_bit(new_node_id-1, &info->node_mask);
+		break;
+	default:
+		return -EIO;
+	}
+
+	return size;
+}
+
+static int xt_cluster_open_proc(struct inode *inode, struct file *file)
+{
+	int ret;
+	
+	ret = seq_open(file, &xt_cluster_seq_ops);
+	if (!ret) {
+		struct seq_file *seq = file->private_data;
+		const struct proc_dir_entry *pde = PDE(inode);
+		struct xt_cluster_match_info *info = pde->data;
+
+		seq->private = info;
+	}
+	return ret;
+};
+
+static struct proc_dir_entry *proc_cluster;
+static const struct file_operations xt_cluster_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= xt_cluster_open_proc,
+	.release	= seq_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.write		= xt_cluster_write_proc,
+};
+
+static bool
+xt_cluster_proc_entry_exist(struct proc_dir_entry *dir, const char *name)
+{
+	struct proc_dir_entry *tmp;
+
+	for (tmp = dir->subdir; tmp; tmp = tmp->next) {
+		if (strcmp(tmp->name, name) == 0)
+			return true;
+	}
+	return false;
+}
+
+static bool xt_cluster_proc_init(struct xt_cluster_match_info *info)
+{
+	struct xt_cluster_internal *internal = info->data;
+
+	BUG_ON(info->data == NULL);
+
+	if (xt_cluster_proc_entry_exist(proc_cluster, info->proc_name)) {
+		printk(KERN_ERR "xt_cluster: proc entry entry `%s' "
+				"already exists\n", info->proc_name);
+		return false;
+	}
+	internal->proc = proc_create_data(info->proc_name, 
+					  S_IWUSR|S_IRUSR, 
+					  proc_cluster,
+					  &xt_cluster_proc_fops, 
+					  info->data);
+	if (!internal->proc) {
+		printk(KERN_ERR "xt_cluster: cannot create proc entry `%s'\n",
+				info->proc_name);
+		return false;
+	}
+	return true;
+}
+#endif /* CONFIG_PROC_FS */
+
+static bool xt_cluster_internal_init(struct xt_cluster_match_info *info)
+{
+	struct xt_cluster_internal *data;
+
+	data = kzalloc(sizeof(struct xt_cluster_internal), GFP_KERNEL);
+	if (!data) {
+		printk(KERN_ERR "xt_cluster: OOM\n");
+		return false;
+	}
+	info->data = data;
+
+#ifdef CONFIG_PROC_FS
+	if (!xt_cluster_proc_init(info)) {
+		kfree(data);
+		return false;
+	}
+#endif
+	atomic_set(&data->use, 1);
+	data->node_mask = (1 << (info->node_id - 1));
+
+	return true;
+}
+
+static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
+{
+	struct xt_cluster_match_info *info = par->matchinfo;
+	struct xt_cluster_internal *data = info->data;
+
+	if (info->node_id > info->total_nodes) {
+		printk(KERN_ERR "xt_cluster: the id of this node cannot be "
+				"higher than the total number of nodes\n");
+		return false;
+	}
+
+	if (!info->data) {
+		if (!xt_cluster_internal_init(info))
+			return false;
+	} else
+		atomic_inc(&data->use);
+
+	return true;
+}
+
+static void xt_cluster_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	struct xt_cluster_match_info *info = par->matchinfo;
+	struct xt_cluster_internal *data = info->data;
+
+	if (atomic_dec_and_test(&data->use)) {
+#ifdef CONFIG_PROC_FS
+		remove_proc_entry(info->proc_name, proc_cluster);
+#endif
+		kfree(info->data);
+	}
+}
+
+static struct xt_match xt_cluster_match[] __read_mostly = {
+	{
+		.name		= "cluster",
+		.family		= AF_INET,
+		.match		= xt_cluster_mt,
+		.checkentry	= xt_cluster_mt_checkentry,
+		.destroy	= xt_cluster_mt_destroy,
+		.matchsize	= sizeof(struct xt_cluster_match_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "cluster",
+		.family		= AF_INET6,
+		.match		= xt_cluster_mt,
+		.checkentry	= xt_cluster_mt_checkentry,
+		.destroy	= xt_cluster_mt_destroy,
+		.matchsize	= sizeof(struct xt_cluster_match_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init xt_cluster_mt_init(void)
+{
+	int ret;
+
+#ifdef CONFIG_PROC_FS
+	proc_cluster = proc_mkdir("cluster", proc_net_netfilter);
+	if (!proc_cluster)
+		return -ENOMEM;
+#endif
+	ret = xt_register_matches(xt_cluster_match,
+				  ARRAY_SIZE(xt_cluster_match));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void __exit xt_cluster_mt_fini(void)
+{
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("cluster", proc_net_netfilter);
+#endif
+	xt_unregister_matches(xt_cluster_match, ARRAY_SIZE(xt_cluster_match));
+}
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Xtables: xt_cluster match");
+MODULE_ALIAS("ipt_cluster");
+MODULE_ALIAS("ip6t_cluster");
+module_init(xt_cluster_mt_init);
+module_exit(xt_cluster_mt_fini);

