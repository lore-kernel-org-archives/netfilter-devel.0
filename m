From: Josh Samuelson <josamue1@wsc.edu>
Subject: Re: [PATCH] new match extension `flow'
Date: Wed, 3 Nov 2004 20:20:39 -0600
Message-ID: <20041104022039.GA25749@wsc.edu>
References: <20041028020550.GA10097@wsc.edu> <41829ADC.2090708@eurodev.net>
	<20041031063813.GA29402@wsc.edu> <4184F9AD.9040902@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <4184F9AD.9040902@eurodev.net>
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


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 31, 2004 at 03:41:49PM +0100, Pablo Neira wrote:
> 
> 
> Josh,
> 
> Sure, your solution is smart but I still think we can do that that this
> stuff without adding it to the core of the conntrack. I think that this
> is a perfect client of the event notification API which is *still* in
> development (expect changes).
> 
> Another issue, AFAICS with your approach we can limit the number of
> connections per machine, but not per network, i.e. limit to 256 tcp
> connections for the whole 192.168.20.0/24, that's a different problem to
> resolve though..
> 
>  Pablo
> 

Hi Pablo,

You'll have to excuse my newness to the netfilter-devel scene and the
list in general.  Thank you for pointing out the thread on the connection
tracking events patch.  I had no idea work was being done there.
Initial impression: Slick!

I took your recommendations and changed the patch to use the connection
tracking events API.  I also altered the flow match module to track
the number of connections based on a network/mask option if one is
specified.

The kernel patch can only be applied after your CTE patch.  It should
patch fine on 2.6.9, but 2.6.10-rc1 will reject a hunk for
net/ipv4/netfilter/Kconfig because I added the lines necessary for
IP_NF_CONNTRACK_EVENTS; easy enough to fix by hand though.

The iptables patch should apply fine to vanilla iptables-1.2.11.

I've only done some initial testing with this thus far: one machine
routing through a patched machine.  Hopefully here in the next
few days I can put this on a machine that routes a few hundred
nodes to put some more load on it for testing purposes.

Cheers,
-Josh

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.9-flow-20041103.diff"

diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_cte_flow.h linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_cte_flow.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ip_cte_flow.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_cte_flow.h	2004-11-03 19:10:13.000000000 -0600
@@ -0,0 +1,28 @@
+#ifndef _IP_CTE_FLOW_H
+#define _IP_CTE_FLOW_H
+
+#define BIT_SET(b) (1 << (b))
+#define INCREMENT_WITHOUT_OVERFLOW(c) if (c < ~(1 << ((sizeof(c) * 8) - 1))) c++
+
+/* A `ip_cte_flow' is a structure containing the IP connection count
+   on various IP protocols.
+*/
+
+struct ip_cte_flow
+{
+	 struct list_head list;
+	 u_int32_t ip_ct_dir_original_ip,
+		   ip,
+		   icmp,
+		   tcp,
+		   udp;
+};
+
+extern struct list_head *ip_cte_flow_hash;
+extern unsigned int ip_cte_flow_htable_size;
+DECLARE_RWLOCK_EXTERN(ip_cte_flow_lock);
+extern int ip_cte_flow_register_notifier(struct notifier_block *nb);
+extern int ip_cte_flow_unregister_notifier(struct notifier_block *nb);
+extern u_int32_t ip_cte_hash_flow_ip(u_int32_t ip);
+
+#endif /* _IP_CTE_FLOW_H */
diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ipt_flow.h linux-2.6.9-flow/include/linux/netfilter_ipv4/ipt_flow.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ipt_flow.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ipt_flow.h	2004-11-03 17:02:37.000000000 -0600
@@ -0,0 +1,41 @@
+#ifndef _IPT_FLOW_H
+#define _IPT_FLOW_H
+
+#define BIT_SET(b) (1 << (b))
+
+typedef enum
+{
+	IPFLOW_IP,
+	IPFLOW_ICMP,
+	IPFLOW_TCP,
+	IPFLOW_UDP,
+	IPFLOW_NETWORK_MASK = 31
+} ipflow_bits_t;
+
+struct ipt_flow_nm
+{
+	u_int32_t ip,
+		  icmp,
+		  tcp,
+		  udp;
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
+	u_int32_t proto,
+		  network,
+		  mask,
+		  max;
+	struct ipt_flow_nm *nm;
+};
+
+#endif /* IPT_FLOW_H */
diff -Pru linux-2.6.9/net/ipv4/netfilter/Kconfig linux-2.6.9-flow/net/ipv4/netfilter/Kconfig
--- linux-2.6.9/net/ipv4/netfilter/Kconfig	2004-10-18 16:54:55.000000000 -0500
+++ linux-2.6.9-flow/net/ipv4/netfilter/Kconfig	2004-11-02 11:01:58.000000000 -0600
@@ -32,6 +32,28 @@
 
 	  If unsure, say `N'.
 
+config IP_NF_CONNTRACK_EVENTS
+	bool "Connection tracking events"
+	depends on IP_NF_CONNTRACK
+	help
+	  If unsure, say `N'.
+	  
+config IP_NF_CTE_FLOW
+	tristate "Connection tracking events: protocol flow counters (EXPERIMENTAL)"
+	depends on IP_NF_CONNTRACK_EVENTS && EXPERIMENTAL
+	help
+	  This option uses the connection tracking event notifiers to
+	  keep protocol flow counters indexed by the original direction
+	  source IP address.  The protocol counters include generic IP,
+	  ICMP, TCP and UDP.
+
+	  These counters can be read from "/proc/net/ip_cte_flow".
+
+	  These counters can be used in the "protocol flow counters match
+	  support", see below.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_CT_PROTO_SCTP
 	tristate  'SCTP protocol connection tracking support (EXPERIMENTAL)'
 	depends on IP_NF_CONNTRACK && EXPERIMENTAL
@@ -279,6 +301,22 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_CTE_MATCH_FLOW
+       tristate 'protocol flow counters match support (EXPERIMENTAL)'
+       depends on IP_NF_IPTABLES && IP_NF_CTE_FLOW && (IP_NF_FILTER || IP_NF_NAT || IP_NF_MANGLE) && EXPERIMENTAL
+       help
+         `flow' matching allows you to match a packet when the specified
+         number of known protocol connections from a original direction
+         source IP address is exceeded.  The matches can be made against
+         generic IP, ICMP, TCP or UDP flow counters.  This match can be
+         used in all tables but raw.
+
+         For example, this match allows you to control the number and type
+         of connections (flows) from hosts in a known local network routing
+         through the machine.
+
+         To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_MATCH_OWNER
 	tristate "Owner match support"
 	depends on IP_NF_IPTABLES
diff -Pru linux-2.6.9/net/ipv4/netfilter/Makefile linux-2.6.9-flow/net/ipv4/netfilter/Makefile
--- linux-2.6.9/net/ipv4/netfilter/Makefile	2004-10-18 16:53:43.000000000 -0500
+++ linux-2.6.9-flow/net/ipv4/netfilter/Makefile	2004-11-02 10:58:21.000000000 -0600
@@ -34,6 +34,9 @@
 obj-$(CONFIG_IP_NF_NAT_FTP) += ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) += ip_nat_irc.o
 
+# connection tracking event objects
+obj-$(CONFIG_IP_NF_CTE_FLOW) += ip_cte_flow.o
+
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
 
@@ -67,6 +70,7 @@
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
+obj-$(CONFIG_IP_NF_CTE_MATCH_FLOW) += ipt_flow.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff -Pru linux-2.6.9/net/ipv4/netfilter/ip_cte_flow.c linux-2.6.9-flow/net/ipv4/netfilter/ip_cte_flow.c
--- linux-2.6.9/net/ipv4/netfilter/ip_cte_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow/net/ipv4/netfilter/ip_cte_flow.c	2004-11-03 20:12:09.000000000 -0600
@@ -0,0 +1,377 @@
+/* Kernel module to track [IP|ICMP|TCP|UDP] flow counts. */
+
+/* (C) 2004 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/vmalloc.h>
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
+#include <linux/netfilter_ipv4/ip_cte_flow.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Josh Samuelson <josamue1@wsc.edu>");
+MODULE_DESCRIPTION("protocol flow count tracking via connection tracking events");
+
+DECLARE_RWLOCK(ip_cte_flow_lock);
+struct list_head *ip_cte_flow_hash;
+unsigned int ip_cte_flow_htable_size = 0;
+/* static atomic_t ip_cte_flow_count = ATOMIC_INIT(0); */
+static int ip_cte_flow_hash_rnd;
+static kmem_cache_t *ip_cte_flow_cachep;
+static struct notifier_block *ip_cte_flow_nb_chain;
+
+#ifdef CONFIG_PROC_FS
+static void *ip_cte_flow_seq_start(struct seq_file *s, loff_t *pos)
+{
+	if (*pos >= ip_cte_flow_htable_size)
+		return NULL;
+	return &ip_cte_flow_hash[*pos];
+}
+  
+static void ip_cte_flow_seq_stop(struct seq_file *s, void *v)
+{
+}
+
+static void *ip_cte_flow_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= ip_cte_flow_htable_size)
+		return NULL;
+	return &ip_cte_flow_hash[*pos];
+}
+
+static int ip_cte_flow_seq_show(struct seq_file *s, void *v)
+{
+	int ret = 0;
+	struct list_head *list;
+	struct ip_cte_flow *flow;
+
+	list = (struct list_head *) v;
+	list = list->next;
+	READ_LOCK(&ip_cte_flow_lock);
+	list_for_each(list, (struct list_head *) v) {
+		flow = (struct ip_cte_flow *) list;
+		if (seq_printf(s, "%u.%u.%u.%u IP: %u ICMP: %hu "
+				  "TCP: %hu UDP: %hu\n",
+				  NIPQUAD(flow->ip_ct_dir_original_ip),
+				  flow->ip,
+				  flow->icmp,
+				  flow->tcp,
+				  flow->udp)) {
+			ret = -ENOSPC;
+			break;
+		}
+	}
+	READ_UNLOCK(&ip_cte_flow_lock);
+	return ret;
+}
+  
+static struct seq_operations ip_cte_flow_seq_ops = {
+	.start = ip_cte_flow_seq_start,
+	.next  = ip_cte_flow_seq_next,
+	.stop  = ip_cte_flow_seq_stop,
+	.show  = ip_cte_flow_seq_show
+};
+
+static int ip_cte_flow_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &ip_cte_flow_seq_ops);
+}
+
+static struct file_operations ip_cte_flow_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = ip_cte_flow_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release
+};
+#endif /* CONFIG_PROC_FS */
+  
+int
+ip_cte_flow_register_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_register(&ip_cte_flow_nb_chain, nb);
+}
+
+int
+ip_cte_flow_unregister_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&ip_cte_flow_nb_chain, nb);
+}
+
+void
+ip_cte_flow_event(enum ip_conntrack_events event, struct ip_conntrack *ct)
+{
+	notifier_call_chain(&ip_cte_flow_nb_chain, event, ct);
+}
+
+u_int32_t
+ip_cte_hash_flow_ip(u_int32_t ip)
+{
+	return(jhash_1word(ip, ip_cte_flow_hash_rnd) % ip_cte_flow_htable_size);
+}
+
+static int
+ip_cte_flow_inc(struct ip_conntrack_tuple_hash *hash)
+{
+	unsigned int flow_hash;
+	u_int32_t ip;
+	struct list_head *list;
+	struct ip_cte_flow *flow = NULL;
+
+	ip = hash->tuple.src.ip;
+	flow_hash = ip_cte_hash_flow_ip(ip);
+	READ_LOCK(&ip_cte_flow_lock);
+	list_for_each(list, &ip_cte_flow_hash[flow_hash]) {
+		if (((struct ip_cte_flow *) list)->ip_ct_dir_original_ip ==
+		    ip) {
+			flow = (struct ip_cte_flow *) list;
+			break;
+		}
+	}
+	READ_UNLOCK(&ip_cte_flow_lock);
+	WRITE_LOCK(&ip_cte_flow_lock);
+	if (!flow) {
+		flow = kmem_cache_alloc(ip_cte_flow_cachep, GFP_ATOMIC);
+		if (flow) {
+			/* atomic_inc(&ip_cte_flow_count); */
+			memset(flow, 0, sizeof(struct ip_cte_flow));
+			flow->ip_ct_dir_original_ip = ip;
+			list = (struct list_head *) flow;
+			list_add(list, &ip_cte_flow_hash[flow_hash]);
+		}
+	}
+	if (flow) {
+		INCREMENT_WITHOUT_OVERFLOW(flow->ip);
+		switch (hash->tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				INCREMENT_WITHOUT_OVERFLOW(flow->icmp);
+				break;
+			case IPPROTO_TCP:
+				INCREMENT_WITHOUT_OVERFLOW(flow->tcp);
+				break;
+			case IPPROTO_UDP:
+				INCREMENT_WITHOUT_OVERFLOW(flow->udp);
+				break;
+		}
+	}
+	WRITE_UNLOCK(&ip_cte_flow_lock);
+	return(flow == NULL);
+}
+
+static void
+ip_cte_flow_dec(struct ip_conntrack_tuple_hash *hash)
+{
+	unsigned int flow_hash;
+	u_int32_t ip;
+	struct list_head *list;
+	struct ip_cte_flow *flow = NULL;
+
+	ip = hash->tuple.src.ip;
+	flow_hash = ip_cte_hash_flow_ip(ip);
+	READ_LOCK(&ip_cte_flow_lock);
+	list_for_each(list, &ip_cte_flow_hash[flow_hash]) {
+		if (((struct ip_cte_flow *) list)->ip_ct_dir_original_ip ==
+		    ip) {
+			flow = (struct ip_cte_flow *) list;
+			break;
+		}
+	}
+	READ_UNLOCK(&ip_cte_flow_lock);
+	if (flow) {
+		WRITE_LOCK(&ip_cte_flow_lock);
+		if(flow->ip)
+			flow->ip--;
+		switch (hash->tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				if (flow->icmp)
+					flow->icmp--;
+				break;
+			case IPPROTO_TCP:
+				if (flow->tcp)
+					flow->tcp--;
+				break;
+			case IPPROTO_UDP:
+				if (flow->udp)
+					flow->udp--;
+				break;
+		}
+		if (flow->ip == 0) {
+			list = (struct list_head *) flow;
+			list_del(list);
+			kmem_cache_free(ip_cte_flow_cachep, flow);
+			/* atomic_dec(&ip_cte_flow_count); */
+		}
+		WRITE_UNLOCK(&ip_cte_flow_lock);
+	} else {
+		printk(KERN_WARNING "conntrack being destroyed, "
+				    "yet not found on flow list\n"
+				    "%u src: %u.%u.%u.%u dst: %u.%u.%u.%u\n",
+				    hash->tuple.dst.protonum,
+				    NIPQUAD(hash->tuple.src.ip),
+				    NIPQUAD(hash->tuple.dst.ip));
+	}
+}
+
+static void
+ip_cte_flow_existing(void)
+{
+	unsigned int i;
+	struct list_head *list;
+	struct ip_conntrack_tuple_hash *hash;
+
+	READ_LOCK(&ip_conntrack_lock);
+	for (i = 0; i < ip_conntrack_htable_size; i++) {
+		list_for_each(list, &ip_conntrack_hash[i]) {
+			hash = (struct ip_conntrack_tuple_hash *) list;
+			if (!DIRECTION(hash))
+				ip_cte_flow_inc(hash);
+		}
+	}
+	READ_UNLOCK(&ip_conntrack_lock);
+}
+
+static void
+ip_cte_flow_destroy(void)
+{
+	unsigned int i;
+	struct list_head *list;
+	struct ip_cte_flow *flow;
+
+	WRITE_LOCK(&ip_cte_flow_lock);
+	for (i = 0; i < ip_cte_flow_htable_size; i++) {
+		list = ip_cte_flow_hash[i].next;
+		while (list != &ip_cte_flow_hash[i]) {
+				flow = (struct ip_cte_flow *) list;
+				list = list->next;
+				list_del((struct list_head *) flow);
+				kmem_cache_free(ip_cte_flow_cachep, flow);
+		}
+	}
+	WRITE_UNLOCK(&ip_cte_flow_lock);
+}
+
+static int ip_cte_flow_notifier(struct notifier_block *nb,
+	unsigned long ips,
+	void *v)
+{
+	struct ip_conntrack *ct = v;
+
+	switch (ips)
+	{
+		case BIT_SET(IPCT_NEW):
+		case BIT_SET(IPCT_RELATED):
+			ip_cte_flow_inc(&ct->tuplehash[IP_CT_DIR_ORIGINAL]);
+			ip_cte_flow_event(ips, ct);
+			break;
+		case BIT_SET(IPCT_DESTROY):
+			ip_cte_flow_dec(&ct->tuplehash[IP_CT_DIR_ORIGINAL]);
+			ip_cte_flow_event(ips, ct);
+			break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ip_cte_flow_nb = {
+	.notifier_call = ip_cte_flow_notifier,
+	.next = NULL,
+	.priority = 0
+};
+
+static int __init init(void)
+{
+	unsigned int i;
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *proc_flow;
+#endif
+
+	need_ip_conntrack();
+
+	ip_cte_flow_htable_size = ip_conntrack_htable_size / 2;
+
+	get_random_bytes(&ip_cte_flow_hash_rnd, 4);
+
+	ip_cte_flow_hash = vmalloc(sizeof(struct list_head)
+					* ip_cte_flow_htable_size);
+	if (!ip_cte_flow_hash) {
+		printk(KERN_ERR "Unable to create ip_cte_flow_hash\n");
+		goto err;
+	}
+
+	for (i = 0; i < ip_cte_flow_htable_size; i++)
+		INIT_LIST_HEAD(&ip_cte_flow_hash[i]);
+
+	ip_cte_flow_cachep = kmem_cache_create("ip_cte_flow",
+						sizeof(struct ip_cte_flow), 0,
+						SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!ip_cte_flow_cachep) {
+		printk(KERN_ERR "Unable to create ip_cte_flow slab cache\n");
+		goto err_free_hash;
+ 	}
+
+#ifdef CONFIG_PROC_FS
+	proc_flow = proc_net_fops_create("ip_cte_flow", 0440, &ip_cte_flow_file_ops);
+	if (!proc_flow) goto err_free_slab;
+#endif
+
+	if (ip_conntrack_register_notifier(&ip_cte_flow_nb)) {
+		goto cleanup_proc;
+	}
+
+	ip_cte_flow_existing();
+
+	printk("connection tracking events: protocol flow counters "
+	       "(%u buckets) - %Zd bytes per IP_CT_DIR_ORIGINAL source\n",
+	       ip_cte_flow_htable_size,
+	       sizeof(struct ip_cte_flow));
+
+	return 0;
+
+cleanup_proc:
+#ifdef CONFIG_PROC_FS
+	proc_net_remove("ip_cte_flow");
+#endif
+err_free_slab:
+ 	kmem_cache_destroy(ip_cte_flow_cachep);
+err_free_hash:
+	vfree(ip_cte_flow_hash);
+err:
+	return -ENOMEM;
+}
+
+static void __exit fini(void)
+{
+	ip_cte_flow_destroy();
+
+	if (ip_conntrack_unregister_notifier(&ip_cte_flow_nb))
+		printk(KERN_ERR "ip_conntrack_unregister_notifier() "
+				"failed, huh?\n");
+#ifdef CONFIG_PROC_FS
+	proc_net_remove("ip_cte_flow");
+#endif
+	kmem_cache_destroy(ip_cte_flow_cachep);
+	vfree(ip_cte_flow_hash);
+}
+
+module_init(init);
+module_exit(fini);
+
+EXPORT_SYMBOL(ip_cte_flow_hash);
+EXPORT_SYMBOL(ip_cte_flow_htable_size);
+EXPORT_SYMBOL(ip_cte_flow_lock);
+EXPORT_SYMBOL(ip_cte_flow_register_notifier);
+EXPORT_SYMBOL(ip_cte_flow_unregister_notifier);
+EXPORT_SYMBOL(ip_cte_hash_flow_ip);
diff -Pru linux-2.6.9/net/ipv4/netfilter/ipt_flow.c linux-2.6.9-flow/net/ipv4/netfilter/ipt_flow.c
--- linux-2.6.9/net/ipv4/netfilter/ipt_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow/net/ipv4/netfilter/ipt_flow.c	2004-11-03 20:12:00.000000000 -0600
@@ -0,0 +1,318 @@
+/* Kernel module to match [IP|ICMP|TCP|UDP] flow counts. */
+
+/* (C) 2004 Josh Samuelson <josamue1@wsc.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/vmalloc.h>
+#include <linux/notifier.h>
+#include <linux/list.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_cte_flow.h>
+#include <linux/netfilter_ipv4/ipt_flow.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Josh Samuelson <josamue1@wsc.edu>");
+MODULE_DESCRIPTION("protocol flow count match module");
+
+
+DECLARE_RWLOCK(ipt_flow_lock);
+LIST_HEAD(ipt_flow_notifier_list);
+static atomic_t ipt_flow_notifier_list_count = ATOMIC_INIT(0);
+static struct notifier_block ipt_flow_nb;
+
+static void
+ipt_flow_nw_inc(struct ip_conntrack *ct,
+	struct ipt_flow_info *finfo)
+{
+	INCREMENT_WITHOUT_OVERFLOW(finfo->nm->ip);
+	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+		case IPPROTO_ICMP:
+			INCREMENT_WITHOUT_OVERFLOW(finfo->nm->icmp);
+			break;
+		case IPPROTO_TCP:
+			INCREMENT_WITHOUT_OVERFLOW(finfo->nm->tcp);
+			break;
+		case IPPROTO_UDP:
+			INCREMENT_WITHOUT_OVERFLOW(finfo->nm->udp);
+			break;
+	}
+}
+
+static void
+ipt_flow_nw_dec(struct ip_conntrack *ct,
+	struct ipt_flow_info *finfo)
+{
+	if (finfo->nm->ip)
+		finfo->nm->ip--;
+	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
+		case IPPROTO_ICMP:
+			if (finfo->nm->icmp)
+				finfo->nm->icmp--;
+			break;
+		case IPPROTO_TCP:
+			if (finfo->nm->tcp)
+				finfo->nm->tcp--;
+			break;
+		case IPPROTO_UDP:
+			if (finfo->nm->udp)
+				finfo->nm->udp--;
+			break;
+	}
+}
+
+static void
+ipt_flow_existing(struct ipt_flow_info *finfo)
+{
+        unsigned int i;
+        struct list_head *list;
+        struct ip_cte_flow *flow;
+
+        READ_LOCK(&ip_cte_flow_lock);
+        for (i = 0; i < ip_cte_flow_htable_size; i++) {
+                list_for_each(list, &ip_cte_flow_hash[i]) {
+                        flow = (struct ip_cte_flow *) list;
+			if ((flow->ip_ct_dir_original_ip & finfo->mask) ==
+			    finfo->network) {
+				finfo->nm->ip += flow->ip;
+				finfo->nm->icmp += flow->icmp;
+				finfo->nm->tcp += flow->tcp;
+				finfo->nm->udp += flow->udp;
+			}
+                }
+        }
+        READ_UNLOCK(&ip_cte_flow_lock);
+}
+
+int
+ipt_flow_nm_notifier(struct notifier_block *self,
+	unsigned long event, void *vct)
+{
+	struct list_head *list;
+	struct ipt_flow_info *finfo;
+	struct ip_conntrack *ct = vct;
+	u_int32_t ip;
+
+	READ_LOCK(&ipt_flow_lock);
+	ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	list_for_each(list, &ipt_flow_notifier_list) {
+		finfo = (struct ipt_flow_info *) list;
+		if ((ip & finfo->mask) == finfo->network) {
+			switch (event) {
+				case BIT_SET(IPCT_NEW):
+				case BIT_SET(IPCT_RELATED):
+					ipt_flow_nw_inc(ct, finfo);
+					break;
+				case BIT_SET(IPCT_DESTROY):
+					ipt_flow_nw_dec(ct, finfo);
+					break;
+			}
+		}
+	}
+	READ_UNLOCK(&ipt_flow_lock);
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
+	struct list_head *list;
+	struct ip_cte_flow *flow = NULL;
+	u_int16_t proto;
+	u_int32_t flow_hash,
+		  ip;
+	int ret = 0;
+
+	proto = skb->nh.iph->protocol;
+	ip = skb->nh.iph->saddr;
+	if ((finfo->proto & BIT_SET(IPFLOW_NETWORK_MASK)) &&
+	    ((ip & finfo->mask) == finfo->network)) {
+		if ((finfo->nm->ip >= finfo->max) &&
+		    (finfo->proto & BIT_SET(IPFLOW_IP)))
+			ret = 1;
+		switch (proto) {
+			case IPPROTO_ICMP:
+				if ((finfo->nm->icmp >= finfo->max) &&
+				    (finfo->proto & BIT_SET(IPFLOW_ICMP)))
+					ret = 1;
+				break;
+			case IPPROTO_TCP:
+				if ((finfo->nm->tcp >= finfo->max) &&
+				    (finfo->proto & BIT_SET(IPFLOW_TCP)))
+					ret = 1;
+				break;
+			case IPPROTO_UDP:
+				if ((finfo->nm->udp >= finfo->max) &&
+				    (finfo->proto & BIT_SET(IPFLOW_UDP)))
+					ret = 1;
+				break;
+		}
+	} else {
+		flow_hash = ip_cte_hash_flow_ip(ip);
+		READ_LOCK(&ip_cte_flow_lock);
+		list_for_each(list, &ip_cte_flow_hash[flow_hash]) {
+			if (((struct ip_cte_flow *)
+			    list)->ip_ct_dir_original_ip == ip) {
+				flow = (struct ip_cte_flow *) list;
+				break;
+			}
+		}
+		if (flow) {
+			if ((flow->ip >= finfo->max) &&
+			    (finfo->proto & BIT_SET(IPFLOW_IP)))
+				ret = 1;
+			switch (proto) {
+				case IPPROTO_ICMP:
+					if ((flow->icmp >= finfo->max) &&
+					    (finfo->proto &
+					    BIT_SET(IPFLOW_ICMP)))
+						ret = 1;
+					break;
+				case IPPROTO_TCP:
+					if ((flow->tcp >= finfo->max) &&
+					    (finfo->proto &
+					    BIT_SET(IPFLOW_TCP)))
+						ret = 1;
+					break;
+				case IPPROTO_UDP:
+					if ((flow->udp >= finfo->max) &&
+					    (finfo->proto &
+					    BIT_SET(IPFLOW_UDP)))
+						ret = 1;
+					break;
+			}
+		}
+		READ_UNLOCK(&ip_cte_flow_lock);
+	}
+	return(ret);
+}
+
+static int check(const char *tablename,
+	const struct ipt_ip *ip,
+	void *matchinfo,
+	unsigned int matchsize,
+	unsigned int hook_mask)
+{
+	struct list_head *list;
+	struct ipt_flow_info *finfo = matchinfo;
+
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_flow_info)))
+		return 0;
+
+	if (strcmp(tablename, "raw") == 0) {
+		printk(KERN_WARNING "flow: can not by used in the \"raw\" table\n");
+		return 0;
+	}
+
+	switch (ip->proto & ~BIT_SET(IPFLOW_NETWORK_MASK)) {
+		case IPPROTO_IP:
+			if ((finfo->proto & BIT_SET(IPFLOW_IP)) &&
+			    (finfo->proto &
+			    ~BIT_SET(IPFLOW_NETWORK_MASK) &
+			    ~BIT_SET(IPFLOW_IP)))
+				return 0;
+			break;
+		case IPPROTO_ICMP:
+			if ((finfo->proto & BIT_SET(IPFLOW_ICMP)) &&
+			    (finfo->proto &
+			    ~BIT_SET(IPFLOW_NETWORK_MASK) &
+			    ~BIT_SET(IPFLOW_ICMP)))
+				return 0;
+			break;
+		case IPPROTO_TCP:
+			if ((finfo->proto & BIT_SET(IPFLOW_TCP)) &&
+			    (finfo->proto &
+			    ~BIT_SET(IPFLOW_NETWORK_MASK) &
+			    ~BIT_SET(IPFLOW_TCP)))
+				return 0;
+			break;
+		case IPPROTO_UDP:
+			if ((finfo->proto & BIT_SET(IPFLOW_UDP)) &&
+			    (finfo->proto &
+			    ~BIT_SET(IPFLOW_NETWORK_MASK) &
+			    ~BIT_SET(IPFLOW_UDP)))
+				return 0;
+			break;
+		default:
+			return 0;
+	}
+
+	if ((finfo->proto & BIT_SET(IPFLOW_NETWORK_MASK))) {
+		finfo->nm = vmalloc(sizeof(struct ipt_flow_nm));
+		if (!finfo->nm)
+			return 0;
+		memset(finfo->nm, 0, sizeof(struct ipt_flow_nm));
+		WRITE_LOCK(&ipt_flow_lock);
+		ipt_flow_existing(finfo);
+		list = (struct list_head *) finfo;
+		list_add(list, &ipt_flow_notifier_list);
+		if (atomic_read(&ipt_flow_notifier_list_count) == 0) {
+			ipt_flow_nb.notifier_call = ipt_flow_nm_notifier;
+			if (ip_cte_flow_register_notifier(&ipt_flow_nb)) {
+				vfree(finfo->nm);
+				return 0;
+			}
+		}
+		atomic_inc(&ipt_flow_notifier_list_count);
+		WRITE_UNLOCK(&ipt_flow_lock);
+	}
+	return 1;
+}
+
+void destroy(void *matchinfo,
+	unsigned int matchsize)
+{
+	struct list_head *list;
+	struct ipt_flow_info *finfo = matchinfo;
+
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_flow_info)))
+		return;
+
+	if ((finfo->proto & BIT_SET(IPFLOW_NETWORK_MASK)) && finfo->nm) {
+		WRITE_LOCK(&ipt_flow_lock);
+		atomic_dec(&ipt_flow_notifier_list_count);
+		if (atomic_read(&ipt_flow_notifier_list_count) == 0) {
+			if (ip_cte_flow_unregister_notifier(&ipt_flow_nb))
+				printk(KERN_ERR
+				       "ip_cte_flow_unregister_notifier failed"
+				       ", huh?\n");
+		}
+		list = (struct list_head *) finfo;
+		list_del(list);
+		WRITE_UNLOCK(&ipt_flow_lock);
+		vfree(finfo->nm);
+	}
+}
+
+static struct ipt_match flow_match = {
+	.name		= "flow",
+	.match		= &match,
+	.checkentry	= &check,
+	.destroy	= &destroy,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	need_ip_conntrack();
+	return ipt_register_match(&flow_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&flow_match);
+}
+
+module_init(init);
+module_exit(fini);

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-1.2.11-flow-20041103.diff"

diff -Pru iptables-1.2.11/extensions/Makefile iptables-1.2.11-flow/extensions/Makefile
--- iptables-1.2.11/extensions/Makefile	2004-06-17 05:22:54.000000000 -0500
+++ iptables-1.2.11-flow/extensions/Makefile	2004-11-02 11:24:37.000000000 -0600
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah connlimit connmark conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
+PF_EXT_SLIB:=ah connlimit connmark conntrack dscp ecn esp flow helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK TRACE
 
 # Optionals
diff -Pru iptables-1.2.11/extensions/libipt_flow.c iptables-1.2.11-flow/extensions/libipt_flow.c
--- iptables-1.2.11/extensions/libipt_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ iptables-1.2.11-flow/extensions/libipt_flow.c	2004-11-03 19:01:06.706838768 -0600
@@ -0,0 +1,184 @@
+/* Shared library iptables add-on to add [IP|ICMP|TCP|UDP] flow count
+ * match support.
+ */
+
+/* (C) 2004 Josh Samuelson <josamue1@wsc.edu>
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
+#define MAX_SIZE(c) ~(1 << ((sizeof(c) * 8) - 1))
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf("flow v%s options:\n"
+	       " --maxip n\n"
+	       " --maxicmp n\n"
+	       " --maxtcp n\n"
+	       " --maxudp n\n"
+	       " --nm n.n.n.n/mm or n.n.n.n/m.m.m.m\n"
+	       "\n", IPTABLES_VERSION);
+}
+
+/* Initialize the match. */
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
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
+		exit_error(PARAMETER_PROBLEM, "multiple IP addresses not allowed");
+	if (naddrs == 1) {
+		*network = addr[0].s_addr;
+		*mask = addr_mask.s_addr;
+	}
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	int ret;
+	u_int32_t count;
+	struct ipt_flow_info *finfo = (struct ipt_flow_info *)(*match)->data;
+
+	if (invert || check_inverse(optarg, &invert, &optind, 0)) {
+		exit_error(PARAMETER_PROBLEM, "flow options cannot be inverted");
+	}
+
+	if (c < 256) {
+		ret = string_to_number(argv[optind - 1], 1, MAX_SIZE(count), &count);
+		if (ret == -1) {
+			exit_error(PARAMETER_PROBLEM, "value out of range");
+		}
+	}
+
+	switch (c) {
+		case 0:
+			finfo->proto |= BIT_SET(IPFLOW_IP);
+			*flags = 1;
+			break;
+		case 1:
+			finfo->proto |= BIT_SET(IPFLOW_ICMP);
+			*flags = 1;
+			break;
+		case 6:
+			finfo->proto |= BIT_SET(IPFLOW_TCP);
+			*flags = 1;
+			break;
+		case 17:
+			finfo->proto |= BIT_SET(IPFLOW_UDP);
+			*flags = 1;
+			break;
+		case 256:
+			parse_network_mask(argv[optind - 1], &finfo->network, &finfo->mask);
+			finfo->proto |= BIT_SET(IPFLOW_NETWORK_MASK);
+			break;
+		default:
+			return 0;
+	}
+	finfo->max = count;
+	return 1;
+}
+
+/* Final check; must have specified --max[ip|icmp|tcp|udp]. */
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "You must specify `--max[ip|icmp|tcp|udp]'");
+}
+
+void flow_print(struct ipt_flow_info *finfo)
+{
+	if ((finfo->proto & BIT_SET(IPFLOW_IP)) &&
+	    finfo->max)
+		printf("--maxip %i ", finfo->max);
+	if ((finfo->proto & BIT_SET(IPFLOW_ICMP)) &&
+	    finfo->max)
+		printf("--maxicmp %i ", finfo->max);
+	if ((finfo->proto & BIT_SET(IPFLOW_TCP)) &&
+	    finfo->max)
+		printf("--maxtcp %i ", finfo->max);
+	if ((finfo->proto & BIT_SET(IPFLOW_UDP)) &&
+	    finfo->max)
+		printf("--maxudp %i ", finfo->max);
+	if (finfo->proto & BIT_SET(IPFLOW_NETWORK_MASK)) {
+		printf("--nm %s%s ", addr_to_dotted((struct in_addr *) &finfo->network),
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
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_flow_info *finfo = (struct ipt_flow_info *)match->data;
+
+	flow_print(finfo);
+}
+
+static struct option opts[] = {
+	{ .name = "maxip", .has_arg = 1, .flag =0, .val = 0 },
+	{ .name = "maxicmp", .has_arg = 1, .flag =0, .val = 1 },
+	{ .name = "maxtcp", .has_arg = 1, .flag = 0, .val = 6 },
+	{ .name = "maxudp", .has_arg = 1, .flag = 0, .val = 17 },
+	{ .name = "nm", .has_arg = 1, .flag = 0, .val = 256 },
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
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match(&flow);
+}
diff -Pru iptables-1.2.11/extensions/libipt_flow.man iptables-1.2.11-flow/extensions/libipt_flow.man
--- iptables-1.2.11/extensions/libipt_flow.man	1969-12-31 18:00:00.000000000 -0600
+++ iptables-1.2.11-flow/extensions/libipt_flow.man	2004-11-03 16:40:15.000000000 -0600
@@ -0,0 +1,13 @@
+This module, when combined with protocol flow counters (via connection
+tracking events), allows access to IP, ICMP, TCP and UDP flow counts
+per source IP address (IP_CT_DIR_ORIGINAL state from ip_conntrack)
+This match module can not be used in the raw table.
+.TP
+.BI "--maxip "   "n"
+.BI "--maxicmp " "n"
+.BI "--maxtcp "  "n"
+.BI "--maxudp "  "n"
+.BI "--nm "      "n.n.n.n/mm or n.n.n.n/m.m.m.m"
+Where n is the max number of connections to allow from some specified source.
+n.n.n.n is a network.  mm or m.m.m.m are the mask bits which should be
+ANDed with a source, the result of which is compared to the network portion.

--opJtzjQTFsWo+cga--
