From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Thu, 17 Jun 2004 19:26:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D1D441.2000504@eurodev.net>
References: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu> <40D18A0B.2070101@eurodev.net> <40D19288.3010103@trash.net> <40D1A0D2.10705@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040208010406010909040307"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40D1A0D2.10705@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040208010406010909040307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Attached an extra patch which apply on top of my current 
protocol-helper-error patch. It performs some checking for invalid UDP 
and ICMP packets. Am I missing anything?

BTW, It also adds C99 initialization. I also modified the structure of 
error_icmp to handle in a different way special icmp messages.

Jozsef, should we define a variable called ip_ct_log_invalid for all the 
protocols or one per protocol? I mean:

+int ip_ct_icmp_log_invalid = 1;

and we should also put this definition in somewhere since other protocol 
helpers could use net_ratelimit.

+#if 0
+#define NET_RATELIMIT(foo)     (foo)
+#else
+#define NET_RATELIMIT(foo)     ((foo) && net_ratelimit())
+#endif

regards,
Pablo

--------------040208010406010909040307
Content-Type: text/x-patch;
 name="unclean-icmp-udp-packets.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="unclean-icmp-udp-packets.patch"

diff -u -r1.2 ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	17 Jun 2004 13:54:41 -0000	1.2
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	17 Jun 2004 17:08:39 -0000
@@ -13,11 +13,20 @@
 #include <linux/in.h>
 #include <linux/icmp.h>
 #include <net/ip.h>
+#include <asm/checksum.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
 unsigned long ip_ct_icmp_timeout = 30*HZ;
 
+/* FIXME: unify with Jozsef's tcp window tracking patch? */
+int ip_ct_icmp_log_invalid = 1;
+#if 0
+#define NET_RATELIMIT(foo)     (foo)
+#else
+#define NET_RATELIMIT(foo)     ((foo) && net_ratelimit())
+#endif
+
 #if 0
 #define DEBUGP printk
 #else
@@ -125,9 +134,8 @@
 }
 
 static int
-icmp_error(struct sk_buff *skb,
-		 enum ip_conntrack_info *ctinfo,
-		 unsigned int hooknum)
+track_error_message(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+		    unsigned int hooknum)
 {
 	struct ip_conntrack_tuple innertuple, origtuple;
 	struct {
@@ -144,13 +152,6 @@
 	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
 		return NF_ACCEPT;
 
-	if (inside.icmp.type != ICMP_DEST_UNREACH
-	    && inside.icmp.type != ICMP_SOURCE_QUENCH
-	    && inside.icmp.type != ICMP_TIME_EXCEEDED
-	    && inside.icmp.type != ICMP_PARAMETERPROB
-	    && inside.icmp.type != ICMP_REDIRECT)
-		return NF_ACCEPT;
-
 	/* Ignore ICMP's containing fragments (shouldn't happen) */
 	if (inside.ip.frag_off & htons(IP_OFFSET)) {
 		DEBUGP("icmp_error_track: fragment of proto %u\n",
@@ -200,7 +201,64 @@
 	return -NF_ACCEPT;
 }
 
-struct ip_conntrack_protocol ip_conntrack_protocol_icmp
-= { { NULL, NULL }, IPPROTO_ICMP, "icmp",
-    icmp_pkt_to_tuple, icmp_invert_tuple, icmp_print_tuple,
-    icmp_print_conntrack, icmp_packet, icmp_new, NULL, NULL, icmp_error, NULL};
+/* Small and modified version of icmp_rcv */
+static int
+icmp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+	   unsigned int hooknum)
+{
+	struct icmphdr *icmph = skb->h.icmph;
+
+	/* ICMP header is too small! */
+	if (skb->len < 4)
+		return -NF_ACCEPT;
+	
+	switch (skb->ip_summed) {
+	case CHECKSUM_HW:
+		if (!(u16)csum_fold(skb->csum)) 
+			break;
+		if (NET_RATELIMIT(ip_ct_icmp_log_invalid))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
+				      "ip_ct_icmp: bad HW ICMP checksum ");
+	case CHECKSUM_NONE:
+		if ((u16)csum_fold(skb_checksum(skb, 0, skb->len, 0))) {
+			if (NET_RATELIMIT(ip_ct_icmp_log_invalid)) {
+				nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
+					      "ip_ct_udp: bad ICMP checksum ");
+			}
+			return -NF_ACCEPT;
+		}
+	default:;
+	}
+
+	/*
+	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
+	 *
+	 *	RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
+	 *		  discarded.
+	 */
+	if (icmph->type > NR_ICMP_TYPES)
+		return -NF_ACCEPT;
+
+	/* Need to track icmp error message? */
+	if (icmph->type != ICMP_DEST_UNREACH
+	    && icmph->type != ICMP_SOURCE_QUENCH
+	    && icmph->type != ICMP_TIME_EXCEEDED
+	    && icmph->type != ICMP_PARAMETERPROB
+	    && icmph->type != ICMP_REDIRECT)
+		return NF_ACCEPT;
+
+	return(track_error_message(skb, ctinfo, hooknum));
+}
+
+struct ip_conntrack_protocol ip_conntrack_protocol_icmp =
+{
+	.proto 			= IPPROTO_ICMP, 
+	.name 			= "icmp",
+	.pkt_to_tuple 		= icmp_pkt_to_tuple,
+	.invert_tuple		= icmp_invert_tuple,
+	.print_tuple 		= icmp_print_tuple,
+	.print_conntrack 	= icmp_print_conntrack,
+	.packet 		= icmp_packet,
+	.new 			= icmp_new,
+	.error 			= icmp_error,
+};
diff -u -r1.2 ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	17 Jun 2004 13:54:41 -0000	1.2
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	17 Jun 2004 17:22:18 -0000
@@ -12,11 +12,20 @@
 #include <linux/netfilter.h>
 #include <linux/in.h>
 #include <linux/udp.h>
+#include <asm/checksum.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
 unsigned long ip_ct_udp_timeout = 30*HZ;
 unsigned long ip_ct_udp_timeout_stream = 180*HZ;
 
+/* FIXME: unify with Jozsef's tcp window tracking patch? */
+int ip_ct_udp_log_invalid = 1;
+#if 0
+#define NET_RATELIMIT(foo)     (foo)
+#else
+#define NET_RATELIMIT(foo)     ((foo) && net_ratelimit())
+#endif
+
 static int udp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
 			     struct ip_conntrack_tuple *tuple)
@@ -80,7 +89,52 @@
 	return 1;
 }
 
-struct ip_conntrack_protocol ip_conntrack_protocol_udp
-= { { NULL, NULL }, IPPROTO_UDP, "udp",
-    udp_pkt_to_tuple, udp_invert_tuple, udp_print_tuple, udp_print_conntrack,
-    udp_packet, udp_new, NULL, NULL, NULL, NULL };
+static int udp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+		     unsigned int hooknum)
+{
+	struct iphdr *iph = skb->nh.iph;
+	unsigned int udplen = skb->len - iph->ihl * 4;
+	struct udphdr hdr;
+
+	/* Header is too small? */
+	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &hdr, 8) != 0)
+		return -NF_ACCEPT;
+
+	/* Length field must be >= 8 */
+	if (hdr.len < 8)
+		return -NF_ACCEPT;
+	
+	/* Packet with no checksum */
+	if (!hdr.check)
+		return NF_ACCEPT;
+
+	/* Checksum invalid? Ignore.
+	 * We skip checking packets on the outgoing path
+	 * because the semantic of CHECKSUM_HW is different there 
+	 * and moreover root might send raw packets.
+	 * FIXME: Source route IP option packets --RR */
+	if (hooknum == NF_IP_PRE_ROUTING
+	    && csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
+			         skb->ip_summed == CHECKSUM_HW ? skb->csum
+			      	 : skb_checksum(skb, iph->ihl*4, udplen, 0))) {
+		if (NET_RATELIMIT(ip_ct_udp_log_invalid))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
+				  "ip_ct_udp: bad UDP checksum ");
+		return -NF_ACCEPT;
+	}
+	
+	return NF_ACCEPT;
+}
+
+struct ip_conntrack_protocol ip_conntrack_protocol_udp =
+{
+	.proto 			= IPPROTO_UDP,
+	.name			= "udp",
+	.pkt_to_tuple		= udp_pkt_to_tuple,
+	.invert_tuple		= udp_invert_tuple,
+	.print_tuple		= udp_print_tuple,
+	.print_conntrack	= udp_print_conntrack,
+	.packet			= udp_packet,
+	.new			= udp_new,
+	.error			= udp_error,
+};

--------------040208010406010909040307--
