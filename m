From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] ip_nat_seq_adjust in a l4 protocol helper
Date: Thu, 05 Aug 2004 15:34:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41123773.8020004@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000403020904010605000104"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Patrick McHardy <kaber@trash.net>, Harald Welte <laforge@gnumonks.org>
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
--------------000403020904010605000104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

 From ip_nat_core.c. Rusty says:
-                       /* future: put this in a l4-proto specific function,
-                        * and call this function here. */
-                       if (!ip_nat_seq_adjust(pskb, ct, ctinfo)

A hamster that claims to be Rusty's pet came to visit me, after he had 
some beers and got bored. So he decided to put ip_nat_seq_adjust in a 
l4-proto nat helper.

regards,
Pablo

--------------000403020904010605000104
Content-Type: text/x-patch;
 name="nat-l4adjust.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nat-l4adjust.patch"

diff -u -r1.1.1.1 ip_nat_core.h
--- a/include/linux/netfilter_ipv4/ip_nat_core.h	4 Aug 2004 15:14:39 -0000	1.1.1.1
+++ b/include/linux/netfilter_ipv4/ip_nat_core.h	5 Aug 2004 08:55:28 -0000
@@ -26,6 +26,10 @@
 extern void place_in_hashes(struct ip_conntrack *conntrack,
 			    struct ip_nat_info *info);
 
+extern u_int16_t
+ip_nat_cheat_check(u_int32_t oldvalinv, u_int32_t newval, 
+		   u_int16_t oldcheck);
+
 /* Built-in protocols. */
 extern struct ip_nat_protocol ip_nat_protocol_tcp;
 extern struct ip_nat_protocol ip_nat_protocol_udp;
diff -u -r1.1.1.1 ip_nat_protocol.h
--- a/include/linux/netfilter_ipv4/ip_nat_protocol.h	4 Aug 2004 15:14:39 -0000	1.1.1.1
+++ b/include/linux/netfilter_ipv4/ip_nat_protocol.h	5 Aug 2004 08:55:28 -0000
@@ -45,6 +45,9 @@
 
 	unsigned int (*print_range)(char *buffer,
 				    const struct ip_nat_range *range);
+
+	unsigned int (*adjust)(struct sk_buff **pskb, struct ip_conntrack *ct,
+			       enum ip_conntrack_info ctinfo, int hooknum);
 };
 
 /* Protocol registration. */
diff -u -r1.2 ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	4 Aug 2004 15:26:55 -0000	1.2
+++ b/net/ipv4/netfilter/ip_nat_core.c	5 Aug 2004 08:56:13 -0000
@@ -709,7 +709,7 @@
 
 /* Returns true if succeeded. */
 static int
-manip_pkt(u_int16_t proto,
+manip_pkt(struct ip_nat_protocol *protocol,
 	  struct sk_buff **pskb,
 	  unsigned int iphdroff,
 	  const struct ip_conntrack_manip *manip,
@@ -724,9 +724,7 @@
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	/* Manipulate protcol part. */
-	if (!find_nat_proto(proto)->manip_pkt(pskb,
-					      iphdroff + iph->ihl*4,
-					      manip, maniptype))
+	if (!protocol->manip_pkt(pskb, iphdroff + iph->ihl*4, manip, maniptype))
 		return 0;
 
 	iph = (void *)(*pskb)->data + iphdroff;
@@ -769,6 +767,9 @@
 	struct ip_nat_helper *helper;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	int proto = (*pskb)->nh.iph->protocol;
+	struct ip_nat_protocol *protocol;
+
+	protocol = find_nat_proto(proto);
 
 	/* Need nat lock to protect against modification, but neither
 	   conntrack (referenced) and helper (deleted with
@@ -783,7 +784,7 @@
 			       ? "SRC" : "DST",
 			       NIPQUAD(info->manips[i].manip.ip),
 			       htons(info->manips[i].manip.u.all));
-			if (!manip_pkt(proto, pskb, 0,
+			if (!manip_pkt(protocol, pskb, 0,
 				       &info->manips[i].manip,
 				       info->manips[i].maniptype)) {
 				READ_UNLOCK(&ip_nat_lock);
@@ -844,13 +845,9 @@
 		
 		/* Adjust sequence number only once per packet 
 		 * (helper is called at all hooks) */
-		if (proto == IPPROTO_TCP
-		    && (hooknum == NF_IP_POST_ROUTING
-			|| hooknum == NF_IP_LOCAL_IN)) {
+		if (protocol->adjust != NULL) {
 			DEBUGP("ip_nat_core: adjusting sequence number\n");
-			/* future: put this in a l4-proto specific function,
-			 * and call this function here. */
-			if (!ip_nat_seq_adjust(pskb, ct, ctinfo))
+			if (!protocol->adjust(pskb, ct, ctinfo, hooknum))
 				ret = NF_DROP;
 		}
 
@@ -935,12 +932,15 @@
 		   where we would normally apply a dst manip, we apply
 		   a src, and vice versa. */
 		if (info->manips[i].hooknum == hooknum) {
+			struct ip_nat_protocol *proto;
+			proto = find_nat_proto(inside->ip.protocol);
+			
 			DEBUGP("icmp_reply: inner %s -> %u.%u.%u.%u %u\n",
 			       info->manips[i].maniptype == IP_NAT_MANIP_SRC
 			       ? "DST" : "SRC",
 			       NIPQUAD(info->manips[i].manip.ip),
 			       ntohs(info->manips[i].manip.u.udp.port));
-			if (!manip_pkt(inside->ip.protocol, pskb,
+			if (!manip_pkt(proto, pskb,
 				       (*pskb)->nh.iph->ihl*4
 				       + sizeof(inside->icmp),
 				       &info->manips[i].manip,
@@ -950,13 +950,13 @@
 			/* Outer packet needs to have IP header NATed like
 	                   it's a reply. */
 
-			/* Use mapping to map outer packet: 0 give no
-                           per-proto mapping */
+			/* Use mapping to map outer packet: 
+			 * unknown_nat_protocol, no per-proto mapping */
 			DEBUGP("icmp_reply: outer %s -> %u.%u.%u.%u\n",
 			       info->manips[i].maniptype == IP_NAT_MANIP_SRC
 			       ? "SRC" : "DST",
 			       NIPQUAD(info->manips[i].manip.ip));
-			if (!manip_pkt(0, pskb, 0,
+			if (!manip_pkt(&unknown_nat_protocol, pskb, 0,
 				       &info->manips[i].manip,
 				       info->manips[i].maniptype))
 				goto unlock_fail;
diff -u -r1.2 ip_nat_helper.c
--- a/net/ipv4/netfilter/ip_nat_helper.c	4 Aug 2004 15:26:55 -0000	1.2
+++ b/net/ipv4/netfilter/ip_nat_helper.c	5 Aug 2004 08:55:28 -0000
@@ -256,149 +256,6 @@
 	return 1;
 }
 
-/* Adjust one found SACK option including checksum correction */
-static void
-sack_adjust(struct sk_buff *skb,
-	    struct tcphdr *tcph, 
-	    unsigned int sackoff,
-	    unsigned int sackend,
-	    struct ip_nat_seq *natseq)
-{
-	while (sackoff < sackend) {
-		struct tcp_sack_block *sack;
-		u_int32_t new_start_seq, new_end_seq;
-
-		sack = (void *)skb->data + sackoff;
-		if (after(ntohl(sack->start_seq) - natseq->offset_before,
-			  natseq->correction_pos))
-			new_start_seq = ntohl(sack->start_seq) 
-					- natseq->offset_after;
-		else
-			new_start_seq = ntohl(sack->start_seq) 
-					- natseq->offset_before;
-		new_start_seq = htonl(new_start_seq);
-
-		if (after(ntohl(sack->end_seq) - natseq->offset_before,
-			  natseq->correction_pos))
-			new_end_seq = ntohl(sack->end_seq)
-				      - natseq->offset_after;
-		else
-			new_end_seq = ntohl(sack->end_seq)
-				      - natseq->offset_before;
-		new_end_seq = htonl(new_end_seq);
-
-		DEBUGP("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
-			ntohl(sack->start_seq), new_start_seq,
-			ntohl(sack->end_seq), new_end_seq);
-
-		tcph->check = 
-			ip_nat_cheat_check(~sack->start_seq, new_start_seq,
-					   ip_nat_cheat_check(~sack->end_seq, 
-						   	      new_end_seq,
-							      tcph->check));
-		sack->start_seq = new_start_seq;
-		sack->end_seq = new_end_seq;
-		sackoff += sizeof(*sack);
-	}
-}
-
-/* TCP SACK sequence number adjustment */
-static inline unsigned int
-ip_nat_sack_adjust(struct sk_buff **pskb,
-		   struct tcphdr *tcph,
-		   struct ip_conntrack *ct,
-		   enum ip_conntrack_info ctinfo)
-{
-	unsigned int dir, optoff, optend;
-
-	optoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct tcphdr);
-	optend = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
-
-	if (!skb_ip_make_writable(pskb, optend))
-		return 0;
-
-	dir = CTINFO2DIR(ctinfo);
-
-	while (optoff < optend) {
-		/* Usually: option, length. */
-		unsigned char *op = (*pskb)->data + optoff;
-
-		switch (op[0]) {
-		case TCPOPT_EOL:
-			return 1;
-		case TCPOPT_NOP:
-			optoff++;
-			continue;
-		default:
-			/* no partial options */
-			if (optoff + 1 == optend
-			    || optoff + op[1] > optend
-			    || op[1] < 2)
-				return 0;
-			if (op[0] == TCPOPT_SACK
-			    && op[1] >= 2+TCPOLEN_SACK_PERBLOCK
-			    && ((op[1] - 2) % TCPOLEN_SACK_PERBLOCK) == 0)
-				sack_adjust(*pskb, tcph, optoff+2,
-					    optoff+op[1],
-					    &ct->nat.info.seq[!dir]);
-			optoff += op[1];
-		}
-	}
-	return 1;
-}
-
-/* TCP sequence number adjustment.  Returns true or false.  */
-int
-ip_nat_seq_adjust(struct sk_buff **pskb, 
-		  struct ip_conntrack *ct, 
-		  enum ip_conntrack_info ctinfo)
-{
-	struct tcphdr *tcph;
-	int dir, newseq, newack;
-	struct ip_nat_seq *this_way, *other_way;	
-
-	dir = CTINFO2DIR(ctinfo);
-
-	this_way = &ct->nat.info.seq[dir];
-	other_way = &ct->nat.info.seq[!dir];
-
-	/* No adjustments to make?  Very common case. */
-	if (!this_way->offset_before && !this_way->offset_after
-	    && !other_way->offset_before && !other_way->offset_after)
-		return 1;
-
-	if (!skb_ip_make_writable(pskb, (*pskb)->nh.iph->ihl*4+sizeof(*tcph)))
-		return 0;
-
-	tcph = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
-	if (after(ntohl(tcph->seq), this_way->correction_pos))
-		newseq = ntohl(tcph->seq) + this_way->offset_after;
-	else
-		newseq = ntohl(tcph->seq) + this_way->offset_before;
-	newseq = htonl(newseq);
-
-	if (after(ntohl(tcph->ack_seq) - other_way->offset_before,
-		  other_way->correction_pos))
-		newack = ntohl(tcph->ack_seq) - other_way->offset_after;
-	else
-		newack = ntohl(tcph->ack_seq) - other_way->offset_before;
-	newack = htonl(newack);
-
-	tcph->check = ip_nat_cheat_check(~tcph->seq, newseq,
-					 ip_nat_cheat_check(~tcph->ack_seq, 
-					 		    newack, 
-							    tcph->check));
-
-	DEBUGP("Adjusting sequence number from %u->%u, ack from %u->%u\n",
-		ntohl(tcph->seq), ntohl(newseq), ntohl(tcph->ack_seq),
-		ntohl(newack));
-
-	tcph->seq = newseq;
-	tcph->ack_seq = newack;
-
-	return ip_nat_sack_adjust(pskb, tcph, ct, ctinfo);
-}
-
 static inline int
 helper_cmp(const struct ip_nat_helper *helper,
 	   const struct ip_conntrack_tuple *tuple)
diff -u -r1.1.1.1 ip_nat_proto_tcp.c
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c	4 Aug 2004 15:14:39 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c	5 Aug 2004 08:55:28 -0000
@@ -7,16 +7,23 @@
  */
 
 #include <linux/types.h>
+#include <linux/skbuff.h>
 #include <linux/init.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
-#include <linux/tcp.h>
+#include <net/tcp.h>
 #include <linux/if.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_nat_protocol.h>
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(args, format...)
+#endif
+
 static int
 tcp_in_range(const struct ip_conntrack_tuple *tuple,
 	     enum ip_nat_manip_type maniptype,
@@ -161,11 +168,160 @@
 	else return 0;
 }
 
-struct ip_nat_protocol ip_nat_protocol_tcp
-= { { NULL, NULL }, "TCP", IPPROTO_TCP,
-    tcp_manip_pkt,
-    tcp_in_range,
-    tcp_unique_tuple,
-    tcp_print,
-    tcp_print_range
+/* Adjust one found SACK option including checksum correction */
+static void
+sack_adjust(struct sk_buff *skb,
+	    struct tcphdr *tcph, 
+	    unsigned int sackoff,
+	    unsigned int sackend,
+	    struct ip_nat_seq *natseq)
+{
+	while (sackoff < sackend) {
+		struct tcp_sack_block *sack;
+		u_int32_t new_start_seq, new_end_seq;
+
+		sack = (void *)skb->data + sackoff;
+		if (after(ntohl(sack->start_seq) - natseq->offset_before,
+			  natseq->correction_pos))
+			new_start_seq = ntohl(sack->start_seq) 
+					- natseq->offset_after;
+		else
+			new_start_seq = ntohl(sack->start_seq) 
+					- natseq->offset_before;
+		new_start_seq = htonl(new_start_seq);
+
+		if (after(ntohl(sack->end_seq) - natseq->offset_before,
+			  natseq->correction_pos))
+			new_end_seq = ntohl(sack->end_seq)
+				      - natseq->offset_after;
+		else
+			new_end_seq = ntohl(sack->end_seq)
+				      - natseq->offset_before;
+		new_end_seq = htonl(new_end_seq);
+
+		DEBUGP("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
+			ntohl(sack->start_seq), new_start_seq,
+			ntohl(sack->end_seq), new_end_seq);
+
+		tcph->check = 
+			ip_nat_cheat_check(~sack->start_seq, new_start_seq,
+					   ip_nat_cheat_check(~sack->end_seq, 
+						   	      new_end_seq,
+							      tcph->check));
+		sack->start_seq = new_start_seq;
+		sack->end_seq = new_end_seq;
+		sackoff += sizeof(*sack);
+	}
+}
+
+/* TCP SACK sequence number adjustment */
+static inline unsigned int
+ip_nat_sack_adjust(struct sk_buff **pskb,
+		   struct tcphdr *tcph,
+		   struct ip_conntrack *ct,
+		   enum ip_conntrack_info ctinfo)
+{
+	unsigned int dir, optoff, optend;
+
+	optoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct tcphdr);
+	optend = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
+
+	if (!skb_ip_make_writable(pskb, optend))
+		return 0;
+
+	dir = CTINFO2DIR(ctinfo);
+
+	while (optoff < optend) {
+		/* Usually: option, length. */
+		unsigned char *op = (*pskb)->data + optoff;
+
+		switch (op[0]) {
+		case TCPOPT_EOL:
+			return 1;
+		case TCPOPT_NOP:
+			optoff++;
+			continue;
+		default:
+			/* no partial options */
+			if (optoff + 1 == optend
+			    || optoff + op[1] > optend
+			    || op[1] < 2)
+				return 0;
+			if (op[0] == TCPOPT_SACK
+			    && op[1] >= 2+TCPOLEN_SACK_PERBLOCK
+			    && ((op[1] - 2) % TCPOLEN_SACK_PERBLOCK) == 0)
+				sack_adjust(*pskb, tcph, optoff+2,
+					    optoff+op[1],
+					    &ct->nat.info.seq[!dir]);
+			optoff += op[1];
+		}
+	}
+	return 1;
+}
+
+/* TCP sequence number adjustment.  Returns true or false.  */
+unsigned int
+tcp_seq_adjust(struct sk_buff **pskb, struct ip_conntrack *ct, 
+	       enum ip_conntrack_info ctinfo, int hooknum)
+{
+	struct tcphdr *tcph;
+	int dir, newseq, newack;
+	struct ip_nat_seq *this_way, *other_way;	
+
+	if (hooknum != NF_IP_POST_ROUTING
+	    && hooknum != NF_IP_LOCAL_IN)
+		return 1;
+	
+	dir = CTINFO2DIR(ctinfo);
+
+	this_way = &ct->nat.info.seq[dir];
+	other_way = &ct->nat.info.seq[!dir];
+
+	/* No adjustments to make?  Very common case. */
+	if (!this_way->offset_before && !this_way->offset_after
+	    && !other_way->offset_before && !other_way->offset_after)
+		return 1;
+
+	if (!skb_ip_make_writable(pskb, (*pskb)->nh.iph->ihl*4+sizeof(*tcph)))
+		return 0;
+
+	tcph = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
+	if (after(ntohl(tcph->seq), this_way->correction_pos))
+		newseq = ntohl(tcph->seq) + this_way->offset_after;
+	else
+		newseq = ntohl(tcph->seq) + this_way->offset_before;
+	newseq = htonl(newseq);
+
+	if (after(ntohl(tcph->ack_seq) - other_way->offset_before,
+		  other_way->correction_pos))
+		newack = ntohl(tcph->ack_seq) - other_way->offset_after;
+	else
+		newack = ntohl(tcph->ack_seq) - other_way->offset_before;
+	newack = htonl(newack);
+
+	tcph->check = ip_nat_cheat_check(~tcph->seq, newseq,
+					 ip_nat_cheat_check(~tcph->ack_seq, 
+					 		    newack, 
+							    tcph->check));
+
+	DEBUGP("Adjusting sequence number from %u->%u, ack from %u->%u\n",
+		ntohl(tcph->seq), ntohl(newseq), ntohl(tcph->ack_seq),
+		ntohl(newack));
+
+	tcph->seq = newseq;
+	tcph->ack_seq = newack;
+
+	return ip_nat_sack_adjust(pskb, tcph, ct, ctinfo);
+}
+
+struct ip_nat_protocol ip_nat_protocol_tcp = 
+{
+	.name 		= "TCP",
+	.protonum 	= IPPROTO_TCP,
+	.manip_pkt 	= tcp_manip_pkt,
+	.in_range 	= tcp_in_range,
+	.unique_tuple 	= tcp_unique_tuple,
+	.print 		= tcp_print,
+	.print_range 	= tcp_print_range,
+	.adjust		= tcp_seq_adjust
 };

--------------000403020904010605000104--
