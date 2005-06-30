From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH: NF_CONNTRACK 4/6] kill nf_debug
Date: Thu, 30 Jun 2005 10:31:17 +0900 (JST)
Message-ID: <200506300131.j5U1VHp7004387@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jun_30_10:31:17_2005_977)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Jun_30_10:31:17_2005_977)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
        [NETFILTER]: Kill nf_debug

        Signed-off-by: Patrick McHardy <kaber@trash.net>
        Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Jun_30_10:31:17_2005_977)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-kill-debug.patch"

Index: net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
--- 2c563bbd248355b4755af27e4ba819b2488b35fc/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c  (mode:100644)
+++ 7c492b3fe4e0c83f4208674b57adb88662a42da7/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c  (mode:100644)
@@ -82,10 +82,6 @@
 static struct sk_buff *
 nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 {
-#ifdef CONFIG_NETFILTER_DEBUG
-        unsigned int olddebug = skb->nf_debug;
-#endif
-
 	skb_orphan(skb);
 
         local_bh_disable();
@@ -95,12 +91,7 @@
         if (skb) {
 		ip_send_check(skb->nh.iph);
 		skb->nfcache |= NFC_ALTERED;
-#ifdef CONFIG_NETFILTER_DEBUG
-		/* Packet path as if nothing had happened. */
-		skb->nf_debug = olddebug;
-#endif
 	}
-
         return skb;
 }
 

----Next_Part(Thu_Jun_30_10:31:17_2005_977)----
