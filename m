From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/9]: Fix multiple problems with TCP window
 tracking
Date: Mon, 23 May 2005 15:17:27 +0900 (JST)
Message-ID: <200505230617.j4N6HROa027617@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:17:27_2005_605)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

----Next_Part(Mon_May_23_15:17:27_2005_605)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

===========

    [NETFILTER]: Fix multiple problems with TCP window tracking

    The first attached patch addresses several problems in the current TCP
    connection tracking in the 2.6 tree. Some of the problems was reported,
    others was discovered by nfsim tests:

    - tcp_sack function was not safe against nonlinear skbs
    - practically arbitrary RST segments (addresses, ports assumed to be
      known) could cause connection teardown in conntrack (thanks to Tim
      Burress for the bugreport and patch)
    - article on which the code was based falsely assumed that packets
      must fit completely into the window: packets must at least overlap
      (thanks to Phil Oester for the bugreport and patch)
    - state table slightly changed to handle ACK packets sent by server to
      late resent SYNs
    - tracking reopening connections reworked
    - cosmetic change: when window tracking is ignored by setting
      ip_conntrack_tcp_be_liberal to nonzero, it's ignored completely from
      now on

    Signed-off-by: Patrick McHardy <kaber@trash.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_15:17:27_2005_605)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-tcp-window.patch"

diff -Nur linux-2.6.12-rc4-nfct/net/netfilter/nf_conntrack_proto_tcp.c linux-2.6.12-rc4-nfct-1-tcp-window/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-2.6.12-rc4-nfct/net/netfilter/nf_conntrack_proto_tcp.c	2005-05-11 15:21:47.000000000 +0900
+++ linux-2.6.12-rc4-nfct-1-tcp-window/net/netfilter/nf_conntrack_proto_tcp.c	2005-05-19 13:52:56.000000000 +0900
@@ -261,7 +261,7 @@
  *	sSS -> sSR	Standard open.
  *	sSR -> sSR	Retransmitted SYN/ACK.
  *	sES -> sIG	Late retransmitted SYN/ACK?
- *	sFW -> sIG
+ *	sFW -> sIG	Might be SYN/ACK answering ignored SYN
  *	sCW -> sIG
  *	sLA -> sIG
  *	sTW -> sIG
@@ -280,10 +280,10 @@
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
@@ -359,14 +359,19 @@
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
 
@@ -455,10 +460,13 @@
 static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 		     struct tcphdr *tcph, __u32 *sack)
 {
-	__u32 tmp;
-	unsigned char *ptr;
         unsigned char buff[(15 * 4) - sizeof(struct tcphdr)];
+	unsigned char *ptr;
 	int length = (tcph->doff*4) - sizeof(struct tcphdr);
+	__u32 tmp;
+
+	if (!length)
+		return;
 
 	ptr = skb_header_pointer(skb, dataoff + sizeof(struct tcphdr),
 				 length, buff);
@@ -515,7 +523,7 @@
 
 static int tcp_in_window(struct ip_ct_tcp *state, 
                          enum ip_conntrack_dir dir,
-                         unsigned int *index,
+                         unsigned int index,
                          const struct sk_buff *skb,
 			 unsigned int dataoff,
                          struct tcphdr *tcph,
@@ -614,20 +622,23 @@
 		ack = sack = receiver->td_end;
 	}
 
-	if (seq == end)
+	if (seq == end
+	    && (!tcph->rst
+		|| (seq == 0 && state->state == TCP_CONNTRACK_SYN_SENT)))
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
@@ -635,24 +646,15 @@
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
+		after(end, sender->td_end - receiver->td_maxwin - 1),
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
@@ -669,6 +671,11 @@
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
@@ -678,7 +685,7 @@
 		/* 
 		 * Check retransmissions.
 		 */
-		if (*index == TCP_ACK_SET) {
+		if (index == TCP_ACK_SET) {
 			if (state->last_dir == dir
 			    && state->last_seq == seq
 			    && state->last_ack == ack
@@ -703,16 +710,16 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL,
 			"nf_ct_tcp: %s ",
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
 
-		res = nf_ct_tcp_be_liberal && !tcph->rst;
+		res = nf_ct_tcp_be_liberal;
   	}
   
 	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
@@ -903,13 +910,12 @@
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
@@ -929,6 +935,8 @@
 		conntrack->proto.tcp.last_index = index;
 		conntrack->proto.tcp.last_dir = dir;
 		conntrack->proto.tcp.last_seq = ntohl(th->seq);
+		conntrack->proto.tcp.last_end =
+		    segment_seq_plus_len(ntohl(th->seq), skb->len, dataoff, th);
 
 		WRITE_UNLOCK(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
@@ -946,7 +954,12 @@
 				  "nf_ct_tcp: invalid state ");
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_SYN_SENT:
-		if (old_state >= TCP_CONNTRACK_TIME_WAIT) {
+		if (old_state < TCP_CONNTRACK_TIME_WAIT)
+			break;
+		if ((conntrack->proto.tcp.seen[dir].flags &
+			IP_CT_TCP_FLAG_CLOSE_INIT)
+		    || after(ntohl(th->seq),
+			     conntrack->proto.tcp.seen[dir].td_end)) {
 		    	/* Attempt to reopen a closed connection.
 		    	* Delete this connection and look up again. */
 		    	WRITE_UNLOCK(&tcp_lock);
@@ -955,22 +968,16 @@
 		    					    conntrack);
 		    	return -NF_REPEAT;
 		}
-		break;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-		         && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET)
-			|| (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
-			 && conntrack->proto.tcp.last_index == TCP_ACK_SET))
-		    && after(ntohl(th->ack_seq),
-		    	     conntrack->proto.tcp.last_seq)) {
-			/* Ignore RST closing down invalid SYN or ACK
-			   we had let trough. */ 
-		    	WRITE_UNLOCK(&tcp_lock);
-			if (LOG_INVALID(IPPROTO_TCP))
-				nf_log_packet(pf, 0, skb, NULL, NULL, 
-					  "nf_ct_tcp: invalid RST (ignored) ");
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
@@ -978,16 +985,14 @@
 		break;
 	}
 
-	if (!tcp_in_window(&conntrack->proto.tcp, dir, &index, 
+	if (!tcp_in_window(&conntrack->proto.tcp, dir, index,
 			   skb, dataoff, th, pf)) {
 		WRITE_UNLOCK(&tcp_lock);
 		return -NF_ACCEPT;
 	}
+     in_window:
 	/* From now on we have got in-window packets */
-
-	/* If FIN was trimmed off, we don't change state. */
 	conntrack->proto.tcp.last_index = index;
-	new_state = tcp_conntracks[dir][index][old_state];
 
 	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
 	       "syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
@@ -998,6 +1003,10 @@
 		old_state, new_state);
 
 	conntrack->proto.tcp.state = new_state;
+	if (old_state != new_state
+	    && (new_state == TCP_CONNTRACK_FIN_WAIT
+		|| new_state == TCP_CONNTRACK_CLOSE))
+		conntrack->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
 		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
@@ -1028,7 +1037,7 @@
 	return NF_ACCEPT;
 }
  
-  /* Called when a new connection for this protocol found. */
+/* Called when a new connection for this protocol found. */
 static int tcp_new(struct nf_conn *conntrack,
 		   const struct sk_buff *skb,
 		   unsigned int dataoff)

----Next_Part(Mon_May_23_15:17:27_2005_605)----
