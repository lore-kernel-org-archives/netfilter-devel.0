From: Patrick McHardy <kaber@trash.net>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's
 brain broke!)
Date: Tue, 13 Jan 2004 05:30:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4003747F.40304@trash.net>
References: <20040112234710.1B13C2C0C4@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000406020709070502020606"
Cc: Harald Welte <laforge@netfilter.org>,  kuznet@ms2.inr.ac.ru,
 fenio@o2.pl,  davem@redhat.com,  linux-net@vger.kernel.org,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
  boris@boris.ca,  email@cs-ware.de,  Jan.Schubert@GMX.li
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20040112234710.1B13C2C0C4@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000406020709070502020606
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Rusty Russell wrote:
> You take all the fun out.
> 
> Yes, this is the best.  It always does *something*, and is
> predictable.  People with really complex routing shouldn't really use
> MASQUERADE, since it's designed for a specific, simple case.

I'm not sure about this, as Julian mentioned it breaks some setups,
but that's your decision.

> 
> Patch?

Patches for 2.4+2.6 attached. Both patches compile, 2.6 version is also
tested.

Best regards,
Patrick

> 
> Cheers,
> Rusty.
> --
>   Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
> 


--------------000406020709070502020606
Content-Type: text/plain;
 name="2.4-masq-ifa_local.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.4-masq-ifa_local.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/01/13 05:05:13+01:00 kaber@trash.net 
#   Use indev->ifa_list->ifa_local for MASQUERADE
# 
# net/ipv4/netfilter/ipt_MASQUERADE.c
#   2004/01/13 05:05:11+01:00 kaber@trash.net +16 -24
#   Use indev->ifa_list->ifa_local for MASQUERADE
# 
diff -Nru a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c	Tue Jan 13 05:09:32 2004
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c	Tue Jan 13 05:09:32 2004
@@ -1,10 +1,13 @@
-/* Masquerade.  Simple mapping which alters range to a local IP address
-   (depending on route). */
+/* Masquerade.  Simple mapping which alters range to a local IP address. */
+#include <linux/kernel.h>
 #include <linux/config.h>
 #include <linux/types.h>
 #include <linux/ip.h>
 #include <linux/timer.h>
 #include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
 #include <linux/netfilter.h>
 #include <net/protocol.h>
 #include <net/checksum.h>
@@ -67,9 +70,8 @@
 	enum ip_conntrack_info ctinfo;
 	const struct ip_nat_multi_range *mr;
 	struct ip_nat_multi_range newrange;
+	struct in_device *indev;
 	u_int32_t newsrc;
-	struct rtable *rt;
-	struct rt_key key;
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
@@ -84,30 +86,20 @@
 
 	mr = targinfo;
 
-	key.dst = (*pskb)->nh.iph->daddr;
-	key.src = 0; /* Unknown: that's what we're trying to establish */
-	key.tos = RT_TOS((*pskb)->nh.iph->tos)|RTO_CONN;
-	key.oif = 0;
-#ifdef CONFIG_IP_ROUTE_FWMARK
-	key.fwmark = (*pskb)->nfmark;
-#endif
-	if (ip_route_output_key(&rt, &key) != 0) {
-                /* Funky routing can do this. */
-                if (net_ratelimit())
-                        printk("MASQUERADE:"
-                               " No route: Rusty's brain broke!\n");
-                return NF_DROP;
-        }
-        if (rt->u.dst.dev != out) {
-                if (net_ratelimit())
-                        printk("MASQUERADE:"
-                               " Route sent us somewhere else.\n");
+	indev = in_dev_get(out);
+	if (indev == NULL)
+		return NF_DROP;
+	read_lock(&indev->lock);
+	if (indev->ifa_list == NULL) {
+		read_unlock(&indev->lock);
+		in_dev_put(indev);
 		return NF_DROP;
 	}
+	newsrc = indev->ifa_list->ifa_local;
+	read_unlock(&indev->lock);
+	in_dev_put(indev);
 
-	newsrc = rt->rt_src;
 	DEBUGP("newsrc = %u.%u.%u.%u\n", NIPQUAD(newsrc));
-	ip_rt_put(rt);
 
 	WRITE_LOCK(&masq_lock);
 	ct->nat.masq_index = out->ifindex;

--------------000406020709070502020606
Content-Type: text/plain;
 name="2.6-masq-ifa_local.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6-masq-ifa_local.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/01/13 05:08:46+01:00 kaber@trash.net 
#   Use indev->ifa_list->ifa_local for MASQUERADE
# 
# net/ipv4/netfilter/ipt_MASQUERADE.c
#   2004/01/13 05:05:49+01:00 kaber@trash.net +18 -28
#   Use indev->ifa_list->ifa_local for MASQUERADE
# 
diff -Nru a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c	Tue Jan 13 05:09:17 2004
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c	Tue Jan 13 05:09:17 2004
@@ -1,10 +1,13 @@
-/* Masquerade.  Simple mapping which alters range to a local IP address
-   (depending on route). */
+/* Masquerade.  Simple mapping which alters range to a local IP address. */
+#include <linux/kernel.h>
 #include <linux/config.h>
 #include <linux/types.h>
 #include <linux/ip.h>
 #include <linux/timer.h>
 #include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
 #include <linux/netfilter.h>
 #include <net/protocol.h>
 #include <net/checksum.h>
@@ -71,8 +74,8 @@
 	enum ip_conntrack_info ctinfo;
 	const struct ip_nat_multi_range *mr;
 	struct ip_nat_multi_range newrange;
+	struct in_device *indev;
 	u_int32_t newsrc;
-	struct rtable *rt;
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
@@ -87,33 +90,20 @@
 
 	mr = targinfo;
 
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
-			return NF_DROP;
-		}
-	}
+	indev = in_dev_get(out);
+	if (indev == NULL)
+		return NF_DROP;
+	read_lock(&indev->lock);
+	if (indev->ifa_list == NULL) {
+		read_unlock(&indev->lock);
+		in_dev_put(indev);
+		return NF_DROP;
+	}
+	newsrc = indev->ifa_list->ifa_local;
+	read_unlock(&indev->lock);
+	in_dev_put(indev);
 
-	newsrc = rt->rt_src;
 	DEBUGP("newsrc = %u.%u.%u.%u\n", NIPQUAD(newsrc));
-	ip_rt_put(rt);
 
 	WRITE_LOCK(&masq_lock);
 	ct->nat.masq_index = out->ifindex;

--------------000406020709070502020606--
