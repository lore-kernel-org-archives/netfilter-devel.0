From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 3/9]: Don't checksum CHECKSUM_UNNECESSARY skbs
 in TCP connection tracking
Date: Mon, 23 May 2005 15:18:52 +0900 (JST)
Message-ID: <200505230618.j4N6Iq8u016636@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:18:52_2005_776)--"
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

----Next_Part(Mon_May_23_15:18:52_2005_776)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

===========

    [NETFILTER]: Don't checksum CHECKSUM_UNNECESSARY skbs in TCP connection tracking

    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_15:18:52_2005_776)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-tcp-csum.patch"

diff -Nur linux-2.6.12-rc4-nfct-2-nat-frag/net/netfilter/nf_conntrack_proto_tcp.c linux-2.6.12-rc4-nfct-3-tcp-csum/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-2.6.12-rc4-nfct-2-nat-frag/net/netfilter/nf_conntrack_proto_tcp.c	2005-05-19 13:53:37.000000000 +0900
+++ linux-2.6.12-rc4-nfct-3-tcp-csum/net/netfilter/nf_conntrack_proto_tcp.c	2005-05-19 14:18:44.000000000 +0900
@@ -828,8 +828,9 @@
 	 */
 	/* FIXME: Source route IP option packets --RR */
 	if (((pf == PF_INET && hooknum == NF_IP_PRE_ROUTING) ||
-	     (pf == PF_INET6 && hooknum  == NF_IP6_PRE_ROUTING)) &&
-	    csum(skb, dataoff)) {
+	     (pf == PF_INET6 && hooknum  == NF_IP6_PRE_ROUTING))
+	    && skb->ip_summed != CHECKSUM_UNNECESSARY
+	    && csum(skb, dataoff)) {
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, 
 				  "nf_ct_tcp: bad TCP checksum ");

----Next_Part(Mon_May_23_15:18:52_2005_776)----
