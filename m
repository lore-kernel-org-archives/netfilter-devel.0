From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/05]: nf_conntrack: /proc compatibility with old
	connection tracking
Date: Sun, 26 Nov 2006 15:44:55 +0100 (MET)
Message-ID: <20061126144455.4215.13382.sendpatchset@localhost.localdomain>
References: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: /proc compatibility with old connection tracking

This patch adds /proc/net/ip_conntrack, /proc/net/ip_conntrack_expect and
/proc/net/stat/ip_conntrack files to keep old programs using them working.

The /proc/net/ip_conntrack and /proc/net/ip_conntrack_expect files show only
IPv4 entries, the /proc/net/stat/ip_conntrack shows global statistics.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7ea75129c8e4f4aec73f7c6b1bb5b3abfe0df498
tree 43de09d262fbe45cac2161d34fefc898ac82e95b
parent 143277a143b7c61beb1d5d6640354e2c64a3a4b6
author Patrick McHardy <kaber@trash.net> Sun, 26 Nov 2006 15:39:34 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 26 Nov 2006 15:39:34 +0100

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h     |    3 
 net/ipv4/netfilter/Makefile                        |    5 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   13 +
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |  412 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_l3proto_generic.c       |    1 
 net/netfilter/nf_conntrack_standalone.c            |    1 
 6 files changed, 434 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 8c4f7e8..34b453a 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -41,4 +41,7 @@ extern struct nf_conntrack_l4proto nf_co
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 
+extern int nf_conntrack_ipv4_compat_init(void);
+extern void nf_conntrack_ipv4_compat_fini(void);
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 76d56b4..21359d8 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -88,6 +88,11 @@ obj-$(CONFIG_IP_NF_QUEUE) += ip_queue.o
 
 # objects for l3 independent conntrack
 nf_conntrack_ipv4-objs  :=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
+ifeq ($(CONFIG_NF_CONNTRACK_PROC_COMPAT),y)
+ifeq ($(CONFIG_PROC_FS),y)
+nf_conntrack_ipv4-objs	+= nf_conntrack_l3proto_ipv4_compat.o
+endif
+endif
 
 # l3 independent conntrack
 obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index bcec682..dd595b8 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -492,8 +492,16 @@ static int __init nf_conntrack_l3proto_i
 		printk("nf_conntrack_ipv4: can't register hooks.\n");
 		goto cleanup_ipv4;
 	}
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	ret = nf_conntrack_ipv4_compat_init();
+	if (ret < 0)
+		goto cleanup_hooks;
+#endif
 	return ret;
-
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+ cleanup_hooks:
+ 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
+#endif
  cleanup_ipv4:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
  cleanup_icmp:
@@ -510,6 +518,9 @@ static int __init nf_conntrack_l3proto_i
 static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 {
 	synchronize_net();
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	nf_conntrack_ipv4_compat_fini();
+#endif
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_icmp);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
new file mode 100644
index 0000000..8fce55c
--- /dev/null
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -0,0 +1,412 @@
+/* ip_conntrack proc compat - based on ip_conntrack_standalone.c
+ *
+ * (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/types.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/percpu.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_l3proto.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+#ifdef CONFIG_IP_NF_CT_ACCT
+static unsigned int
+seq_print_counters(struct seq_file *s,
+		   const struct nf_conntrack_counter *counter)
+{
+	return seq_printf(s, "packets=%llu bytes=%llu ",
+			  (unsigned long long)counter->packets,
+			  (unsigned long long)counter->bytes);
+}
+#else
+#define seq_print_counters(x, y)	0
+#endif
+
+struct ct_iter_state {
+	unsigned int bucket;
+};
+
+static struct list_head *ct_get_first(struct seq_file *seq)
+{
+	struct ct_iter_state *st = seq->private;
+
+	for (st->bucket = 0;
+	     st->bucket < nf_conntrack_htable_size;
+	     st->bucket++) {
+		if (!list_empty(&nf_conntrack_hash[st->bucket]))
+			return nf_conntrack_hash[st->bucket].next;
+	}
+	return NULL;
+}
+
+static struct list_head *ct_get_next(struct seq_file *seq, struct list_head *head)
+{
+	struct ct_iter_state *st = seq->private;
+
+	head = head->next;
+	while (head == &nf_conntrack_hash[st->bucket]) {
+		if (++st->bucket >= nf_conntrack_htable_size)
+			return NULL;
+		head = nf_conntrack_hash[st->bucket].next;
+	}
+	return head;
+}
+
+static struct list_head *ct_get_idx(struct seq_file *seq, loff_t pos)
+{
+	struct list_head *head = ct_get_first(seq);
+
+	if (head)
+		while (pos && (head = ct_get_next(seq, head)))
+			pos--;
+	return pos ? NULL : head;
+}
+
+static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	read_lock_bh(&nf_conntrack_lock);
+	return ct_get_idx(seq, *pos);
+}
+
+static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return ct_get_next(s, v);
+}
+
+static void ct_seq_stop(struct seq_file *s, void *v)
+{
+	read_unlock_bh(&nf_conntrack_lock);
+}
+
+static int ct_seq_show(struct seq_file *s, void *v)
+{
+	const struct nf_conntrack_tuple_hash *hash = v;
+	const struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(hash);
+	struct nf_conntrack_l3proto *l3proto;
+	struct nf_conntrack_l4proto *l4proto;
+
+	NF_CT_ASSERT(ct);
+
+	/* we only want to print DIR_ORIGINAL */
+	if (NF_CT_DIRECTION(hash))
+		return 0;
+	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num != AF_INET)
+		return 0;
+
+	l3proto = __nf_ct_l3proto_find(ct->tuplehash[IP_CT_DIR_ORIGINAL]
+				       .tuple.src.l3num);
+	NF_CT_ASSERT(l3proto);
+	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_ORIGINAL]
+				       .tuple.src.l3num,
+				       ct->tuplehash[IP_CT_DIR_ORIGINAL]
+				       .tuple.dst.protonum);
+	NF_CT_ASSERT(l4proto);
+
+	if (seq_printf(s, "%-8s %u %ld ",
+		      l4proto->name,
+		      ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
+		      timer_pending(&ct->timeout)
+		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
+		return -ENOSPC;
+
+	if (l3proto->print_conntrack(s, ct))
+		return -ENOSPC;
+
+	if (l4proto->print_conntrack(s, ct))
+		return -ENOSPC;
+
+	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+			l3proto, l4proto))
+		return -ENOSPC;
+
+ 	if (seq_print_counters(s, &ct->counters[IP_CT_DIR_ORIGINAL]))
+		return -ENOSPC;
+
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
+		if (seq_printf(s, "[UNREPLIED] "))
+			return -ENOSPC;
+
+	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
+			l3proto, l4proto))
+		return -ENOSPC;
+
+ 	if (seq_print_counters(s, &ct->counters[IP_CT_DIR_REPLY]))
+		return -ENOSPC;
+
+	if (test_bit(IPS_ASSURED_BIT, &ct->status))
+		if (seq_printf(s, "[ASSURED] "))
+			return -ENOSPC;
+
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+	if (seq_printf(s, "mark=%u ", ct->mark))
+		return -ENOSPC;
+#endif
+
+#ifdef CONFIG_IP_NF_CONNTRACK_SECMARK
+	if (seq_printf(s, "secmark=%u ", ct->secmark))
+		return -ENOSPC;
+#endif
+
+	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
+		return -ENOSPC;
+
+	return 0;
+}
+
+static struct seq_operations ct_seq_ops = {
+	.start = ct_seq_start,
+	.next  = ct_seq_next,
+	.stop  = ct_seq_stop,
+	.show  = ct_seq_show
+};
+
+static int ct_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq;
+	struct ct_iter_state *st;
+	int ret;
+
+	st = kmalloc(sizeof(struct ct_iter_state), GFP_KERNEL);
+	if (st == NULL)
+		return -ENOMEM;
+	ret = seq_open(file, &ct_seq_ops);
+	if (ret)
+		goto out_free;
+	seq          = file->private_data;
+	seq->private = st;
+	memset(st, 0, sizeof(struct ct_iter_state));
+	return ret;
+out_free:
+	kfree(st);
+	return ret;
+}
+
+static struct file_operations ct_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = ct_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release_private,
+};
+
+/* expects */
+static void *exp_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct list_head *e = &nf_conntrack_expect_list;
+	loff_t i;
+
+	/* strange seq_file api calls stop even if we fail,
+	 * thus we need to grab lock since stop unlocks */
+	read_lock_bh(&nf_conntrack_lock);
+
+	if (list_empty(e))
+		return NULL;
+
+	for (i = 0; i <= *pos; i++) {
+		e = e->next;
+		if (e == &nf_conntrack_expect_list)
+			return NULL;
+	}
+	return e;
+}
+
+static void *exp_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+ 	struct list_head *e = v;
+
+	++*pos;
+	e = e->next;
+
+	if (e == &nf_conntrack_expect_list)
+		return NULL;
+
+	return e;
+}
+
+static void exp_seq_stop(struct seq_file *s, void *v)
+{
+	read_unlock_bh(&nf_conntrack_lock);
+}
+
+static int exp_seq_show(struct seq_file *s, void *v)
+{
+	struct nf_conntrack_expect *exp = v;
+
+	if (exp->tuple.src.l3num != AF_INET)
+		return 0;
+
+	if (exp->timeout.function)
+		seq_printf(s, "%ld ", timer_pending(&exp->timeout)
+			   ? (long)(exp->timeout.expires - jiffies)/HZ : 0);
+	else
+		seq_printf(s, "- ");
+
+	seq_printf(s, "proto=%u ", exp->tuple.dst.protonum);
+
+	print_tuple(s, &exp->tuple,
+		    __nf_ct_l3proto_find(exp->tuple.src.l3num),
+		    __nf_ct_l4proto_find(exp->tuple.src.l3num,
+		    			 exp->tuple.dst.protonum));
+	return seq_putc(s, '\n');
+}
+
+static struct seq_operations exp_seq_ops = {
+	.start = exp_seq_start,
+	.next = exp_seq_next,
+	.stop = exp_seq_stop,
+	.show = exp_seq_show
+};
+
+static int exp_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &exp_seq_ops);
+}
+
+static struct file_operations ip_exp_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = exp_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release
+};
+
+static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	int cpu;
+
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	for (cpu = *pos-1; cpu < NR_CPUS; ++cpu) {
+		if (!cpu_possible(cpu))
+			continue;
+		*pos = cpu+1;
+		return &per_cpu(nf_conntrack_stat, cpu);
+	}
+
+	return NULL;
+}
+
+static void *ct_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	int cpu;
+
+	for (cpu = *pos; cpu < NR_CPUS; ++cpu) {
+		if (!cpu_possible(cpu))
+			continue;
+		*pos = cpu+1;
+		return &per_cpu(nf_conntrack_stat, cpu);
+	}
+
+	return NULL;
+}
+
+static void ct_cpu_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int ct_cpu_seq_show(struct seq_file *seq, void *v)
+{
+	unsigned int nr_conntracks = atomic_read(&nf_conntrack_count);
+	struct ip_conntrack_stat *st = v;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_printf(seq, "entries  searched found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete\n");
+		return 0;
+	}
+
+	seq_printf(seq, "%08x  %08x %08x %08x %08x %08x %08x %08x "
+			"%08x %08x %08x %08x %08x  %08x %08x %08x \n",
+		   nr_conntracks,
+		   st->searched,
+		   st->found,
+		   st->new,
+		   st->invalid,
+		   st->ignore,
+		   st->delete,
+		   st->delete_list,
+		   st->insert,
+		   st->insert_failed,
+		   st->drop,
+		   st->early_drop,
+		   st->error,
+
+		   st->expect_new,
+		   st->expect_create,
+		   st->expect_delete
+		);
+	return 0;
+}
+
+static struct seq_operations ct_cpu_seq_ops = {
+	.start  = ct_cpu_seq_start,
+	.next   = ct_cpu_seq_next,
+	.stop   = ct_cpu_seq_stop,
+	.show   = ct_cpu_seq_show,
+};
+
+static int ct_cpu_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &ct_cpu_seq_ops);
+}
+
+static struct file_operations ct_cpu_seq_fops = {
+	.owner   = THIS_MODULE,
+	.open    = ct_cpu_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release_private,
+};
+
+int __init nf_conntrack_ipv4_compat_init(void)
+{
+	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
+
+	proc = proc_net_fops_create("ip_conntrack", 0440, &ct_file_ops);
+	if (!proc)
+		goto err1;
+
+	proc_exp = proc_net_fops_create("ip_conntrack_expect", 0440,
+					&ip_exp_file_ops);
+	if (!proc_exp)
+		goto err2;
+
+	proc_stat = create_proc_entry("ip_conntrack", S_IRUGO, proc_net_stat);
+	if (!proc_stat)
+		goto err3;
+
+	proc_stat->proc_fops = &ct_cpu_seq_fops;
+	proc_stat->owner = THIS_MODULE;
+
+	return 0;
+
+err3:
+	proc_net_remove("ip_conntrack_expect");
+err2:
+	proc_net_remove("ip_conntrack");
+err1:
+	return -ENOMEM;
+}
+
+void __exit nf_conntrack_ipv4_compat_fini(void)
+{
+	remove_proc_entry("ip_conntrack", proc_net_stat);
+	proc_net_remove("ip_conntrack_expect");
+	proc_net_remove("ip_conntrack");
+}
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 3124b3a..a3d31c3 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -92,3 +92,4 @@ struct nf_conntrack_l3proto nf_conntrack
 	.prepare	 = generic_prepare,
 	.get_features	 = generic_get_features,
 };
+EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_generic);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9d89068..3db24f4 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -52,6 +52,7 @@ print_tuple(struct seq_file *s, const st
 {
 	return l3proto->print_tuple(s, tuple) || l4proto->print_tuple(s, tuple);
 }
+EXPORT_SYMBOL_GPL(print_tuple);
 
 #ifdef CONFIG_NF_CT_ACCT
 static unsigned int
