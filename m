From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 6/8] Netfilter:  Use ct_extend for NAT TCP sequence
	alteration information
Date: Thu, 13 Jan 2005 07:59:23 +1100
Message-ID: <1105563564.12794.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Use ct_extend for NAT TCP sequence alteration information
Status: Tested lightly under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

It's unusual to adjust sequence numbers in a connection, so that
information is a good candidate to move into ct_extend.

Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-12 23:43:00.822693672 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-12 23:43:21.560541040 +1100
@@ -34,6 +34,7 @@
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 
 #if 0
 #define DEBUGP printk
@@ -479,6 +480,13 @@
 	return 1;
 }
 
+static struct ct_extend_type seq_extend =
+{
+	.len = sizeof(struct ip_nat_seq)*2,
+	.align = __alignof__(struct ip_nat_seq),
+	.type = CTE_NAT_SEQ,
+};
+
 int __init ip_nat_init(void)
 {
 	size_t i;
@@ -510,6 +518,7 @@
 
 	/* Initialize fake conntrack so that NAT will skip it */
 	ip_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
+	register_ct_extend_type(&seq_extend);
 	return 0;
 }
 
@@ -525,5 +534,6 @@
 {
 	ip_ct_iterate_cleanup(&clean_nat, NULL);
 	ip_conntrack_destroyed = NULL;
+	unregister_ct_extend_type(&seq_extend);
 	vfree(bysource);
 }
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-12 23:43:00.822693672 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-12 23:43:21.562540736 +1100
@@ -38,6 +38,7 @@
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 
 #if 0
 #define DEBUGP printk
@@ -47,45 +48,42 @@
 #define DUMP_OFFSET(x)
 #endif
 
-static DECLARE_LOCK(ip_nat_seqofs_lock);
-
 /* Setup TCP sequence correction given this change at this sequence */
-static inline void 
+static inline int 
 adjust_tcp_sequence(u32 seq,
 		    int sizediff,
 		    struct ip_conntrack *ct, 
 		    enum ip_conntrack_info ctinfo)
 {
 	int dir;
-	struct ip_nat_seq *this_way, *other_way;
+	struct ip_nat_seq *natseq;
 
 	DEBUGP("ip_nat_resize_packet: old_size = %u, new_size = %u\n",
 		(*skb)->len, new_size);
 
 	dir = CTINFO2DIR(ctinfo);
 
-	this_way = &ct->nat.info.seq[dir];
-	other_way = &ct->nat.info.seq[!dir];
-
-	DEBUGP("ip_nat_resize_packet: Seq_offset before: ");
-	DUMP_OFFSET(this_way);
-
-	LOCK_BH(&ip_nat_seqofs_lock);
+	WRITE_LOCK(&ip_conntrack_lock);
+	natseq = ct_extend_find(ct->ext, CTE_NAT_SEQ);
+	if (!natseq) {
+		natseq = ct_extend_add(&ct->ext, CTE_NAT_SEQ, GFP_ATOMIC);
+		if (!natseq)
+			return 0;
+		memset(natseq, 0, sizeof(*natseq));
+	}
 
 	/* SYN adjust. If it's uninitialized, or this is after last
 	 * correction, record it: we don't handle more than one
 	 * adjustment in the window, but do deal with common case of a
 	 * retransmit */
-	if (this_way->offset_before == this_way->offset_after
-	    || before(this_way->correction_pos, seq)) {
-		    this_way->correction_pos = seq;
-		    this_way->offset_before = this_way->offset_after;
-		    this_way->offset_after += sizediff;
+	if (natseq[dir].offset_before == natseq[dir].offset_after
+	    || before(natseq[dir].correction_pos, seq)) {
+		    natseq[dir].correction_pos = seq;
+		    natseq[dir].offset_before = natseq[dir].offset_after;
+		    natseq[dir].offset_after += sizediff;
 	}
-	UNLOCK_BH(&ip_nat_seqofs_lock);
-
-	DEBUGP("ip_nat_resize_packet: Seq_offset after: ");
-	DUMP_OFFSET(this_way);
+	WRITE_UNLOCK(&ip_conntrack_lock);
+	return 1;
 }
 
 /* Frobs data inside this packet, which is linear. */
@@ -193,10 +191,11 @@
 				   csum_partial((char *)tcph, datalen, 0));
 
 	if (rep_len != match_len) {
+		if (!adjust_tcp_sequence(ntohl(tcph->seq),
+					 (int)rep_len - (int)match_len,
+					 ct, ctinfo))
+			return 0;
 		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
-		adjust_tcp_sequence(ntohl(tcph->seq),
-				    (int)rep_len - (int)match_len,
-				    ct, ctinfo);
 		/* Tell TCP window tracking about seq change */
 		ip_conntrack_tcp_update(*pskb, ct, CTINFO2DIR(ctinfo));
 	}
@@ -310,10 +309,9 @@
 static inline unsigned int
 ip_nat_sack_adjust(struct sk_buff **pskb,
 		   struct tcphdr *tcph,
-		   struct ip_conntrack *ct,
-		   enum ip_conntrack_info ctinfo)
+		   struct ip_nat_seq *other_way)
 {
-	unsigned int dir, optoff, optend;
+	unsigned int optoff, optend;
 
 	optoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct tcphdr);
 	optend = (*pskb)->nh.iph->ihl*4 + tcph->doff*4;
@@ -321,8 +319,6 @@
 	if (!skb_ip_make_writable(pskb, optend))
 		return 0;
 
-	dir = CTINFO2DIR(ctinfo);
-
 	while (optoff < optend) {
 		/* Usually: option, length. */
 		unsigned char *op = (*pskb)->data + optoff;
@@ -343,8 +339,7 @@
 			    && op[1] >= 2+TCPOLEN_SACK_PERBLOCK
 			    && ((op[1] - 2) % TCPOLEN_SACK_PERBLOCK) == 0)
 				sack_adjust(*pskb, tcph, optoff+2,
-					    optoff+op[1],
-					    &ct->nat.info.seq[!dir]);
+					    optoff+op[1], other_way);
 			optoff += op[1];
 		}
 	}
@@ -359,16 +354,18 @@
 {
 	struct tcphdr *tcph;
 	int dir, newseq, newack;
-	struct ip_nat_seq *this_way, *other_way;	
+	struct ip_nat_seq *seqpair, *this_way, *other_way;
 
 	dir = CTINFO2DIR(ctinfo);
 
-	this_way = &ct->nat.info.seq[dir];
-	other_way = &ct->nat.info.seq[!dir];
-
 	if (!skb_ip_make_writable(pskb, (*pskb)->nh.iph->ihl*4+sizeof(*tcph)))
 		return 0;
 
+	READ_LOCK(&ip_conntrack_lock);
+	seqpair = ct_extend_find(ct->ext, CTE_NAT_SEQ);
+	this_way = &seqpair[dir];
+	other_way = &seqpair[!dir];
+
 	tcph = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
 	if (after(ntohl(tcph->seq), this_way->correction_pos))
 		newseq = ntohl(tcph->seq) + this_way->offset_after;
@@ -395,10 +392,13 @@
 	tcph->seq = newseq;
 	tcph->ack_seq = newack;
 
-	if (!ip_nat_sack_adjust(pskb, tcph, ct, ctinfo))
+	if (!ip_nat_sack_adjust(pskb, tcph, other_way)) {
+		READ_UNLOCK(&ip_conntrack_lock);
 		return 0;
+	}
 
 	ip_conntrack_tcp_update(*pskb, ct, dir);
+	READ_UNLOCK(&ip_conntrack_lock);
 
 	return 1;
 }
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_nat.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat.h	2005-01-12 23:43:00.823693520 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_nat.h	2005-01-12 23:43:21.563540584 +1100
@@ -56,8 +56,6 @@
 struct ip_nat_info
 {
 	struct list_head bysource;
-
-	struct ip_nat_seq seq[IP_CT_DIR_MAX];
 };
 
 struct ip_conntrack;
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:43:16.845257872 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:44:19.588719416 +1100
@@ -8,6 +8,7 @@
 	CTE_FTP_CONN,
 	CTE_MARK,
 	CTE_CT_HELPER,
+	CTE_NAT_SEQ,
 	CTE_MAX,
 } __attribute__((packed));
 
@@ -15,6 +16,7 @@
 #define CTE_FTP_CONN_TYPE struct ip_ct_ftp_master
 #define CTE_MARK_TYPE unsigned long
 #define CTE_CT_HELPER_TYPE struct ip_conntrack_helper *
+#define CTE_NAT_SEQ_TYPE struct ip_nat_seq
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct ct_extend {
