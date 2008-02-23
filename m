From: Greg KH <gregkh@suse.de>
Subject: [patch 02/38] NETFILTER: nf_conntrack_tcp: conntrack reopening fix
Date: Fri, 22 Feb 2008 16:29:34 -0800
Message-ID: <20080223002934.GC7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:44622 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760206AbYBWAdH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:33:07 -0500
Content-Disposition: inline; filename="netfilter-nf_conntrack_tcp-conntrack-reopening-fix.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
 
 From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

[NETFILTER]: nf_conntrack_tcp: conntrack reopening fix

[Upstream commits b2155e7f + d0c1fd7a]

TCP connection tracking in netfilter did not handle TCP reopening
properly: active close was taken into account for one side only and
not for any side, which is fixed now. The patch includes more comments
to explain the logic how the different cases are handled.
The bug was discovered by Jeff Chua.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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
_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable

-- 
