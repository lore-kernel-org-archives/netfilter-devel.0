From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] Fix ip_queue for bridged packets
Date: Sat, 25 Oct 2003 17:09:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310251709.13913.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

When ip_queue copies an old skbuff to a new one (because the tailroom is
too small), it uses skb_copy_expand(). This function doesn't copy the
Ethernet header, which is not needed for normal IP traffic. Normally, the
Ethernet header is filled in later before doing dev_queue_xmit.
When ip_queue does this to a bridged IP packet, it has to copy the Ethernet
header, because the Ethernet header is already filled in and won't be filled
in again.
The patch below makes this happen. It puts the code that actually copies the
header inside netfilter_bridge.h, so that it can be reused and altered
without touching other code.

The patch is already approved by Stephen Hemminger (in private mail).
Since Harald Welte excels in silence, I'm sending netfilter stuff directly
to you from now on.

The patch is vs test7 but applies fine vs test8.

cheers,
Bart

--- linux-2.6.0-test7/net/ipv4/netfilter/ip_queue.c.old	2003-10-12 21:23:01.000000000 +0200
+++ linux-2.6.0-test7/net/ipv4/netfilter/ip_queue.c	2003-10-12 22:13:45.000000000 +0200
@@ -21,6 +21,9 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_queue.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#ifdef CONFIG_BRIDGE_NETFILTER
+#include <linux/netfilter_bridge.h>
+#endif
 #include <linux/netlink.h>
 #include <linux/spinlock.h>
 #include <linux/sysctl.h>
@@ -353,6 +356,10 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, st
 			}
 			if (e->skb->sk)
 				skb_set_owner_w(newskb, e->skb->sk);
+#ifdef CONFIG_BRIDGE_NETFILTER
+			/* bridged packets already have their Ethernet header */
+			br_nf_maybe_copy_header2(newskb, e->skb);
+#endif
 			kfree_skb(e->skb);
 			e->skb = newskb;
 		}
--- linux-2.6.0-test7/include/linux/netfilter_bridge.h.old	2003-10-12 21:44:28.000000000 +0200
+++ linux-2.6.0-test7/include/linux/netfilter_bridge.h	2003-10-12 22:21:16.000000000 +0200
@@ -81,6 +81,22 @@ void nf_bridge_maybe_copy_header(struct 
 	}
 }
 
+/* needed in IP netfilter modules that can copy bridged skbuff's,
+ * but don't copy the Ethernet header by default. */
+static inline
+void nf_bridge_maybe_copy_header2(struct sk_buff *d,
+				  struct sk_buff *s)
+{
+	if (s->nf_bridge) {
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
+		if (s->protocol == __constant_htons(ETH_P_8021Q))
+			memcpy(d->data - 18, s->data - 18, 18);
+		else
+#endif
+			memcpy(d->data - 16, s->data - 16, 16);
+	}
+}
+
 static inline
 void nf_bridge_save_header(struct sk_buff *skb)
 {
