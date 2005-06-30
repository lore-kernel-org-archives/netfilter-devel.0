From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH: NF_CONNTRACK 6/6] Avoid unncessary UDP checksum validation
Date: Thu, 30 Jun 2005 10:31:44 +0900 (JST)
Message-ID: <200506300131.j5U1Vj34029455@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jun_30_10:31:44_2005_958)--"
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

----Next_Part(Thu_Jun_30_10:31:44_2005_958)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
        [NETFILTER]: Avoid unncessary checksum validation in UDP connection tracking


        Signed-off-by: Keir Fraser <Keir.Fraser@xl.cam.ac.uk>
        Signed-off-by: Patrick McHardy <kaber@trash.net>
        Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Jun_30_10:31:44_2005_958)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="06-udp-csum.patch"

Index: net/netfilter/nf_conntrack_proto_udp.c
===================================================================
--- f871f52dbc341242903410f69bff6c850e4471c4/net/netfilter/nf_conntrack_proto_udp.c  (mode:100644)
+++ 8f5349238592a31f661053760dff7db8d6ca79fe/net/netfilter/nf_conntrack_proto_udp.c  (mode:100644)
@@ -134,6 +134,7 @@
 	 * FIXME: Source route IP option packets --RR */
 	if (((pf == PF_INET && hooknum == NF_IP_PRE_ROUTING) ||
 	     (pf == PF_INET6 && hooknum == NF_IP6_PRE_ROUTING))
+	    && skb->ip_summed != CHECKSUM_UNNECESSARY
 	    && csum(skb, dataoff)) {
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(pf, 0, skb, NULL, NULL,

----Next_Part(Thu_Jun_30_10:31:44_2005_958)----
