From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 2/2] use C99 structure initialization in nat helpers
Date: Mon, 07 Mar 2005 00:34:57 +0100
Message-ID: <422B93A1.8020200@eurodev.net>
References: <422B8716.9010804@eurodev.net> <422B8E46.30908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010900090406060900070304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <422B8E46.30908@trash.net>
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
--------------010900090406060900070304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Thanks, but it doesn't apply without the previous patch. Hint: Send
> cleanups first in a series of patches :)

ACK, thanks patrick, attached the new patch.

--
Pablo

--------------010900090406060900070304
Content-Type: text/x-patch;
 name="c99.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="c99.patch"

===== net/ipv4/netfilter/ip_nat_proto_icmp.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ip_nat_proto_icmp.c	2005-01-17 23:00:55 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_icmp.c	2005-03-07 00:31:35 +01:00
@@ -105,11 +105,12 @@
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_icmp
-= { "ICMP", IPPROTO_ICMP,
-    icmp_manip_pkt,
-    icmp_in_range,
-    icmp_unique_tuple,
-    icmp_print,
-    icmp_print_range
+struct ip_nat_protocol ip_nat_protocol_icmp = {
+	.name		= "ICMP",
+	.protonum	= IPPROTO_ICMP,
+	.manip_pkt	= icmp_manip_pkt,
+	.in_range	= icmp_in_range,
+	.unique_tuple	= icmp_unique_tuple,
+	.print		= icmp_print,
+	.print_range	= icmp_print_range
 };
===== net/ipv4/netfilter/ip_nat_proto_tcp.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-01-31 07:21:51 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-03-07 00:29:17 +01:00
@@ -168,11 +168,12 @@
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_tcp
-= { "TCP", IPPROTO_TCP,
-    tcp_manip_pkt,
-    tcp_in_range,
-    tcp_unique_tuple,
-    tcp_print,
-    tcp_print_range
+struct ip_nat_protocol ip_nat_protocol_tcp = {
+	.name		= "TCP",
+	.protonum	= IPPROTO_TCP,
+	.manip_pkt	= tcp_manip_pkt,
+	.in_range	= tcp_in_range,
+	.unique_tuple	= tcp_unique_tuple,
+	.print		= tcp_print,
+	.print_range	= tcp_print_range
 };
===== net/ipv4/netfilter/ip_nat_proto_udp.c 1.9 vs edited =====
--- 1.9/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-01-17 23:00:55 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-03-07 00:30:06 +01:00
@@ -155,11 +155,12 @@
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_udp
-= { "UDP", IPPROTO_UDP,
-    udp_manip_pkt,
-    udp_in_range,
-    udp_unique_tuple,
-    udp_print,
-    udp_print_range
+struct ip_nat_protocol ip_nat_protocol_udp = {
+	.name		= "UDP",
+	.protonum	= IPPROTO_UDP,
+	.manip_pkt	= udp_manip_pkt,
+	.in_range	= udp_in_range,
+	.unique_tuple	= udp_unique_tuple,
+	.print		= udp_print,
+	.print_range	= udp_print_range
 };
===== net/ipv4/netfilter/ip_nat_proto_unknown.c 1.7 vs edited =====
--- 1.7/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-01-17 23:00:55 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-03-07 00:30:49 +01:00
@@ -61,10 +61,11 @@
 }
 
 struct ip_nat_protocol ip_nat_unknown_protocol = {
-	"unknown", 0,
-	unknown_manip_pkt,
-	unknown_in_range,
-	unknown_unique_tuple,
-	unknown_print,
-	unknown_print_range
+	.name		= "unknown", 
+	.protonum	= 0,
+	.manip_pkt	= unknown_manip_pkt,
+	.in_range	= unknown_in_range,
+	.unique_tuple	= unknown_unique_tuple,
+	.print		= unknown_print,
+	.print_range	= unknown_print_range
 };

--------------010900090406060900070304--
