From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/8] Netfilter:  Use ct_extend for MASQUERADE
Date: Thu, 13 Jan 2005 07:58:16 +1100
Message-ID: <1105563496.12794.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Use ct_extend for MASQUERADE
Status: Tested lightly under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

The MASQUERADE target use to destroy connections when an interface
went down.  We changed this to merely remove the ASSURED bit, and
destroy them if the same interface came up with a different IP
address.  Unfortunately, as Phil Oester pointed out, that code was
crap for PPP connections, since we (1) compared ifa_address instead of
ifa_local, (2) identified interfaces by ifindex, which increments as a
PPP device downs and ups, and (3) caused all connections to be flushed
when we added an IP address.

So that code was reverted after 2.6.10-rc2.

This code stores the interface name, rather than trying to use the
ifindex, and only deletes connections if *no* ifa_local on the
interface matches the connection, so simply adding a new IP address is
a NOOP.  We use the new ct_extend functions to avoid bloating the
conntrack struct.

Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:29:07.340402240 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:31:37.545567584 +1100
@@ -187,13 +187,12 @@
 
 	union ip_conntrack_help help;
 
+	/* Use for masqueraded connections: protected by ip_conntrack_lock */
+	struct ct_extend *ext;
+
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	struct {
 		struct ip_nat_info info;
-#if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
-	defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
-		int masq_index;
-#endif
 	} nat;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
 
@@ -300,6 +299,7 @@
 };
 
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
+DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
 
 static inline int ip_nat_initialized(struct ip_conntrack *conntrack,
 				     enum ip_nat_manip_type manip)
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2005-01-12 23:29:07.378396464 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c	2005-01-12 23:31:37.546567432 +1100
@@ -21,6 +21,8 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
@@ -32,9 +34,6 @@
 #define DEBUGP(format, args...)
 #endif
 
-/* Lock protects masq region inside conntrack */
-static DECLARE_RWLOCK(masq_lock);
-
 /* FIXME: Multiple targets. --RR */
 static int
 masquerade_check(const char *tablename,
@@ -82,6 +81,7 @@
 	const struct ip_nat_multi_range_compat *mr;
 	struct ip_nat_range newrange;
 	struct rtable *rt;
+	char *p;
 	u_int32_t newsrc;
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
@@ -103,9 +103,14 @@
 		return NF_DROP;
 	}
 
-	WRITE_LOCK(&masq_lock);
-	ct->nat.masq_index = out->ifindex;
-	WRITE_UNLOCK(&masq_lock);
+	WRITE_LOCK(&ip_conntrack_lock);
+	p = ct_extend_add(&ct->ext, CTE_MASQ, GFP_ATOMIC);
+	if (!p) {
+		WRITE_UNLOCK(&ip_conntrack_lock);
+		return NF_DROP;
+	}
+	strcpy(p, out->name);
+	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	/* Transfer from original range. */
 	newrange = ((struct ip_nat_range)
@@ -118,57 +123,64 @@
 }
 
 static inline int
-device_cmp(struct ip_conntrack *i, void *ifindex)
+no_address_matches(u32 dstip, struct in_device *in_dev)
 {
-	int ret;
+	struct in_ifaddr *i;
 
-	READ_LOCK(&masq_lock);
-	ret = (i->nat.masq_index == (int)(long)ifindex);
-	READ_UNLOCK(&masq_lock);
+	for (i = in_dev->ifa_list; i; i = i->ifa_next)
+		if (i->ifa_local == dstip)
+			return 0;
+	return 1;
+}
+
+static inline int
+device_cmp(struct ip_conntrack *i, void *_ina)
+{
+	int ret = 0;
+	struct in_ifaddr *ina = _ina;
+	char *ifname;
+
+	ifname = ct_extend_find(i->ext, CTE_MASQ);
+	/* If it's masquerading out this interface with an address,
+	 * which is not any of the existing ones, time to go. */
+	if (ifname
+	    && strcmp(ifname, ina->ifa_dev->dev->name) == 0
+	    && no_address_matches(i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip,
+				  ina->ifa_dev))
+		ret = 1;
 
 	return ret;
 }
 
-static int masq_device_event(struct notifier_block *this,
-			     unsigned long event,
-			     void *ptr)
-{
-	struct net_device *dev = ptr;
-
-	if (event == NETDEV_DOWN) {
-		/* Device was downed.  Search entire table for
-		   conntracks which were associated with that device,
-		   and forget them. */
-		IP_NF_ASSERT(dev->ifindex != 0);
-
-		ip_ct_iterate_cleanup(device_cmp, (void *)(long)dev->ifindex);
-	}
+static inline int
+connect_unassure(struct ip_conntrack *i, void *_ina)
+{
+	struct in_ifaddr *ina = _ina;
+	char *ifname;
 
-	return NOTIFY_DONE;
+	/* We reset the ASSURED bit on all connections, so they will
+	 * get reaped under memory pressure. */
+	ifname = ct_extend_find(i->ext, CTE_MASQ);
+	if (ifname && strcmp(ifname, ina->ifa_dev->dev->name) == 0)
+		clear_bit(IPS_ASSURED_BIT, (unsigned long *)&i->status);
+	return 0;
 }
 
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	struct net_device *dev = ((struct in_ifaddr *)ptr)->ifa_dev->dev;
-
-	if (event == NETDEV_DOWN) {
-		/* IP address was deleted.  Search entire table for
-		   conntracks which were associated with that device,
-		   and forget them. */
-		IP_NF_ASSERT(dev->ifindex != 0);
-
-		ip_ct_iterate_cleanup(device_cmp, (void *)(long)dev->ifindex);
-	}
+	/* For some configurations, interfaces often come back with
+	 * the same address.  If not, clean up old conntrack
+	 * entries. */
+	if (event == NETDEV_UP)
+		ip_ct_iterate_cleanup(device_cmp, ptr);
+	else if (event == NETDEV_DOWN)
+		ip_ct_iterate_cleanup(connect_unassure, ptr);
 
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block masq_dev_notifier = {
-	.notifier_call	= masq_device_event,
-};
-
 static struct notifier_block masq_inet_notifier = {
 	.notifier_call	= masq_inet_event,
 };
@@ -180,6 +192,12 @@
 	.me		= THIS_MODULE,
 };
 
+struct ct_extend_type ct_masquerade = {
+	.len		= IFNAMSIZ,
+	.align		= 1,
+	.type		= CTE_MASQ,
+};
+
 static int __init init(void)
 {
 	int ret;
@@ -187,10 +205,9 @@
 	ret = ipt_register_target(&masquerade);
 
 	if (ret == 0) {
-		/* Register for device down reports */
-		register_netdevice_notifier(&masq_dev_notifier);
 		/* Register IP address change reports */
 		register_inetaddr_notifier(&masq_inet_notifier);
+		register_ct_extend_type(&ct_masquerade);
 	}
 
 	return ret;
@@ -199,8 +216,8 @@
 static void __exit fini(void)
 {
 	ipt_unregister_target(&masquerade);
-	unregister_netdevice_notifier(&masq_dev_notifier);
 	unregister_inetaddr_notifier(&masq_inet_notifier);	
+	unregister_ct_extend_type(&ct_masquerade);
 }
 
 module_init(init);
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:31:11.362548008 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:34:29.335451552 +1100
@@ -4,9 +4,12 @@
 
 enum ct_ext_type
 {
+	CTE_MASQ,
 	CTE_MAX,
 } __attribute__((packed));
 
+#define CTE_MASQ_TYPE char 	/* Actually char[IFNAMSIZ] */
+
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct ct_extend {
 	enum ct_ext_type type[CTE_MAX];
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:29:07.379396312 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-12 23:31:37.549566976 +1100
@@ -47,6 +47,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 #include <linux/netfilter_ipv4/listhelp.h>
 
 #define IP_CONNTRACK_VERSION	"2.1"
@@ -259,6 +260,9 @@
 	if (ct->master)
 		ip_conntrack_put(ct->master);
 
+	if (ct->ext)
+		ct_extend_free(ct->ext);
+
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);
 	atomic_dec(&ip_conntrack_count);
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_core.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-12 23:29:07.340402240 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-12 23:31:37.550566824 +1100
@@ -47,6 +47,5 @@
 
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_expect_list;
-DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
 #endif /* _IP_CONNTRACK_CORE_H */
 
