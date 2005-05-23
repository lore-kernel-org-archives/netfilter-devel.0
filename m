From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 9/9]: Do not be clever about SKB ownership in
 ip_ct_gather_frags().
Date: Mon, 23 May 2005 15:23:45 +0900 (JST)
Message-ID: <200505230623.j4N6NkY6005428@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:23:45_2005_206)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

----Next_Part(Mon_May_23_15:23:45_2005_206)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

===========

    [NETFILTER]: Do not be clever about SKB ownership in ip_ct_gather_frags().

    Just do an skb_orphan() and be done with it.
    Based upon discussions with Herbert Xu on netdev.

    Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_15:23:45_2005_206)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="09-skb-owner.patch"

diff -Nur linux-2.6.12-rc4-nfct-8-expect/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c linux-2.6.12-rc4-nfct-9-skb-owner/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.12-rc4-nfct-8-expect/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-05-20 03:16:23.000000000 +0900
+++ linux-2.6.12-rc4-nfct-9-skb-owner/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-05-22 00:48:55.000000000 +0900
@@ -82,37 +82,25 @@
 static struct sk_buff *
 nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 {
-        struct sock *sk = skb->sk;
 #ifdef CONFIG_NETFILTER_DEBUG
         unsigned int olddebug = skb->nf_debug;
 #endif
 
-        if (sk) {
-                sock_hold(sk);
-                skb_orphan(skb);
-        }
+	skb_orphan(skb);
 
         local_bh_disable();
         skb = ip_defrag(skb, user);
         local_bh_enable();
 
-        if (!skb) {
-                if (sk)
-                        sock_put(sk);
-                return skb;
-        }
-
-        if (sk) {
-                skb_set_owner_w(skb, sk);
-                sock_put(sk);
-        }
-
-        ip_send_check(skb->nh.iph);
-        skb->nfcache |= NFC_ALTERED;
+        if (skb) {
+		ip_send_check(skb->nh.iph);
+		skb->nfcache |= NFC_ALTERED;
 #ifdef CONFIG_NETFILTER_DEBUG
-        /* Packet path as if nothing had happened. */
-        skb->nf_debug = olddebug;
+		/* Packet path as if nothing had happened. */
+		skb->nf_debug = olddebug;
 #endif
+	}
+
         return skb;
 }
 

----Next_Part(Mon_May_23_15:23:45_2005_206)----
