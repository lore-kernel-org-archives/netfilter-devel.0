From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 2/19]: Change MASQUERADE to Use Device Address Directly
Date: Mon, 25 Oct 2004 02:48:46 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D6E.8060702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080207070501070409040303"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080207070501070409040303
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Rusty's MASQUERADE patch: Use inet_select_addr for getting source
address and clear ASSURED bit when interface goes down.



--------------080207070501070409040303
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/19 02:08:50+02:00 rusty@rustcorp.com.au 
#   [NETFILTER]: Change MASQUERADE to Use Device Address Directly
#   
#   Instead of doing a dubious route lookup, just use the first IP address
#   of the (dynamic) interface.  Also, reset assured bit so after masq
#   connections can be cleaned up if memory pressure.
#   
#   Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_MASQUERADE.c
#   2004/10/19 02:08:24+02:00 rusty@rustcorp.com.au +18 -29
#   [NETFILTER]: Change MASQUERADE to Use Device Address Directly
#   
#   Instead of doing a dubious route lookup, just use the first IP address
#   of the (dynamic) interface.  Also, reset assured bit so after masq
#   connections can be cleaned up if memory pressure.
#   
#   Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-10-22 03:37:12 +02:00
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-10-22 03:37:12 +02:00
@@ -82,7 +82,6 @@
 	const struct ip_nat_multi_range *mr;
 	struct ip_nat_multi_range newrange;
 	u_int32_t newsrc;
-	struct rtable *rt;
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
@@ -96,36 +95,12 @@
 	                    || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
 
 	mr = targinfo;
-
-	{
-		struct flowi fl = { .nl_u = { .ip4_u =
-					      { .daddr = (*pskb)->nh.iph->daddr,
-						.tos = (RT_TOS((*pskb)->nh.iph->tos) |
-							RTO_CONN),
-#ifdef CONFIG_IP_ROUTE_FWMARK
-						.fwmark = (*pskb)->nfmark
-#endif
-					      } } };
-		if (ip_route_output_key(&rt, &fl) != 0) {
-			/* Funky routing can do this. */
-			if (net_ratelimit())
-				printk("MASQUERADE:"
-				       " No route: Rusty's brain broke!\n");
-			return NF_DROP;
-		}
-		if (rt->u.dst.dev != out) {
-			if (net_ratelimit())
-				printk("MASQUERADE:"
-				       " Route sent us somewhere else.\n");
-			ip_rt_put(rt);
-			return NF_DROP;
-		}
+	newsrc = inet_select_addr(out, 0, RT_SCOPE_UNIVERSE);
+	if (!newsrc) {
+		printk("MASQUERADE: %s ate my IP address\n", out->name);
+		return NF_DROP;
 	}
 
-	newsrc = rt->rt_src;
-	DEBUGP("newsrc = %u.%u.%u.%u\n", NIPQUAD(newsrc));
-	ip_rt_put(rt);
-
 	WRITE_LOCK(&masq_lock);
 	ct->nat.masq_index = out->ifindex;
 	WRITE_UNLOCK(&masq_lock);
@@ -157,6 +132,18 @@
 	return ret;
 }
 
+static inline int
+connect_unassure(const struct ip_conntrack *i, void *_ina)
+{
+	struct in_ifaddr *ina = _ina;
+
+	/* We reset the ASSURED bit on all connections, so they will
+	 * get reaped under memory pressure. */
+	if (i->nat.masq_index == ina->ifa_dev->dev->ifindex)
+		clear_bit(IPS_ASSURED_BIT, (unsigned long *)&i->status);
+	return 0;
+}
+
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
@@ -166,6 +153,8 @@
 	 * entries. */
 	if (event == NETDEV_UP)
 		ip_ct_selective_cleanup(device_cmp, ptr);
+	else if (event == NETDEV_DOWN)
+		ip_ct_selective_cleanup(connect_unassure, ptr);
 
 	return NOTIFY_DONE;
 }

--------------080207070501070409040303--
