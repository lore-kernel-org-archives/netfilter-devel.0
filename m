From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable]: nf_conntrack_tcp: fix connection reopening
Date: Mon, 05 Nov 2007 12:37:55 +0100
Message-ID: <472F0093.6040508@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090305090506050803000604"
Cc: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Krzysztof Piotr Oledzki <ole@ans.pl>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63299 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXKELiF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:38:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090305090506050803000604
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes problem with TCP conntrack and connection reopening.
Applies to stable-2.6.22 and stable-2.6.23.

Please apply, thanks.

--------------090305090506050803000604
Content-Type: text/x-patch;
 name="nfct-tcp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfct-tcp.diff"

[NETFILTER]: nf_conntrack_tcp: fix connection reopening

With your description I could reproduce the bug and actually you were
completely right: the code above is incorrect. Somehow I was able to
misread RFC1122 and mixed the roles :-(:

   When a connection is >>closed actively<<, it MUST linger in
   TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
   However, it MAY >>accept<< a new SYN from the remote TCP to
   reopen the connection directly from TIME-WAIT state, if it:
   [...]

The fix is as follows: if the receiver initiated an active close, then the
sender may reopen the connection - otherwise try to figure out if we hold
a dead connection.

Upstream commits: 17311393 + bc34b841

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 985721925ca65c60566ce72b327e2977d8fbb0f7
tree 8dd67a070bd71d43d4eb95c16fc364f3ae0a8340
parent 2ffb1c81aa78b9a7c0b59e08d257e82773d8a2ff
author Patrick McHardy <kaber@trash.net> Mon, 05 Nov 2007 12:20:12 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 05 Nov 2007 12:20:12 +0100

 net/netfilter/nf_conntrack_proto_tcp.c |   38 ++++++++++++++------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ccdd5d2..2721ff4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -839,6 +839,22 @@ static int tcp_packet(struct nf_conn *conntrack,
 	new_state = tcp_conntracks[dir][index][old_state];
 
 	switch (new_state) {
+	case TCP_CONNTRACK_SYN_SENT:
+		if (old_state < TCP_CONNTRACK_TIME_WAIT)
+			break;
+		if ((conntrack->proto.tcp.seen[!dir].flags &
+			IP_CT_TCP_FLAG_CLOSE_INIT)
+		    || (conntrack->proto.tcp.last_dir == dir
+		        && conntrack->proto.tcp.last_index == TCP_RST_SET)) {
+			/* Attempt to reopen a closed/aborted connection.
+			 * Delete this connection and look up again. */
+			write_unlock_bh(&tcp_lock);
+			if (del_timer(&conntrack->timeout))
+				conntrack->timeout.function((unsigned long)
+							    conntrack);
+			return -NF_REPEAT;
+		}
+		/* Fall through */
 	case TCP_CONNTRACK_IGNORE:
 		/* Ignored packets:
 		 *
@@ -888,27 +904,6 @@ static int tcp_packet(struct nf_conn *conntrack,
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 				  "nf_ct_tcp: invalid state ");
 		return -NF_ACCEPT;
-	case TCP_CONNTRACK_SYN_SENT:
-		if (old_state < TCP_CONNTRACK_TIME_WAIT)
-			break;
-		if ((conntrack->proto.tcp.seen[dir].flags &
-			IP_CT_TCP_FLAG_CLOSE_INIT)
-		    || after(ntohl(th->seq),
-			     conntrack->proto.tcp.seen[dir].td_end)) {
-			/* Attempt to reopen a closed connection.
-			* Delete this connection and look up again. */
-			write_unlock_bh(&tcp_lock);
-			if (del_timer(&conntrack->timeout))
-				conntrack->timeout.function((unsigned long)
-							    conntrack);
-			return -NF_REPEAT;
-		} else {
-			write_unlock_bh(&tcp_lock);
-			if (LOG_INVALID(IPPROTO_TCP))
-				nf_log_packet(pf, 0, skb, NULL, NULL,
-					      NULL, "nf_ct_tcp: invalid SYN");
-			return -NF_ACCEPT;
-		}
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
 		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
@@ -941,6 +936,7 @@ static int tcp_packet(struct nf_conn *conntrack,
      in_window:
 	/* From now on we have got in-window packets */
 	conntrack->proto.tcp.last_index = index;
+	conntrack->proto.tcp.last_dir = dir;
 
 	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
 	       "syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",

--------------090305090506050803000604--
