From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/5]: Use correct byteorder in ICMP NAT
Date: Fri, 22 Jul 2005 09:35:57 +0200
Message-ID: <42E0A1DD.2070900@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="04.diff"
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
commit d778c0e9a5c2aa805b7c297b5712efb9c1ada2c6
tree 852cbf03161a4a0d4453cc820a630a8dcf5c0181
parent dd51c6e4ab8df9819d686b0a88a6d7ec8b3d2b28
author Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:24:04 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:24:04 +0200

 net/ipv4/netfilter/ip_nat_proto_icmp.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_proto_icmp.c b/net/ipv4/netfilter/ip_nat_proto_icmp.c
--- a/net/ipv4/netfilter/ip_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_icmp.c
@@ -35,16 +35,17 @@ icmp_unique_tuple(struct ip_conntrack_tu
 		  const struct ip_conntrack *conntrack)
 {
 	static u_int16_t id;
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
