From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/2] use C99 structure initialization in nat helpers
Date: Sun, 06 Mar 2005 23:41:26 +0100
Message-ID: <422B8716.9010804@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090605010005060805090600"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------090605010005060805090600
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch makes nat helpers use c99 structure initialization. It 
applies on top of the previous patch.

--
Pablo

--------------090605010005060805090600
Content-Type: text/x-patch;
 name="c99-nat-proto.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="c99-nat-proto.patch"

Use C99 structure initialization for nat protocols.
Status: trivial
Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

 ip_nat_proto_icmp.c    |   16 ++++++++--------
 ip_nat_proto_tcp.c     |   17 +++++++++--------
 ip_nat_proto_udp.c     |   16 ++++++++--------
 ip_nat_proto_unknown.c |   14 +++++++-------
 4 files changed, 32 insertions(+), 31 deletions(-)
 
--- linux-2.5/net/ipv4/netfilter/ip_nat_proto_tcp.c.orig	2005-02-26 20:35:55.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-02-26 20:38:26.000000000 +0100
@@ -317,12 +317,13 @@ tcp_seq_adjust(struct sk_buff **pskb, 
 	return 1;
 }
 
-struct ip_nat_protocol ip_nat_protocol_tcp
-= { "TCP", IPPROTO_TCP,
-    tcp_manip_pkt,
-    tcp_in_range,
-    tcp_unique_tuple,
-    tcp_print,
-    tcp_print_range,
-    tcp_seq_adjust
+struct ip_nat_protocol ip_nat_protocol_tcp = {
+	.name		= "TCP",
+	.protonum	= IPPROTO_TCP,
+	.manip_pkt	= tcp_manip_pkt,
+	.in_range	= tcp_in_range,
+	.unique_tuple	= tcp_unique_tuple,
+	.print		= tcp_print,
+	.print_range	= tcp_print_range,
+	.adjust		= tcp_seq_adjust
 };
--- linux-2.5/net/ipv4/netfilter/ip_nat_proto_udp.c.orig	2005-02-26 20:36:03.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-02-26 20:39:41.000000000 +0100
@@ -155,12 +155,12 @@ udp_print_range(char *buffer, const stru
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_udp
-= { "UDP", IPPROTO_UDP,
-    udp_manip_pkt,
-    udp_in_range,
-    udp_unique_tuple,
-    udp_print,
-    udp_print_range,
-    NULL
+struct ip_nat_protocol ip_nat_protocol_udp = {
+	.name		= "UDP",
+	.protonum	= IPPROTO_UDP,
+	.manip_pkt	= udp_manip_pkt,
+	.in_range	= udp_in_range,
+	.unique_tuple	= udp_unique_tuple,
+	.print		= udp_print,
+	.print_range	= udp_print_range
 };
--- linux-2.5/net/ipv4/netfilter/ip_nat_proto_icmp.c.orig	2005-02-26 20:35:45.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/ip_nat_proto_icmp.c	2005-02-26 20:38:32.000000000 +0100
@@ -105,12 +105,12 @@ icmp_print_range(char *buffer, const str
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_icmp
-= { "ICMP", IPPROTO_ICMP,
-    icmp_manip_pkt,
-    icmp_in_range,
-    icmp_unique_tuple,
-    icmp_print,
-    icmp_print_range,
-    NULL
+struct ip_nat_protocol ip_nat_protocol_icmp = {
+	.name		= "ICMP",
+	.protonum	= IPPROTO_ICMP,
+	.manip_pkt	= icmp_manip_pkt,
+	.in_range	= icmp_in_range,
+	.unique_tuple	= icmp_unique_tuple,
+	.print		= icmp_print,
+	.print_range	= icmp_print_range
 };
--- linux-2.5/net/ipv4/netfilter/ip_nat_proto_unknown.c.orig	2005-02-26 20:36:14.000000000 +0100
+++ linux-2.5/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-02-26 20:41:15.000000000 +0100
@@ -61,11 +61,11 @@ unknown_print_range(char *buffer, const 
 }
 
 struct ip_nat_protocol ip_nat_unknown_protocol = {
-	"unknown", 0,
-	unknown_manip_pkt,
-	unknown_in_range,
-	unknown_unique_tuple,
-	unknown_print,
-	unknown_print_range,
-	NULL
+	.name		= "unknown",
+	.protonum	= 0,
+	.manip_pkt	= unknown_manip_pkt,
+	.in_range	= unknown_in_range,
+	.unique_tuple	= unknown_unique_tuple,
+	.print		= unknown_print,
+	.print_range	= unknown_print_range
 };

--------------090605010005060805090600--
