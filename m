From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_nat tree updated
Date: Fri, 24 Nov 2006 09:16:09 +0100
Message-ID: <4566AA49.5020706@trash.net>
References: <4565C47E.3030907@trash.net>	<Pine.LNX.4.64.0611240036380.21966@blackhole.kfki.hu>
	<45669021.8060109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090407090105050400060408"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <45669021.8060109@trash.net>
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

This is a multi-part message in MIME format.
--------------090407090105050400060408
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Jozsef Kadlecsik wrote:
> 
>>>- /proc-compatibility: since the plan is to get rid of the
>>> old IPv4-only connection tracking ASAP, we need to think
>>> of something to keep old scripts fiddling with /proc-files
>>> working. So we probably need to do some symlinking (is that
>>> possible?) of the old net/ipv4/netfilter files or just keep
>>> the around as normal files. 
>>
>>
>>As I see symlinking is not possible, so we have to keep the old files.
>>
>>
>>> And we need a /proc/net/ip_conntrack that only shows IPv4 entries I 
>>> suppose.
>>
>>
>>Yes! Missing /proc/net/ip_conntrack could break a lot of scripts.
> 
> 
> I'll take care of the proc files.

This is a first attempt - its quite ugly because of all the
new exports it needs. But even worse - what should we do about
proc entries added by modules, like the SCTP protocol module?
Should we just put this in nf_conntrack_standalone or in case
of SCTP in the module itself?


--------------090407090105050400060408
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 6b01ba2..33908a1 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -52,6 +52,19 @@ struct ip_ct_tcp
 	u_int16_t	last_win;	/* Last window advertisement seen in dir */
 };
 
+extern unsigned int nf_ct_tcp_timeout_syn_sent;
+extern unsigned int nf_ct_tcp_timeout_syn_recv;
+extern unsigned int nf_ct_tcp_timeout_established;
+extern unsigned int nf_ct_tcp_timeout_fin_wait;
+extern unsigned int nf_ct_tcp_timeout_close_wait;
+extern unsigned int nf_ct_tcp_timeout_last_ack;
+extern unsigned int nf_ct_tcp_timeout_time_wait;
+extern unsigned int nf_ct_tcp_timeout_close;
+extern unsigned int nf_ct_tcp_timeout_max_retrans;
+extern int nf_ct_tcp_loose; 
+extern int nf_ct_tcp_be_liberal;
+extern int nf_ct_tcp_max_retrans;
+
 #endif /* __KERNEL__ */
 
 #endif /* _NF_CONNTRACK_TCP_H */
diff --git a/include/linux/netfilter/nf_conntrack_udp.h b/include/linux/netfilter/nf_conntrack_udp.h
new file mode 100644
index 0000000..54f0753
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_udp.h
@@ -0,0 +1,7 @@
+#ifndef _NF_CONNTRACK_PROTO_UDP
+#define _NF_CONNTRACK_PROTO_UDP
+
+extern unsigned int nf_ct_udp_timeout;
+extern unsigned int nf_ct_udp_timeout_stream;
+
+#endif /* _NF_CONNTRACK_PROTO_UDP */
diff --git a/include/net/netfilter/ipv4/nf_conntrack_icmp.h b/include/net/netfilter/ipv4/nf_conntrack_icmp.h
index 3dd22cf..e8567d7 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_icmp.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_icmp.h
@@ -8,4 +8,7 @@ struct ip_ct_icmp
 	/* Optimization: when number in == number out, forget immediately. */
 	atomic_t count;
 };
+
+extern unsigned long nf_ct_icmp_timeout;
+
 #endif /* _NF_CONNTRACK_ICMP_H */
diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index e9455e8..63571c3 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -33,4 +33,7 @@ #endif /* CONFIG_NF_NAT_NEEDED */
 struct sk_buff *
 nf_ct_ipv4_ct_gather_frags(struct sk_buff *skb);
 
+extern int nf_conntrack_compat_init(void);
+extern void nf_conntrack_compat_fini(void);
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f2a4946..3433ef4 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -20,6 +20,7 @@ #include <linux/compiler.h>
 #include <asm/atomic.h>
 
 #include <linux/netfilter/nf_conntrack_tcp.h>
+#include <linux/netfilter/nf_conntrack_udp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
 #include <net/netfilter/ipv4/nf_conntrack_icmp.h>
@@ -247,7 +248,12 @@ static inline int nf_ct_is_dying(struct 
 
 extern unsigned int nf_conntrack_htable_size;
 extern int nf_conntrack_checksum;
+extern atomic_t nf_conntrack_count;
+extern int nf_conntrack_max;
 
+extern unsigned int nf_ct_generic_timeout;
+
+DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 #define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
 
 /* no helper, no nat */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 20fa890..8de32bc 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -19,6 +19,17 @@ config NF_CONNTRACK_IPV4
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_IPV4_COMPAT
+	bool "/proc compatibility with IPv4-only connection tracking"
+	depends on NF_CONNTRACK && PROC_FS
+	default y
+	help
+	  When this option is enabled, the connection tracking controls
+	  under /proc/sys/net/netfilter will additionally be available
+	  under their old names in /proc/sys/net/ipv4/netfilter.
+
+	  If unsure, say Y.
+
 # connection tracking, helpers and protocols
 config IP_NF_CT_ACCT
 	bool "Connection tracking flow accounting"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index f9bc5c7..05151ea 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -107,6 +107,9 @@ obj-$(CONFIG_IP_NF_QUEUE) += ip_queue.o
 
 # objects for l3 independent conntrack
 nf_conntrack_ipv4-objs  :=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
+ifneq ($(CONFIG_NF_CONNTRACK_IPV4_COMPAT),)
+nf_conntrack_ipv4-objs	+= nf_conntrack_l3proto_ipv4_compat.o
+endif
 
 # l3 independent conntrack
 obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 3f2a517..cac40f5 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -38,8 +38,6 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_PER_CPU(struct nf_conntrack_stat, nf_conntrack_stat);
-
 static int ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
@@ -269,8 +267,6 @@ static struct nf_hook_ops ipv4_conntrack
 };
 
 #ifdef CONFIG_SYSCTL
-/* From nf_conntrack_proto_icmp.c */
-extern unsigned int nf_ct_icmp_timeout;
 static struct ctl_table_header *nf_ct_ipv4_sysctl_header;
 
 static ctl_table nf_ct_sysctl_table[] = {
@@ -487,8 +483,19 @@ #ifdef CONFIG_SYSCTL
 		goto cleanup_hooks;
 	}
 #endif
+#ifdef CONFIG_NF_CONNTRACK_IPV4_COMPAT
+	ret = nf_conntrack_compat_init();
+	if (ret < 0)
+		goto cleanup_sysctl;
+#endif
 	return ret;
 
+#ifdef CONFIG_NF_CONNTRACK_IPV4_COMPAT
+ cleanup_sysctl:
+#ifdef CONFIG_SYSCTL
+ 	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
+#endif
+#endif
 #ifdef CONFIG_SYSCTL
  cleanup_hooks:
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
@@ -509,6 +516,9 @@ #endif
 static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 {
 	synchronize_net();
+#ifdef CONFIG_NF_CONNTRACK_IPV4_COMPAT
+	nf_conntrack_compat_fini();
+#endif
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
 #endif
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
new file mode 100644
index 0000000..fe16934
--- /dev/null
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -0,0 +1,654 @@
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
+#ifdef CONFIG_SYSCTL
+#include <linux/sysctl.h>
+#endif
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
+#ifdef CONFIG_SYSCTL
+
+/* From ip_conntrack_proto_icmp.c */
+extern unsigned int ip_ct_icmp_timeout;
+
+/* Log invalid packets of a given protocol */
+static int log_invalid_proto_min = 0;
+static int log_invalid_proto_max = 255;
+
+static struct ctl_table_header *ip_ct_sysctl_header;
+
+static ctl_table ip_ct_sysctl_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_MAX,
+		.procname	= "ip_conntrack_max",
+		.data		= &nf_conntrack_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_COUNT,
+		.procname	= "ip_conntrack_count",
+		.data		= &nf_conntrack_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_BUCKETS,
+		.procname	= "ip_conntrack_buckets",
+		.data		= &nf_conntrack_htable_size,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_CHECKSUM,
+		.procname	= "ip_conntrack_checksum",
+		.data		= &nf_conntrack_checksum,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
+		.procname	= "ip_conntrack_tcp_timeout_syn_sent",
+		.data		= &nf_ct_tcp_timeout_syn_sent,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV,
+		.procname	= "ip_conntrack_tcp_timeout_syn_recv",
+		.data		= &nf_ct_tcp_timeout_syn_recv,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_ESTABLISHED,
+		.procname	= "ip_conntrack_tcp_timeout_established",
+		.data		= &nf_ct_tcp_timeout_established,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_FIN_WAIT,
+		.procname	= "ip_conntrack_tcp_timeout_fin_wait",
+		.data		= &nf_ct_tcp_timeout_fin_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE_WAIT,
+		.procname	= "ip_conntrack_tcp_timeout_close_wait",
+		.data		= &nf_ct_tcp_timeout_close_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_LAST_ACK,
+		.procname	= "ip_conntrack_tcp_timeout_last_ack",
+		.data		= &nf_ct_tcp_timeout_last_ack,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_TIME_WAIT,
+		.procname	= "ip_conntrack_tcp_timeout_time_wait",
+		.data		= &nf_ct_tcp_timeout_time_wait,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_CLOSE,
+		.procname	= "ip_conntrack_tcp_timeout_close",
+		.data		= &nf_ct_tcp_timeout_close,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT,
+		.procname	= "ip_conntrack_udp_timeout",
+		.data		= &nf_ct_udp_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT_STREAM,
+		.procname	= "ip_conntrack_udp_timeout_stream",
+		.data		= &nf_ct_udp_timeout_stream,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT,
+		.procname	= "ip_conntrack_icmp_timeout",
+		.data		= &nf_ct_icmp_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT,
+		.procname	= "ip_conntrack_generic_timeout",
+		.data		= &nf_ct_generic_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_LOG_INVALID,
+		.procname	= "ip_conntrack_log_invalid",
+		.data		= &nf_ct_log_invalid,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &log_invalid_proto_min,
+		.extra2		= &log_invalid_proto_max,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS,
+		.procname	= "ip_conntrack_tcp_timeout_max_retrans",
+		.data		= &nf_ct_tcp_timeout_max_retrans,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_LOOSE,
+		.procname	= "ip_conntrack_tcp_loose",
+		.data		= &nf_ct_tcp_loose,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL,
+		.procname	= "ip_conntrack_tcp_be_liberal",
+		.data		= &nf_ct_tcp_be_liberal,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS,
+		.procname	= "ip_conntrack_tcp_max_retrans",
+		.data		= &nf_ct_tcp_max_retrans,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{ .ctl_name = 0 }
+};
+
+#define NET_IP_CONNTRACK_MAX 2089
+
+static ctl_table ip_ct_netfilter_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NETFILTER,
+		.procname	= "netfilter",
+		.mode		= 0555,
+		.child		= ip_ct_sysctl_table,
+	},
+	{
+		.ctl_name	= NET_IP_CONNTRACK_MAX,
+		.procname	= "ip_conntrack_max",
+		.data		= &nf_conntrack_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table ip_ct_ipv4_table[] = {
+	{
+		.ctl_name	= NET_IPV4,
+		.procname	= "ipv4",
+		.mode		= 0555,
+		.child		= ip_ct_netfilter_table,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table ip_ct_net_table[] = {
+	{
+		.ctl_name	= CTL_NET,
+		.procname	= "net",
+		.mode		= 0555,
+		.child		= ip_ct_ipv4_table,
+	},
+	{ .ctl_name = 0 }
+};
+#endif /* CONFIG_SYSCTL */
+
+int __init nf_conntrack_compat_init(void)
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
+#ifdef CONFIG_SYSCTL
+	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table, 0);
+	if (ip_ct_sysctl_header == NULL)
+		goto err4;
+#endif
+	return 0;
+
+#ifdef CONFIG_SYSCTL
+err4:
+	remove_proc_entry("ip_conntrack", proc_net_stat);
+#endif
+err3:
+	proc_net_remove("ip_conntrack_expect");
+err2:
+	proc_net_remove("ip_conntrack");
+err1:
+	return -ENOMEM;
+}
+
+void __exit nf_conntrack_compat_fini(void)
+{
+#ifdef CONFIG_SYSCTL
+	unregister_sysctl_table(ip_ct_sysctl_header);
+#endif
+	remove_proc_entry("ip_conntrack", proc_net_stat);
+	proc_net_remove("ip_conntrack_expect");
+	proc_net_remove("ip_conntrack");
+}
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index cdbba44..4699406 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -43,8 +43,6 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
-
 static int ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b9cca48..c9bb836 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -66,10 +66,12 @@ DEFINE_RWLOCK(nf_conntrack_lock);
 
 /* nf_conntrack_standalone needs this */
 atomic_t nf_conntrack_count = ATOMIC_INIT(0);
+EXPORT_SYMBOL_GPL(nf_conntrack_count);
 
 void (*nf_conntrack_destroyed)(struct nf_conn *conntrack) = NULL;
 unsigned int nf_conntrack_htable_size __read_mostly;
 int nf_conntrack_max __read_mostly;
+EXPORT_SYMBOL_GPL(nf_conntrack_max);
 struct list_head *nf_conntrack_hash __read_mostly;
 struct nf_conn nf_conntrack_untracked __read_mostly;
 unsigned int nf_ct_log_invalid __read_mostly;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e1d4f66..fce9a4e 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -28,7 +28,6 @@ #include <net/netfilter/nf_conntrack_tup
 
 LIST_HEAD(nf_conntrack_expect_list);
 kmem_cache_t *nf_conntrack_expect_cachep __read_mostly;
-DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 static unsigned int nf_conntrack_expect_next_id;
 
 /* nf_conntrack_expect helper functions */
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 1852c9d..a3d31c3 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -37,8 +37,6 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_PER_CPU(struct nf_conntrack_stat, nf_conntrack_stat);
-
 static int generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 				struct nf_conntrack_tuple *tuple)
 {
@@ -94,3 +92,4 @@ struct nf_conntrack_l3proto nf_conntrack
 	.prepare	 = generic_prepare,
 	.get_features	 = generic_get_features,
 };
+EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_generic);
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index f44811e..2d604e7 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -18,6 +18,7 @@ #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 
 unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
+EXPORT_SYMBOL_GPL(nf_ct_generic_timeout);
 
 static int generic_pkt_to_tuple(const struct sk_buff *skb,
 				unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 86a19cd..e88ed75 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -59,6 +59,7 @@ static DEFINE_RWLOCK(tcp_lock);
     be liberal in what you accept from others." 
     If it's non-zero, we mark only out of window RST segments as INVALID. */
 int nf_ct_tcp_be_liberal __read_mostly = 0;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_be_liberal);
 
 /* When connection is picked up from the middle, how many packets are required
    to pass in each direction when we assume we are in sync - if any side uses
@@ -66,11 +67,13 @@ int nf_ct_tcp_be_liberal __read_mostly =
    If it is set to zero, we disable picking up already established 
    connections. */
 int nf_ct_tcp_loose __read_mostly = 3;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_loose);
 
 /* Max number of the retransmitted packets without receiving an (acceptable) 
    ACK from the destination. If this number is reached, a shorter timer 
    will be started. */
 int nf_ct_tcp_max_retrans __read_mostly = 3;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_max_retrans);
 
   /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
      closely.  They're more complex. --RR */
@@ -94,18 +97,27 @@ #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
 
 unsigned int nf_ct_tcp_timeout_syn_sent __read_mostly =      2 MINS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_syn_sent);
 unsigned int nf_ct_tcp_timeout_syn_recv __read_mostly =     60 SECS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_syn_recv);
 unsigned int nf_ct_tcp_timeout_established __read_mostly =   5 DAYS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_established);
 unsigned int nf_ct_tcp_timeout_fin_wait __read_mostly =      2 MINS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_fin_wait);
 unsigned int nf_ct_tcp_timeout_close_wait __read_mostly =   60 SECS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_close_wait);
 unsigned int nf_ct_tcp_timeout_last_ack __read_mostly =     30 SECS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_last_ack);
 unsigned int nf_ct_tcp_timeout_time_wait __read_mostly =     2 MINS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_time_wait);
 unsigned int nf_ct_tcp_timeout_close __read_mostly =        10 SECS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_close);
 
 /* RFC1122 says the R2 limit should be at least 100 seconds.
    Linux uses 15 packets as limit, which corresponds 
    to ~13-30min depending on RTO. */
 unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly =   5 MINS;
+EXPORT_SYMBOL_GPL(nf_ct_tcp_timeout_max_retrans);
  
 static unsigned int * tcp_timeouts[]
 = { NULL,                              /* TCP_CONNTRACK_NONE */
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 200d7d3..52e3f11 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -30,7 +30,9 @@ #include <net/netfilter/nf_conntrack_l4p
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
+EXPORT_SYMBOL_GPL(nf_ct_udp_timeout);
 unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
+EXPORT_SYMBOL_GPL(nf_ct_udp_timeout_stream);
 
 static int udp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2e1a88e..2624bf2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -44,9 +44,6 @@ #endif
 
 MODULE_LICENSE("GPL");
 
-extern atomic_t nf_conntrack_count;
-DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
-
 #ifdef CONFIG_PROC_FS
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
@@ -55,6 +52,7 @@ print_tuple(struct seq_file *s, const st
 {
 	return l3proto->print_tuple(s, tuple) || l4proto->print_tuple(s, tuple);
 }
+EXPORT_SYMBOL_GPL(print_tuple);
 
 #ifdef CONFIG_NF_CT_ACCT
 static unsigned int
@@ -334,31 +332,6 @@ int nf_conntrack_checksum __read_mostly 
 
 #ifdef CONFIG_SYSCTL
 
-/* From nf_conntrack_core.c */
-extern int nf_conntrack_max;
-extern unsigned int nf_conntrack_htable_size;
-
-/* From nf_conntrack_proto_tcp.c */
-extern unsigned int nf_ct_tcp_timeout_syn_sent;
-extern unsigned int nf_ct_tcp_timeout_syn_recv;
-extern unsigned int nf_ct_tcp_timeout_established;
-extern unsigned int nf_ct_tcp_timeout_fin_wait;
-extern unsigned int nf_ct_tcp_timeout_close_wait;
-extern unsigned int nf_ct_tcp_timeout_last_ack;
-extern unsigned int nf_ct_tcp_timeout_time_wait;
-extern unsigned int nf_ct_tcp_timeout_close;
-extern unsigned int nf_ct_tcp_timeout_max_retrans;
-extern int nf_ct_tcp_loose;
-extern int nf_ct_tcp_be_liberal;
-extern int nf_ct_tcp_max_retrans;
-
-/* From nf_conntrack_proto_udp.c */
-extern unsigned int nf_ct_udp_timeout;
-extern unsigned int nf_ct_udp_timeout_stream;
-
-/* From nf_conntrack_proto_generic.c */
-extern unsigned int nf_ct_generic_timeout;
-
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min = 0;
 static int log_invalid_proto_max = 255;

--------------090407090105050400060408--
