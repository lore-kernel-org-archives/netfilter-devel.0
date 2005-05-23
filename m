From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/9]: Prevent NAT from seeing fragments
Date: Mon, 23 May 2005 15:18:41 +0900 (JST)
Message-ID: <200505230618.j4N6IgCo016460@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:18:42_2005_135)--"
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

----Next_Part(Mon_May_23_15:18:42_2005_135)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch follows the recent changes to ip_conntrack.
Please note that this codes are deleted by patch [5/9].

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

===========

    [NETFILTER]: Prevent NAT from seeing fragments

    The path for loopback is:
    LOCAL_OUT: conntrack defrags
    POST_ROUTING: conntrack refrags
    PRE_ROUTING: skip conntrack defrag because skb->nfct != NULL
    PRE_ROUTING: NAT gets hit by fragments

    Always defrag on loopback if NAT is compiled in.

    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Acked-by: Rusty Russel <rusty@rustcorp.com.au>
    Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_15:18:42_2005_135)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-nat-frag.patch"

diff -Nur linux-2.6.12-rc4-nfct-1-tcp-window/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c linux-2.6.12-rc4-nfct-2-nat-frag/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.12-rc4-nfct-1-tcp-window/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-05-11 16:31:15.000000000 +0900
+++ linux-2.6.12-rc4-nfct-2-nat-frag/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-05-19 13:38:08.000000000 +0900
@@ -180,10 +180,12 @@
 					  const struct net_device *out,
 					  int (*okfn)(struct sk_buff *))
 {
+#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
 	/* Previously seen (loopback)?  Ignore.  Do this before
 	   fragment check. */
 	if ((*pskb)->nfct)
 		return NF_ACCEPT;
+#endif
 
 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {

----Next_Part(Mon_May_23_15:18:42_2005_135)----
