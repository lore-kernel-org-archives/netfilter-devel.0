From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Tue, 2 Nov 2004 13:04:40 -0800
Message-ID: <20041102210440.GA1851@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
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


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

About 14 months ago, MASQUERADE target was modified to only flush conntracks
on interface up/down if the IP address changed [1].  Unfortunately, there were
a few problems with this change:

1) ina->ifa_address was used as the IP address of the interface for
   comparison purposes.  This works great for ethernet interfaces
   since ifa_address and ifa_local are identical.  But on ppp interfaces
   ifa_address is the address of the remote side, not the local side

2) dev->ifindex was used to determine whether the interface which cycled
   matches the interface the conntrack is masquerading out.  Again, this
   works fine for ethernet (static ifindex), but not at all for ppp which
   uses sequentially increasing interface indexes.  The ifindex associated
   with pppX increments on each up/down cycle

3) even if #2 were not true, in a scenario where multiple ppp interfaces
   are utilized, the order in which they are cycled makes the ifindex
   comparison haphazard

The below patch addresses these issues by returning to the old behavior
for ppp interfaces: flush all conntracks masquerading out that interface
on device down.  I can think of no other foolproof way to ensure the proper
conntracks get destroyed.

This fixes Bugzilla #227

Phil

[1] http://linux.bkbits.net:8080/linux-2.5/diffs/net/ipv4/netfilter/ipt_MASQUERADE.c@1.11?nav=index.html|src/.|src/net|src/net/ipv4|src/net/ipv4/netfilter|hist/net/ipv4/netfilter/ipt_MASQUERADE.c




--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-masq

diff -ru linux-orig/net/ipv4/netfilter/ipt_MASQUERADE.c linux-new/net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux-orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-02 14:03:15.053073816 -0500
+++ linux-new/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-02 15:30:31.907455400 -0500
@@ -118,16 +118,28 @@
 }
 
 static inline int
+index_cmp(const struct ip_conntrack *i, void *ifindex)
+{
+	int ret = 0;
+
+	READ_LOCK(&masq_lock);
+	ret = (i->nat.masq_index == (int)(long)ifindex);
+	READ_UNLOCK(&masq_lock);
+
+	return ret;
+}
+
+static inline int
 device_cmp(const struct ip_conntrack *i, void *_ina)
 {
 	int ret = 0;
 	struct in_ifaddr *ina = _ina;
 
 	READ_LOCK(&masq_lock);
-	/* If it's masquerading out this interface with a different address,
-	   or we don't know the new address of this interface. */
+	/* If it's masquerading out this interface with a
+	 * different or unknown address, drop conntrack. */
 	if (i->nat.masq_index == ina->ifa_dev->dev->ifindex
-	    && i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip != ina->ifa_address)
+	    && i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip != ina->ifa_local)
 		ret = 1;
 	READ_UNLOCK(&masq_lock);
 
@@ -146,14 +158,46 @@
 	return 0;
 }
 
+static int
+masq_device_event(struct notifier_block *this,
+		  unsigned long event,
+		  void *ptr)
+{
+	struct net_device *dev = ptr;
+
+	/* Point-to-Point interfaces don't use static interface
+	 * indexes, so conntracks associated with these devices
+	 * must be cleared on device down. */
+	if (event == NETDEV_DOWN && (dev->flags & IFF_POINTOPOINT)) {
+		IP_NF_ASSERT(dev->ifindex != 0);
+
+		ip_ct_selective_cleanup(index_cmp, (void *)(long)dev->ifindex);
+	}
+	return NOTIFY_DONE;
+}
+
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
+	struct net_device *dev = ((struct in_ifaddr *)ptr)->ifa_dev->dev;
+
+	/* Point-to-Point interfaces don't use static interface
+	 * indexes, so conntracks associated with these devices
+	 * must be cleared on IP address deletion. */
+	if (event == NETDEV_DOWN && (dev->flags & IFF_POINTOPOINT)) {
+		/* Search entire table for conntracks which were
+		 * associated with the device and forget them. */
+		IP_NF_ASSERT(dev->ifindex != 0);
+
+		ip_ct_selective_cleanup(index_cmp, (void *)(long)dev->ifindex);
+		return NOTIFY_DONE;
+	}
+
 	/* For some configurations, interfaces often come back with
 	 * the same address.  If not, clean up old conntrack
 	 * entries. */
-	if (event == NETDEV_UP)
+	if (event == NETDEV_UP && !(dev->flags & IFF_POINTOPOINT))
 		ip_ct_selective_cleanup(device_cmp, ptr);
 	else if (event == NETDEV_DOWN)
 		ip_ct_selective_cleanup(connect_unassure, ptr);
@@ -161,6 +205,10 @@
 	return NOTIFY_DONE;
 }
 
+static struct notifier_block masq_dev_notifier = {
+	.notifier_call  = masq_device_event,
+};
+
 static struct notifier_block masq_inet_notifier = {
 	.notifier_call	= masq_inet_event,
 };
@@ -178,9 +226,12 @@
 
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
@@ -188,6 +239,7 @@
 static void __exit fini(void)
 {
 	ipt_unregister_target(&masquerade);
+	unregister_netdevice_notifier(&masq_dev_notifier);
 	unregister_inetaddr_notifier(&masq_inet_notifier);	
 }
 

--TB36FDmn/VVEgNH/--
