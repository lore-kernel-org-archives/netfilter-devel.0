From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] MASQUERADE device handling - revert optimization
Date: Wed, 17 Nov 2004 16:15:30 -0800
Message-ID: <20041118001530.GA5670@linuxace.com>
References: <20041112200126.GA30173@linuxace.com> <4199185A.7000404@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4199185A.7000404@trash.net>
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


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 15, 2004 at 09:58:02PM +0100, Patrick McHardy wrote:
> Phil Oester wrote:
> 
> ><>Since it looks like no other solution will be accepted, the only way to
> >fix masquerade is to revert the 'mostly static' optimization which
> >went in last year. The patch below does so.
> >
> >This fixes bugzilla #227.
> 
> Patch applied, thanks Phil. Can you send a patch for 2.4 as well ?

Sure, attached.

Phil



--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-24unmasq

diff -ru linux24-orig/net/ipv4/netfilter/ipt_MASQUERADE.c linux24-new/net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux24-orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-08-07 19:26:06.000000000 -0400
+++ linux24-new/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-11-17 19:10:10.974391736 -0500
@@ -125,35 +125,58 @@
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
-	 * or we don't know the new address of this interface. */
-	if (i->nat.masq_index == ina->ifa_dev->dev->ifindex
-	    && i->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip != ina->ifa_address)
-		ret = 1;
+	ret = (i->nat.masq_index == (int)(long)ifindex);
 	READ_UNLOCK(&masq_lock);
 
 	return ret;
 }
 
+static int masq_device_event(struct notifier_block *this,
+			     unsigned long event,
+			     void *ptr)
+{
+	struct net_device *dev = ptr;
+
+	if (event == NETDEV_DOWN) {
+		/* Device was downed.  Search entire table for
+		   conntracks which were associated with that device,
+		   and forget them. */
+		IP_NF_ASSERT(dev->ifindex != 0);
+ 
+		ip_ct_selective_cleanup(device_cmp, (void *)(long)dev->ifindex);
+	}
+
+	return NOTIFY_DONE;
+}
+
+
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	/* For some configurations, interfaces often come back with
-	 * the same address.  If not, clean up old conntrack
-	 * entries. */
-	if (event == NETDEV_UP)
-		ip_ct_selective_cleanup(device_cmp, ptr);
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
+	.notifier_call  = masq_device_event,
+};
+
 static struct notifier_block masq_inet_notifier = {
 	.notifier_call = masq_inet_event
 };
@@ -168,9 +191,12 @@
 
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
@@ -178,6 +204,7 @@
 static void __exit fini(void)
 {
 	ipt_unregister_target(&masquerade);
+	unregister_netdevice_notifier(&masq_dev_notifier);
 	unregister_inetaddr_notifier(&masq_inet_notifier);	
 }
 

--jI8keyz6grp/JLjh--
