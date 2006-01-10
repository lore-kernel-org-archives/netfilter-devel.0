From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/05]: Remove unused function from NAT protocol helpers
Date: Tue, 10 Jan 2006 01:38:43 +0100
Message-ID: <20060110003843.9105.17212.sendpatchset@localhost.localdomain>
References: <20060110003838.9105.8158.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060110003838.9105.8158.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Remove unused function from NAT protocol helpers

->print and ->print_range are not used (and apparently never were).

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2d7be102c6e62236562415d7beacd790cc6504f4
tree e77e60cd6294f94e1ad3bd7f99aafcee18b28750
parent 80996cd784ba8851c0cf72ace29f410446d079e0
author Patrick McHardy <kaber@trash.net> Sun, 08 Jan 2006 06:42:07 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 08 Jan 2006 06:42:07 +0100

 include/linux/netfilter_ipv4/ip_nat_protocol.h |    7 ----
 net/ipv4/netfilter/ip_nat_proto_gre.c          |   38 ------------------------
 net/ipv4/netfilter/ip_nat_proto_icmp.c         |   34 ---------------------
 net/ipv4/netfilter/ip_nat_proto_tcp.c          |   36 -----------------------
 net/ipv4/netfilter/ip_nat_proto_udp.c          |   36 -----------------------
 net/ipv4/netfilter/ip_nat_proto_unknown.c      |   16 ----------
 6 files changed, 0 insertions(+), 167 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_nat_protocol.h b/include/linux/netfilter_ipv4/ip_nat_protocol.h
index ef63aa9..612a436 100644
--- a/include/linux/netfilter_ipv4/ip_nat_protocol.h
+++ b/include/linux/netfilter_ipv4/ip_nat_protocol.h
@@ -42,13 +42,6 @@ struct ip_nat_protocol
 			    enum ip_nat_manip_type maniptype,
 			    const struct ip_conntrack *conntrack);
 
-	unsigned int (*print)(char *buffer,
-			      const struct ip_conntrack_tuple *match,
-			      const struct ip_conntrack_tuple *mask);
-
-	unsigned int (*print_range)(char *buffer,
-				    const struct ip_nat_range *range);
-
 	int (*range_to_nfattr)(struct sk_buff *skb,
 			       const struct ip_nat_range *range);
 
diff --git a/net/ipv4/netfilter/ip_nat_proto_gre.c b/net/ipv4/netfilter/ip_nat_proto_gre.c
index f7cad7c..6c4899d 100644
--- a/net/ipv4/netfilter/ip_nat_proto_gre.c
+++ b/net/ipv4/netfilter/ip_nat_proto_gre.c
@@ -151,42 +151,6 @@ gre_manip_pkt(struct sk_buff **pskb,
 	return 1;
 }
 
-/* print out a nat tuple */
-static unsigned int 
-gre_print(char *buffer, 
-	  const struct ip_conntrack_tuple *match,
-	  const struct ip_conntrack_tuple *mask)
-{
-	unsigned int len = 0;
-
-	if (mask->src.u.gre.key)
-		len += sprintf(buffer + len, "srckey=0x%x ", 
-				ntohl(match->src.u.gre.key));
-
-	if (mask->dst.u.gre.key)
-		len += sprintf(buffer + len, "dstkey=0x%x ",
-				ntohl(match->src.u.gre.key));
-
-	return len;
-}
-
-/* print a range of keys */
-static unsigned int 
-gre_print_range(char *buffer, const struct ip_nat_range *range)
-{
-	if (range->min.gre.key != 0 
-	    || range->max.gre.key != 0xFFFF) {
-		if (range->min.gre.key == range->max.gre.key)
-			return sprintf(buffer, "key 0x%x ",
-					ntohl(range->min.gre.key));
-		else
-			return sprintf(buffer, "keys 0x%u-0x%u ",
-					ntohl(range->min.gre.key),
-					ntohl(range->max.gre.key));
-	} else
-		return 0;
-}
-
 /* nat helper struct */
 static struct ip_nat_protocol gre = { 
 	.name		= "GRE", 
@@ -194,8 +158,6 @@ static struct ip_nat_protocol gre = { 
 	.manip_pkt	= gre_manip_pkt,
 	.in_range	= gre_in_range,
 	.unique_tuple	= gre_unique_tuple,
-	.print		= gre_print,
-	.print_range	= gre_print_range,
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.range_to_nfattr	= ip_nat_port_range_to_nfattr,
diff --git a/net/ipv4/netfilter/ip_nat_proto_icmp.c b/net/ipv4/netfilter/ip_nat_proto_icmp.c
index 9387190..31a3f4c 100644
--- a/net/ipv4/netfilter/ip_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_icmp.c
@@ -74,38 +74,6 @@ icmp_manip_pkt(struct sk_buff **pskb,
 	return 1;
 }
 
-static unsigned int
-icmp_print(char *buffer,
-	   const struct ip_conntrack_tuple *match,
-	   const struct ip_conntrack_tuple *mask)
-{
-	unsigned int len = 0;
-
-	if (mask->src.u.icmp.id)
-		len += sprintf(buffer + len, "id=%u ",
-			       ntohs(match->src.u.icmp.id));
-
-	if (mask->dst.u.icmp.type)
-		len += sprintf(buffer + len, "type=%u ",
-			       ntohs(match->dst.u.icmp.type));
-
-	if (mask->dst.u.icmp.code)
-		len += sprintf(buffer + len, "code=%u ",
-			       ntohs(match->dst.u.icmp.code));
-
-	return len;
-}
-
-static unsigned int
-icmp_print_range(char *buffer, const struct ip_nat_range *range)
-{
-	if (range->min.icmp.id != 0 || range->max.icmp.id != 0xFFFF)
-		return sprintf(buffer, "id %u-%u ",
-			       ntohs(range->min.icmp.id),
-			       ntohs(range->max.icmp.id));
-	else return 0;
-}
-
 struct ip_nat_protocol ip_nat_protocol_icmp = {
 	.name			= "ICMP",
 	.protonum		= IPPROTO_ICMP,
@@ -113,8 +81,6 @@ struct ip_nat_protocol ip_nat_protocol_i
 	.manip_pkt		= icmp_manip_pkt,
 	.in_range		= icmp_in_range,
 	.unique_tuple		= icmp_unique_tuple,
-	.print			= icmp_print,
-	.print_range		= icmp_print_range,
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.range_to_nfattr	= ip_nat_port_range_to_nfattr,
diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
index 1d381bf..a3d1407 100644
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
@@ -136,40 +136,6 @@ tcp_manip_pkt(struct sk_buff **pskb,
 	return 1;
 }
 
-static unsigned int
-tcp_print(char *buffer,
-	  const struct ip_conntrack_tuple *match,
-	  const struct ip_conntrack_tuple *mask)
-{
-	unsigned int len = 0;
-
-	if (mask->src.u.tcp.port)
-		len += sprintf(buffer + len, "srcpt=%u ",
-			       ntohs(match->src.u.tcp.port));
-
-
-	if (mask->dst.u.tcp.port)
-		len += sprintf(buffer + len, "dstpt=%u ",
-			       ntohs(match->dst.u.tcp.port));
-
-	return len;
-}
-
-static unsigned int
-tcp_print_range(char *buffer, const struct ip_nat_range *range)
-{
-	if (range->min.tcp.port != 0 || range->max.tcp.port != 0xFFFF) {
-		if (range->min.tcp.port == range->max.tcp.port)
-			return sprintf(buffer, "port %u ",
-				       ntohs(range->min.tcp.port));
-		else
-			return sprintf(buffer, "ports %u-%u ",
-				       ntohs(range->min.tcp.port),
-				       ntohs(range->max.tcp.port));
-	}
-	else return 0;
-}
-
 struct ip_nat_protocol ip_nat_protocol_tcp = {
 	.name			= "TCP",
 	.protonum		= IPPROTO_TCP,
@@ -177,8 +143,6 @@ struct ip_nat_protocol ip_nat_protocol_t
 	.manip_pkt		= tcp_manip_pkt,
 	.in_range		= tcp_in_range,
 	.unique_tuple		= tcp_unique_tuple,
-	.print			= tcp_print,
-	.print_range		= tcp_print_range,
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.range_to_nfattr	= ip_nat_port_range_to_nfattr,
diff --git a/net/ipv4/netfilter/ip_nat_proto_udp.c b/net/ipv4/netfilter/ip_nat_proto_udp.c
index c4906e1..ec6053f 100644
--- a/net/ipv4/netfilter/ip_nat_proto_udp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_udp.c
@@ -122,40 +122,6 @@ udp_manip_pkt(struct sk_buff **pskb,
 	return 1;
 }
 
-static unsigned int
-udp_print(char *buffer,
-	  const struct ip_conntrack_tuple *match,
-	  const struct ip_conntrack_tuple *mask)
-{
-	unsigned int len = 0;
-
-	if (mask->src.u.udp.port)
-		len += sprintf(buffer + len, "srcpt=%u ",
-			       ntohs(match->src.u.udp.port));
-
-
-	if (mask->dst.u.udp.port)
-		len += sprintf(buffer + len, "dstpt=%u ",
-			       ntohs(match->dst.u.udp.port));
-
-	return len;
-}
-
-static unsigned int
-udp_print_range(char *buffer, const struct ip_nat_range *range)
-{
-	if (range->min.udp.port != 0 || range->max.udp.port != 0xFFFF) {
-		if (range->min.udp.port == range->max.udp.port)
-			return sprintf(buffer, "port %u ",
-				       ntohs(range->min.udp.port));
-		else
-			return sprintf(buffer, "ports %u-%u ",
-				       ntohs(range->min.udp.port),
-				       ntohs(range->max.udp.port));
-	}
-	else return 0;
-}
-
 struct ip_nat_protocol ip_nat_protocol_udp = {
 	.name			= "UDP",
 	.protonum		= IPPROTO_UDP,
@@ -163,8 +129,6 @@ struct ip_nat_protocol ip_nat_protocol_u
 	.manip_pkt		= udp_manip_pkt,
 	.in_range		= udp_in_range,
 	.unique_tuple		= udp_unique_tuple,
-	.print			= udp_print,
-	.print_range		= udp_print_range,
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.range_to_nfattr	= ip_nat_port_range_to_nfattr,
diff --git a/net/ipv4/netfilter/ip_nat_proto_unknown.c b/net/ipv4/netfilter/ip_nat_proto_unknown.c
index f0099a6..3bf0495 100644
--- a/net/ipv4/netfilter/ip_nat_proto_unknown.c
+++ b/net/ipv4/netfilter/ip_nat_proto_unknown.c
@@ -46,26 +46,10 @@ unknown_manip_pkt(struct sk_buff **pskb,
 	return 1;
 }
 
-static unsigned int
-unknown_print(char *buffer,
-	      const struct ip_conntrack_tuple *match,
-	      const struct ip_conntrack_tuple *mask)
-{
-	return 0;
-}
-
-static unsigned int
-unknown_print_range(char *buffer, const struct ip_nat_range *range)
-{
-	return 0;
-}
-
 struct ip_nat_protocol ip_nat_unknown_protocol = {
 	.name			= "unknown",
 	/* .me isn't set: getting a ref to this cannot fail. */
 	.manip_pkt		= unknown_manip_pkt,
 	.in_range		= unknown_in_range,
 	.unique_tuple		= unknown_unique_tuple,
-	.print			= unknown_print,
-	.print_range		= unknown_print_range
 };
