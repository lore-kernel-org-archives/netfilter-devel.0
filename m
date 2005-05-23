From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 5/9]: Drop conntrack reference when packet
 leaves IP
Date: Mon, 23 May 2005 15:19:15 +0900 (JST)
Message-ID: <200505230619.j4N6JFeg029650@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:19:15_2005_123)--"
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

----Next_Part(Mon_May_23_15:19:15_2005_123)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

===========

    [NETFILTER]: Drop conntrack reference when packet leaves IP

    In the event a raw socket is created for sending purposes only, the creator
    never bothers to check the socket's receive queue.  But we continue to
    add skbs to its queue until it fills up.

    Unfortunately, if ip_conntrack is loaded on the box, each skb we add to the
    queue potentially holds a reference to a conntrack.  If the user attempts
    to unload ip_conntrack, we will spin around forever since the queued skbs
    are pinned.

    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_15:19:15_2005_123)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="05-drop-ref.patch"

diff -Nur linux-2.6.12-rc4-nfct-4-tcp-psh/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.12-rc4-nfct-4-tcp-psh/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-05-19 14:21:20.000000000 +0900
+++ linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-05-19 20:46:13.000000000 +0900
@@ -180,13 +180,6 @@
 					  const struct net_device *out,
 					  int (*okfn)(struct sk_buff *))
 {
-#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
-	/* Previously seen (loopback)?  Ignore.  Do this before
-	   fragment check. */
-	if ((*pskb)->nfct)
-		return NF_ACCEPT;
-#endif
-
 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
 		*pskb = nf_ct_ipv4_gather_frags(*pskb,

----Next_Part(Mon_May_23_15:19:15_2005_123)----
