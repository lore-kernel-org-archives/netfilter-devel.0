From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 5/8] [NETFILTER]: Use bool type in nf_nat_proto
Date: Tue,  8 Apr 2008 16:17:34 +0200
Message-ID: <2c53bdac5644e1bba8f663f011834b1fbf735d09.1207664141.git.jengelh@computergmbh.de>
References: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59949 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYDHORk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:17:40 -0400
In-Reply-To: <1207664257-1927-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <67629b27a77644a6643e252580a9f77663191831.1207664141.git.jengelh@computergmbh.de>
References: <67629b27a77644a6643e252580a9f77663191831.1207664141.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/net/netfilter/nf_nat_protocol.h   |   42 ++++++++++----------
 net/ipv4/netfilter/nf_nat_core.c          |    8 ++--
 net/ipv4/netfilter/nf_nat_proto_common.c  |   10 ++--
 net/ipv4/netfilter/nf_nat_proto_dccp.c    |   10 ++--
 net/ipv4/netfilter/nf_nat_proto_gre.c     |   18 ++++----
 net/ipv4/netfilter/nf_nat_proto_icmp.c    |   14 +++---
 net/ipv4/netfilter/nf_nat_proto_sctp.c    |    8 ++--
 net/ipv4/netfilter/nf_nat_proto_tcp.c     |   10 ++--
 net/ipv4/netfilter/nf_nat_proto_udp.c     |    8 ++--
 net/ipv4/netfilter/nf_nat_proto_udplite.c |    8 ++--
 net/ipv4/netfilter/nf_nat_proto_unknown.c |   24 ++++++------
 11 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
index df3d9df..272b169 100644
--- a/include/net/netfilter/nf_nat_protocol.h
+++ b/include/net/netfilter/nf_nat_protocol.h
@@ -15,25 +15,25 @@ struct nf_nat_protocol
 
 	/* Translate a packet to the target according to manip type.
 	   Return true if succeeded. */
-	int (*manip_pkt)(struct sk_buff *skb,
-			 unsigned int iphdroff,
-			 const struct nf_conntrack_tuple *tuple,
-			 enum nf_nat_manip_type maniptype);
+	bool (*manip_pkt)(struct sk_buff *skb,
+			  unsigned int iphdroff,
+			  const struct nf_conntrack_tuple *tuple,
+			  enum nf_nat_manip_type maniptype);
 
 	/* Is the manipable part of the tuple between min and max incl? */
-	int (*in_range)(const struct nf_conntrack_tuple *tuple,
-			enum nf_nat_manip_type maniptype,
-			const union nf_conntrack_man_proto *min,
-			const union nf_conntrack_man_proto *max);
+	bool (*in_range)(const struct nf_conntrack_tuple *tuple,
+			 enum nf_nat_manip_type maniptype,
+			 const union nf_conntrack_man_proto *min,
+			 const union nf_conntrack_man_proto *max);
 
 	/* Alter the per-proto part of the tuple (depending on
 	   maniptype), to give a unique tuple in the given range if
 	   possible; return false if not.  Per-protocol part of tuple
 	   is initialized to the incoming packet. */
-	int (*unique_tuple)(struct nf_conntrack_tuple *tuple,
-			    const struct nf_nat_range *range,
-			    enum nf_nat_manip_type maniptype,
-			    const struct nf_conn *ct);
+	bool (*unique_tuple)(struct nf_conntrack_tuple *tuple,
+			     const struct nf_nat_range *range,
+			     enum nf_nat_manip_type maniptype,
+			     const struct nf_conn *ct);
 
 	int (*range_to_nlattr)(struct sk_buff *skb,
 			       const struct nf_nat_range *range);
@@ -59,16 +59,16 @@ extern int init_protocols(void) __init;
 extern void cleanup_protocols(void);
 extern const struct nf_nat_protocol *find_nat_proto(u_int16_t protonum);
 
-extern int nf_nat_proto_in_range(const struct nf_conntrack_tuple *tuple,
-				 enum nf_nat_manip_type maniptype,
-				 const union nf_conntrack_man_proto *min,
-				 const union nf_conntrack_man_proto *max);
+extern bool nf_nat_proto_in_range(const struct nf_conntrack_tuple *tuple,
+				  enum nf_nat_manip_type maniptype,
+				  const union nf_conntrack_man_proto *min,
+				  const union nf_conntrack_man_proto *max);
 
-extern int nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
-				     const struct nf_nat_range *range,
-				     enum nf_nat_manip_type maniptype,
-				     const struct nf_conn *ct,
-				     u_int16_t *rover);
+extern bool nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
+				      const struct nf_nat_range *range,
+				      enum nf_nat_manip_type maniptype,
+				      const struct nf_conn *ct,
+				      u_int16_t *rover);
 
 extern int nf_nat_port_range_to_nlattr(struct sk_buff *skb,
 				       const struct nf_nat_range *range);
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 9c8aa8d..d49444f 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -349,7 +349,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 EXPORT_SYMBOL(nf_nat_setup_info);
 
 /* Returns true if succeeded. */
-static int
+static bool
 manip_pkt(u_int16_t proto,
 	  struct sk_buff *skb,
 	  unsigned int iphdroff,
@@ -360,7 +360,7 @@ manip_pkt(u_int16_t proto,
 	const struct nf_nat_protocol *p;
 
 	if (!skb_make_writable(skb, iphdroff + sizeof(*iph)))
-		return 0;
+		return false;
 
 	iph = (void *)skb->data + iphdroff;
 
@@ -369,7 +369,7 @@ manip_pkt(u_int16_t proto,
 	/* rcu_read_lock()ed by nf_hook_slow */
 	p = __nf_nat_proto_find(proto);
 	if (!p->manip_pkt(skb, iphdroff, target, maniptype))
-		return 0;
+		return false;
 
 	iph = (void *)skb->data + iphdroff;
 
@@ -380,7 +380,7 @@ manip_pkt(u_int16_t proto,
 		csum_replace4(&iph->check, iph->daddr, target->dst.u3.ip);
 		iph->daddr = target->dst.u3.ip;
 	}
-	return 1;
+	return true;
 }
 
 /* Do packet manipulations according to nf_nat_setup_info. */
diff --git a/net/ipv4/netfilter/nf_nat_proto_common.c b/net/ipv4/netfilter/nf_nat_proto_common.c
index 7f56f6b..962eab8 100644
--- a/net/ipv4/netfilter/nf_nat_proto_common.c
+++ b/net/ipv4/netfilter/nf_nat_proto_common.c
@@ -17,7 +17,7 @@
 #include <net/netfilter/nf_nat_rule.h>
 #include <net/netfilter/nf_nat_protocol.h>
 
-int
+bool
 nf_nat_proto_in_range(const struct nf_conntrack_tuple *tuple,
 		      enum nf_nat_manip_type maniptype,
 		      const union nf_conntrack_man_proto *min,
@@ -35,7 +35,7 @@ nf_nat_proto_in_range(const struct nf_conntrack_tuple *tuple,
 }
 EXPORT_SYMBOL_GPL(nf_nat_proto_in_range);
 
-int
+bool
 nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 			  const struct nf_nat_range *range,
 			  enum nf_nat_manip_type maniptype,
@@ -54,7 +54,7 @@ nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
 		/* If it's dst rewrite, can't change port */
 		if (maniptype == IP_NAT_MANIP_DST)
-			return 0;
+			return false;
 
 		if (ntohs(*portptr) < 1024) {
 			/* Loose convention: >> 512 is credential passing */
@@ -80,8 +80,8 @@ nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	for (i = 0; i < range_size; i++, (*rover)++) {
 		*portptr = htons(min + *rover % range_size);
 		if (!nf_nat_used_tuple(tuple, ct))
-			return 1;
+			return true;
 	}
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_GPL(nf_nat_proto_unique_tuple);
diff --git a/net/ipv4/netfilter/nf_nat_proto_dccp.c b/net/ipv4/netfilter/nf_nat_proto_dccp.c
index caf4b19..d4b43ac 100644
--- a/net/ipv4/netfilter/nf_nat_proto_dccp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_dccp.c
@@ -22,7 +22,7 @@
 
 static u_int16_t dccp_port_rover;
 
-static int
+static bool
 dccp_unique_tuple(struct nf_conntrack_tuple *tuple,
 		  const struct nf_nat_range *range,
 		  enum nf_nat_manip_type maniptype,
@@ -32,7 +32,7 @@ dccp_unique_tuple(struct nf_conntrack_tuple *tuple,
 					 &dccp_port_rover);
 }
 
-static int
+static bool
 dccp_manip_pkt(struct sk_buff *skb,
 	       unsigned int iphdroff,
 	       const struct nf_conntrack_tuple *tuple,
@@ -49,7 +49,7 @@ dccp_manip_pkt(struct sk_buff *skb,
 		hdrsize = sizeof(struct dccp_hdr);
 
 	if (!skb_make_writable(skb, hdroff + hdrsize))
-		return 0;
+		return false;
 
 	iph = (struct iphdr *)(skb->data + iphdroff);
 	hdr = (struct dccp_hdr *)(skb->data + hdroff);
@@ -70,12 +70,12 @@ dccp_manip_pkt(struct sk_buff *skb,
 	*portptr = newport;
 
 	if (hdrsize < sizeof(*hdr))
-		return 1;
+		return true;
 
 	inet_proto_csum_replace4(&hdr->dccph_checksum, skb, oldip, newip, 1);
 	inet_proto_csum_replace2(&hdr->dccph_checksum, skb, oldport, newport,
 				 0);
-	return 1;
+	return true;
 }
 
 static const struct nf_nat_protocol nf_nat_protocol_dccp = {
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index e5025d6..3b5ec55 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -37,7 +37,7 @@ MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");
 
 /* generate unique tuple ... */
-static int
+static bool
 gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_nat_range *range,
 		 enum nf_nat_manip_type maniptype,
@@ -50,7 +50,7 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 	/* If there is no master conntrack we are not PPTP,
 	   do not change tuples */
 	if (!ct->master)
-		return 0;
+		return false;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
 		keyptr = &tuple->src.u.gre.key;
@@ -71,15 +71,15 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 	for (i = 0; i < range_size; i++, key++) {
 		*keyptr = htons(min + key % range_size);
 		if (!nf_nat_used_tuple(tuple, ct))
-			return 1;
+			return true;
 	}
 
 	pr_debug("%p: no NAT mapping\n", ct);
-	return 0;
+	return false;
 }
 
 /* manipulate a GRE packet according to maniptype */
-static int
+static bool
 gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 	      const struct nf_conntrack_tuple *tuple,
 	      enum nf_nat_manip_type maniptype)
@@ -92,7 +92,7 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 	/* pgreh includes two optional 32bit fields which are not required
 	 * to be there.  That's where the magic '8' comes from */
 	if (!skb_make_writable(skb, hdroff + sizeof(*pgreh) - 8))
-		return 0;
+		return false;
 
 	greh = (void *)skb->data + hdroff;
 	pgreh = (struct gre_hdr_pptp *)greh;
@@ -100,7 +100,7 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 	/* we only have destination manip of a packet, since 'source key'
 	 * is not present in the packet itself */
 	if (maniptype != IP_NAT_MANIP_DST)
-		return 1;
+		return true;
 	switch (greh->version) {
 	case GRE_VERSION_1701:
 		/* We do not currently NAT any GREv0 packets.
@@ -112,9 +112,9 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 		break;
 	default:
 		pr_debug("can't nat unknown GRE version\n");
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
 }
 
 static const struct nf_nat_protocol gre = {
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 197f42d..9c2dbd0 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -17,7 +17,7 @@
 #include <net/netfilter/nf_nat_rule.h>
 #include <net/netfilter/nf_nat_protocol.h>
 
-static int
+static bool
 icmp_in_range(const struct nf_conntrack_tuple *tuple,
 	      enum nf_nat_manip_type maniptype,
 	      const union nf_conntrack_man_proto *min,
@@ -27,7 +27,7 @@ icmp_in_range(const struct nf_conntrack_tuple *tuple,
 	       ntohs(tuple->src.u.icmp.id) <= ntohs(max->icmp.id);
 }
 
-static int
+static bool
 icmp_unique_tuple(struct nf_conntrack_tuple *tuple,
 		  const struct nf_nat_range *range,
 		  enum nf_nat_manip_type maniptype,
@@ -46,12 +46,12 @@ icmp_unique_tuple(struct nf_conntrack_tuple *tuple,
 		tuple->src.u.icmp.id = htons(ntohs(range->min.icmp.id) +
 					     (id % range_size));
 		if (!nf_nat_used_tuple(tuple, ct))
-			return 1;
+			return true;
 	}
-	return 0;
+	return false;
 }
 
-static int
+static bool
 icmp_manip_pkt(struct sk_buff *skb,
 	       unsigned int iphdroff,
 	       const struct nf_conntrack_tuple *tuple,
@@ -62,13 +62,13 @@ icmp_manip_pkt(struct sk_buff *skb,
 	unsigned int hdroff = iphdroff + iph->ihl*4;
 
 	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return 0;
+		return false;
 
 	hdr = (struct icmphdr *)(skb->data + hdroff);
 	inet_proto_csum_replace2(&hdr->checksum, skb,
 				 hdr->un.echo.id, tuple->src.u.icmp.id, 0);
 	hdr->un.echo.id = tuple->src.u.icmp.id;
-	return 1;
+	return true;
 }
 
 const struct nf_nat_protocol nf_nat_protocol_icmp = {
diff --git a/net/ipv4/netfilter/nf_nat_proto_sctp.c b/net/ipv4/netfilter/nf_nat_proto_sctp.c
index de0df3e..12accde 100644
--- a/net/ipv4/netfilter/nf_nat_proto_sctp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_sctp.c
@@ -16,7 +16,7 @@
 
 static u_int16_t nf_sctp_port_rover;
 
-static int
+static bool
 sctp_unique_tuple(struct nf_conntrack_tuple *tuple,
 		  const struct nf_nat_range *range,
 		  enum nf_nat_manip_type maniptype,
@@ -26,7 +26,7 @@ sctp_unique_tuple(struct nf_conntrack_tuple *tuple,
 					 &nf_sctp_port_rover);
 }
 
-static int
+static bool
 sctp_manip_pkt(struct sk_buff *skb,
 	       unsigned int iphdroff,
 	       const struct nf_conntrack_tuple *tuple,
@@ -39,7 +39,7 @@ sctp_manip_pkt(struct sk_buff *skb,
 	u32 crc32;
 
 	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return 0;
+		return false;
 
 	iph = (struct iphdr *)(skb->data + iphdroff);
 	hdr = (struct sctphdr *)(skb->data + hdroff);
@@ -63,7 +63,7 @@ sctp_manip_pkt(struct sk_buff *skb,
 	crc32 = sctp_end_cksum(crc32);
 	hdr->checksum = htonl(crc32);
 
-	return 1;
+	return true;
 }
 
 static const struct nf_nat_protocol nf_nat_protocol_sctp = {
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index 0933f72..22b839d 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -20,7 +20,7 @@
 
 static u_int16_t tcp_port_rover;
 
-static int
+static bool
 tcp_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_nat_range *range,
 		 enum nf_nat_manip_type maniptype,
@@ -30,7 +30,7 @@ tcp_unique_tuple(struct nf_conntrack_tuple *tuple,
 					 &tcp_port_rover);
 }
 
-static int
+static bool
 tcp_manip_pkt(struct sk_buff *skb,
 	      unsigned int iphdroff,
 	      const struct nf_conntrack_tuple *tuple,
@@ -50,7 +50,7 @@ tcp_manip_pkt(struct sk_buff *skb,
 		hdrsize = sizeof(struct tcphdr);
 
 	if (!skb_make_writable(skb, hdroff + hdrsize))
-		return 0;
+		return false;
 
 	iph = (struct iphdr *)(skb->data + iphdroff);
 	hdr = (struct tcphdr *)(skb->data + hdroff);
@@ -73,11 +73,11 @@ tcp_manip_pkt(struct sk_buff *skb,
 	*portptr = newport;
 
 	if (hdrsize < sizeof(*hdr))
-		return 1;
+		return true;
 
 	inet_proto_csum_replace4(&hdr->check, skb, oldip, newip, 1);
 	inet_proto_csum_replace2(&hdr->check, skb, oldport, newport, 0);
-	return 1;
+	return true;
 }
 
 const struct nf_nat_protocol nf_nat_protocol_tcp = {
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index d0c930f..7cf8f35 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -19,7 +19,7 @@
 
 static u_int16_t udp_port_rover;
 
-static int
+static bool
 udp_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_nat_range *range,
 		 enum nf_nat_manip_type maniptype,
@@ -29,7 +29,7 @@ udp_unique_tuple(struct nf_conntrack_tuple *tuple,
 					 &udp_port_rover);
 }
 
-static int
+static bool
 udp_manip_pkt(struct sk_buff *skb,
 	      unsigned int iphdroff,
 	      const struct nf_conntrack_tuple *tuple,
@@ -42,7 +42,7 @@ udp_manip_pkt(struct sk_buff *skb,
 	__be16 *portptr, newport;
 
 	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return 0;
+		return false;
 
 	iph = (struct iphdr *)(skb->data + iphdroff);
 	hdr = (struct udphdr *)(skb->data + hdroff);
@@ -68,7 +68,7 @@ udp_manip_pkt(struct sk_buff *skb,
 			hdr->check = CSUM_MANGLED_0;
 	}
 	*portptr = newport;
-	return 1;
+	return true;
 }
 
 const struct nf_nat_protocol nf_nat_protocol_udp = {
diff --git a/net/ipv4/netfilter/nf_nat_proto_udplite.c b/net/ipv4/netfilter/nf_nat_proto_udplite.c
index f4997a4..9a8b864 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udplite.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udplite.c
@@ -18,7 +18,7 @@
 
 static u_int16_t udplite_port_rover;
 
-static int
+static bool
 udplite_unique_tuple(struct nf_conntrack_tuple *tuple,
 		     const struct nf_nat_range *range,
 		     enum nf_nat_manip_type maniptype,
@@ -28,7 +28,7 @@ udplite_unique_tuple(struct nf_conntrack_tuple *tuple,
 					 &udplite_port_rover);
 }
 
-static int
+static bool
 udplite_manip_pkt(struct sk_buff *skb,
 		  unsigned int iphdroff,
 		  const struct nf_conntrack_tuple *tuple,
@@ -41,7 +41,7 @@ udplite_manip_pkt(struct sk_buff *skb,
 	__be16 *portptr, newport;
 
 	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
-		return 0;
+		return false;
 
 	iph = (struct iphdr *)(skb->data + iphdroff);
 	hdr = (struct udphdr *)(skb->data + hdroff);
@@ -66,7 +66,7 @@ udplite_manip_pkt(struct sk_buff *skb,
 		hdr->check = CSUM_MANGLED_0;
 
 	*portptr = newport;
-	return 1;
+	return true;
 }
 
 static const struct nf_nat_protocol nf_nat_protocol_udplite = {
diff --git a/net/ipv4/netfilter/nf_nat_proto_unknown.c b/net/ipv4/netfilter/nf_nat_proto_unknown.c
index cda21ff..14381c6 100644
--- a/net/ipv4/netfilter/nf_nat_proto_unknown.c
+++ b/net/ipv4/netfilter/nf_nat_proto_unknown.c
@@ -18,31 +18,31 @@
 #include <net/netfilter/nf_nat_rule.h>
 #include <net/netfilter/nf_nat_protocol.h>
 
-static int unknown_in_range(const struct nf_conntrack_tuple *tuple,
-			    enum nf_nat_manip_type manip_type,
-			    const union nf_conntrack_man_proto *min,
-			    const union nf_conntrack_man_proto *max)
+static bool unknown_in_range(const struct nf_conntrack_tuple *tuple,
+			     enum nf_nat_manip_type manip_type,
+			     const union nf_conntrack_man_proto *min,
+			     const union nf_conntrack_man_proto *max)
 {
-	return 1;
+	return true;
 }
 
-static int unknown_unique_tuple(struct nf_conntrack_tuple *tuple,
-				const struct nf_nat_range *range,
-				enum nf_nat_manip_type maniptype,
-				const struct nf_conn *ct)
+static bool unknown_unique_tuple(struct nf_conntrack_tuple *tuple,
+				 const struct nf_nat_range *range,
+				 enum nf_nat_manip_type maniptype,
+				 const struct nf_conn *ct)
 {
 	/* Sorry: we can't help you; if it's not unique, we can't frob
 	   anything. */
-	return 0;
+	return false;
 }
 
-static int
+static bool
 unknown_manip_pkt(struct sk_buff *skb,
 		  unsigned int iphdroff,
 		  const struct nf_conntrack_tuple *tuple,
 		  enum nf_nat_manip_type maniptype)
 {
-	return 1;
+	return true;
 }
 
 const struct nf_nat_protocol nf_nat_unknown_protocol = {
-- 
1.5.5.rc3

