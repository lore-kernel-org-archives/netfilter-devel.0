From: Josh Samuelson <josamue1@wsc.edu>
Subject: Re: [PATCH] new match extension `flow'
Date: Sun, 31 Oct 2004 01:38:14 -0500
Message-ID: <20041031063813.GA29402@wsc.edu>
References: <20041028020550.GA10097@wsc.edu> <41829ADC.2090708@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <41829ADC.2090708@eurodev.net>
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


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 29, 2004 at 09:32:44PM +0200, Pablo Neira wrote:
> cool, nice work. But can't we do a match which counts new connections? I 
> bet that
> the problem is that we don't know when a connection is closed, maybe we 
> could add a
> new ip_conntrack_status (something like IPS_CLOSED_BIT) which would be 
> set when
> a connection is closed, i.e. in tcp tracking when in time 
> TIME_WAIT/FIN_WAIT). I don't
> like so much the idea of adding more stuff to the core of the conntrack 
> to keep things simpler.
> 
> Pablo

That's what I thought was elegant about this approach, the simplicity.
Besides the added code needed to set up the memory structures to store
the counters and the proc entries, there are only two entry points for
the added code.  One in init_conntrack() -> ip_conntrack_flow_inc(), the
other in destroy_conntrack() -> ip_conntrack_flow_dec().
Counter increment/decrement happen closest to when the state
of the connection tracking actually change.  The cost of this
code path is always going to contain a hash computation, a linked list
search to find the structure, then increment/decrement the relevant
counter.  New and unused old flow structures will have an
allocation/deallocation and linked list add/delete overhead added to the
former stated cost.

Later, the match modules that could use the data from these flow structures
only have to compute a hash/LL search for the structure, then compare the
data.  No looping through the ip_conntrack_hash to count protocol types,
meanwhile checking states/timeouts or even invalidating the existence
of conntracks the match function believes exist against what the
connection tracking core actually has; executing said process for
each matched packet.

It could be argued that not everyone will want their connection tracking
core to have this added functionality because they simply don't need it.
I couldn't agree more!  Which makes me wonder why I didn't make the changes
to the conntrack_core a boolean sub-option initially.  Well, it is now!

I hope that this change eases your feelings about the slight conntrack_core
tampering.

Cheers,
-Josh

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.9-flow-20041030.diff"

diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.6.9-flow-20041030/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack.h	2004-10-18 16:55:21.000000000 -0500
+++ linux-2.6.9-flow-20041030/include/linux/netfilter_ipv4/ip_conntrack.h	2004-10-30 16:46:31.436032840 -0500
@@ -6,6 +6,9 @@
 
 #include <linux/config.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#ifdef CONFIG_IP_NF_CT_FLOW
+#include <linux/netfilter_ipv4/ip_conntrack_flow.h>
+#endif
 #include <linux/bitops.h>
 #include <linux/compiler.h>
 #include <asm/atomic.h>
@@ -291,6 +294,9 @@
 }
 
 extern unsigned int ip_conntrack_htable_size;
+#ifdef CONFIG_IP_NF_CT_FLOW
+extern unsigned int ip_conntrack_flow_htable_size;
+#endif
  
 struct ip_conntrack_stat
 {
diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack_core.h linux-2.6.9-flow-20041030/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-10-18 16:55:35.000000000 -0500
+++ linux-2.6.9-flow-20041030/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-10-30 16:46:59.585753432 -0500
@@ -17,6 +17,11 @@
 
 struct ip_conntrack_protocol;
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+extern u_int32_t
+hash_flow(u_int32_t ip);
+#endif
+
 extern int
 ip_ct_get_tuple(const struct iphdr *iph,
 		const struct sk_buff *skb,
@@ -46,6 +51,9 @@
 }
 
 extern struct list_head *ip_conntrack_hash;
+#ifdef CONFIG_IP_NF_CT_FLOW
+extern struct list_head *ip_conntrack_flow_hash;
+#endif
 extern struct list_head ip_conntrack_expect_list;
 DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
 DECLARE_RWLOCK_EXTERN(ip_conntrack_expect_tuple_lock);
diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack_flow.h linux-2.6.9-flow-20041030/include/linux/netfilter_ipv4/ip_conntrack_flow.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ip_conntrack_flow.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow-20041030/include/linux/netfilter_ipv4/ip_conntrack_flow.h	2004-10-29 20:30:24.000000000 -0500
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
diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ipt_flow.h linux-2.6.9-flow-20041030/include/linux/netfilter_ipv4/ipt_flow.h
--- linux-2.6.9/include/linux/netfilter_ipv4/ipt_flow.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow-20041030/include/linux/netfilter_ipv4/ipt_flow.h	2004-10-29 20:30:24.000000000 -0500
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
diff -Pru linux-2.6.9/include/linux/sysctl.h linux-2.6.9-flow-20041030/include/linux/sysctl.h
--- linux-2.6.9/include/linux/sysctl.h	2004-10-18 16:54:31.000000000 -0500
+++ linux-2.6.9-flow-20041030/include/linux/sysctl.h	2004-10-29 20:30:24.000000000 -0500
@@ -426,6 +426,7 @@
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=25,
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=26,
 	NET_IPV4_NF_CONNTRACK_COUNT=27,
+	NET_IPV4_NF_CONNTRACK_FLOW_COUNT=28,
 };
  
 /* /proc/sys/net/ipv6 */
diff -Pru linux-2.6.9/net/ipv4/netfilter/Kconfig linux-2.6.9-flow-20041030/net/ipv4/netfilter/Kconfig
--- linux-2.6.9/net/ipv4/netfilter/Kconfig	2004-10-18 16:54:55.000000000 -0500
+++ linux-2.6.9-flow-20041030/net/ipv4/netfilter/Kconfig	2004-10-30 21:25:54.522656320 -0500
@@ -32,6 +32,25 @@
 
 	  If unsure, say `N'.
 
+config IP_NF_CT_FLOW
+	bool "Connection tracking protocol flow counters (EXPERIMENTAL)"
+	depends on IP_NF_CONNTRACK && EXPERIMENTAL
+	help
+	  If this option is enabled, the connection tracking code will
+	  keep protocol flow counters indexed by the original direction
+	  source IP address.  The protocol counters include generic IP,
+	  ICMP, TCP and UDP.
+
+	  These counters can be read from "/proc/net/ip_conntrack_flow".
+
+	  The number of entries being tracked can be read from
+	  "/proc/sys/net/ipv4/netfilter/ip_conntrack_flow_count".
+
+	  These counters can be used in the "Connection tracking protocol
+	  flow counters" match, see below.
+
+	  If unsure, say N.
+
 config IP_NF_CT_PROTO_SCTP
 	tristate  'SCTP protocol connection tracking support (EXPERIMENTAL)'
 	depends on IP_NF_CONNTRACK && EXPERIMENTAL
@@ -279,6 +298,22 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_MATCH_FLOW
+	tristate 'Connection tracking protocol flow counters match support (EXPERIMENTAL)'
+	depends on IP_NF_IPTABLES && IP_NF_CT_FLOW && (IP_NF_FILTER || IP_NF_NAT || IP_NF_MANGLE) && EXPERIMENTAL
+	help
+	  `flow' matching allows you to match a packet when the specified
+	  number of known protocol connections from a original direction
+	  source IP address is exceeded.  The matches can be made against
+	  generic IP, ICMP, TCP or UDP flow counters.  This match can be
+	  used in all tables but raw.
+
+	  For example, this match allows you to control the number and type
+	  of connections (flows) from hosts in a known local network routing
+	  through the machine.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_MATCH_OWNER
 	tristate "Owner match support"
 	depends on IP_NF_IPTABLES
diff -Pru linux-2.6.9/net/ipv4/netfilter/Makefile linux-2.6.9-flow-20041030/net/ipv4/netfilter/Makefile
--- linux-2.6.9/net/ipv4/netfilter/Makefile	2004-10-18 16:53:43.000000000 -0500
+++ linux-2.6.9-flow-20041030/net/ipv4/netfilter/Makefile	2004-10-29 20:30:24.000000000 -0500
@@ -67,6 +67,7 @@
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
+obj-$(CONFIG_IP_NF_MATCH_FLOW) += ipt_flow.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff -Pru linux-2.6.9/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.9-flow-20041030/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.9/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-18 16:53:05.000000000 -0500
+++ linux-2.6.9-flow-20041030/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-30 22:17:03.919037144 -0500
@@ -76,6 +76,14 @@
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+atomic_t ip_conntrack_flow_count = ATOMIC_INIT(0);
+EXPORT_SYMBOL(ip_conntrack_flow_count);
+unsigned int ip_conntrack_flow_htable_size = 0;
+struct list_head *ip_conntrack_flow_hash;
+static kmem_cache_t *ip_conntrack_flow_cachep;
+#endif
+
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
 inline void 
@@ -100,6 +108,114 @@
 	                     ip_conntrack_hash_rnd) % ip_conntrack_htable_size);
 }
 
+#ifdef CONFIG_IP_NF_CT_FLOW
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
+#endif /* CONFIG_IP_NF_CT_FLOW */
+
 int
 ip_ct_get_tuple(const struct iphdr *iph,
 		const struct sk_buff *skb,
@@ -288,6 +404,11 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+	/* flow entry: delete flow here */
+	ip_conntrack_flow_dec(&ct->tuplehash[IP_CT_DIR_ORIGINAL]);
+#endif
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to ip_conntrack_lock!!! -HW */
@@ -618,6 +739,13 @@
 end:	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+	/* flow entry: insert flow here */
+	if (ip_conntrack_flow_inc(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL])) {
+		printk(KERN_WARNING "flow cache alloc failed, cannot track new flows\n");
+	}
+#endif
+
 ret:	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
 }
 
@@ -1304,8 +1432,14 @@
 	}
 
 	kmem_cache_destroy(ip_conntrack_cachep);
+#ifdef CONFIG_IP_NF_CT_FLOW
+	kmem_cache_destroy(ip_conntrack_flow_cachep);
+#endif
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	vfree(ip_conntrack_hash);
+#ifdef CONFIG_IP_NF_CT_FLOW
+	vfree(ip_conntrack_flow_hash);
+#endif
 	nf_unregister_sockopt(&so_getorigdst);
 }
 
@@ -1337,6 +1471,15 @@
 	       ip_conntrack_htable_size, ip_conntrack_max,
 	       sizeof(struct ip_conntrack));
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+	ip_conntrack_flow_htable_size = ip_conntrack_htable_size / 2;
+
+	printk("  protocol flow counters (%u buckets, %d max)"
+	       " - %Zd bytes per CT_DO source\n",
+	       ip_conntrack_flow_htable_size, ip_conntrack_max,
+	       sizeof(struct ip_conntrack_flow));
+#endif
+
 	ret = nf_register_sockopt(&so_getorigdst);
 	if (ret != 0) {
 		printk(KERN_ERR "Unable to register netfilter socket option\n");
@@ -1350,20 +1493,47 @@
 		goto err_unreg_sockopt;
 	}
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+	ip_conntrack_flow_hash = vmalloc(sizeof(struct list_head)
+					* ip_conntrack_flow_htable_size);
+	if (!ip_conntrack_flow_hash) {
+		printk(KERN_ERR "Unable to create ip_conntrack_flow_hash\n");
+		goto err_free_hash;
+	}
+#endif
+
 	ip_conntrack_cachep = kmem_cache_create("ip_conntrack",
 	                                        sizeof(struct ip_conntrack), 0,
 	                                        SLAB_HWCACHE_ALIGN, NULL, NULL);
 	if (!ip_conntrack_cachep) {
 		printk(KERN_ERR "Unable to create ip_conntrack slab cache\n");
+#ifdef CONFIG_IP_NF_CT_FLOW
+		goto err_free_flow_hash;
+#else
 		goto err_free_hash;
+#endif
+	}
+
+#ifdef CONFIG_IP_NF_CT_FLOW
+	ip_conntrack_flow_cachep = kmem_cache_create("ip_conntrack_flow",
+	                                        sizeof(struct ip_conntrack_flow), 0,
+	                                        SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!ip_conntrack_flow_cachep) {
+		printk(KERN_ERR "Unable to create ip_conntrack_flow slab cache\n");
+		goto err_free_conntrack_slab;
 	}
+#endif
 
 	ip_conntrack_expect_cachep = kmem_cache_create("ip_conntrack_expect",
 					sizeof(struct ip_conntrack_expect),
 					0, SLAB_HWCACHE_ALIGN, NULL, NULL);
 	if (!ip_conntrack_expect_cachep) {
 		printk(KERN_ERR "Unable to create ip_expect slab cache\n");
+#ifdef CONFIG_IP_NF_CT_FLOW
+		goto err_free_conntrack_flow_slab;
+#else
 		goto err_free_conntrack_slab;
+#endif
 	}
 
 	/* Don't NEED lock here, but good form anyway. */
@@ -1379,6 +1549,11 @@
 	for (i = 0; i < ip_conntrack_htable_size; i++)
 		INIT_LIST_HEAD(&ip_conntrack_hash[i]);
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+	for (i = 0; i < ip_conntrack_flow_htable_size; i++)
+		INIT_LIST_HEAD(&ip_conntrack_flow_hash[i]);
+#endif
+
 	/* For use by ipt_REJECT */
 	ip_ct_attach = ip_conntrack_attach;
 
@@ -1390,8 +1565,16 @@
 
 	return ret;
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+err_free_conntrack_flow_slab:
+	kmem_cache_destroy(ip_conntrack_flow_cachep);
+#endif
 err_free_conntrack_slab:
 	kmem_cache_destroy(ip_conntrack_cachep);
+#ifdef CONFIG_IP_NF_CT_FLOW
+err_free_flow_hash:
+	vfree(ip_conntrack_flow_hash);
+#endif
 err_free_hash:
 	vfree(ip_conntrack_hash);
 err_unreg_sockopt:
diff -Pru linux-2.6.9/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.6.9-flow-20041030/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.9/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-30 21:51:12.798843256 -0500
+++ linux-2.6.9-flow-20041030/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-30 16:45:52.609935304 -0500
@@ -46,6 +46,9 @@
 MODULE_LICENSE("GPL");
 
 extern atomic_t ip_conntrack_count;
+#ifdef CONFIG_IP_NF_CT_FLOW
+extern atomic_t ip_conntrack_flow_count;
+#endif
 DECLARE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
 static int kill_proto(const struct ip_conntrack *i, void *data)
@@ -172,7 +175,7 @@
 	.stop  = ct_seq_stop,
 	.show  = ct_seq_show
 };
-  
+
 static int ct_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &ct_seq_ops);
@@ -186,6 +189,72 @@
 	.release = seq_release
 };
   
+#ifdef CONFIG_IP_NF_CT_FLOW
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
+#endif /* CONFIG_IP_NF_CT_FLOW */
+  
 /* expects */
 static void *exp_seq_start(struct seq_file *s, loff_t *pos)
 {
@@ -351,6 +420,7 @@
 	.llseek  = seq_lseek,
 	.release = seq_release_private,
 };
+
 #endif
 
 static unsigned int ip_confirm(unsigned int hooknum,
@@ -529,6 +599,16 @@
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_IP_NF_CT_FLOW
+	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_FLOW_COUNT,
+		.procname	= "ip_conntrack_flow_count",
+		.data		= &ip_conntrack_flow_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_BUCKETS,
 		.procname	= "ip_conntrack_buckets",
@@ -725,7 +805,11 @@
 static int init_or_cleanup(int init)
 {
 #ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
+	struct proc_dir_entry *proc,
+#ifdef CONFIG_IP_NF_CT_FLOW
+	*proc_flow,
+#endif
+	*proc_exp, *proc_stat;
 #endif
 	int ret = 0;
 
@@ -739,9 +823,18 @@
 	proc = proc_net_fops_create("ip_conntrack", 0440, &ct_file_ops);
 	if (!proc) goto cleanup_init;
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+	proc_flow = proc_net_fops_create("ip_conntrack_flow", 0440, &ct_flow_file_ops);
+	if (!proc_flow) goto cleanup_proc;
+#endif
+
 	proc_exp = proc_net_fops_create("ip_conntrack_expect", 0440,
 					&exp_file_ops);
+#ifdef CONFIG_IP_NF_CT_FLOW
+	if (!proc_exp) goto cleanup_proc_flow;
+#else
 	if (!proc_exp) goto cleanup_proc;
+#endif
 
 	proc_stat = create_proc_entry("ip_conntrack", S_IRUGO, proc_net_stat);
 	if (!proc_stat)
@@ -815,8 +908,12 @@
  cleanup_proc_stat:
 #ifdef CONFIG_PROC_FS
 	proc_net_remove("ip_conntrack_stat");
-cleanup_proc_exp:
+ cleanup_proc_exp:
 	proc_net_remove("ip_conntrack_expect");
+#ifdef CONFIG_IP_NF_CT_FLOW
+ cleanup_proc_flow:
+	proc_net_remove("ip_conntrack_flow");
+#endif
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:
@@ -875,6 +972,9 @@
 {
 }
 
+#ifdef CONFIG_IP_NF_CT_FLOW
+EXPORT_SYMBOL(hash_flow);
+#endif
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
 EXPORT_SYMBOL(invert_tuplepr);
@@ -900,6 +1000,9 @@
 EXPORT_SYMBOL(ip_conntrack_expect_list);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
+#ifdef CONFIG_IP_NF_CT_FLOW
+EXPORT_SYMBOL(ip_conntrack_flow_hash);
+#endif
 EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
diff -Pru linux-2.6.9/net/ipv4/netfilter/ipt_flow.c linux-2.6.9-flow-20041030/net/ipv4/netfilter/ipt_flow.c
--- linux-2.6.9/net/ipv4/netfilter/ipt_flow.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.9-flow-20041030/net/ipv4/netfilter/ipt_flow.c	2004-10-30 01:03:48.000000000 -0500
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
+	if (strcmp(tablename, "raw") == 0) {
+		printk(KERN_WARNING "flow: can not by used in the \"raw\" table\n");
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

--n8g4imXOkfNTN/H1--
