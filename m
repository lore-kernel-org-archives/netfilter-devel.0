From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] MASQUERADE device handling - revert optimization
Date: Fri, 12 Nov 2004 12:01:26 -0800
Message-ID: <20041112200126.GA30173@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
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


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Since it looks like no other solution will be accepted, the only way to 
fix masquerade is to revert the 'mostly static' optimization which
went in last year.  The patch below does so.

This fixes bugzilla #227.

Phil



--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-unmasq

diff -ru linux-orig/net/ipv4/netfilter/ipt_MASQUERADE.c linux-new/net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux-orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-04 17:32:05.000000000 -0500
+++ linux-new/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-12 14:59:17.953399384 -0500
@@ -118,49 +118,57 @@
 }
 
 static inline int
-device_cmp(const struct ip_conntrack *i, void *_ina)
+device_cmp(const struct ip_conntrack *i, void *ifindex)
 {
-	int ret = 0;
-	struct in_ifaddr *ina = _ina;
+	int ret;
 
 	READ_LOCK(&masq_lock);
-	/* If it's masquerading out this interface with a different address,
-	   or we don't know the new address of this interface. */
-	if (i->nat.masq_index == ina->ifa_dev->dev->ifindex
-	    && i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip != ina->ifa_address)
-		ret = 1;
+	ret = (i->nat.masq_index == (int)(long)ifindex);
 	READ_UNLOCK(&masq_lock);
 
 	return ret;
 }
 
-static inline int
-connect_unassure(const struct ip_conntrack *i, void *_ina)
+static int masq_device_event(struct notifier_block *this,
+			     unsigned long event,
+			     void *ptr)
 {
-	struct in_ifaddr *ina = _ina;
+	struct net_device *dev = ptr;
+
+	if (event == NETDEV_DOWN) {
+		/* Device was downed.  Search entire table for
+		   conntracks which were associated with that device,
+		   and forget them. */
+		IP_NF_ASSERT(dev->ifindex != 0);
 
-	/* We reset the ASSURED bit on all connections, so they will
-	 * get reaped under memory pressure. */
-	if (i->nat.masq_index == ina->ifa_dev->dev->ifindex)
-		clear_bit(IPS_ASSURED_BIT, (unsigned long *)&i->status);
-	return 0;
+		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
+	}
+
+	return NOTIFY_DONE;
 }
 
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	/* For some configurations, interfaces often come back with
-	 * the same address.  If not, clean up old conntrack
-	 * entries. */
-	if (event == NETDEV_UP)
-		ip_ct_selective_cleanup(device_cmp, ptr);
-	else if (event == NETDEV_DOWN)
-		ip_ct_selective_cleanup(connect_unassure, ptr);
+	struct net_device *dev = ((struct in_ifaddr *)ptr)->ifa_dev->dev;
+
+	if (event == NETDEV_DOWN) {
+		/* IP address was deleted.  Search entire table for
+		   conntracks which were associated with that device,
+		   and forget them. */
+		IP_NF_ASSERT(dev->ifindex != 0);
+
+		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
+	}
 
 	return NOTIFY_DONE;
 }
 
+static struct notifier_block masq_dev_notifier = {
+	.notifier_call	= masq_device_event,
+};
+
 static struct notifier_block masq_inet_notifier = {
 	.notifier_call	= masq_inet_event,
 };
@@ -178,9 +186,12 @@
 
 	ret = ipt_register_target(&masquerade);
 
-	if (ret == 0)
+	if (ret == 0) {
+		/* Register for device down reports */
+		register_netdevice_notifier(&masq_dev_notifier);
 		/* Register IP address change reports */
 		register_inetaddr_notifier(&masq_inet_notifier);
+	}
 
 	return ret;
 }
@@ -188,6 +199,7 @@
 static void __exit fini(void)
 {
 	ipt_unregister_target(&masquerade);
+	unregister_netdevice_notifier(&masq_dev_notifier);
 	unregister_inetaddr_notifier(&masq_inet_notifier);	
 }
 

--EeQfGwPcQSOJBaQU--
