From: Josh Samuelson <josamue1@wsc.edu>
Subject: [PATCH] new match extension `flow'
Date: Wed, 27 Oct 2004 21:05:50 -0500
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041028020550.GA10097@wsc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qjNfmADvan18RZcF"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

The attached diff files add to iptables the ability to match max
connections allowed for various IP protocols: generic IP, ICMP, TCP
and UDP.

kernel changes:
The patch file is for 2.6.9.
net/ipv4/netfilter/ip_conntrack_standalone.c must be fixed by a
patch I sent to the list earlier; see line 819 for the problem.
It modifies some files relevant to ip_conntrack and adds a ipt_flow.c
match module.  When a new conntrack is created, a flow structure will
have counters incremented for the type of protocol being used, indexed
by the original direction source IP address.  All current flows can
be viewed in the "/proc/net/ip_conntrack_flow" file.  The current
number of flows can be viewed from the
"/proc/sys/net/ipv4/netfilter/ip_conntrack_flow_count" file.

# cat /proc/net/ip_conntrack_flow 
192.168.1.7 IP: 1 ICMP: 0 TCP: 1 UDP: 0
192.168.1.254 IP: 1 ICMP: 0 TCP: 0 UDP: 0
192.168.1.7 IP: 1 ICMP: 0 TCP: 1 UDP: 0
192.168.1.55 IP: 1 ICMP: 0 TCP: 1 UDP: 0
192.168.1.121 IP: 2 ICMP: 0 TCP: 0 UDP: 2
# cat /proc/sys/net/ipv4/netfilter/ip_conntrack_flow_count
5
#

iptables changes:
The patch is for iptables-1.2.11.  It adds the source to allow
iptables to have the flow match via the shared library API that
iptables defines.  The module adds the following options:
--maxip n   (which can only be used when no protocol is specified)
--maxicmp n (allowed with -p icmp)
--maxtcp n  (allowed with -p tcp)
--maxudp n  (allowed with -p udp)
The flow match module can only be used in the filter table.

An example of the usage:

iptables -A FORWARD -p tcp -s 192.168.1.0/24 -m flow --maxtcp 150 \
-m state --state NEW -j REJECT --reject-with tcp-reset

This would deny new TCP connections from all hosts routing
through the machine from the 192.168.1.0/24 network that already
have 150 connections.

Hope some people find this useful!  Original idea from John Dunning,
see "Flow count module" from Tue Oct 12 14:54:20 CEST 2004.

Questions, comments?

-Josh

--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.9-flow-20041027.diff"

diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack.h	2004-10-18 16:55:21.000000000 -0500
+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_conntrack.h	2004-10-27 18:22:39.867487432 -0500
@@ -6,6 +6,7 @@
 
 #include <linux/config.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/netfilter_ipv4/ip_conntrack_flow.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
 #include <asm/atomic.h>
@@ -291,6 +292,7 @@
 }
 
 extern unsigned int ip_conntrack_htable_size;
+extern unsigned int ip_conntrack_flow_htable_size;
  
 struct ip_conntrack_stat
 {
diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack_core.h linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-10-18 16:55:35.000000000 -0500
+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-10-27 18:22:39.867487432 -0500
@@ -17,6 +17,9 @@
 
 struct ip_conntrack_protocol;
 
+extern u_int32_t
+hash_flow(u_int32_t ip);
+
 extern int
 ip_ct_get_tuple(const struct iphdr *iph,
 		const struct sk_buff *skb,
@@ -46,6 +49,7 @@
 }
 
 extern struct list_head *ip_conntrack_hash;
+extern struct list_head *ip_conntrack_flow_hash;
 extern struct list_head ip_conntrack_expect_list;
 DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
 DECLARE_RWLOCK_EXTERN(ip_conntrack_expect_tuple_lock);
diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack_flow.h linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_conntrack_flow.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack_flow.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_conntrack_flow.h	2004-10-27 18:22:39.868487280 -0500
@@ -0,0 +1,27 @@
+#ifndef _IP_CONNTRACK_FLOW_H
+#define _IP_CONNTRACK_FLOW_H
+
+/* A `flow' is a structure containing the IP connection count
+  on various IP protocols.
+*/
+
+struct ip_conntrack_flow
+{
+#ifdef __KERNEL__
+	struct list_head list;
+	atomic_t use;
+#else
+	struct
+	{
+		void *next,
+		     *prev;
+	} list;
+	u_int32_t use;
+#endif /* __KERNEL__ */
+	u_int32_t ip_ct_dir_original_ip;
+	u_int16_t icmp,
+		  tcp,
+		  udp;
+};
+
+#endif /* _IP_CONNTRACK_FLOW_H */
diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ipt_flow.h linux-2.6.9-flow/include/linux/netfilter_ipv4/ipt_flow.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ipt_flow.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ipt_flow.h	2004-10-27 18:22:39.868487280 -0500
@@ -0,0 +1,21 @@
+#ifndef _IPT_FLOW_H
+#define _IPT_FLOW_H
+
+typedef enum
+{
+	IPFLOW_IP = 1,
+	IPFLOW_ICMP = 2,
+	IPFLOW_TCP = 4,
+	IPFLOW_UDP = 8
+} ipflow_t;
+
+struct ipt_flow_info
+{
+	ipflow_t  proto;
+	u_int16_t max_ip,
+		  max_icmp,
+		  max_tcp,
+		  max_udp;
+};
+
+#endif /* IPT_FLOW_H */
diff -Pru linux-2.6.9/include/linux/sysctl.h linux-2.6.9-flow/include/linux/sysctl.h
--- linux-2.6.9/include/linux/sysctl.h	2004-10-18 16:54:31.000000000 -0500
+++ linux-2.6.9-flow/include/linux/sysctl.h	2004-10-27 18:22:39.871486824 -0500
@@ -426,6 +426,7 @@
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=25,
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=26,
 	NET_IPV4_NF_CONNTRACK_COUNT=27,
+	NET_IPV4_NF_CONNTRACK_FLOW_COUNT=28,
 };
  
 /* /proc/sys/net/ipv6 */
diff -Pru linux-2.6.9/net/ipv4/netfilter/Kconfig linux-2.6.9-flow/net/ipv4/netfilter/Kconfig
--- linux-2.6.9/net/ipv4/netfilter/Kconfig	2004-10-18 16:54:55.000000000 -0500
+++ linux-2.6.9-flow/net/ipv4/netfilter/Kconfig	2004-10-27 18:22:39.873486520 -0500
@@ -342,6 +342,15 @@
 	  If you want to compile it as a module, say M here and read
 	  Documentation/modules.txt.  If unsure, say `N'.
 
+config IP_NF_MATCH_FLOW
+	tristate 'flow match support (EXPERIMENTAL)'
+	depends on IP_NF_CONNTRACK && IP_NF_FILTER && EXPERIMENTAL
+	help
+	  This option adds a 'flow' match.  With this match you can
+	  specify the maximum allowed connections for original direction
+	  conntracks.  The matches can be made against generic IP, ICMP,
+	  TCP or UDP flows.
+
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
diff -Pru linux-2.6.9/net/ipv4/netfilter/Makefile linux-2.6.9-flow/net/ipv4/netfilter/Makefile
--- linux-2.6.9/net/ipv4/netfilter/Makefile	2004-10-18 16:53:43.000000000 -0500
+++ linux-2.6.9-flow/net/ipv4/netfilter/Makefile	2004-10-27 18:22:39.874486368 -0500
@@ -67,6 +67,7 @@
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
+obj-$(CONFIG_IP_NF_MATCH_FLOW) += ipt_flow.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff -Pru linux-2.6.9/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.9-flow/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.9/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-18 16:53:05.000000000 -0500
+++ linux-2.6.9-flow/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-27 20:17:20.991397592 -0500
@@ -62,16 +62,21 @@
 
 /* ip_conntrack_standalone needs this */
 atomic_t ip_conntrack_count = ATOMIC_INIT(0);
+atomic_t ip_conntrack_flow_count = ATOMIC_INIT(0);
 EXPORT_SYMBOL(ip_conntrack_count);
+EXPORT_SYMBOL(ip_conntrack_flow_count);
 
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) = NULL;
 LIST_HEAD(ip_conntrack_expect_list);
 struct ip_conntrack_protocol *ip_ct_protos[MAX_IP_CT_PROTO];
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size = 0;
+unsigned int ip_conntrack_flow_htable_size = 0;
 int ip_conntrack_max;
 struct list_head *ip_conntrack_hash;
+struct list_head *ip_conntrack_flow_hash;
 static kmem_cache_t *ip_conntrack_cachep;
+static kmem_cache_t *ip_conntrack_flow_cachep;
 static kmem_cache_t *ip_conntrack_expect_cachep;
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
@@ -100,6 +105,112 @@
 	                     ip_conntrack_hash_rnd) % ip_conntrack_htable_size);
 }
 
+u_int32_t
+hash_flow(u_int32_t ip)
+{
+	return(jhash_1word(ip, ip_conntrack_hash_rnd) % ip_conntrack_flow_htable_size);
+}
+
+#define INCREMENT_WITHOUT_OVERFLOW(c) if (c < ((1 << (sizeof(c) * 8)) - 1)) c++
+
+int
+ip_conntrack_flow_inc(struct ip_conntrack_tuple_hash *hash)
+{
+	unsigned int flow_hash;
+	u_int32_t ip;
+	struct list_head *list;
+	struct ip_conntrack_flow *flow = NULL;
+
+	ip = hash->tuple.src.ip;
+	flow_hash = hash_flow(ip);
+	READ_LOCK(&ip_conntrack_lock);
+	list_for_each(list, &ip_conntrack_flow_hash[flow_hash]) {
+		if (((struct ip_conntrack_flow *) list)->ip_ct_dir_original_ip == ip) {
+			flow = (struct ip_conntrack_flow *) list;
+			break;
+		}
+	}
+	READ_UNLOCK(&ip_conntrack_lock);
+	WRITE_LOCK(&ip_conntrack_lock);
+	if (!flow) {
+		flow = kmem_cache_alloc(ip_conntrack_flow_cachep, GFP_ATOMIC);
+		if (flow) {
+			atomic_inc(&ip_conntrack_flow_count);
+			memset(flow, 0, sizeof(struct ip_conntrack_flow));
+			atomic_set(&flow->use, 0);
+			flow->ip_ct_dir_original_ip = ip;
+			list = (struct list_head *) flow;
+			list_add(list, &ip_conntrack_flow_hash[flow_hash]);
+		}
+	}
+	if (flow) {
+		atomic_inc(&flow->use);
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
+	WRITE_UNLOCK(&ip_conntrack_lock);
+	return(flow == NULL);
+}
+
+void
+ip_conntrack_flow_dec(struct ip_conntrack_tuple_hash *hash)
+{
+	unsigned int flow_hash;
+	u_int32_t ip;
+	struct list_head *list;
+	struct ip_conntrack_flow *flow = NULL;
+
+	ip = hash->tuple.src.ip;
+	flow_hash = hash_flow(ip);
+	READ_LOCK(&ip_conntrack_lock);
+	list_for_each(list, &ip_conntrack_flow_hash[flow_hash]) {
+		if (((struct ip_conntrack_flow *) list)->ip_ct_dir_original_ip == ip) {
+			flow = (struct ip_conntrack_flow *) list;
+			break;
+		}
+	}
+	READ_UNLOCK(&ip_conntrack_lock);
+	if (flow) {
+		WRITE_LOCK(&ip_conntrack_lock);
+		atomic_dec(&flow->use);
+		switch (hash->tuple.dst.protonum) {
+			case IPPROTO_ICMP:
+				if (flow->icmp) {
+					flow->icmp--;
+				}
+				break;
+			case IPPROTO_TCP:
+				if (flow->tcp) {
+					flow->tcp--;
+				}
+				break;
+			case IPPROTO_UDP:
+				if (flow->udp) {
+					flow->udp--;
+				}
+				break;
+		}
+		if (atomic_read(&flow->use) == 0) {
+			list = (struct list_head *) flow;
+			list_del(list);
+			kmem_cache_free(ip_conntrack_flow_cachep, flow);
+			atomic_dec(&ip_conntrack_flow_count);
+		}
+		WRITE_UNLOCK(&ip_conntrack_lock);
+	} else {
+		printk(KERN_WARNING "conntrack being destroyed, yet not found on flow list\n");
+	}
+}
+
 int
 ip_ct_get_tuple(const struct iphdr *iph,
 		const struct sk_buff *skb,
@@ -288,6 +399,9 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
+	/* flow entry: delete flow here */
+	ip_conntrack_flow_dec(&ct->tuplehash[IP_CT_DIR_ORIGINAL]);
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to ip_conntrack_lock!!! -HW */
@@ -618,6 +732,11 @@
 end:	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
+	/* flow entry: insert flow here */
+	if (ip_conntrack_flow_inc(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL])) {
+		printk(KERN_WARNING "flow cache alloc failed, cannot track new flows\n");
+	}
+
 ret:	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
 }
 
@@ -1304,8 +1423,10 @@
 	}
 
 	kmem_cache_destroy(ip_conntrack_cachep);
+	kmem_cache_destroy(ip_conntrack_flow_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	vfree(ip_conntrack_hash);
+	vfree(ip_conntrack_flow_hash);
 	nf_unregister_sockopt(&so_getorigdst);
 }
 
@@ -1330,6 +1451,7 @@
 		if (ip_conntrack_htable_size < 16)
 			ip_conntrack_htable_size = 16;
 	}
+	ip_conntrack_flow_htable_size = ip_conntrack_htable_size / 2;
 	ip_conntrack_max = 8 * ip_conntrack_htable_size;
 
 	printk("ip_conntrack version %s (%u buckets, %d max)"
@@ -1350,12 +1472,27 @@
 		goto err_unreg_sockopt;
 	}
 
+	ip_conntrack_flow_hash = vmalloc(sizeof(struct list_head)
+					* ip_conntrack_flow_htable_size);
+	if (!ip_conntrack_flow_hash) {
+		printk(KERN_ERR "Unable to create ip_conntrack_flow_hash\n");
+		goto err_free_hash;
+	}
+
 	ip_conntrack_cachep = kmem_cache_create("ip_conntrack",
 	                                        sizeof(struct ip_conntrack), 0,
 	                                        SLAB_HWCACHE_ALIGN, NULL, NULL);
 	if (!ip_conntrack_cachep) {
 		printk(KERN_ERR "Unable to create ip_conntrack slab cache\n");
-		goto err_free_hash;
+		goto err_free_flow_hash;
+	}
+
+	ip_conntrack_flow_cachep = kmem_cache_create("ip_conntrack_flow",
+	                                        sizeof(struct ip_conntrack_flow), 0,
+	                                        SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!ip_conntrack_flow_cachep) {
+		printk(KERN_ERR "Unable to create ip_conntrack_flow slab cache\n");
+		goto err_free_conntrack_slab;
 	}
 
 	ip_conntrack_expect_cachep = kmem_cache_create("ip_conntrack_expect",
@@ -1363,7 +1500,7 @@
 					0, SLAB_HWCACHE_ALIGN, NULL, NULL);
 	if (!ip_conntrack_expect_cachep) {
 		printk(KERN_ERR "Unable to create ip_expect slab cache\n");
-		goto err_free_conntrack_slab;
+		goto err_free_conntrack_flow_slab;
 	}
 
 	/* Don't NEED lock here, but good form anyway. */
@@ -1379,6 +1516,9 @@
 	for (i = 0; i < ip_conntrack_htable_size; i++)
 		INIT_LIST_HEAD(&ip_conntrack_hash[i]);
 
+	for (i = 0; i < ip_conntrack_flow_htable_size; i++)
+		INIT_LIST_HEAD(&ip_conntrack_flow_hash[i]);
+
 	/* For use by ipt_REJECT */
 	ip_ct_attach = ip_conntrack_attach;
 
@@ -1390,8 +1530,12 @@
 
 	return ret;
 
+err_free_conntrack_flow_slab:
+	kmem_cache_destroy(ip_conntrack_flow_cachep);
 err_free_conntrack_slab:
 	kmem_cache_destroy(ip_conntrack_cachep);
+err_free_flow_hash:
+	vfree(ip_conntrack_flow_hash);
 err_free_hash:
 	vfree(ip_conntrack_hash);
 err_unreg_sockopt:
diff -Pru linux-2.6.9/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.6.9-flow/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.9/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-27 18:44:12.967906288 -0500
+++ linux-2.6.9-flow/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-27 18:22:39.881485304 -0500
@@ -46,6 +46,7 @@
 MODULE_LICENSE("GPL");
 
 extern atomic_t ip_conntrack_count;
+extern atomic_t ip_conntrack_flow_count;
 DECLARE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
 static int kill_proto(const struct ip_conntrack *i, void *data)
@@ -172,7 +173,7 @@
 	.stop  = ct_seq_stop,
 	.show  = ct_seq_show
 };
-  
+
 static int ct_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &ct_seq_ops);
@@ -186,6 +187,70 @@
 	.release = seq_release
 };
   
+static void *ct_flow_seq_start(struct seq_file *s, loff_t *pos)
+{
+	if (*pos >= ip_conntrack_flow_htable_size)
+		return NULL;
+	return &ip_conntrack_flow_hash[*pos];
+}
+  
+static void ct_flow_seq_stop(struct seq_file *s, void *v)
+{
+}
+
+static void *ct_flow_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= ip_conntrack_flow_htable_size)
+		return NULL;
+	return &ip_conntrack_flow_hash[*pos];
+}
+
+static int ct_flow_seq_show(struct seq_file *s, void *v)
+{
+	int ret = 0;
+	struct ip_conntrack_flow *flow;
+	struct list_head *list;
+
+	list = (struct list_head *) v;
+	list = list->next;
+	READ_LOCK(&ip_conntrack_lock);
+	list_for_each(list, (struct list_head *) v) {
+		flow = (struct ip_conntrack_flow *) list;
+		if (seq_printf(s, "%u.%u.%u.%u IP: %u ICMP: %hu TCP: %hu UDP: %hu\n",
+			       NIPQUAD(flow->ip_ct_dir_original_ip),
+			       atomic_read(&flow->use),
+			       flow->icmp,
+			       flow->tcp,
+			       flow->udp)) {
+			ret = -ENOSPC;
+			break;
+		}
+	}
+	READ_UNLOCK(&ip_conntrack_lock);
+	return(ret);
+}
+  
+static struct seq_operations ct_flow_seq_ops = {
+	.start = ct_flow_seq_start,
+	.next  = ct_flow_seq_next,
+	.stop  = ct_flow_seq_stop,
+	.show  = ct_flow_seq_show
+};
+
+static int ct_flow_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &ct_flow_seq_ops);
+}
+
+static struct file_operations ct_flow_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = ct_flow_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release
+};
+  
 /* expects */
 static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 {
@@ -351,6 +416,7 @@
 	.llseek  = seq_lseek,
 	.release = seq_release_private,
 };
+
 #endif
 
 static unsigned int ip_confirm(unsigned int hooknum,
@@ -530,6 +596,14 @@
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_FLOW_COUNT,
+		.procname	= "ip_conntrack_flow_count",
+		.data		= &ip_conntrack_flow_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_BUCKETS,
 		.procname	= "ip_conntrack_buckets",
 		.data		= &ip_conntrack_htable_size,
@@ -725,7 +799,7 @@
 static int init_or_cleanup(int init)
 {
 #ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
+	struct proc_dir_entry *proc, *proc_flow, *proc_exp, *proc_stat;
 #endif
 	int ret = 0;
 
@@ -739,9 +813,12 @@
 	proc = proc_net_fops_create("ip_conntrack", 0440, &ct_file_ops);
 	if (!proc) goto cleanup_init;
 
+	proc_flow = proc_net_fops_create("ip_conntrack_flow", 0440, &ct_flow_file_ops);
+	if (!proc_flow) goto cleanup_proc;
+
 	proc_exp = proc_net_fops_create("ip_conntrack_expect", 0440,
 					&exp_file_ops);
-	if (!proc_exp) goto cleanup_proc;
+	if (!proc_exp) goto cleanup_proc_flow;
 
 	proc_stat = create_proc_entry("ip_conntrack", S_IRUGO, proc_net_stat);
 	if (!proc_stat)
@@ -815,8 +892,10 @@
  cleanup_proc_stat:
 #ifdef CONFIG_PROC_FS
 	proc_net_remove("ip_conntrack_stat");
-cleanup_proc_exp:
+ cleanup_proc_exp:
 	proc_net_remove("ip_conntrack_expect");
+ cleanup_proc_flow:
+	proc_net_remove("ip_conntrack_flow");
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:
@@ -875,6 +954,7 @@
 {
 }
 
+EXPORT_SYMBOL(hash_flow);
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
 EXPORT_SYMBOL(invert_tuplepr);
@@ -900,6 +980,7 @@
 EXPORT_SYMBOL(ip_conntrack_expect_list);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
+EXPORT_SYMBOL(ip_conntrack_flow_hash);
 EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
diff -Pru linux-2.6.9/net/ipv4/netfilter/ipt_flow.c linux-2.6.9-flow/net/ipv4/netfilter/ipt_flow.c
--- linux-2.6.9/net/ipv4/netfilter/ipt_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow/net/ipv4/netfilter/ipt_flow.c	2004-10-27 18:22:39.882485152 -0500
@@ -0,0 +1,127 @@
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
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_flow.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Josh Samuelson <josamue1@wsc.edu>");
+MODULE_DESCRIPTION("iptables connection flow match module");
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
+	struct ip_conntrack_flow *flow = NULL;
+	u_int16_t proto;
+	u_int32_t flow_hash,
+		  ip;
+	int ret = 0;
+
+	proto = skb->nh.iph->protocol;
+	ip = skb->nh.iph->saddr;
+	flow_hash = hash_flow(ip);
+	READ_LOCK(&ip_conntrack_lock);
+	list_for_each(list, &ip_conntrack_flow_hash[flow_hash]) {
+		if (((struct ip_conntrack_flow *) list)->ip_ct_dir_original_ip == ip) {
+			flow = (struct ip_conntrack_flow *) list;
+			break;
+		}
+	}
+	if (flow) {
+		if ((atomic_read(&flow->use) > finfo->max_ip) && (finfo->proto & IPFLOW_IP))
+			ret = 1;
+		switch (proto) {
+			case IPPROTO_ICMP:
+				if ((flow->icmp > finfo->max_icmp) && (finfo->proto & IPFLOW_ICMP))
+					ret = 1;
+				break;
+			case IPPROTO_TCP:
+				if ((flow->tcp > finfo->max_tcp) && (finfo->proto & IPFLOW_TCP))
+					ret = 1;
+				break;
+			case IPPROTO_UDP:
+				if ((flow->udp > finfo->max_udp) && (finfo->proto & IPFLOW_UDP))
+					ret = 1;
+				break;
+		}
+	}
+	READ_UNLOCK(&ip_conntrack_lock);
+	return(ret);
+}
+
+static int check(const char *tablename,
+	const struct ipt_ip *ip,
+	void *matchinfo,
+	unsigned int matchsize,
+	unsigned int hook_mask)
+{
+	const struct ipt_flow_info *finfo = matchinfo;
+
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_flow_info)))
+		return 0;
+
+	if (strcmp(tablename, "filter") != 0) {
+		printk(KERN_WARNING "flow: can only be used in \"filter\" table, not \"%s\"\n", tablename);
+		return(0);
+	}
+
+	switch (ip->proto) {
+		case IPPROTO_IP:
+			if (finfo->max_icmp || finfo->max_tcp || finfo->max_udp)
+				return(0);
+			break;
+		case IPPROTO_ICMP:
+			if (finfo->max_ip || finfo->max_tcp || finfo->max_udp)
+				return(0);
+			break;
+		case IPPROTO_TCP:
+			if (finfo->max_ip || finfo->max_icmp || finfo->max_udp)
+				return(0);
+			break;
+		case IPPROTO_UDP:
+			if (finfo->max_ip || finfo->max_icmp || finfo->max_tcp)
+				return(0);
+			break;
+		default:
+			return(0);
+	}
+	return 1;
+}
+
+static struct ipt_match flow_match = {
+	.name		= "flow",
+	.match		= &match,
+	.checkentry	= &check,
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

--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-1.2.11-flow-20041027.diff"

diff -Pru iptables-1.2.11/extensions/Makefile iptables-flow/extensions/Makefile
--- iptables-1.2.11/extensions/Makefile	2004-06-17 05:22:54.000000000 -0500
+++ iptables-flow/extensions/Makefile	2004-10-25 13:42:19.000000000 -0500
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah connlimit connmark conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
+PF_EXT_SLIB:=ah connlimit connmark conntrack dscp ecn esp flow helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK TRACE
 
 # Optionals
diff -Pru iptables-1.2.11/extensions/libipt_flow.c iptables-flow/extensions/libipt_flow.c
--- iptables-1.2.11/extensions/libipt_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ iptables-flow/extensions/libipt_flow.c	2004-10-27 12:47:54.763557256 -0500
@@ -0,0 +1,154 @@
+/* Shared library add-on to iptables to add [IP|ICMP|TCP|UDP] flow count match support. */
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
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ipt_flow.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"flow v%s options:\n"
+" --maxip n\n"
+" --maxicmp n\n"
+" --maxtcp n\n"
+" --maxudp n\n"
+"\n", IPTABLES_VERSION);
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
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	unsigned int count;
+	struct ipt_flow_info *finfo = (struct ipt_flow_info *)(*match)->data;
+
+	if(invert || check_inverse(optarg, &invert, &optind, 0)) {
+		exit_error(PARAMETER_PROBLEM, "flow options cannot be inverted");
+	}
+	switch (c) {
+		case 0:
+			if(string_to_number(argv[optind - 1], 1, 65535, &count) == -1)
+				exit_error(PARAMETER_PROBLEM, "maxip value out of range");
+			finfo->max_ip = count;
+			finfo->proto |= IPFLOW_IP;
+			*flags = 1;
+			break;
+		case 1:
+			if(string_to_number(argv[optind - 1], 1, 65535, &count) == -1)
+				exit_error(PARAMETER_PROBLEM, "maxicmp value out of range");
+			finfo->max_icmp = count;
+			finfo->proto |= IPFLOW_ICMP;
+			*flags = 1;
+			break;
+		case 6:
+			if(string_to_number(argv[optind - 1], 1, 65535, &count) == -1)
+				exit_error(PARAMETER_PROBLEM, "maxtcp value out of range");
+			finfo->max_tcp = count;
+			finfo->proto |= IPFLOW_TCP;
+			*flags = 1;
+			break;
+		case 17:
+			if(string_to_number(argv[optind - 1], 1, 65535, &count) == -1)
+				exit_error(PARAMETER_PROBLEM, "maxudp value out of range");
+			finfo->max_udp = count;
+			finfo->proto |= IPFLOW_UDP;
+			*flags = 1;
+			break;
+
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+/* Final check; must have specified --max[icmp|tcp|udp]. */
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "You must specify `--max[ip|icmp|tcp|udp]'");
+}
+
+void flow_print(struct ipt_flow_info *finfo)
+{
+	if(finfo->max_ip)
+		printf("--maxip %i ", finfo->max_ip);
+	if(finfo->max_icmp)
+		printf("--maxicmp %i ", finfo->max_icmp);
+	if(finfo->max_tcp)
+		printf("--maxtcp %i ", finfo->max_tcp);
+	if(finfo->max_udp)
+		printf("--maxudp %i ", finfo->max_udp);
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
+	{0}
+};
+
+static
+struct iptables_match flow
+= {	.next		= NULL,
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
diff -Pru iptables-1.2.11/extensions/libipt_flow.man iptables-flow/extensions/libipt_flow.man
--- iptables-1.2.11/extensions/libipt_flow.man	1969-12-31 18:00:00.000000000 -0600
+++ iptables-flow/extensions/libipt_flow.man	2004-10-27 11:40:46.000000000 -0500
@@ -0,0 +1,10 @@
+This module, when combined with connection tracking, allows access to
+IP, ICMP, TCP and UDP flow counts per source IP address (IP_CT_DIR_ORIGINAL
+state from ip_conntrack)  This match module can only be used in the filter
+table.
+.TP
+.BI "--maxip "   "n"
+.BI "--maxicmp " "n"
+.BI "--maxtcp "  "n"
+.BI "--maxudp "  "n"
+Where n is the max number of connections to allow from some specified source.

--qjNfmADvan18RZcF--
