From: Josh Samuelson <josamue1@wsc.edu>
Subject: [PATCH 1/2] flow match
Date: Tue, 28 Jun 2005 18:49:12 -0500
Message-ID: <20050628234912.GB23662@wsc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings all,

This patch requires Pablo Neira's conntrack event API patch.  It's been
many months since I've posted, but I've been tracking the changes that
have been made and making the necessary revisions to the code.
Thanks Pablo for the heads-up on my silly misuses of the locks,
hopefully I've got those cleared up. :)  I also added the ability to
track new and established flows to the module.  Also I used
Patrick McHardy's iterative state method of looping over the hashes
for the proc files.  I figured it was high time to submit it again.

Quoting the man page for the match:

  This module allows you to match a packet when the specified number of
  known protocol connections is exceeded.  The matches can be made
  against generic IP, ICMP, TCP or UDP flow counters.  This match can be
  used in all tables but raw.

  Matches when >= n flows exist

  --DIR-PROTOCOL[-TYPE] [!] n
      where DIR is orig or repl for original and reply directions
      respectively.  PROTOCOL is ip, icmp, tcp or udp.  TYPE is n or
      e.  TYPE n is for new connections.  TYPE e is for established
      connections.  Specifying no TYPE results in the comparison being
      made for all PROTOCOL connections regardless of TYPE.

The patch should apply to 2.6.12 and iptables v1.3.1.  Though I'll
be away from my email for the next week, I would appreciate any
feedback.  Questions?  Comments?  Useful/Not?

Cheers,
Josh

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-flow-20050628.diff"

diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_flow.h b/include/linux/netfilter_ipv4/ip_conntrack_flow.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_flow.h	1969-12-31 18:00:00.000000000 -0600
+++ b/include/linux/netfilter_ipv4/ip_conntrack_flow.h	2005-06-28 13:09:39.000000000 -0500
@@ -0,0 +1,68 @@
+#ifndef _IP_CONNTRACK_FLOW_H
+#define _IP_CONNTRACK_FLOW_H
+
+#define PROC_NAME_ORIG "ip_conntrack_flow_orig"
+#define PROC_NAME_REPL "ip_conntrack_flow_repl"
+#define INCREMENT_WITHOUT_OVERFLOW(c) if (c < ((1 << (sizeof(c) * 8)) - 1)) c++
+
+enum { IPCT_NONE };
+
+typedef enum {
+	INITIALIZE,
+	MISSING_ORIG_BIT = 0,
+	MISSING_ORIG = (1 << MISSING_ORIG_BIT),
+	MISSING_REPL_BIT = 1,
+	MISSING_REPL = (1 << MISSING_REPL_BIT),
+	MISSING_MASK = (MISSING_ORIG | MISSING_REPL),
+	ALLOC_ORIG_BIT = 2,
+	ALLOC_ORIG = (1 << ALLOC_ORIG_BIT),
+	ALLOC_REPL_BIT = 3,
+	ALLOC_REPL = (1 << ALLOC_REPL_BIT),
+	ALLOC_MASK = (ALLOC_ORIG | ALLOC_REPL),
+	SC_NULL_BIT = 4,
+	SC_NULL = (1 << SC_NULL_BIT)
+} ipct_flow_counter_error_t; 
+
+struct ipct_flow_status_cache
+{
+	struct ip_conntrack *ct;
+	unsigned long status;
+	struct list_head dir[IP_CT_DIR_MAX];
+};
+
+/* A `ipct_flow' is a structure containing the IP connection count
+ * on various IP protocols.
+ * _n is for new connections
+ * _e is for established connections
+ */
+
+struct ipct_flow
+{
+	struct list_head list,
+			 sc;
+	u_int32_t ip;
+	u_int16_t ip_n,
+		  ip_e,
+		  icmp_n,
+		  icmp_e,
+		  tcp_n,
+		  tcp_e,
+		  udp_n,
+		  udp_e;
+};
+
+struct ipct_flow_notifier_data
+{
+	struct ip_conntrack *ct;
+	unsigned long new_status;
+};
+
+extern struct list_head *ipct_flow_orig_hash,
+			*ipct_flow_repl_hash;
+extern unsigned int ipct_flow_htable_size;
+extern rwlock_t ipct_flow_lock;
+extern int ipct_flow_register_notifier(struct notifier_block *nb);
+extern int ipct_flow_unregister_notifier(struct notifier_block *nb);
+extern u_int32_t ip_hash_flow_ip(u_int32_t ip);
+
+#endif /* _IP_CONNTRACK_FLOW_H */
diff -Nru a/include/linux/netfilter_ipv4/ipt_flow.h b/include/linux/netfilter_ipv4/ipt_flow.h
--- a/include/linux/netfilter_ipv4/ipt_flow.h	1969-12-31 18:00:00.000000000 -0600
+++ b/include/linux/netfilter_ipv4/ipt_flow.h	2005-06-28 13:09:39.000000000 -0500
@@ -0,0 +1,83 @@
+#ifndef _IPT_FLOW_H
+#define _IPT_FLOW_H
+
+#define MAX_SIZE(c) ((1 << (sizeof(c) * 8)) - 1)
+
+typedef enum
+{
+	IPFLOW_IP_SHIFT = 0,
+	IPFLOW_IP_BIT = 0,
+	IPFLOW_IP = (1 << IPFLOW_IP_BIT),
+	IPFLOW_IP_N_BIT = 1,
+	IPFLOW_IP_N = (1 << IPFLOW_IP_N_BIT),
+	IPFLOW_IP_E_BIT = 2,
+	IPFLOW_IP_E = (1 << IPFLOW_IP_E_BIT),
+	IPFLOW_IP_MASK = (IPFLOW_IP | IPFLOW_IP_N | IPFLOW_IP_E),
+
+	IPFLOW_ICMP_SHIFT = 3,
+	IPFLOW_ICMP_BIT = 3,
+	IPFLOW_ICMP = (1 << IPFLOW_ICMP_BIT),
+	IPFLOW_ICMP_N_BIT = 4,
+	IPFLOW_ICMP_N = (1 << IPFLOW_ICMP_N_BIT),
+	IPFLOW_ICMP_E_BIT = 5,
+	IPFLOW_ICMP_E = (1 << IPFLOW_ICMP_E_BIT),
+	IPFLOW_ICMP_MASK = (IPFLOW_ICMP | IPFLOW_ICMP_N | IPFLOW_ICMP_E),
+
+	IPFLOW_TCP_SHIFT = 6,
+	IPFLOW_TCP_BIT = 6,
+	IPFLOW_TCP = (1 << IPFLOW_TCP_BIT),
+	IPFLOW_TCP_N_BIT = 7,
+	IPFLOW_TCP_N = (1 << IPFLOW_TCP_N_BIT),
+	IPFLOW_TCP_E_BIT = 8,
+	IPFLOW_TCP_E = (1 << IPFLOW_TCP_E_BIT),
+	IPFLOW_TCP_MASK = (IPFLOW_TCP | IPFLOW_TCP_N | IPFLOW_TCP_E),
+
+	IPFLOW_UDP_SHIFT = 9,
+	IPFLOW_UDP_BIT = 9,
+	IPFLOW_UDP = (1 << IPFLOW_UDP_BIT),
+	IPFLOW_UDP_N_BIT = 10,
+	IPFLOW_UDP_N = (1 << IPFLOW_UDP_N_BIT),
+	IPFLOW_UDP_E_BIT = 11,
+	IPFLOW_UDP_E = (1 << IPFLOW_UDP_E_BIT),
+	IPFLOW_UDP_MASK = (IPFLOW_UDP | IPFLOW_UDP_N | IPFLOW_UDP_E),
+
+	IPFLOW_DIR_BIT = 30,
+	IPFLOW_DIR = (1 << IPFLOW_DIR_BIT),
+
+	IPFLOW_NETWORK_MASK_BIT = 31,
+	IPFLOW_NETWORK_MASK = (1 << IPFLOW_NETWORK_MASK_BIT)
+} ipflow_bits_t;
+
+struct ipt_flow_nm
+{
+	u_int16_t ip_n,
+		  ip_e,
+		  icmp_n,
+		  icmp_e,
+		  tcp_n,
+		  tcp_e,
+		  udp_n,
+		  udp_e;
+};
+
+struct ipt_flow_info
+{
+#ifdef __KERNEL__
+	struct list_head list;
+#else
+	struct
+	{
+		void *next,
+		     *prev;
+	} list;
+#endif
+	u_int8_t invert,
+		 invert_network;
+	u_int32_t proto,
+		  network,
+		  mask,
+		  max;
+	struct ipt_flow_nm *nm;
+};
+
+#endif /* IPT_FLOW_H */
diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig	2005-06-28 13:24:31.000000000 -0500
+++ b/net/ipv4/netfilter/Kconfig	2005-06-28 13:09:39.000000000 -0500
@@ -381,6 +381,21 @@
 	  destination IP' or `500pps from any given source IP'  with a single
 	  IPtables rule.
 
+config IP_NF_MATCH_FLOW
+       tristate 'protocol flow counters match support (EXPERIMENTAL)'
+       depends on IP_NF_IPTABLES && IP_NF_FLOW && (IP_NF_FILTER || IP_NF_NAT || IP_NF_MANGLE) && EXPERIMENTAL
+       help
+         `flow' matching allows you to match a packet when the specified
+         number of known protocol connections is exceeded.  The matches
+	 can be made against generic IP, ICMP, TCP or UDP flow counters.
+	 This match can be used in all tables but raw.
+
+         For example, this match allows you to control the number and type
+         of connections (flows) from hosts in a known local network routing
+         through the machine.
+
+         To compile it as a module, choose M here.  If unsure, say N.
+
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
@@ -708,5 +723,23 @@
 	  
 	  IF unsure, say `N'.
 
+config IP_NF_FLOW
+	tristate "protocol flow counters (EXPERIMENTAL)"
+	depends on IP_NF_CONNTRACK_EVENTS && EXPERIMENTAL
+	help
+	  This option uses the connection tracking event notifiers to
+	  keep protocol flow counters for source and destination IP address.
+	  The protocol counters include generic IP, ICMP, TCP and UDP.
+
+	  If the proc filesystem is built into the kernel
+	  "/proc/net/ip_conntrack_flow_orig" and
+	  "/proc/net/ip_conntrack_flow_repl" can be used to read the flow
+	  count tables.
+
+	  These counters can be used with the "protocol flow counters match
+	  support."
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 endmenu
 
diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile	2005-06-28 13:24:31.000000000 -0500
+++ b/net/ipv4/netfilter/Makefile	2005-06-28 13:09:39.000000000 -0500
@@ -27,6 +27,9 @@
 obj-$(CONFIG_IP_NF_NAT_FTP) += ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) += ip_nat_irc.o
 
+# connection tracking event objects
+obj-$(CONFIG_IP_NF_FLOW) += ip_conntrack_flow.o
+
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
 
@@ -62,6 +65,7 @@
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
+obj-$(CONFIG_IP_NF_MATCH_FLOW) += ipt_flow.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff -Nru a/net/ipv4/netfilter/ip_conntrack_flow.c b/net/ipv4/netfilter/ip_conntrack_flow.c
--- a/net/ipv4/netfilter/ip_conntrack_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ b/net/ipv4/netfilter/ip_conntrack_flow.c	2005-06-28 13:33:07.000000000 -0500
@@ -0,0 +1,907 @@
+/* Kernel module to track [IP|ICMP|TCP|UDP] flow counts. */
+
+/* (C) 2004 2005 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/jhash.h>
+#include <linux/random.h>
+#include <linux/in.h>
+#include <linux/notifier.h>
+#ifdef CONFIG_PROC_FS
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#endif
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_flow.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Josh Samuelson <josamue1@wsc.edu>");
+MODULE_DESCRIPTION("protocol flow count tracking "
+		   "via connection tracking events");
+
+rwlock_t ipct_flow_lock = RW_LOCK_UNLOCKED;
+struct list_head *ipct_flow_orig_hash,
+		 *ipct_flow_repl_hash;
+unsigned int ipct_flow_htable_size = 0;
+static int ipct_flow_hash_rnd;
+static kmem_cache_t *ipct_flow_cachep,
+		    *ipct_flow_sc_cachep;
+static struct notifier_block *ipct_flow_nb_chain;
+
+#ifdef CONFIG_PROC_FS
+struct ipct_flow_iter_state {
+	unsigned int bucket;
+	struct list_head *dir;
+};
+
+static struct list_head *
+ipct_flow_get_first(struct seq_file *seq)
+{
+	struct ipct_flow_iter_state *st = seq->private;
+
+	for (st->bucket = 0;
+	st->bucket < ipct_flow_htable_size;
+	st->bucket++) {
+		if (!list_empty(&st->dir[st->bucket]))
+			return st->dir[st->bucket].next;
+	}
+	return NULL;
+}
+
+static struct list_head *
+ipct_flow_get_next(struct seq_file *seq, struct list_head *head)
+{
+	struct ipct_flow_iter_state *st = seq->private;
+
+	head = head->next;
+	while (head == &st->dir[st->bucket]) {
+		if (++st->bucket >= ipct_flow_htable_size)
+			return NULL;
+		head = st->dir[st->bucket].next;
+	}
+	return head;
+}
+
+static struct list_head *
+ipct_flow_get_idx(struct seq_file *seq, loff_t pos)
+{
+	struct list_head *head = ipct_flow_get_first(seq);
+
+	if (head)
+		while (pos && (head = ipct_flow_get_next(seq, head)))
+			pos--;
+	return pos ? NULL : head;
+}
+
+static void *
+ipct_flow_seq_start(struct seq_file *seq, loff_t *ppos)
+{
+	read_lock_bh(&ipct_flow_lock);
+	return ipct_flow_get_idx(seq, *ppos);
+}
+  
+static void
+ipct_flow_seq_stop(struct seq_file *seq, void *v)
+{
+	read_unlock_bh(&ipct_flow_lock);
+}
+
+static void *
+ipct_flow_seq_next(struct seq_file *seq, void *v, loff_t *ppos)
+{
+	(*ppos)++;
+	return ipct_flow_get_next(seq, v);
+}
+
+static int
+ipct_flow_seq_show(struct seq_file *seq, void *v)
+{
+	struct ipct_flow *flow = (struct ipct_flow *) v;
+
+	if (seq_printf(seq, "%u.%u.%u.%u IP: %u/%hu/%hu ICMP: %u/%hu/%hu "
+		       "TCP: %u/%hu/%hu UDP: %u/%hu/%hu\n",
+		       NIPQUAD(flow->ip),
+		       flow->ip_n + flow->ip_e,
+		       flow->ip_n,
+		       flow->ip_e,
+		       flow->icmp_n + flow->icmp_e,
+		       flow->icmp_n,
+		       flow->icmp_e,
+		       flow->tcp_n + flow->tcp_e,
+		       flow->tcp_n,
+		       flow->tcp_e,
+		       flow->udp_n + flow->udp_e,
+		       flow->udp_n,
+		       flow->udp_e)) {
+		return -ENOSPC;
+	}
+	return 0;
+}
+  
+static struct seq_operations ipct_flow_seq_ops = {
+	.start = ipct_flow_seq_start,
+	.stop  = ipct_flow_seq_stop,
+	.next  = ipct_flow_seq_next,
+	.show  = ipct_flow_seq_show
+};
+
+static int
+ipct_flow_open(struct inode *inode, struct file *file, struct list_head *dir)
+{
+	struct seq_file *seq;
+	struct ipct_flow_iter_state *st;
+	int ret;
+
+	st = kmalloc(sizeof(struct ipct_flow_iter_state), GFP_KERNEL);
+
+	if (!st)
+		return -ENOMEM;
+	ret = seq_open(file, &ipct_flow_seq_ops);
+	if (ret)
+		goto out_free;
+	seq = file->private_data;
+	seq->private = st;
+	memset(st, 0, sizeof(struct ipct_flow_iter_state));
+	st->dir = dir;
+	return ret;
+out_free:
+	kfree(st);
+	return ret;
+}
+
+static int
+ipct_flow_orig_open(struct inode *inode, struct file *file)
+{
+	return ipct_flow_open(inode, file, ipct_flow_orig_hash);
+}
+
+static int
+ipct_flow_repl_open(struct inode *inode, struct file *file)
+{
+	return ipct_flow_open(inode, file, ipct_flow_repl_hash);
+}
+
+static struct file_operations ipct_flow_orig_file_ops = {
+	.owner   = THIS_MODULE,
+	.llseek  = seq_lseek,
+	.read    = seq_read,
+	.open    = ipct_flow_orig_open,
+	.release = seq_release_private
+};
+
+static struct file_operations ipct_flow_repl_file_ops = {
+	.owner   = THIS_MODULE,
+	.llseek  = seq_lseek,
+	.read    = seq_read,
+	.open    = ipct_flow_repl_open,
+	.release = seq_release_private
+};
+#endif /* CONFIG_PROC_FS */
+  
+int
+ipct_flow_register_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_register(&ipct_flow_nb_chain, nb);
+}
+
+int
+ipct_flow_unregister_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&ipct_flow_nb_chain, nb);
+}
+
+void
+ipct_flow_event(enum ip_conntrack_events event,
+	struct ipct_flow_notifier_data *nd)
+{
+	notifier_call_chain(&ipct_flow_nb_chain, event, nd);
+}
+
+u_int32_t
+ip_hash_flow_ip(u_int32_t ip)
+{
+	return(jhash_1word(ip, ipct_flow_hash_rnd) % ipct_flow_htable_size);
+}
+
+static struct ipct_flow_status_cache *
+ipct_flow_get_status_cache(struct ip_conntrack_tuple_hash *hash,
+	struct ipct_flow *flow_orig,
+	struct ipct_flow *flow_repl,
+	enum ip_conntrack_events events)
+{
+	struct list_head *list;
+	struct ip_conntrack *ct;
+	struct ipct_flow_status_cache *sc,
+				      *sc_orig,
+				      *sc_repl;
+
+	ct = tuplehash_to_ctrack(&hash[IP_CT_DIR_ORIGINAL]);
+	sc_orig = NULL;
+	list_for_each(list, &flow_orig->sc) {
+		sc = container_of(list, struct ipct_flow_status_cache,
+				  dir[IP_CT_DIR_ORIGINAL]);
+		if (sc->ct == ct) {
+			sc_orig = sc;
+			break;
+		}
+	}
+	sc_repl = NULL;
+	list_for_each(list, &flow_repl->sc) {
+		sc = container_of(list, struct ipct_flow_status_cache,
+				  dir[IP_CT_DIR_REPLY   ]);
+		if (sc->ct == ct) {
+			sc_repl = sc;
+			break;
+		}
+	}
+
+	if (!sc_orig && !sc_repl) {
+		if ((events & (IPCT_NEW | IPCT_RELATED)) ||
+		    (events == IPCT_NONE)) {
+			sc = kmem_cache_alloc(ipct_flow_sc_cachep, GFP_ATOMIC);
+			if (sc) {
+				memset(sc, 0,
+				       sizeof(struct ipct_flow_status_cache));
+				sc->ct = ct;
+				sc->status = ct->status;
+				list = (struct list_head *)
+				       &sc->dir[IP_CT_DIR_ORIGINAL];
+				list_add(list, &flow_orig->sc);
+				list = (struct list_head *)
+				       &sc->dir[IP_CT_DIR_REPLY   ];
+				list_add(list, &flow_repl->sc);
+			} else if (net_ratelimit())
+				printk(KERN_WARNING "ipct_flow: Can't "
+				       "allocate sc\n");
+			return sc;
+		} else if (net_ratelimit())
+			printk(KERN_WARNING
+			       "ipct_flow: notified of %s%swithout "
+			       "prior IPCT_NEW or IPCT_RELATED event\n",
+			       events & IPCT_DESTROY ? "IPCT_DESTROY " : "",
+			       events & IPCT_STATUS ? "IPCT_STATUS " : "");
+	} else if ((sc_orig == sc_repl) &&
+		   (events & (IPCT_NEW | IPCT_RELATED))) {
+		if (net_ratelimit())
+			printk(KERN_WARNING "ipct_flow: duplicate %sdetected\n",
+			       events & IPCT_NEW
+			       ? "IPCT_NEW " : "IPCT_RELATED ");
+		return NULL;
+	}
+	return sc_orig == sc_repl ? sc_orig : NULL;
+}
+
+static unsigned long
+ipct_flow_status_new(struct ip_conntrack_tuple_hash *hash,
+	struct ipct_flow_status_cache *sc)
+{
+	unsigned long new_status;
+	struct ip_conntrack *ct;
+
+	ct = tuplehash_to_ctrack(&hash[IP_CT_DIR_ORIGINAL]);
+	new_status = (sc->status ^ ct->status) & ct->status;
+	sc->status = ct->status;
+
+	return new_status;
+}
+
+static void
+ipct_flow_check_unlink(struct ipct_flow *flow_orig, struct ipct_flow *flow_repl)
+{
+	struct list_head *list;
+
+	if (flow_orig) {
+		if ((flow_orig->ip_n == 0) && (flow_orig->ip_e == 0)) {
+			if ((&flow_orig->sc != flow_orig->sc.next)) {
+				if (net_ratelimit())
+					printk(KERN_WARNING
+					       "flow_orig->sc list "
+					       "not empty!\n");
+			} else {
+				list = (struct list_head *) flow_orig;
+				list_del(list);
+				kmem_cache_free(ipct_flow_cachep, flow_orig);
+			}
+		}
+	}
+	if (flow_repl) {
+		if ((flow_repl->ip_n == 0) && (flow_repl->ip_e == 0)) {
+			if ((&flow_repl->sc != flow_repl->sc.next)) {
+				if (net_ratelimit())
+					printk(KERN_WARNING
+					       "flow_repl->sc list "
+					       "not empty!\n");
+			} else {
+				list = (struct list_head *) flow_repl;
+				list_del(list);
+				kmem_cache_free(ipct_flow_cachep, flow_repl);
+			}
+		}
+	}
+}
+
+static unsigned long
+ipct_flow_inc(struct ip_conntrack_tuple_hash *hash,
+	enum ip_conntrack_events events,
+	struct ipct_flow_status_cache *sc,
+	struct ipct_flow *flow_orig,
+	struct ipct_flow *flow_repl)
+{
+	unsigned long new_status;
+
+	new_status = 0;
+	if (events & (IPCT_NEW | IPCT_RELATED)) {
+		INCREMENT_WITHOUT_OVERFLOW(flow_orig->ip_n);
+		INCREMENT_WITHOUT_OVERFLOW(flow_repl->ip_n);
+		switch (hash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				INCREMENT_WITHOUT_OVERFLOW(flow_orig->icmp_n);
+				INCREMENT_WITHOUT_OVERFLOW(flow_repl->icmp_n);
+				break;
+			case IPPROTO_TCP:
+				INCREMENT_WITHOUT_OVERFLOW(flow_orig->tcp_n);
+				INCREMENT_WITHOUT_OVERFLOW(flow_repl->tcp_n);
+				break;
+			case IPPROTO_UDP:
+				INCREMENT_WITHOUT_OVERFLOW(flow_orig->udp_n);
+				INCREMENT_WITHOUT_OVERFLOW(flow_repl->udp_n);
+				break;
+		}
+	} else if (events & IPCT_STATUS) {
+		new_status = ipct_flow_status_new(hash, sc);
+		if (test_bit(IPS_SEEN_REPLY_BIT, &new_status)) {
+			if(flow_orig->ip_n)
+				flow_orig->ip_n--;
+			if(flow_repl->ip_n)
+				flow_repl->ip_n--;
+			INCREMENT_WITHOUT_OVERFLOW(flow_orig->ip_e);
+			INCREMENT_WITHOUT_OVERFLOW(flow_repl->ip_e);
+			switch (hash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+				case IPPROTO_ICMP:
+					if (flow_orig->icmp_n)
+						flow_orig->icmp_n--;
+					if (flow_repl->icmp_n)
+						flow_repl->icmp_n--;
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->icmp_e);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->icmp_e);
+					break;
+				case IPPROTO_TCP:
+					if (flow_orig->tcp_n)
+						flow_orig->tcp_n--;
+					if (flow_repl->tcp_n)
+						flow_repl->tcp_n--;
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->tcp_e);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->tcp_e);
+					break;
+				case IPPROTO_UDP:
+					if (flow_orig->udp_n)
+						flow_orig->udp_n--;
+					if (flow_repl->udp_n)
+						flow_repl->udp_n--;
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->udp_e);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->udp_e);
+					break;
+			}
+		}
+	} else if (events == IPCT_NONE) {
+		if (test_bit(IPS_SEEN_REPLY_BIT, &tuplehash_to_ctrack
+			     (&hash[IP_CT_DIR_ORIGINAL])->status)) {
+			INCREMENT_WITHOUT_OVERFLOW(flow_orig->ip_e);
+			INCREMENT_WITHOUT_OVERFLOW(flow_repl->ip_e);
+			switch (hash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+				case IPPROTO_ICMP:
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->icmp_e);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->icmp_e);
+					break;
+				case IPPROTO_TCP:
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->tcp_e);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->tcp_e);
+					break;
+				case IPPROTO_UDP:
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->udp_e);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->udp_e);
+					break;
+			}
+		} else {
+			INCREMENT_WITHOUT_OVERFLOW(flow_orig->ip_n);
+			INCREMENT_WITHOUT_OVERFLOW(flow_repl->ip_n);
+			switch (hash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+				case IPPROTO_ICMP:
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->icmp_n);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->icmp_n);
+					break;
+				case IPPROTO_TCP:
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->tcp_n);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->tcp_n);
+					break;
+				case IPPROTO_UDP:
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_orig->udp_n);
+					INCREMENT_WITHOUT_OVERFLOW
+					 (flow_repl->udp_n);
+					break;
+			}
+		}
+	}
+	return new_status;
+}
+
+
+static void
+ipct_flow_dec(struct ip_conntrack_tuple_hash *hash,
+	struct ipct_flow_status_cache *sc,
+	struct ipct_flow *flow_orig,
+	struct ipct_flow *flow_repl)
+{
+	unsigned long new_status;
+	struct list_head *list;
+
+	new_status = ipct_flow_status_new(hash, sc);
+	if (test_bit(IPS_SEEN_REPLY_BIT, &new_status)) {
+	/*
+	 * This is where the reply packet is DROPPED and we never
+	 * see the IPCT_STATUS notification for it.  If our new
+	 * status is IPS_SEEN_REPLY_BIT, then we must decrement
+	 * the new counters.
+	 */
+		if(flow_orig->ip_n)
+			flow_orig->ip_n--;
+		if(flow_repl->ip_n)
+			flow_repl->ip_n--;
+		switch (hash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				if (flow_orig->icmp_n)
+					flow_orig->icmp_n--;
+				if (flow_repl->icmp_n)
+					flow_repl->icmp_n--;
+				break;
+			case IPPROTO_TCP:
+				if (flow_orig->tcp_n)
+					flow_orig->tcp_n--;
+				if (flow_repl->tcp_n)
+					flow_repl->tcp_n--;
+				break;
+			case IPPROTO_UDP:
+				if (flow_orig->udp_n)
+					flow_orig->udp_n--;
+				if (flow_repl->udp_n)
+					flow_repl->udp_n--;
+				break;
+		}
+	} else if (test_bit(IPS_SEEN_REPLY_BIT,
+	    &tuplehash_to_ctrack(&hash[IP_CT_DIR_ORIGINAL])->status)) {
+	/*
+	 * This checks for established connections.
+	 */
+		if(flow_orig->ip_e)
+			flow_orig->ip_e--;
+		if(flow_repl->ip_e)
+			flow_repl->ip_e--;
+		switch (hash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				if (flow_orig->icmp_e)
+					flow_orig->icmp_e--;
+				if (flow_repl->icmp_e)
+					flow_repl->icmp_e--;
+				break;
+			case IPPROTO_TCP:
+				if (flow_orig->tcp_e)
+					flow_orig->tcp_e--;
+				if (flow_repl->tcp_e)
+					flow_repl->tcp_e--;
+				break;
+			case IPPROTO_UDP:
+				if (flow_orig->udp_e)
+					flow_orig->udp_e--;
+				if (flow_repl->udp_e)
+					flow_repl->udp_e--;
+				break;
+		}
+	} else {
+	/*
+	 * This is for the connections left in the new state.
+	 */
+		if(flow_orig->ip_n)
+			flow_orig->ip_n--;
+		if(flow_repl->ip_n)
+			flow_repl->ip_n--;
+		switch (hash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				if (flow_orig->icmp_n)
+					flow_orig->icmp_n--;
+				if (flow_repl->icmp_n)
+					flow_repl->icmp_n--;
+				break;
+			case IPPROTO_TCP:
+				if (flow_orig->tcp_n)
+					flow_orig->tcp_n--;
+				if (flow_repl->tcp_n)
+					flow_repl->tcp_n--;
+				break;
+			case IPPROTO_UDP:
+				if (flow_orig->udp_n)
+					flow_orig->udp_n--;
+				if (flow_repl->udp_n)
+					flow_repl->udp_n--;
+				break;
+		}
+	}
+	list = (struct list_head *) &sc->dir[IP_CT_DIR_ORIGINAL];
+	list_del(list);
+	list = (struct list_head *) &sc->dir[IP_CT_DIR_REPLY   ];
+	list_del(list);
+	kmem_cache_free(ipct_flow_sc_cachep, sc);
+}
+
+static unsigned long
+ipct_flow_counters(struct ip_conntrack_tuple_hash *hash,
+	enum ip_conntrack_events events)
+{
+	u_int32_t ip_orig,
+		  ip_repl;
+	unsigned int hash_orig,
+		     hash_repl;
+	unsigned long new_status;
+	struct list_head *list;
+	struct ipct_flow *flow_orig,
+			 *flow_repl;
+	struct ipct_flow_status_cache *sc;
+	ipct_flow_counter_error_t error;
+
+	new_status = 0;
+	error = INITIALIZE;
+	ip_orig = hash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	ip_repl = hash[IP_CT_DIR_REPLY   ].tuple.src.ip;
+	hash_orig = ip_hash_flow_ip(ip_orig);
+	hash_repl = ip_hash_flow_ip(ip_repl);
+
+	write_lock_bh(&ipct_flow_lock);
+	flow_orig = NULL;
+	list_for_each(list, &ipct_flow_orig_hash[hash_orig]) {
+		if (((struct ipct_flow *) list)->ip == ip_orig) {
+			flow_orig = (struct ipct_flow *) list;
+			break;
+		}
+	}
+	flow_repl = NULL;
+	list_for_each(list, &ipct_flow_repl_hash[hash_repl]) {
+		if (((struct ipct_flow *) list)->ip == ip_repl) {
+			flow_repl = (struct ipct_flow *) list;
+			break;
+		}
+	}
+	if ((events & (IPCT_NEW | IPCT_RELATED)) ||
+	    (events == IPCT_NONE)) {
+		if (!flow_orig) {
+			flow_orig = kmem_cache_alloc(ipct_flow_cachep,
+						     GFP_ATOMIC);
+			if (flow_orig) {
+				memset(flow_orig, 0, sizeof(struct ipct_flow));
+				INIT_LIST_HEAD(&flow_orig->sc);
+				flow_orig->ip = ip_orig;
+				list = (struct list_head *) flow_orig;
+				list_add(list, &ipct_flow_orig_hash[hash_orig]);
+			} else
+				error |= ALLOC_ORIG;
+		}
+		if (!flow_repl) {
+			flow_repl = kmem_cache_alloc(ipct_flow_cachep,
+						     GFP_ATOMIC);
+			if (flow_repl) {
+				memset(flow_repl, 0, sizeof(struct ipct_flow));
+				INIT_LIST_HEAD(&flow_repl->sc);
+				flow_repl->ip = ip_repl;
+				list = (struct list_head *) flow_repl;
+				list_add(list, &ipct_flow_repl_hash[hash_repl]);
+			} else
+				error |= ALLOC_REPL;
+		}
+	} else {
+		if (!flow_orig)
+			error |= MISSING_ORIG;
+		if (!flow_repl)
+			error |= MISSING_REPL;
+	}
+	if (flow_orig && flow_repl) {
+		sc = ipct_flow_get_status_cache(hash, flow_orig,
+						flow_repl, events);
+		if (!sc) {
+			error |= SC_NULL;
+			ipct_flow_check_unlink(flow_orig, flow_repl);
+		} else {
+			if ((events & (IPCT_NEW |
+				       IPCT_RELATED |
+				       IPCT_STATUS)) ||
+			    (events == IPCT_NONE))
+				new_status = ipct_flow_inc(hash, events, sc,
+							 flow_orig, flow_repl);
+			else if (events & IPCT_DESTROY) {
+				ipct_flow_dec(hash, sc, flow_orig, flow_repl);
+				ipct_flow_check_unlink(flow_orig, flow_repl);
+			}
+		}
+	} else
+		ipct_flow_check_unlink(flow_orig, flow_repl);
+
+	if (error && net_ratelimit()) {
+		printk(KERN_WARNING "ipct_flow: %s%s%s%sevent ignored because ",
+		       events & IPCT_NEW ? "IPCT_NEW " : "",
+		       events & IPCT_RELATED ? "IPCT_RELATED " : "",
+		       events & IPCT_DESTROY ? "IPCT_DESTROY " : "",
+		       events & IPCT_STATUS ? "IPCT_STATUS " : "");
+		if (error & MISSING_MASK) {
+			if ((error & MISSING_MASK) == MISSING_MASK)
+				printk("flow_orig/flow_repl ");
+			else if (error & MISSING_ORIG)
+				printk("flow_orig ");
+			else if (error & MISSING_REPL)
+				printk("flow_repl ");
+			printk("wasn't found ");
+		}
+		if (error & ALLOC_MASK) {
+			if ((error & MISSING_MASK) == MISSING_MASK)
+				printk(", ");
+			if ((error & ALLOC_MASK) == ALLOC_MASK)
+				printk("flow_orig/flow_repl ");
+			else if (error & ALLOC_ORIG)
+				printk("flow_orig ");
+			else if (error & ALLOC_REPL)
+				printk("flow_repl ");
+			printk("failed to allocate ");
+		}
+		if (error & SC_NULL) {
+			if ((error & MISSING_MASK) ||
+			    (error & ALLOC_MASK)) {
+				printk(", ");
+			}
+			printk("sc is missing ");
+		}
+		printk("\n\tprotonum=%u orig=%u.%u.%u.%u repl=%u.%u.%u.%u\n",
+		       hash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
+		       NIPQUAD(ip_orig),
+		       NIPQUAD(ip_repl));
+	}
+
+	write_unlock_bh(&ipct_flow_lock);
+	return new_status;
+}
+
+static int
+ipct_flow_notifier(struct notifier_block *nb, unsigned long events, void *v)
+{
+	struct ipct_flow_notifier_data nd;
+
+	nd.ct = v;
+	if ((events & IPCT_NEW) ||
+	    (events & IPCT_RELATED) ||
+	    (events & IPCT_STATUS) ||
+	    (events & IPCT_DESTROY)) {
+		nd.new_status = ipct_flow_counters(nd.ct->tuplehash, events);
+		ipct_flow_event(events, &nd);
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ipct_flow_nb = {
+	.notifier_call = ipct_flow_notifier,
+	.next = NULL,
+	.priority = 0
+};
+
+static int
+ipct_flow_existing(void)
+{
+	unsigned int i;
+	int ret = 0;
+	struct list_head *list;
+	struct ip_conntrack_tuple_hash *hash;
+
+	read_lock_bh(&ip_conntrack_lock);
+	if ((ret = ip_conntrack_register_notifier(&ipct_flow_nb)))
+		goto skip_existing;
+	for (i = 0; i < ip_conntrack_htable_size; i++) {
+		list_for_each(list, &ip_conntrack_hash[i]) {
+			hash = (struct ip_conntrack_tuple_hash *) list;
+			if (DIRECTION(hash) == IP_CT_DIR_ORIGINAL)
+				ipct_flow_counters(hash, IPCT_NONE);
+		}
+	}
+skip_existing:
+	read_unlock_bh(&ip_conntrack_lock);
+	return ret;
+}
+
+static void
+ipct_flow_status_cache_free_list(struct list_head *head,
+	enum ip_conntrack_dir dir)
+{
+	struct list_head *list;
+	struct ipct_flow_status_cache *sc;
+
+/*	ASSERT_WRITE_LOCK(&ipct_flow_lock); */
+	list = head->next;
+	while (list != head) {
+		sc = container_of(list, struct ipct_flow_status_cache,
+				  dir[dir]);
+		list = list->next;
+		list_del(&sc->dir[IP_CT_DIR_ORIGINAL]);
+		list_del(&sc->dir[IP_CT_DIR_REPLY   ]);
+		kmem_cache_free(ipct_flow_sc_cachep, sc);
+	}
+}
+
+static void
+ipct_flow_destroy(void)
+{
+	unsigned int i;
+	struct list_head *list;
+	struct ipct_flow *flow;
+
+	write_lock_bh(&ipct_flow_lock);
+	if (ip_conntrack_unregister_notifier(&ipct_flow_nb))
+		printk(KERN_ERR "ip_conntrack_unregister_notifier() "
+				"failed, huh?\n");
+	for (i = 0; i < ipct_flow_htable_size; i++) {
+		list = ipct_flow_orig_hash[i].next;
+		while (list != &ipct_flow_orig_hash[i]) {
+				flow = (struct ipct_flow *) list;
+				ipct_flow_status_cache_free_list(&flow->sc,
+				 IP_CT_DIR_ORIGINAL);
+				list = list->next;
+				list_del((struct list_head *) flow);
+				kmem_cache_free(ipct_flow_cachep, flow);
+		}
+		list = ipct_flow_repl_hash[i].next;
+		while (list != &ipct_flow_repl_hash[i]) {
+				flow = (struct ipct_flow *) list;
+				ipct_flow_status_cache_free_list(&flow->sc,
+				 IP_CT_DIR_REPLY   );
+				list = list->next;
+				list_del((struct list_head *) flow);
+				kmem_cache_free(ipct_flow_cachep, flow);
+		}
+	}
+	write_unlock_bh(&ipct_flow_lock);
+}
+
+static int
+init_or_fini(int fini)
+{
+	unsigned int i;
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *proc_flow_orig,
+			      *proc_flow_repl;
+#endif
+
+	if (fini)
+		goto cleanup;
+
+	need_ip_conntrack();
+
+	ipct_flow_htable_size = ip_conntrack_htable_size / 2;
+
+	get_random_bytes(&ipct_flow_hash_rnd, 4);
+
+	ipct_flow_orig_hash = vmalloc(sizeof(struct list_head)
+					* ipct_flow_htable_size);
+	if (!ipct_flow_orig_hash) {
+		printk(KERN_ERR "Unable to create ipct_flow_orig_hash\n");
+		goto err;
+	}
+
+	ipct_flow_repl_hash = vmalloc(sizeof(struct list_head)
+					* ipct_flow_htable_size);
+	if (!ipct_flow_orig_hash) {
+		printk(KERN_ERR "Unable to create ipct_flow_orig_hash\n");
+		goto err_free_orig_hash;
+	}
+
+	for (i = 0; i < ipct_flow_htable_size; i++) {
+		INIT_LIST_HEAD(&ipct_flow_orig_hash[i]);
+		INIT_LIST_HEAD(&ipct_flow_repl_hash[i]);
+	}
+
+	ipct_flow_cachep = kmem_cache_create("ipct_flow",
+					     sizeof(struct ipct_flow),
+					     0, 0, NULL, NULL);
+	if (!ipct_flow_cachep) {
+		printk(KERN_ERR "Unable to create ipct_flow slab cache\n");
+		goto err_free_hash;
+ 	}
+
+	ipct_flow_sc_cachep = kmem_cache_create("ipct_flow_sc",
+						sizeof(struct
+						ipct_flow_status_cache),
+						0, 0, NULL, NULL);
+	if (!ipct_flow_sc_cachep) {
+		printk(KERN_ERR "Unable to create ipct_flow_sc slab cache\n");
+		goto err_free_slab_flow;
+ 	}
+
+	if (ipct_flow_existing())
+		goto err_free_slab;
+
+#ifdef CONFIG_PROC_FS
+	proc_flow_orig = proc_net_fops_create(PROC_NAME_ORIG,
+					     0440, &ipct_flow_orig_file_ops);
+	if (!proc_flow_orig) goto err_cleanup_flow;
+
+	proc_flow_repl = proc_net_fops_create(PROC_NAME_REPL,
+					     0440, &ipct_flow_repl_file_ops);
+	if (!proc_flow_repl) goto err_cleanup_proc;
+#endif
+
+	printk("ip_conntrack: protocol flow counters "
+	       "(%u buckets) - %Zd bytes per flow\n",
+	       ipct_flow_htable_size * 2,
+	       sizeof(struct ipct_flow));
+
+	return 0;
+
+cleanup:
+#ifdef CONFIG_PROC_FS
+	proc_net_remove(PROC_NAME_REPL);
+err_cleanup_proc:
+	proc_net_remove(PROC_NAME_ORIG);
+#endif
+err_cleanup_flow:
+	ipct_flow_destroy();
+err_free_slab:
+ 	kmem_cache_destroy(ipct_flow_sc_cachep);
+err_free_slab_flow:
+ 	kmem_cache_destroy(ipct_flow_cachep);
+err_free_hash:
+	vfree(ipct_flow_repl_hash);
+err_free_orig_hash:
+	vfree(ipct_flow_orig_hash);
+err:
+	return -ENOMEM;
+}
+
+static int __init
+init(void)
+{
+	return init_or_fini(0);
+}
+
+static void __exit
+fini(void)
+{
+	init_or_fini(1);
+}
+
+module_init(init);
+module_exit(fini);
+
+EXPORT_SYMBOL(ipct_flow_orig_hash);
+EXPORT_SYMBOL(ipct_flow_repl_hash);
+EXPORT_SYMBOL(ipct_flow_htable_size);
+EXPORT_SYMBOL(ipct_flow_lock);
+EXPORT_SYMBOL(ipct_flow_register_notifier);
+EXPORT_SYMBOL(ipct_flow_unregister_notifier);
+EXPORT_SYMBOL(ip_hash_flow_ip);
diff -Nru a/net/ipv4/netfilter/ipt_flow.c b/net/ipv4/netfilter/ipt_flow.c
--- a/net/ipv4/netfilter/ipt_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ b/net/ipv4/netfilter/ipt_flow.c	2005-06-28 13:09:39.000000000 -0500
@@ -0,0 +1,529 @@
+/* Kernel module to match [IP|ICMP|TCP|UDP] flow counts. */
+
+/* (C) 2004 2005 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/notifier.h>
+#include <linux/list.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_flow.h>
+#include <linux/netfilter_ipv4/ipt_flow.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Josh Samuelson <josamue1@wsc.edu>");
+MODULE_DESCRIPTION("protocol flow count match module");
+
+
+rwlock_t ipt_flow_lock = RW_LOCK_UNLOCKED;
+LIST_HEAD(ipt_flow_notifier_list);
+static atomic_t ipt_flow_notifier_list_count = ATOMIC_INIT(0);
+static struct notifier_block ipt_flow_nb;
+
+static void
+ipt_flow_nw_inc(struct ipct_flow_notifier_data *nd, struct ipt_flow_info *finfo)
+{
+	if (test_bit(IPS_SEEN_REPLY_BIT, &nd->new_status)) {
+		if (finfo->nm->ip_n)
+			finfo->nm->ip_n--;
+		INCREMENT_WITHOUT_OVERFLOW(finfo->nm->ip_e);
+		switch (nd->ct->tuplehash[IP_CT_DIR_ORIGINAL]
+			.tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				if (finfo->nm->icmp_n)
+					finfo->nm->icmp_n--;
+				INCREMENT_WITHOUT_OVERFLOW(finfo->nm->icmp_e);
+				break;
+			case IPPROTO_TCP:
+				if (finfo->nm->tcp_n)
+					finfo->nm->tcp_n--;
+				INCREMENT_WITHOUT_OVERFLOW(finfo->nm->tcp_e);
+				break;
+			case IPPROTO_UDP:
+				if (finfo->nm->udp_n)
+					finfo->nm->udp_n--;
+				INCREMENT_WITHOUT_OVERFLOW(finfo->nm->udp_e);
+				break;
+		}
+	} else {
+		INCREMENT_WITHOUT_OVERFLOW(finfo->nm->ip_n);
+		switch (nd->ct->tuplehash[IP_CT_DIR_ORIGINAL]
+			.tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				INCREMENT_WITHOUT_OVERFLOW(finfo->nm->icmp_n);
+				break;
+			case IPPROTO_TCP:
+				INCREMENT_WITHOUT_OVERFLOW(finfo->nm->tcp_n);
+				break;
+			case IPPROTO_UDP:
+				INCREMENT_WITHOUT_OVERFLOW(finfo->nm->udp_n);
+				break;
+		}
+	}
+}
+
+static void
+ipt_flow_nw_dec(struct ipct_flow_notifier_data *nd, struct ipt_flow_info *finfo)
+{
+	if (test_bit(IPS_SEEN_REPLY_BIT, &nd->ct->status)) {
+		if (finfo->nm->ip_e)
+			finfo->nm->ip_e--;
+		switch (nd->ct->tuplehash[IP_CT_DIR_ORIGINAL]
+			.tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				if (finfo->nm->icmp_e)
+					finfo->nm->icmp_e--;
+				break;
+			case IPPROTO_TCP:
+				if (finfo->nm->tcp_e)
+					finfo->nm->tcp_e--;
+				break;
+			case IPPROTO_UDP:
+				if (finfo->nm->udp_e)
+					finfo->nm->udp_e--;
+				break;
+		}
+	} else {
+		if (finfo->nm->ip_n)
+			finfo->nm->ip_n--;
+		switch (nd->ct->tuplehash[IP_CT_DIR_ORIGINAL]
+			.tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				if (finfo->nm->icmp_n)
+					finfo->nm->icmp_n--;
+				break;
+			case IPPROTO_TCP:
+				if (finfo->nm->tcp_n)
+					finfo->nm->tcp_n--;
+				break;
+			case IPPROTO_UDP:
+				if (finfo->nm->udp_n)
+					finfo->nm->udp_n--;
+				break;
+		}
+	}
+}
+
+static void
+ipt_flow_existing(struct ipt_flow_info *finfo)
+{
+        unsigned int i;
+        struct list_head *list,
+			 *dir;
+        struct ipct_flow *flow;
+
+	if (finfo->proto & IPFLOW_DIR)
+		dir = ipct_flow_repl_hash;
+	else
+		dir = ipct_flow_orig_hash;
+	read_lock_bh(&ipct_flow_lock);
+	for (i = 0; i < ipct_flow_htable_size; i++) {
+		list_for_each(list, &dir[i]) {
+			flow = (struct ipct_flow *) list;
+			if (finfo->invert_network ^
+			    ((flow->ip & finfo->mask) == finfo->network)) {
+				finfo->nm->ip_n += flow->ip_n;
+				finfo->nm->ip_e += flow->ip_e;
+				finfo->nm->icmp_n += flow->icmp_n;
+				finfo->nm->icmp_e += flow->icmp_e;
+				finfo->nm->tcp_n += flow->tcp_n;
+				finfo->nm->tcp_e += flow->tcp_e;
+				finfo->nm->udp_n += flow->udp_n;
+				finfo->nm->udp_e += flow->udp_e;
+			}
+		}
+	}
+	read_unlock_bh(&ipct_flow_lock);
+}
+
+int
+ipt_flow_nm_notifier(struct notifier_block *self,
+	unsigned long events, void *vnd)
+{
+	struct list_head *list;
+	struct ipt_flow_info *finfo;
+	struct ipct_flow_notifier_data *nd = vnd;
+	u_int32_t ip;
+
+	read_lock_bh(&ipt_flow_lock);
+	list_for_each(list, &ipt_flow_notifier_list) {
+		finfo = (struct ipt_flow_info *) list;
+		if (finfo->proto & IPFLOW_DIR)
+			ip = nd->ct->tuplehash[IP_CT_DIR_REPLY   ].tuple.src.ip;
+		else
+			ip = nd->ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		if (finfo->invert_network ^
+		    ((ip & finfo->mask) == finfo->network)) {
+			if ((events & IPCT_NEW) ||
+			    (events & IPCT_RELATED) ||
+			    (events & IPCT_STATUS)) {
+				ipt_flow_nw_inc(nd, finfo);
+			}
+			if (events & IPCT_DESTROY) {
+				ipt_flow_nw_dec(nd, finfo);
+			}
+		}
+	}
+	read_unlock_bh(&ipt_flow_lock);
+}
+
+static int
+match(const struct sk_buff *skb,
+	const struct net_device *in,
+	const struct net_device *out,
+	const void *matchinfo,
+	int offset,
+	int *hotdrop)
+{
+	const struct ipt_flow_info *finfo = matchinfo;
+	struct list_head *list,
+			 *dir;
+	struct ipct_flow *flow = NULL;
+	u_int16_t proto;
+	u_int32_t flow_hash,
+		  ip;
+	int ret = 0;
+
+	if (finfo->proto & IPFLOW_DIR) {
+		ip = skb->nh.iph->daddr;
+		dir = ipct_flow_repl_hash;
+	} else {
+		ip = skb->nh.iph->saddr;
+		dir = ipct_flow_orig_hash;
+	}
+	proto = skb->nh.iph->protocol;
+	if ((finfo->proto & IPFLOW_NETWORK_MASK) &&
+	    (finfo->invert_network ^ 
+	    ((ip & finfo->mask) == finfo->network))) {
+		switch (finfo->proto & IPFLOW_IP_MASK) {
+			case IPFLOW_IP:
+				if ((finfo->nm->ip_n + finfo->nm->ip_e) >=
+				    finfo->max)
+					ret = 1;
+				break;
+			case IPFLOW_IP_N:
+				if (finfo->nm->ip_n >= finfo->max)
+					ret = 1;
+				break;
+			case IPFLOW_IP_E:
+				if (finfo->nm->ip_e >= finfo->max)
+					ret = 1;
+				break;
+		}
+		switch (proto) {
+			case IPPROTO_ICMP:
+				switch (finfo->proto & IPFLOW_ICMP_MASK) {
+					case IPFLOW_ICMP:
+						if ((finfo->nm->icmp_n +
+						    finfo->nm->icmp_e) >=
+						    finfo->max)
+							ret = 1;
+						break;
+					case IPFLOW_ICMP_N:
+						if (finfo->nm->icmp_n >=
+						    finfo->max)
+							ret = 1;
+						break;
+					case IPFLOW_ICMP_E:
+						if (finfo->nm->icmp_e >=
+						    finfo->max)
+							ret = 1;
+						break;
+				}
+				break;
+			case IPPROTO_TCP:
+				switch (finfo->proto & IPFLOW_TCP_MASK) {
+					case IPFLOW_TCP:
+						if ((finfo->nm->tcp_n +
+						    finfo->nm->tcp_e) >=
+						    finfo->max)
+							ret = 1;
+						break;
+					case IPFLOW_TCP_N:
+						if (finfo->nm->tcp_n >=
+						    finfo->max)
+							ret = 1;
+						break;
+					case IPFLOW_TCP_E:
+						if (finfo->nm->tcp_e >=
+						    finfo->max)
+							ret = 1;
+						break;
+				}
+				break;
+			case IPPROTO_UDP:
+				switch (finfo->proto & IPFLOW_UDP_MASK) {
+					case IPFLOW_UDP:
+						if ((finfo->nm->udp_n +
+						    finfo->nm->udp_e) >=
+						    finfo->max)
+							ret = 1;
+						break;
+					case IPFLOW_UDP_N:
+						if (finfo->nm->udp_n >=
+						    finfo->max)
+							ret = 1;
+						break;
+					case IPFLOW_UDP_E:
+						if (finfo->nm->udp_e >=
+						    finfo->max)
+							ret = 1;
+						break;
+				}
+				break;
+		}
+	} else {
+		flow_hash = ip_hash_flow_ip(ip);
+		read_lock_bh(&ipct_flow_lock);
+		list_for_each(list, &dir[flow_hash]) {
+			if (((struct ipct_flow *) list)->ip == ip) {
+				flow = (struct ipct_flow *) list;
+				break;
+			}
+		}
+		if (flow) {
+			switch (finfo->proto & IPFLOW_IP_MASK) {
+				case IPFLOW_IP:
+					if ((flow->ip_n + flow->ip_e) >=
+					    finfo->max)
+						ret = 1;
+					break;
+				case IPFLOW_IP_N:
+					if (flow->ip_n >= finfo->max)
+						ret = 1;
+					break;
+				case IPFLOW_IP_E:
+					if (flow->ip_e >= finfo->max)
+						ret = 1;
+					break;
+			}
+			switch (proto) {
+				case IPPROTO_ICMP:
+					switch (finfo->proto &
+						IPFLOW_ICMP_MASK) {
+						case IPFLOW_ICMP:
+							if ((flow->icmp_n +
+							    flow->icmp_e) >=
+							    finfo->max)
+								ret = 1;
+							break;
+						case IPFLOW_ICMP_N:
+							if (flow->icmp_n >=
+							    finfo->max)
+								ret = 1;
+							break;
+						case IPFLOW_ICMP_E:
+							if (flow->icmp_e >=
+							    finfo->max)
+								ret = 1;
+							break;
+					}
+					break;
+				case IPPROTO_TCP:
+					switch (finfo->proto &
+						IPFLOW_TCP_MASK) {
+						case IPFLOW_TCP:
+							if ((flow->tcp_n +
+							    flow->tcp_e) >=
+							    finfo->max)
+								ret = 1;
+							break;
+						case IPFLOW_TCP_N:
+							if (flow->tcp_n >=
+							    finfo->max)
+								ret = 1;
+							break;
+						case IPFLOW_TCP_E:
+							if (flow->tcp_e >=
+							    finfo->max)
+								ret = 1;
+							break;
+					}
+					break;
+				case IPPROTO_UDP:
+					switch (finfo->proto &
+						IPFLOW_UDP_MASK) {
+						case IPFLOW_UDP:
+							if ((flow->udp_n +
+							    flow->udp_e) >=
+							    finfo->max)
+								ret = 1;
+							break;
+						case IPFLOW_UDP_N:
+							if (flow->udp_n >=
+							    finfo->max)
+								ret = 1;
+							break;
+						case IPFLOW_UDP_E:
+							if (flow->udp_e >=
+							    finfo->max)
+								ret = 1;
+							break;
+					}
+					break;
+			}
+		}
+		read_unlock_bh(&ipct_flow_lock);
+	}
+	return finfo->invert ^ ret;
+}
+
+static int
+checkentry(const char *tablename,
+	const struct ipt_ip *ip,
+	void *matchinfo,
+	unsigned int matchinfosize,
+	unsigned int hook_mask)
+{
+	/* BIT 0, 1 or 2 is exclusively allowed */
+	int bad_combo[8] = { 1, 0, 0, 1, 0, 1, 1, 1 };
+	u_int16_t max;
+	struct list_head *list;
+	struct ipt_flow_info *finfo = matchinfo;
+
+	if (matchinfosize != IPT_ALIGN(sizeof(struct ipt_flow_info)))
+		return 0;
+
+	if (strcmp(tablename, "raw") == 0) {
+		printk(KERN_WARNING "ipt_flow: can not by used "
+		       "in the \"raw\" table\n");
+		return 0;
+	}
+
+	switch (ip->proto) {
+		case IPPROTO_IP:
+			if ((finfo->proto & IPFLOW_IP_MASK) &&
+			    (finfo->proto &
+			    ~IPFLOW_NETWORK_MASK &
+			    ~IPFLOW_DIR &
+			    ~IPFLOW_IP_MASK))
+				return 0;
+			if (bad_combo[(finfo->proto >> IPFLOW_IP_SHIFT) & 0x7])
+				return 0;
+			break;
+		case IPPROTO_ICMP:
+			if ((finfo->proto & IPFLOW_ICMP_MASK) &&
+			    (finfo->proto &
+			    ~IPFLOW_NETWORK_MASK &
+			    ~IPFLOW_DIR &
+			    ~IPFLOW_ICMP_MASK))
+				return 0;
+			if (bad_combo[(finfo->proto >> IPFLOW_ICMP_SHIFT) &
+			    0x7])
+				return 0;
+			break;
+		case IPPROTO_TCP:
+			if ((finfo->proto & IPFLOW_TCP_MASK) &&
+			    (finfo->proto &
+			    ~IPFLOW_NETWORK_MASK &
+			    ~IPFLOW_DIR &
+			    ~IPFLOW_TCP_MASK))
+				return 0;
+			if (bad_combo[(finfo->proto >> IPFLOW_TCP_SHIFT) & 0x7])
+				return 0;
+			break;
+		case IPPROTO_UDP:
+			if ((finfo->proto & IPFLOW_UDP_MASK) &&
+			    (finfo->proto &
+			    ~IPFLOW_NETWORK_MASK &
+			    ~IPFLOW_DIR &
+			    ~IPFLOW_UDP_MASK))
+				return 0;
+			if (bad_combo[(finfo->proto >> IPFLOW_UDP_SHIFT) & 0x7])
+				return 0;
+			break;
+		default:
+			return 0;
+	}
+
+	if ((finfo->proto & IPFLOW_NETWORK_MASK)) {
+		if (finfo->proto & IPFLOW_DIR) {
+			if ((finfo->network & ip->dmsk.s_addr) !=
+			    ip->dst.s_addr)
+				return 0;
+		} else {
+			if ((finfo->network & ip->smsk.s_addr) !=
+			    ip->src.s_addr)
+				return 0;
+		}
+		if (finfo->max > (MAX_SIZE(max) * 2))
+			return 0;
+		finfo->nm = kmalloc(sizeof(struct ipt_flow_nm), GFP_KERNEL);
+		if (!finfo->nm)
+			return 0;
+		memset(finfo->nm, 0, sizeof(struct ipt_flow_nm));
+		write_lock_bh(&ipt_flow_lock);
+		ipt_flow_existing(finfo);
+		if (atomic_read(&ipt_flow_notifier_list_count) == 0) {
+			ipt_flow_nb.notifier_call = ipt_flow_nm_notifier;
+			if (ipct_flow_register_notifier(&ipt_flow_nb)) {
+				kfree(finfo->nm);
+				write_unlock_bh(&ipt_flow_lock);
+				return 0;
+			}
+		}
+		list = (struct list_head *) finfo;
+		list_add(list, &ipt_flow_notifier_list);
+		atomic_inc(&ipt_flow_notifier_list_count);
+		write_unlock_bh(&ipt_flow_lock);
+	} else {
+		if (finfo->max > MAX_SIZE(max))
+			return 0;
+	}
+	return 1;
+}
+
+void
+destroy(void *matchinfo, unsigned int matchinfosize)
+{
+	struct list_head *list;
+	struct ipt_flow_info *finfo = matchinfo;
+
+	if (matchinfosize != IPT_ALIGN(sizeof(struct ipt_flow_info)))
+		return;
+
+	if ((finfo->proto & IPFLOW_NETWORK_MASK) && finfo->nm) {
+		write_lock_bh(&ipt_flow_lock);
+		atomic_dec(&ipt_flow_notifier_list_count);
+		if (atomic_read(&ipt_flow_notifier_list_count) == 0) {
+			if (ipct_flow_unregister_notifier(&ipt_flow_nb))
+				printk(KERN_ERR
+				       "ipct_flow_unregister_notifier failed, "
+				       "huh?\n");
+		}
+		list = (struct list_head *) finfo;
+		list_del(list);
+		write_unlock_bh(&ipt_flow_lock);
+		kfree(finfo->nm);
+	}
+}
+
+static struct ipt_match flow_match = {
+	.name		= "flow",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.destroy	= &destroy,
+	.me		= THIS_MODULE,
+};
+
+static int __init
+init(void)
+{
+	return ipt_register_match(&flow_match);
+}
+
+static void __exit
+fini(void)
+{
+	ipt_unregister_match(&flow_match);
+}
+
+module_init(init);
+module_exit(fini);

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-flow-20050628.diff"

diff -Nru a/extensions/Makefile b/extensions/Makefile
--- a/extensions/Makefile	2004-11-18 16:52:12.000000000 -0600
+++ b/extensions/Makefile	2005-06-15 08:48:50.000000000 -0500
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp flow hashlimit helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner physdev standard tcp udp HL LOG MARK TRACE
 
 # Optionals
diff -Nru a/extensions/libipt_flow.c b/extensions/libipt_flow.c
--- a/extensions/libipt_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ b/extensions/libipt_flow.c	2005-06-15 13:36:20.000000000 -0500
@@ -0,0 +1,338 @@
+/*
+ * Shared library iptables add-on to add [IP|ICMP|TCP|UDP] flow count
+ * match support.
+ */
+
+/* (C) 2004 2005 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_flow.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf("flow v%s options:\n"
+	       "Matches when >= n flows exist\n"
+	       " --DIR-PROTOCOL[-TYPE] [!] n\n"
+	       " --nm [!] n.n.n.n/mm or n.n.n.n/m.m.m.m\n"
+	       "    where\n"
+	       "\tDIR is orig or repl\n"
+	       "\tPROTOCOL is ip, icmp, tcp or udp\n"
+	       "\tTYPE is n or e\n"
+	       "\t\tTYPE n is new connections\n"
+	       "\t\tTYPE e is established connections\n"
+	       "\t\tSpecifying no TYPE results in the comparison being made\n"
+	       "\t\tfor all PROTOCOL connections regardless of TYPE."
+	       "\n", IPTABLES_VERSION);
+}
+
+static void
+parse_network_mask(const char *nm, u_int32_t *network, u_int32_t *mask)
+{
+	unsigned int naddrs;
+	struct in_addr *addr,
+	               addr_mask;
+
+	parse_hostnetworkmask(nm, &addr, &addr_mask, &naddrs);
+	if (naddrs > 1)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiple IP addresses not allowed");
+	if (naddrs == 1) {
+		*network = addr[0].s_addr;
+		*mask = addr_mask.s_addr;
+	}
+}
+
+/* Function which parses command options; returns true if it ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	int ret;
+	u_int16_t max;
+	u_int32_t count;
+	struct ipt_flow_info *finfo = (struct ipt_flow_info *)(*match)->data;
+
+
+	if (c < 256) {
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "cannot invert %s, only its argument",
+				   argv[optind - 2]);
+		check_inverse(optarg, &invert, &optind, 0);
+		finfo->invert = invert;
+		*flags = 1;
+	}
+
+	switch (c) {
+		case 0:
+		case 3:
+		case 6:
+		case 9:
+		case 12:
+		case 15:
+		case 18:
+		case 21:
+			ret = string_to_number(argv[optind - 1], 1,
+					       MAX_SIZE(max) * 2, &count);
+			if (ret == -1) {
+				exit_error(PARAMETER_PROBLEM,
+					   "value out of range");
+			}
+			break;
+		default:
+			ret = string_to_number(argv[optind - 1], 1,
+					       MAX_SIZE(max), &count);
+			if (ret == -1) {
+				exit_error(PARAMETER_PROBLEM,
+					   "value out of range");
+			}
+			break;
+	}
+
+	switch (c) {
+		case 0:
+			finfo->proto |= IPFLOW_IP;
+			break;
+		case 1:
+			finfo->proto |= IPFLOW_IP_N;
+			break;
+		case 2:
+			finfo->proto |= IPFLOW_IP_E;
+			break;
+		case 3:
+			finfo->proto |= IPFLOW_ICMP;
+			break;
+		case 4:
+			finfo->proto |= IPFLOW_ICMP_N;
+			break;
+		case 5:
+			finfo->proto |= IPFLOW_ICMP_E;
+			break;
+		case 6:
+			finfo->proto |= IPFLOW_TCP;
+			break;
+		case 7:
+			finfo->proto |= IPFLOW_TCP_N;
+			break;
+		case 8:
+			finfo->proto |= IPFLOW_TCP_E;
+			break;
+		case 9:
+			finfo->proto |= IPFLOW_UDP;
+			break;
+		case 10:
+			finfo->proto |= IPFLOW_UDP_N;
+			break;
+		case 11:
+			finfo->proto |= IPFLOW_UDP_E;
+			break;
+		case 12:
+			finfo->proto |= IPFLOW_IP;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 13:
+			finfo->proto |= IPFLOW_IP_N;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 14:
+			finfo->proto |= IPFLOW_IP_E;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 15:
+			finfo->proto |= IPFLOW_ICMP;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 16:
+			finfo->proto |= IPFLOW_ICMP_N;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 17:
+			finfo->proto |= IPFLOW_ICMP_E;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 18:
+			finfo->proto |= IPFLOW_TCP;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 19:
+			finfo->proto |= IPFLOW_TCP_N;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 20:
+			finfo->proto |= IPFLOW_TCP_E;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 21:
+			finfo->proto |= IPFLOW_UDP;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 22:
+			finfo->proto |= IPFLOW_UDP_N;
+			break;
+		case 23:
+			finfo->proto |= IPFLOW_UDP_E;
+			finfo->proto |= IPFLOW_DIR;
+			break;
+		case 256:
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+				   	   "cannot invert %s, only "
+					   "its argument",
+					   argv[optind - 2]);
+			check_inverse(optarg, &invert, &optind, 0);
+			finfo->invert_network = invert;
+			parse_network_mask(argv[optind - 1],
+					   &finfo->network, &finfo->mask);
+			finfo->proto |= IPFLOW_NETWORK_MASK;
+			break;
+		default:
+			return 0;
+	}
+	finfo->max = count;
+	return 1;
+}
+
+/* Final check; must must specify `--<orig|repl>-<ip|icmp|tcp|udp>[-<n|e>]' */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "You must specify "
+			   "`--<orig|repl>-<ip|icmp|tcp|udp>[-<n|e>]'");
+}
+
+void
+flow_print(struct ipt_flow_info *finfo)
+{
+	char *dir,
+	     *invert,
+	     *invert_network;
+	
+	if (finfo->proto & IPFLOW_DIR)
+		dir = "repl";
+	else
+		dir = "orig";
+	if (finfo->invert)
+		invert = "! ";
+	else
+		invert = " ";
+	if (finfo->invert_network)
+		invert_network = "! ";
+	else
+		invert_network = " ";
+	if ((finfo->proto & IPFLOW_IP) && finfo->max)
+		printf("--%s-ip %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_IP_N) && finfo->max)
+		printf("--%s-ip-n %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_IP_E) && finfo->max)
+		printf("--%s-ip-e %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_ICMP) && finfo->max)
+		printf("--%s-icmp %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_ICMP_N) && finfo->max)
+		printf("--%s-icmp-n %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_ICMP_E) && finfo->max)
+		printf("--%s-icmp-e %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_TCP) && finfo->max)
+		printf("--%s-tcp %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_TCP_N) && finfo->max)
+		printf("--%s-tcp-n %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_TCP_E) && finfo->max)
+		printf("--%s-tcp-e %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_UDP) && finfo->max)
+		printf("--%s-udp %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_UDP_N) && finfo->max)
+		printf("--%s-udp-n %s%i ", dir, invert, finfo->max);
+	if ((finfo->proto & IPFLOW_UDP_E) && finfo->max)
+		printf("--%s-udp-e %s%i ", dir, invert, finfo->max);
+	if (finfo->proto & IPFLOW_NETWORK_MASK) {
+		printf("--nm %s%s%s ",
+		       invert_network,
+		       addr_to_dotted((struct in_addr *) &finfo->network),
+		       mask_to_dotted((struct in_addr *) &finfo->mask));
+	}
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	struct ipt_flow_info *finfo = (struct ipt_flow_info *)match->data;
+
+	printf("flow ");
+	flow_print(finfo);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_flow_info *finfo = (struct ipt_flow_info *)match->data;
+
+	flow_print(finfo);
+}
+
+static struct option opts[] = {
+	{ .name = "orig-ip",		.has_arg = 1, .flag = 0, .val =  0 },
+	{ .name = "orig-ip-n",		.has_arg = 1, .flag = 0, .val =  1 },
+	{ .name = "orig-ip-e",		.has_arg = 1, .flag = 0, .val =  2 },
+	{ .name = "orig-icmp",		.has_arg = 1, .flag = 0, .val =  3 },
+	{ .name = "orig-icmp-n",	.has_arg = 1, .flag = 0, .val =  4 },
+	{ .name = "orig-icmp-e",	.has_arg = 1, .flag = 0, .val =  5 },
+	{ .name = "orig-tcp",		.has_arg = 1, .flag = 0, .val =  6 },
+	{ .name = "orig-tcp-n",		.has_arg = 1, .flag = 0, .val =  7 },
+	{ .name = "orig-tcp-e",		.has_arg = 1, .flag = 0, .val =  8 },
+	{ .name = "orig-udp",		.has_arg = 1, .flag = 0, .val =  9 },
+	{ .name = "orig-udp-n",		.has_arg = 1, .flag = 0, .val = 10 },
+	{ .name = "orig-udp-e",		.has_arg = 1, .flag = 0, .val = 11 },
+	{ .name = "repl-ip",		.has_arg = 1, .flag = 0, .val = 12 },
+	{ .name = "repl-ip-n",		.has_arg = 1, .flag = 0, .val = 13 },
+	{ .name = "repl-ip-e",		.has_arg = 1, .flag = 0, .val = 14 },
+	{ .name = "repl-icmp",		.has_arg = 1, .flag = 0, .val = 15 },
+	{ .name = "repl-icmp-n",	.has_arg = 1, .flag = 0, .val = 16 },
+	{ .name = "repl-icmp-e",	.has_arg = 1, .flag = 0, .val = 17 },
+	{ .name = "repl-tcp",		.has_arg = 1, .flag = 0, .val = 18 },
+	{ .name = "repl-tcp-n",		.has_arg = 1, .flag = 0, .val = 19 },
+	{ .name = "repl-tcp-e",		.has_arg = 1, .flag = 0, .val = 20 },
+	{ .name = "repl-udp",		.has_arg = 1, .flag = 0, .val = 21 },
+	{ .name = "repl-udp-n",		.has_arg = 1, .flag = 0, .val = 22 },
+	{ .name = "repl-udp-e",		.has_arg = 1, .flag = 0, .val = 23 },
+	{ .name = "nm",			.has_arg = 1, .flag = 0, .val = 256 },
+	{0}
+};
+
+static
+struct iptables_match flow = {
+	.next		= NULL,
+	.name		= "flow",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_flow_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_flow_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void
+_init(void)
+{
+	register_match(&flow);
+}
diff -Nru a/extensions/libipt_flow.man b/extensions/libipt_flow.man
--- a/extensions/libipt_flow.man	1969-12-31 18:00:00.000000000 -0600
+++ b/extensions/libipt_flow.man	2005-06-15 13:45:55.000000000 -0500
@@ -0,0 +1,15 @@
+This module allows you to match a packet when the specified number of known
+protocol connections is exceeded.  The matches can be made against
+generic IP, ICMP, TCP or UDP flow counters.  This match can be used in
+all tables but raw.
+.TP
+.BI "Matches when >= " "n" " flows exist"
+.TP
+.BI "--" "DIR" "-" "PROTOCOL" "[-" "TYPE" "] [!] " "n"
+.IR "" "where " "DIR" " is orig or repl for original and reply directions respectively.  " "PROTOCOL" " is ip, icmp, tcp or udp.  " "TYPE" " is n or e.  " "TYPE" " n is for new connections.  " "TYPE" " e is for established connections.  Specifying no " "TYPE" " results in the comparison being made for all " "PROTOCOL" " connections regardless of " "TYPE" "."
+.TP
+.BI "--" "nm" " [!] " "n.n.n.n" "/" "mm" " or " "n.n.n.n" "/" "m.m.m.m"
+.IR "" "where " "n.n.n.n" " is a network and " "mm" " or " "m.m.m.m" " are mask.  This option creates a flow counting object for the specified subnet; the counters for the relevant protocols will consist of all the counters for the addresses that match the subnet."
+.TP
+.BI "if " "! " "is specified"
+.IR "" "The --" "DIR" "-" "PROTOCOL" "[-" "TYPE" "] matches when the flow count is < " "n" ".  The --" "nm n.n.n.n" "/" "mm" " or " "n.n.n.n" "/" "m.m.m.m" " matches when the packet is not in the specified subnet."

--xHFwDpU9dbj6ez1V--
