From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/2] Move tcp_adjust to generic layer
Date: Sun, 06 Mar 2005 23:40:22 +0100
Message-ID: <422B86D6.8040905@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040301010001080400090105"
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
--------------040301010001080400090105
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

This patch moves tcp_adjust to a generic layer. I sent something similar 
some time ago but it seems that it got lost.

--
Pablo

--------------040301010001080400090105
Content-Type: text/x-patch;
 name="nat-adjust.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nat-adjust.patch"

Move tcp sequence adjusting to a generic layer.
Status: Tested on 2.6.11-rc5
Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

 include/linux/netfilter_ipv4/ip_nat_protocol.h |    3 
 net/ipv4/netfilter/ip_nat_core.c               |   12 +
 net/ipv4/netfilter/ip_nat_helper.c             |  143 -----------------------
 net/ipv4/netfilter/ip_nat_proto_icmp.c         |    3 
 net/ipv4/netfilter/ip_nat_proto_tcp.c          |  154 ++++++++++++++++++++++++-
 net/ipv4/netfilter/ip_nat_proto_udp.c          |    3 
 net/ipv4/netfilter/ip_nat_proto_unknown.c      |    3 
 7 files changed, 168 insertions(+), 153 deletions(-)

===== include/linux/netfilter_ipv4/ip_nat_protocol.h 1.5 vs edited =====
--- 1.5/include/linux/netfilter_ipv4/ip_nat_protocol.h	2005-01-17 23:00:55 +01:00
+++ edited/include/linux/netfilter_ipv4/ip_nat_protocol.h	2005-02-15 03:16:54 +01:00
@@ -43,6 +43,9 @@
 
 	unsigned int (*print_range)(char *buffer,
 				    const struct ip_nat_range *range);
+
+	int (*adjust)(struct sk_buff **pskb, struct ip_conntrack *ct, 
+		      enum ip_conntrack_info ctinfo);
 };
 
 #define MAX_IP_NAT_PROTO 256
===== net/ipv4/netfilter/ip_nat_core.c 1.69 vs edited =====
--- 1.69/net/ipv4/netfilter/ip_nat_core.c	2005-02-07 06:48:35 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_core.c	2005-02-15 03:21:59 +01:00
@@ -358,11 +358,13 @@
 
 	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)
 	    && (hooknum == NF_IP_POST_ROUTING || hooknum == NF_IP_LOCAL_IN)) {
-		DEBUGP("ip_nat_core: adjusting sequence number\n");
-		/* future: put this in a l4-proto specific function,
-		 * and call this function here. */
-		if (!ip_nat_seq_adjust(pskb, ct, ctinfo))
-			return NF_DROP;
+		int proto = (*pskb)->nh.iph->protocol; 
+		struct ip_nat_protocol *protocol = ip_nat_find_proto(proto);
+		if (protocol->adjust != NULL) {
+			DEBUGP("ip_nat_core: adjusting sequence number\n");
+			if (!protocol->adjust(pskb, ct, ctinfo))
+				return NF_DROP;
+		}
 	}
 
 	if (mtype == IP_NAT_MANIP_SRC)
===== net/ipv4/netfilter/ip_nat_helper.c 1.32 vs edited =====
--- 1.32/net/ipv4/netfilter/ip_nat_helper.c	2005-01-17 23:04:57 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_helper.c	2005-02-15 03:19:12 +01:00
@@ -260,149 +260,6 @@
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
-/* TCP sequence number adjustment.  Returns 1 on success, 0 on failure */
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
-	if (!ip_nat_sack_adjust(pskb, tcph, ct, ctinfo))
-		return 0;
-
-	ip_conntrack_tcp_update(*pskb, ct, dir);
-
-	return 1;
-}
-
 /* Setup NAT on this expected conntrack so it follows master. */
 /* If we fail to get a free NAT slot, we'll get dropped on confirm */
 void ip_nat_follow_master(struct ip_conntrack *ct,
===== net/ipv4/netfilter/ip_nat_proto_icmp.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ip_nat_proto_icmp.c	2005-01-17 23:00:55 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_icmp.c	2005-02-15 03:17:17 +01:00
@@ -111,5 +111,6 @@
     icmp_in_range,
     icmp_unique_tuple,
     icmp_print,
-    icmp_print_range
+    icmp_print_range,
+    NULL
 };
===== net/ipv4/netfilter/ip_nat_proto_tcp.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-01-31 07:21:51 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-02-15 03:21:24 +01:00
@@ -10,13 +10,19 @@
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
+#define DEBUGP(format, args...)
+#endif
+
 static int
 tcp_in_range(const struct ip_conntrack_tuple *tuple,
 	     enum ip_nat_manip_type maniptype,
@@ -168,11 +174,155 @@
 	else return 0;
 }
 
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
+/* TCP sequence number adjustment.  Returns 1 on success, 0 on failure */
+static int
+tcp_seq_adjust(struct sk_buff **pskb, 
+	       struct ip_conntrack *ct, 
+	       enum ip_conntrack_info ctinfo)
+{
+	struct tcphdr *tcph;
+	int dir, newseq, newack;
+	struct ip_nat_seq *this_way, *other_way;	
+
+	dir = CTINFO2DIR(ctinfo);
+
+	this_way = &ct->nat.info.seq[dir];
+	other_way = &ct->nat.info.seq[!dir];
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
+	if (!ip_nat_sack_adjust(pskb, tcph, ct, ctinfo))
+		return 0;
+
+	ip_conntrack_tcp_update(*pskb, ct, dir);
+
+	return 1;
+}
+
 struct ip_nat_protocol ip_nat_protocol_tcp
 = { "TCP", IPPROTO_TCP,
     tcp_manip_pkt,
     tcp_in_range,
     tcp_unique_tuple,
     tcp_print,
-    tcp_print_range
+    tcp_print_range,
+    tcp_seq_adjust
 };
===== net/ipv4/netfilter/ip_nat_proto_udp.c 1.9 vs edited =====
--- 1.9/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-01-17 23:00:55 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-02-15 03:17:07 +01:00
@@ -161,5 +161,6 @@
     udp_in_range,
     udp_unique_tuple,
     udp_print,
-    udp_print_range
+    udp_print_range,
+    NULL
 };
===== net/ipv4/netfilter/ip_nat_proto_unknown.c 1.7 vs edited =====
--- 1.7/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-01-17 23:00:55 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-02-15 03:17:26 +01:00
@@ -66,5 +66,6 @@
 	unknown_in_range,
 	unknown_unique_tuple,
 	unknown_print,
-	unknown_print_range
+	unknown_print_range,
+	NULL
 };

--------------040301010001080400090105--
