From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] TCP conntrack reopening fix (stable branch)
Date: Tue, 5 Feb 2008 22:51:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802052250560.3630@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:49461 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761485AbYBEVvL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:51:11 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 8CB501881FB
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Feb 2008 22:51:09 +0100 (CET)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 16102-04 for <netfilter-devel@vger.kernel.org>;
	Tue, 5 Feb 2008 22:51:09 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id 6C8991881F4
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Feb 2008 22:51:09 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

And here is the patch against the stable branch:

TCP connection tracking in netfilter did not handle TCP reopening
properly: active close was taken into account for one side only and
not for any side, which is fixed now. The patch includes more comments
to explain the logic how the different cases are handled.
The bug was discovered by Jeff Chua.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 7a3f64c..17ef459 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -135,7 +135,7 @@ enum tcp_bit_set {
  * CLOSE_WAIT:	ACK seen (after FIN)
  * LAST_ACK:	FIN seen (after FIN)
  * TIME_WAIT:	last ACK seen
- * CLOSE:	closed connection
+ * CLOSE:	closed connection (RST)
  *
  * LISTEN state is not used.
  *
@@ -834,8 +834,21 @@ static int tcp_packet(struct nf_conn *conntrack,
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state < TCP_CONNTRACK_TIME_WAIT)
 			break;
-		if ((conntrack->proto.tcp.seen[!dir].flags &
-			IP_CT_TCP_FLAG_CLOSE_INIT)
+		/* RFC 1122: "When a connection is closed actively,
+		 * it MUST linger in TIME-WAIT state for a time 2xMSL
+		 * (Maximum Segment Lifetime). However, it MAY accept
+		 * a new SYN from the remote TCP to reopen the connection
+		 * directly from TIME-WAIT state, if..."
+		 * We ignore the conditions because we are in the
+		 * TIME-WAIT state anyway.
+		 *
+		 * Handle aborted connections: we and the server
+		 * think there is an existing connection but the client
+		 * aborts it and starts a new one.
+		 */
+		if (((conntrack->proto.tcp.seen[dir].flags
+		      | conntrack->proto.tcp.seen[!dir].flags)
+		     & IP_CT_TCP_FLAG_CLOSE_INIT)
 		    || (conntrack->proto.tcp.last_dir == dir
 		        && conntrack->proto.tcp.last_index == TCP_RST_SET)) {
 			/* Attempt to reopen a closed/aborted connection.
@@ -848,18 +861,25 @@ static int tcp_packet(struct nf_conn *conntrack,
 		}
 		/* Fall through */
 	case TCP_CONNTRACK_IGNORE:
-		/* Ignored packets:
+		/* Ignored packets: 
+		 *
+		 * Our connection entry may be out of sync, so ignore
+		 * packets which may signal the real connection between
+		 * the client and the server.
 		 *
 		 * a) SYN in ORIGINAL
 		 * b) SYN/ACK in REPLY
 		 * c) ACK in reply direction after initial SYN in original.
+		 *
+		 * If the ignored packet is invalid, the receiver will send 
+		 * a RST we'll catch below.
 		 */
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
 		    && ntohl(th->ack_seq) ==
 			     conntrack->proto.tcp.last_end) {
-			/* This SYN/ACK acknowledges a SYN that we earlier
+			/* b) This SYN/ACK acknowledges a SYN that we earlier
 			 * ignored as invalid. This means that the client and
 			 * the server are both in sync, while the firewall is
 			 * not. We kill this session and block the SYN/ACK so
@@ -884,7 +904,7 @@ static int tcp_packet(struct nf_conn *conntrack,
 		write_unlock_bh(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
-				  "nf_ct_tcp: invalid packed ignored ");
+				  "nf_ct_tcp: invalid packet ignored ");
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
@@ -938,8 +958,7 @@ static int tcp_packet(struct nf_conn *conntrack,
 
 	conntrack->proto.tcp.state = new_state;
 	if (old_state != new_state
-	    && (new_state == TCP_CONNTRACK_FIN_WAIT
-		|| new_state == TCP_CONNTRACK_CLOSE))
+	    && new_state == TCP_CONNTRACK_FIN_WAIT)
 		conntrack->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
