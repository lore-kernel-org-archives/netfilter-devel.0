From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 7/8]: Fix multiple problems with TCP window tracking
Date: Fri, 04 Mar 2005 13:00:54 +0100
Message-ID: <42284DF6.8050108@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="07.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/03 23:19:00+01:00 kadlec@blackhole.kfki.hu 
#   [NETFILTER]: Fix multiple problems with TCP window tracking
#   
#   The first attached patch addresses several problems in the current TCP
#   connection tracking in the 2.6 tree. Some of the problems was reported,
#   others was discovered by nfsim tests:
#   
#   - tcp_sack function was not safe against nonlinear skbs
#   - practically arbitrary RST segments (addresses, ports assumed to be
#     known) could cause connection teardown in conntrack (thanks to Tim
#     Burress for the bugreport and patch)
#   - article on which the code was based falsely assumed that packets
#     must fit completely into the window: packets must at least overlap
#     (thanks to Phil Oester for the bugreport and patch)
#   - state table slightly changed to handle ACK packets sent by server to
#     late resent SYNs
#   - tracking reopening connections reworked
#   - cosmetic change: when window tracking is ignored by setting
#     ip_conntrack_tcp_be_liberal to nonzero, it's ignored completely from
#     now on
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_tcp.c
#   2005/03/03 23:18:52+01:00 kadlec@blackhole.kfki.hu +89 -66
#   [NETFILTER]: Fix multiple problems with TCP window tracking
#   
#   The first attached patch addresses several problems in the current TCP
#   connection tracking in the 2.6 tree. Some of the problems was reported,
#   others was discovered by nfsim tests:
#   
#   - tcp_sack function was not safe against nonlinear skbs
#   - practically arbitrary RST segments (addresses, ports assumed to be
#     known) could cause connection teardown in conntrack (thanks to Tim
#     Burress for the bugreport and patch)
#   - article on which the code was based falsely assumed that packets
#     must fit completely into the window: packets must at least overlap
#     (thanks to Phil Oester for the bugreport and patch)
#   - state table slightly changed to handle ACK packets sent by server to
#     late resent SYNs
#   - tracking reopening connections reworked
#   - cosmetic change: when window tracking is ignored by setting
#     ip_conntrack_tcp_be_liberal to nonzero, it's ignored completely from
#     now on
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack_tcp.h
#   2005/03/03 23:18:52+01:00 kadlec@blackhole.kfki.hu +4 -1
#   [NETFILTER]: Fix multiple problems with TCP window tracking
#   
#   The first attached patch addresses several problems in the current TCP
#   connection tracking in the 2.6 tree. Some of the problems was reported,
#   others was discovered by nfsim tests:
#   
#   - tcp_sack function was not safe against nonlinear skbs
#   - practically arbitrary RST segments (addresses, ports assumed to be
#     known) could cause connection teardown in conntrack (thanks to Tim
#     Burress for the bugreport and patch)
#   - article on which the code was based falsely assumed that packets
#     must fit completely into the window: packets must at least overlap
#     (thanks to Phil Oester for the bugreport and patch)
#   - state table slightly changed to handle ACK packets sent by server to
#     late resent SYNs
#   - tracking reopening connections reworked
#   - cosmetic change: when window tracking is ignored by setting
#     ip_conntrack_tcp_be_liberal to nonzero, it's ignored completely from
#     now on
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_tcp.h b/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2005-03-03 23:36:06 +01:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2005-03-03 23:36:06 +01:00
@@ -23,13 +23,16 @@
 /* SACK is permitted by the sender */
 #define IP_CT_TCP_FLAG_SACK_PERM		0x02
 
+/* This sender sent FIN first */
+#define IP_CT_TCP_FLAG_CLOSE_INIT		0x03
+
 struct ip_ct_tcp_state {
 	u_int32_t	td_end;		/* max of seq + len */
 	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
 	u_int32_t	td_maxwin;	/* max(win) */
 	u_int8_t	td_scale;	/* window scale factor */
 	u_int8_t	loose;		/* used when connection picked up from the middle */
-	u_int8_t	flags;		/* per direction state flags */
+	u_int8_t	flags;		/* per direction options */
 };
 
 struct ip_ct_tcp
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-03-03 23:36:06 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-03-03 23:36:06 +01:00
@@ -254,7 +254,7 @@
  *	sSS -> sSR	Standard open.
  *	sSR -> sSR	Retransmitted SYN/ACK.
  *	sES -> sIG	Late retransmitted SYN/ACK?
- *	sFW -> sIG
+ *	sFW -> sIG	Might be SYN/ACK answering ignored SYN
  *	sCW -> sIG
  *	sLA -> sIG
  *	sTW -> sIG
@@ -273,10 +273,10 @@
  *	sCL -> sCL
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
-/*ack*/	   { sIV, sIG, sIV, sES, sCW, sCW, sTW, sTW, sCL, sIV },
+/*ack*/	   { sIV, sIV, sSR, sES, sCW, sCW, sTW, sTW, sCL, sIV },
 /*
- *	sSS -> sIG	Might be a half-open connection.
- *	sSR -> sIV	Simultaneous open.
+ *	sSS -> sIV	Might be a half-open connection.
+ *	sSR -> sSR	Might answer late resent SYN.
  *	sES -> sES	:-)
  *	sFW -> sCW	Normal close request answered by ACK.
  *	sCW -> sCW
@@ -352,14 +352,19 @@
    http://www.nluug.nl/events/sane2000/papers.html
    http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz
    
-   The boundaries and the conditions are slightly changed:
-   
+   The boundaries and the conditions are changed according to RFC793:
+   the packet must intersect the window (i.e. segments may be
+   after the right or before the left edge) and thus receivers may ACK
+   segments after the right edge of the window.
+
    	td_maxend = max(sack + max(win,1)) seen in reply packets
 	td_maxwin = max(max(win, 1)) + (sack - ack) seen in sent packets
+	td_maxwin += seq + len - sender.td_maxend
+			if seq + len > sender.td_maxend
 	td_end    = max(seq + len) seen in sent packets
    
-   I. 	Upper bound for valid data:	seq + len <= sender.td_maxend
-   II. 	Lower bound for valid data:	seq >= sender.td_end - receiver.td_maxwin
+   I.   Upper bound for valid data:	seq <= sender.td_maxend
+   II.  Lower bound for valid data:	seq + len >= sender.td_end - receiver.td_maxwin
    III.	Upper bound for valid ack:      sack <= receiver.td_end
    IV.	Lower bound for valid ack:	ack >= receiver.td_end - MAXACKWINDOW
    	
@@ -373,7 +378,7 @@
 					 size_t len,
 					 struct iphdr *iph,
 					 struct tcphdr *tcph)
-  {
+{
 	return (seq + len - (iph->ihl + tcph->doff)*4
 		+ (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0));
 }
@@ -444,22 +449,33 @@
 	}
 }
 
-static void tcp_sack(struct tcphdr *tcph, __u32 *sack)
+static void tcp_sack(const struct sk_buff *skb,
+		     struct iphdr *iph,
+		     struct tcphdr *tcph,
+		     __u32 *sack)
 {
-	__u32 tmp;
+	unsigned char buff[(15 * 4) - sizeof(struct tcphdr)];
 	unsigned char *ptr;
 	int length = (tcph->doff*4) - sizeof(struct tcphdr);
-	
+	__u32 tmp;
+
+	if (!length)
+		return;
+
+	ptr = skb_header_pointer(skb,
+				 (iph->ihl * 4) + sizeof(struct tcphdr),
+				 length, buff);
+	BUG_ON(ptr == NULL);
+
 	/* Fast path for timestamp-only option */
 	if (length == TCPOLEN_TSTAMP_ALIGNED*4
-	    && *(__u32 *)(tcph + 1) ==
+	    && *(__u32 *)ptr ==
 	        __constant_ntohl((TCPOPT_NOP << 24) 
 	        		 | (TCPOPT_NOP << 16)
 	        		 | (TCPOPT_TIMESTAMP << 8)
 	        		 | TCPOLEN_TIMESTAMP))
 		return;
 		
-	ptr = (unsigned char *)(tcph + 1);
 	while (length > 0) {
 		int opcode=*ptr++;
 		int opsize, i;
@@ -500,7 +516,7 @@
 
 static int tcp_in_window(struct ip_ct_tcp *state, 
                          enum ip_conntrack_dir dir,
-                         unsigned int *index,
+                         unsigned int index,
                          const struct sk_buff *skb,
                          struct iphdr *iph,
                          struct tcphdr *tcph)
@@ -519,7 +535,7 @@
 	end = segment_seq_plus_len(seq, skb->len, iph, tcph);
 	
 	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
-		tcp_sack(tcph, &sack);
+		tcp_sack(skb, iph, tcph, &sack);
 		
 	DEBUGP("tcp_in_window: START\n");
 	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
@@ -598,20 +614,23 @@
 		ack = sack = receiver->td_end;
 	}
 
-	if (seq == end)
+	if (seq == end
+	    && (!tcph->rst 
+	        || (seq == 0 && state->state == TCP_CONNTRACK_SYN_SENT)))
 		/*
 		 * Packets contains no data: we assume it is valid
 		 * and check the ack value only.
+		 * However RST segments are always validated by their
+		 * SEQ number, except when seq == 0 (reset sent answering
+		 * SYN.
 		 */
 		seq = end = sender->td_end;
 		
 	DEBUGP("tcp_in_window: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
-	       "seq=%u ack=%u sack =%u win=%u end=%u trim=%u\n",
+	       "seq=%u ack=%u sack =%u win=%u end=%u\n",
 		NIPQUAD(iph->saddr), ntohs(tcph->source),
 		NIPQUAD(iph->daddr), ntohs(tcph->dest),
-		seq, ack, sack, win, end, 
-		after(end, sender->td_maxend) && before(seq, sender->td_maxend)
-		? sender->td_maxend : end);
+		seq, ack, sack, win, end);
 	DEBUGP("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
 	       "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
 		sender->td_end, sender->td_maxend, sender->td_maxwin,
@@ -619,24 +638,15 @@
 		receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
 		receiver->td_scale);
 	
-	/* Ignore data over the right edge of the receiver's window. */
-	if (after(end, sender->td_maxend) &&
-	    before(seq, sender->td_maxend)) {
-		end = sender->td_maxend;
-		if (*index == TCP_FIN_SET)
-			*index = TCP_ACK_SET;
-	}
 	DEBUGP("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
-		before(end, sender->td_maxend + 1) 
-		    || before(seq, sender->td_maxend + 1),
-	    	after(seq, sender->td_end - receiver->td_maxwin - 1) 
-	    	    || after(end, sender->td_end - receiver->td_maxwin - 1),
+		before(seq, sender->td_maxend + 1),
+	    	after(end, sender->td_end - receiver->td_maxwin - 1),
 	    	before(sack, receiver->td_end + 1),
 	    	after(ack, receiver->td_end - MAXACKWINDOW(sender)));
 	
 	if (sender->loose || receiver->loose ||
-	    (before(end, sender->td_maxend + 1) &&
-	     after(seq, sender->td_end - receiver->td_maxwin - 1) &&
+	    (before(seq, sender->td_maxend + 1) &&
+	     after(end, sender->td_end - receiver->td_maxwin - 1) &&
 	     before(sack, receiver->td_end + 1) &&
 	     after(ack, receiver->td_end - MAXACKWINDOW(sender)))) {
 	    	/*
@@ -653,6 +663,11 @@
 			sender->td_maxwin = swin;
 		if (after(end, sender->td_end))
 			sender->td_end = end;
+		/*
+		 * Update receiver data.
+		 */
+		if (after(end, sender->td_maxend))
+			receiver->td_maxwin += end - sender->td_maxend;
 		if (after(sack + win, receiver->td_maxend - 1)) {
 			receiver->td_maxend = sack + win;
 			if (win == 0)
@@ -662,7 +677,7 @@
 		/* 
 		 * Check retransmissions.
 		 */
-		if (*index == TCP_ACK_SET) {
+		if (index == TCP_ACK_SET) {
 			if (state->last_dir == dir
 			    && state->last_seq == seq
 			    && state->last_ack == ack
@@ -687,16 +702,16 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 			"ip_ct_tcp: %s ",
-			before(end, sender->td_maxend + 1) ?
-			after(seq, sender->td_end - receiver->td_maxwin - 1) ?
+			before(seq, sender->td_maxend + 1) ?
+			after(end, sender->td_end - receiver->td_maxwin - 1) ?
 			before(sack, receiver->td_end + 1) ?
 			after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
-			: "ACK is under the lower bound (possibly overly delayed ACK)"
-			: "ACK is over the upper bound (ACKed data has never seen yet)"
-			: "SEQ is under the lower bound (retransmitted already ACKed data)"
+			: "ACK is under the lower bound (possible overly delayed ACK)"
+			: "ACK is over the upper bound (ACKed data not seen yet)"
+			: "SEQ is under the lower bound (already ACKed data retransmitted)"
 			: "SEQ is over the upper bound (over the window of the receiver)");
 
-		res = ip_ct_tcp_be_liberal && !tcph->rst;
+		res = ip_ct_tcp_be_liberal;
   	}
   
 	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
@@ -849,13 +864,12 @@
 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
 		/* Either SYN in ORIGINAL
-		 * or SYN/ACK in REPLY
-		 * or ACK in REPLY direction (half-open connection). */
+		 * or SYN/ACK in REPLY. */
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
-		    && after(ntohl(th->ack_seq),
-		    	     conntrack->proto.tcp.last_seq)) {
+		    && ntohl(th->ack_seq) ==
+		    	     conntrack->proto.tcp.last_end) {
 			/* This SYN/ACK acknowledges a SYN that we earlier 
 			 * ignored as invalid. This means that the client and
 			 * the server are both in sync, while the firewall is
@@ -875,6 +889,8 @@
 		conntrack->proto.tcp.last_index = index;
 		conntrack->proto.tcp.last_dir = dir;
 		conntrack->proto.tcp.last_seq = ntohl(th->seq);
+		conntrack->proto.tcp.last_end = 
+		    segment_seq_plus_len(ntohl(th->seq), skb->len, iph, th);
 		
 		WRITE_UNLOCK(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
@@ -892,7 +908,12 @@
 				  "ip_ct_tcp: invalid state ");
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_SYN_SENT:
-		if (old_state >= TCP_CONNTRACK_TIME_WAIT) {	
+		if (old_state < TCP_CONNTRACK_TIME_WAIT)
+			break;
+		if ((conntrack->proto.tcp.seen[dir].flags &
+		         IP_CT_TCP_FLAG_CLOSE_INIT)
+		    || after(ntohl(th->seq),
+		    	     conntrack->proto.tcp.seen[dir].td_end)) {	
 		    	/* Attempt to reopen a closed connection.
 		    	* Delete this connection and look up again. */
 		    	WRITE_UNLOCK(&tcp_lock);
@@ -900,23 +921,23 @@
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
 		    	return -NF_REPEAT;
+		} else {
+			WRITE_UNLOCK(&tcp_lock);
+			if (LOG_INVALID(IPPROTO_TCP))
+				nf_log_packet(PF_INET, 0, skb, NULL, NULL,
+				              "ip_ct_tcp: invalid SYN");
+			return -NF_ACCEPT;
 		}
-		break;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-		         && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET)
-		        || (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
-			 && conntrack->proto.tcp.last_index == TCP_ACK_SET))
-		    && after(ntohl(th->ack_seq),
-		    	     conntrack->proto.tcp.last_seq)) {
-			/* Ignore RST closing down invalid SYN or ACK
-			   we had let trough. */ 
-		    	WRITE_UNLOCK(&tcp_lock);
-			if (LOG_INVALID(IPPROTO_TCP))
-				nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
-					  "ip_ct_tcp: invalid RST (ignored) ");
-			return NF_ACCEPT;
+		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
+		    && ntohl(th->ack_seq) == conntrack->proto.tcp.last_end) {
+			/* RST sent to invalid SYN we had let trough
+			 * SYN was in window then, tear down connection.
+			 * We skip window checking, because packet might ACK
+			 * segments we ignored in the SYN. */
+			goto in_window;
 		}
 		/* Just fall trough */
 	default:
@@ -924,16 +945,14 @@
 		break;
 	}
 
-	if (!tcp_in_window(&conntrack->proto.tcp, dir, &index, 
+	if (!tcp_in_window(&conntrack->proto.tcp, dir, index, 
 			   skb, iph, th)) {
 		WRITE_UNLOCK(&tcp_lock);
 		return -NF_ACCEPT;
 	}
-	/* From now on we have got in-window packets */
-	
-	/* If FIN was trimmed off, we don't change state. */
+    in_window:
+	/* From now on we have got in-window packets */	
 	conntrack->proto.tcp.last_index = index;
-	new_state = tcp_conntracks[dir][index][old_state];
 
 	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
 	       "syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
@@ -944,6 +963,10 @@
 		old_state, new_state);
 
 	conntrack->proto.tcp.state = new_state;
+	if (old_state != new_state 
+	    && (new_state == TCP_CONNTRACK_FIN_WAIT
+	    	|| new_state == TCP_CONNTRACK_CLOSE))
+		conntrack->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 	timeout = conntrack->proto.tcp.retrans >= ip_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > ip_ct_tcp_timeout_max_retrans
 		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
@@ -974,7 +997,7 @@
 	return NF_ACCEPT;
 }
  
-  /* Called when a new connection for this protocol found. */
+/* Called when a new connection for this protocol found. */
 static int tcp_new(struct ip_conntrack *conntrack,
 		   const struct sk_buff *skb)
 {
