From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Sun, 21 Nov 2004 13:58:28 +1100
Message-ID: <1101005908.18919.11.camel@localhost.localdomain>
References: <20041107181825.GA3522@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041107181825.GA3522@linuxace.com>
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

On Sun, 2004-11-07 at 10:18 -0800, Phil Oester wrote:
> As discussed in recent days, MASQUERADE target handling of device events
> is broken in a couple of ways:
> 
> 1) when ppp interfaces cycle, conntracks with old ip addresses are not
>    flushed
> 
> 2) an 'ip addr add' on an interface used for masquerading flushes all
>    conntracks associated with that interface

Sorry, just caught up with this reversion in 2.6.10-rc2-bk* (was trying
to figure out why my nfsim testcase was failing: this explains it).

We had numerous complaints about the old behaviour: several people with
small (or clever?) ISPs actually got the same IP address most of the
time, and the old code was damaging them.  It also registered two
callbacks which AFAICT is unnecessary.

This patch bloats conntrack, but is worth it IMHO.  Most importantly,
Phil, does it work for you?

Rusty.
Name: Reliable Masquerading Connection Removal
Status: Compiles, Untested
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
a NOOP.

Index: linux-2.6.10-rc2-bk1-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-rc2-bk1-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2004-11-20 17:53:54.000000000 +1100
+++ linux-2.6.10-rc2-bk1-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2004-11-20 17:55:40.000000000 +1100
@@ -193,7 +193,7 @@
 		union ip_conntrack_nat_help help;
 #if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
 	defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
-		int masq_index;
+		char masq_iface[IFNAMSIZ];
 #endif
 	} nat;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
Index: linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- linux-2.6.10-rc2-bk1-Netfilter.orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-19 16:51:36.000000000 +1100
+++ linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-21 13:50:02.943750896 +1100
@@ -104,7 +104,7 @@
 	}
 
 	WRITE_LOCK(&masq_lock);
-	ct->nat.masq_index = out->ifindex;
+	strcpy(ct->nat.masq_iface, out->name);
 	WRITE_UNLOCK(&masq_lock);
 
 	/* Transfer from original range. */
@@ -118,57 +118,61 @@
 }
 
 static inline int
-device_cmp(const struct ip_conntrack *i, void *ifindex)
+no_address_matches(u32 dstip, struct in_device *in_dev)
 {
-	int ret;
+	struct in_ifaddr *i;
+
+	for (i = in_dev->ifa_list; i; i = i->ifa_next)
+		if (i->ifa_local == dstip)
+			return 0;
+	return 1;
+}
+
+static inline int
+device_cmp(const struct ip_conntrack *i, void *_ina)
+{
+	int ret = 0;
+	struct in_ifaddr *ina = _ina;
 
 	READ_LOCK(&masq_lock);
-	ret = (i->nat.masq_index == (int)(long)ifindex);
+	/* If it's masquerading out this interface with an address,
+	 * which is not any of the existing ones, time to go. */
+	if (strcmp(i->nat.masq_iface, ina->ifa_dev->dev->name) == 0
+	    && no_address_matches(i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip,
+				  ina->ifa_dev))
+		ret = 1;
 	READ_UNLOCK(&masq_lock);
 
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
-		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
-	}
+static inline int
+connect_unassure(const struct ip_conntrack *i, void *_ina)
+{
+	struct in_ifaddr *ina = _ina;
 
-	return NOTIFY_DONE;
+	/* We reset the ASSURED bit on all connections, so they will
+	 * get reaped under memory pressure. */
+	if (strcmp(i->nat.masq_iface, ina->ifa_dev->dev->name) == 0)
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
-		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
-	}
+	/* For some configurations, interfaces often come back with
+	 * the same address.  If not, clean up old conntrack
+	 * entries. */
+	if (event == NETDEV_UP)
+		ip_ct_selective_cleanup(device_cmp, ptr);
+	else if (event == NETDEV_DOWN)
+		ip_ct_selective_cleanup(connect_unassure, ptr);
 
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block masq_dev_notifier = {
-	.notifier_call	= masq_device_event,
-};
-
 static struct notifier_block masq_inet_notifier = {
 	.notifier_call	= masq_inet_event,
 };
@@ -187,8 +191,6 @@
 	ret = ipt_register_target(&masquerade);
 
 	if (ret == 0) {
-		/* Register for device down reports */
-		register_netdevice_notifier(&masq_dev_notifier);
 		/* Register IP address change reports */
 		register_inetaddr_notifier(&masq_inet_notifier);
 	}
@@ -199,7 +201,6 @@
 static void __exit fini(void)
 {
 	ipt_unregister_target(&masquerade);
-	unregister_netdevice_notifier(&masq_dev_notifier);
 	unregister_inetaddr_notifier(&masq_inet_notifier);	
 }
 

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
