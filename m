From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4 6/6]: Use correct byteorder in ICMP NAT
Date: Mon, 01 Aug 2005 02:42:37 +0200
Message-ID: <42ED6FFD.5040501@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="6.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="6.diff"
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

[NETFILTER]: Use correct byteorder in ICMP NAT

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3ffc46afa170d4ffa61f28785bad485c3a3ce922
tree 45782dfbf13dc5700f19ce25df1e827f5f4f8993
parent b3db926712f01d98e672510bdb69b940e09880eb
author Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 20:28:17 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 20:28:17 +0200

 net/ipv4/netfilter/ip_nat_proto_icmp.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_proto_icmp.c b/net/ipv4/netfilter/ip_nat_proto_icmp.c
--- a/net/ipv4/netfilter/ip_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_icmp.c
@@ -26,16 +26,17 @@ icmp_unique_tuple(struct ip_conntrack_tu
 		  const struct ip_conntrack *conntrack)
 {
 	static u_int16_t id = 0;
-	unsigned int range_size
-		= (unsigned int)range->max.icmp.id - range->min.icmp.id + 1;
+	unsigned int range_size;
 	unsigned int i;
 
+	range_size = ntohs(range->max.icmp.id) - ntohs(range->min.icmp.id) + 1;
 	/* If no range specified... */
 	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED))
 		range_size = 0xFFFF;
 
 	for (i = 0; i < range_size; i++, id++) {
-		tuple->src.u.icmp.id = range->min.icmp.id + (id % range_size);
+		tuple->src.u.icmp.id = htons(ntohs(range->min.icmp.id) +
+		                             (id % range_size));
 		if (!ip_nat_used_tuple(tuple, conntrack))
 			return 1;
 	}
