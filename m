From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 6/7]: Avoid unncessary checksum validation in UDP
 connection tracking
Date: Tue, 21 Jun 2005 01:04:25 +0200
Message-ID: <42B74B79.3040807@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="06.diff"
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

[NETFILTER]: Avoid unncessary checksum validation in UDP connection tracking

Signed-off-by: Keir Fraser <Keir.Fraser@xl.cam.ac.uk>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f324916223389c944e50fa8b2c514bacf3f460c5
tree e67258b81c73684aa0cfc8117243b9c0b303324f
parent 2976a51fd8ab66770b1b3083ffaa41bd05d70e1e
author Keir Fraser <Keir.Fraser@xl.cam.ac.uk> Mon, 20 Jun 2005 18:52:00
committer Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:52:00

 net/ipv4/netfilter/ip_conntrack_proto_udp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
@@ -120,6 +120,7 @@ static int udp_error(struct sk_buff *skb
 	 * and moreover root might send raw packets.
 	 * FIXME: Source route IP option packets --RR */
 	if (hooknum == NF_IP_PRE_ROUTING
+	    && skb->ip_summed != CHECKSUM_UNNECESSARY
 	    && csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
 			         skb->ip_summed == CHECKSUM_HW ? skb->csum
 			      	 : skb_checksum(skb, iph->ihl*4, udplen, 0))) {
