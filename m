From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 8/9]: Fix invalid tcp/udp checksums within NATed icmp
 errors
Date: Mon, 15 Nov 2004 22:45:29 +0100
Message-ID: <41992379.2070904@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020605040209030209090007"
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
--------------020605040209030209090007
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Fix invalid tcp/udp checksums within NATed icmp errors.
The IP used for checksum adjustment is always the address
of the outer IP header.



--------------020605040209030209090007
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/13 17:01:15+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix invalid tcp/udp checksums within NATed icmp errors
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_proto_unknown.c
#   2004/11/13 17:01:07+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix invalid tcp/udp checksums within NATed icmp errors
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_proto_udp.c
#   2004/11/13 17:01:07+01:00 kaber@coreworks.de +5 -3
#   [NETFILTER]: Fix invalid tcp/udp checksums within NATed icmp errors
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_proto_tcp.c
#   2004/11/13 17:01:07+01:00 kaber@coreworks.de +5 -3
#   [NETFILTER]: Fix invalid tcp/udp checksums within NATed icmp errors
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_proto_icmp.c
#   2004/11/13 17:01:07+01:00 kaber@coreworks.de +3 -1
#   [NETFILTER]: Fix invalid tcp/udp checksums within NATed icmp errors
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/11/13 17:01:07+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix invalid tcp/udp checksums within NATed icmp errors
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_nat_protocol.h
#   2004/11/13 17:01:07+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix invalid tcp/udp checksums within NATed icmp errors
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_nat_protocol.h b/include/linux/netfilter_ipv4/ip_nat_protocol.h
--- a/include/linux/netfilter_ipv4/ip_nat_protocol.h	2004-11-15 22:07:44 +01:00
+++ b/include/linux/netfilter_ipv4/ip_nat_protocol.h	2004-11-15 22:07:44 +01:00
@@ -18,7 +18,7 @@
 	/* Do a packet translation according to the ip_nat_proto_manip
 	 * and manip type.  Return true if succeeded. */
 	int (*manip_pkt)(struct sk_buff **pskb,
-			 unsigned int hdroff,
+			 unsigned int iphdroff,
 			 const struct ip_conntrack_manip *manip,
 			 enum ip_nat_manip_type maniptype);
 
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-11-15 22:07:44 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-11-15 22:07:44 +01:00
@@ -687,7 +687,7 @@
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	/* Manipulate protcol part. */
-	if (!ip_nat_find_proto(proto)->manip_pkt(pskb, iphdroff + iph->ihl*4,
+	if (!ip_nat_find_proto(proto)->manip_pkt(pskb, iphdroff,
 	                                         manip, maniptype))
 		return 0;
 
diff -Nru a/net/ipv4/netfilter/ip_nat_proto_icmp.c b/net/ipv4/netfilter/ip_nat_proto_icmp.c
--- a/net/ipv4/netfilter/ip_nat_proto_icmp.c	2004-11-15 22:07:44 +01:00
+++ b/net/ipv4/netfilter/ip_nat_proto_icmp.c	2004-11-15 22:07:44 +01:00
@@ -53,11 +53,13 @@
 
 static int
 icmp_manip_pkt(struct sk_buff **pskb,
-	       unsigned int hdroff,
+	       unsigned int iphdroff,
 	       const struct ip_conntrack_manip *manip,
 	       enum ip_nat_manip_type maniptype)
 {
+	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
 	struct icmphdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl*4;
 
 	if (!skb_ip_make_writable(pskb, hdroff + sizeof(*hdr)))
 		return 0;
diff -Nru a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c	2004-11-15 22:07:44 +01:00
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c	2004-11-15 22:07:44 +01:00
@@ -84,11 +84,13 @@
 
 static int
 tcp_manip_pkt(struct sk_buff **pskb,
-	      unsigned int hdroff,
+	      unsigned int iphdroff,
 	      const struct ip_conntrack_manip *manip,
 	      enum ip_nat_manip_type maniptype)
 {
+	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
 	struct tcphdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl*4;
 	u_int32_t oldip;
 	u_int16_t *portptr, oldport;
 	int hdrsize = 8; /* TCP connection tracking guarantees this much */
@@ -106,11 +108,11 @@
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
-		oldip = (*pskb)->nh.iph->saddr;
+		oldip = iph->saddr;
 		portptr = &hdr->source;
 	} else {
 		/* Get rid of dst ip and dst pt */
-		oldip = (*pskb)->nh.iph->daddr;
+		oldip = iph->daddr;
 		portptr = &hdr->dest;
 	}
 
diff -Nru a/net/ipv4/netfilter/ip_nat_proto_udp.c b/net/ipv4/netfilter/ip_nat_proto_udp.c
--- a/net/ipv4/netfilter/ip_nat_proto_udp.c	2004-11-15 22:07:44 +01:00
+++ b/net/ipv4/netfilter/ip_nat_proto_udp.c	2004-11-15 22:07:44 +01:00
@@ -83,11 +83,13 @@
 
 static int
 udp_manip_pkt(struct sk_buff **pskb,
-	      unsigned int hdroff,
+	      unsigned int iphdroff,
 	      const struct ip_conntrack_manip *manip,
 	      enum ip_nat_manip_type maniptype)
 {
+	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
 	struct udphdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl*4;
 	u_int32_t oldip;
 	u_int16_t *portptr;
 
@@ -97,11 +99,11 @@
 	hdr = (void *)(*pskb)->data + hdroff;
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
-		oldip = (*pskb)->nh.iph->saddr;
+		oldip = iph->saddr;
 		portptr = &hdr->source;
 	} else {
 		/* Get rid of dst ip and dst pt */
-		oldip = (*pskb)->nh.iph->daddr;
+		oldip = iph->daddr;
 		portptr = &hdr->dest;
 	}
 	if (hdr->check) /* 0 is a special case meaning no checksum */
diff -Nru a/net/ipv4/netfilter/ip_nat_proto_unknown.c b/net/ipv4/netfilter/ip_nat_proto_unknown.c
--- a/net/ipv4/netfilter/ip_nat_proto_unknown.c	2004-11-15 22:07:44 +01:00
+++ b/net/ipv4/netfilter/ip_nat_proto_unknown.c	2004-11-15 22:07:44 +01:00
@@ -39,7 +39,7 @@
 
 static int
 unknown_manip_pkt(struct sk_buff **pskb,
-		  unsigned int hdroff,
+		  unsigned int iphdroff,
 		  const struct ip_conntrack_manip *manip,
 		  enum ip_nat_manip_type maniptype)
 {

--------------020605040209030209090007--
