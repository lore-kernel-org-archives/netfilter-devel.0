From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: C99 initizalizers for NAT protocols
Date: Sat, 23 Jul 2005 07:59:08 +0200
Message-ID: <42E1DCAC.605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010900030100030903030401"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------010900030100030903030401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Applies on top of the unresolved symbols patch.


--------------010900030100030903030401
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: C99 initizalizers for NAT protocols

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a6b1cad65cc50bf64093ed442004e0851d41c8dd
tree 53b5845cf12b63270c041a3678e58ccc44865055
parent f6a24a992ce129888cd3137a90689edf8c859aef
author Patrick McHardy <kaber@trash.net> Sat, 23 Jul 2005 07:58:26 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 23 Jul 2005 07:58:26 +0200

 net/ipv4/netfilter/ip_nat_proto_icmp.c    |   20 +++++++++++---------
 net/ipv4/netfilter/ip_nat_proto_tcp.c     |   20 +++++++++++---------
 net/ipv4/netfilter/ip_nat_proto_udp.c     |   20 +++++++++++---------
 net/ipv4/netfilter/ip_nat_proto_unknown.c |   13 +++++++------
 4 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_proto_icmp.c b/net/ipv4/netfilter/ip_nat_proto_icmp.c
--- a/net/ipv4/netfilter/ip_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_icmp.c
@@ -105,16 +105,18 @@ icmp_print_range(char *buffer, const str
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_icmp
-= { "ICMP", IPPROTO_ICMP, THIS_MODULE,
-    icmp_manip_pkt,
-    icmp_in_range,
-    icmp_unique_tuple,
-    icmp_print,
-    icmp_print_range,
+struct ip_nat_protocol ip_nat_protocol_icmp = {
+	.name			= "ICMP",
+	.protonum		= IPPROTO_ICMP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= icmp_manip_pkt,
+	.in_range		= icmp_in_range,
+	.unique_tuple		= icmp_unique_tuple,
+	.print			= icmp_print,
+	.print_range		= icmp_print_range,
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
-    ip_nat_port_range_to_nfattr,
-    ip_nat_port_nfattr_to_range,
+	.range_to_nfattr	= ip_nat_port_range_to_nfattr,
+	.nfattr_to_range	= ip_nat_port_nfattr_to_range,
 #endif
 };
diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
@@ -169,16 +169,18 @@ tcp_print_range(char *buffer, const stru
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_tcp
-= { "TCP", IPPROTO_TCP, THIS_MODULE,
-    tcp_manip_pkt,
-    tcp_in_range,
-    tcp_unique_tuple,
-    tcp_print,
-    tcp_print_range,
+struct ip_nat_protocol ip_nat_protocol_tcp = {
+	.name			= "TCP",
+	.protonum		= IPPROTO_TCP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= tcp_manip_pkt,
+	.in_range		= tcp_in_range,
+	.unique_tuple		= tcp_unique_tuple,
+	.print			= tcp_print,
+	.print_range		= tcp_print_range,
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
-    ip_nat_port_range_to_nfattr,
-    ip_nat_port_nfattr_to_range,
+	.range_to_nfattr	= ip_nat_port_range_to_nfattr,
+	.nfattr_to_range	= ip_nat_port_nfattr_to_range,
 #endif
 };
diff --git a/net/ipv4/netfilter/ip_nat_proto_udp.c b/net/ipv4/netfilter/ip_nat_proto_udp.c
--- a/net/ipv4/netfilter/ip_nat_proto_udp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_udp.c
@@ -155,16 +155,18 @@ udp_print_range(char *buffer, const stru
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_udp
-= { "UDP", IPPROTO_UDP, THIS_MODULE,
-    udp_manip_pkt,
-    udp_in_range,
-    udp_unique_tuple,
-    udp_print,
-    udp_print_range,
+struct ip_nat_protocol ip_nat_protocol_udp = {
+	.name			= "UDP",
+	.protonum		= IPPROTO_UDP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= udp_manip_pkt,
+	.in_range		= udp_in_range,
+	.unique_tuple		= udp_unique_tuple,
+	.print			= udp_print,
+	.print_range		= udp_print_range,
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
-    ip_nat_port_range_to_nfattr,
-    ip_nat_port_nfattr_to_range,
+	.range_to_nfattr	= ip_nat_port_range_to_nfattr,
+	.nfattr_to_range	= ip_nat_port_nfattr_to_range,
 #endif
 };
diff --git a/net/ipv4/netfilter/ip_nat_proto_unknown.c b/net/ipv4/netfilter/ip_nat_proto_unknown.c
--- a/net/ipv4/netfilter/ip_nat_proto_unknown.c
+++ b/net/ipv4/netfilter/ip_nat_proto_unknown.c
@@ -61,10 +61,11 @@ unknown_print_range(char *buffer, const 
 }
 
 struct ip_nat_protocol ip_nat_unknown_protocol = {
-	"unknown", 0, THIS_MODULE,
-	unknown_manip_pkt,
-	unknown_in_range,
-	unknown_unique_tuple,
-	unknown_print,
-	unknown_print_range
+	.name			= "unknown",
+	.me			= THIS_MODULE,
+	.manip_pkt		= unknown_manip_pkt,
+	.in_range		= unknown_in_range,
+	.unique_tuple		= unknown_unique_tuple,
+	.print			= unknown_print,
+	.print_range		= unknown_print_range
 };

--------------010900030100030903030401--
