From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/04]: nf_conntrack: TCP conntrack reopening fix
Date: Wed,  6 Feb 2008 14:34:00 +0100 (MET)
Message-ID: <20080206133400.15303.99049.sendpatchset@localhost.localdomain>
References: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54115 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763030AbYBFNeD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:34:03 -0500
In-Reply-To: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: TCP conntrack reopening fix

TCP connection tracking in netfilter did not handle TCP reopening
properly: active close was taken into account for one side only and
not for any side, which is fixed now. The patch includes more comments
to explain the logic how the different cases are handled.
The bug was discovered by Jeff Chua.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e57c5fa967bbd2afcd57f902b32d7037f1030932
tree 0791b76306b6ff3edaea52503e63d381974d37f8
parent f908bd210a30649273b607ca363de0ff1476655f
author Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> Tue, 05 Feb 2008 22:50:53 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 06 Feb 2008 02:51:12 +0100

 net/netfilter/nf_conntrack_proto_tcp.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3e0ccca..202d7fa 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -125,7 +125,7 @@ enum tcp_bit_set {
  * CLOSE_WAIT:	ACK seen (after FIN)
  * LAST_ACK:	FIN seen (after FIN)
  * TIME_WAIT:	last ACK seen
- * CLOSE:	closed connection
+ * CLOSE:	closed connection (RST)
  *
  * LISTEN state is not used.
  *
@@ -824,7 +824,21 @@ static int tcp_packet(struct nf_conn *ct,
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state < TCP_CONNTRACK_TIME_WAIT)
 			break;
-		if ((ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_CLOSE_INIT)
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
+		if (((ct->proto.tcp.seen[dir].flags
+		      | ct->proto.tcp.seen[!dir].flags)
+		     & IP_CT_TCP_FLAG_CLOSE_INIT)
 		    || (ct->proto.tcp.last_dir == dir
 		        && ct->proto.tcp.last_index == TCP_RST_SET)) {
 			/* Attempt to reopen a closed/aborted connection.
@@ -838,15 +852,22 @@ static int tcp_packet(struct nf_conn *ct,
 	case TCP_CONNTRACK_IGNORE:
 		/* Ignored packets:
 		 *
+		 * Our connection entry may be out of sync, so ignore
+		 * packets which may signal the real connection between
+		 * the client and the server.
+		 *
 		 * a) SYN in ORIGINAL
 		 * b) SYN/ACK in REPLY
 		 * c) ACK in reply direction after initial SYN in original.
+		 *
+		 * If the ignored packet is invalid, the receiver will send
+		 * a RST we'll catch below.
 		 */
 		if (index == TCP_SYNACK_SET
 		    && ct->proto.tcp.last_index == TCP_SYN_SET
 		    && ct->proto.tcp.last_dir != dir
 		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {
-			/* This SYN/ACK acknowledges a SYN that we earlier
+			/* b) This SYN/ACK acknowledges a SYN that we earlier
 			 * ignored as invalid. This means that the client and
 			 * the server are both in sync, while the firewall is
 			 * not. We kill this session and block the SYN/ACK so
@@ -870,7 +891,7 @@ static int tcp_packet(struct nf_conn *ct,
 		write_unlock_bh(&tcp_lock);
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
-				  "nf_ct_tcp: invalid packed ignored ");
+				  "nf_ct_tcp: invalid packet ignored ");
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
@@ -924,8 +945,7 @@ static int tcp_packet(struct nf_conn *ct,
 
 	ct->proto.tcp.state = new_state;
 	if (old_state != new_state
-	    && (new_state == TCP_CONNTRACK_FIN_WAIT
-		|| new_state == TCP_CONNTRACK_CLOSE))
+	    && new_state == TCP_CONNTRACK_CLOSE)
 		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 	timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
