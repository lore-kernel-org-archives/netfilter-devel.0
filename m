From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening
Date: Thu, 11 Oct 2007 18:44:04 +0200 (MEST)
Message-ID: <20071011164351.31373.99334.sendpatchset@localhost.localdomain>
References: <20071011164349.31373.23530.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64520 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXJKQoG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:44:06 -0400
In-Reply-To: <20071011164349.31373.23530.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c24af9fc1daa4e809ad2c5032d6504e57474bd1a
tree 1c75a5d1c7494551731acc83cbdae099814f2f7c
parent d23410bf25ccf95fe91d0f8f56bf2e82fde702a6
author Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> Thu, 11 Oct 2007 06:04:04 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 11 Oct 2007 06:04:04 +0200

 net/netfilter/nf_conntrack_proto_tcp.c |   35 +++++++++++++-------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index df718e7..c707534 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -831,6 +831,20 @@ static int tcp_packet(struct nf_conn *conntrack,
 	tuple = &conntrack->tuplehash[dir].tuple;
 
 	switch (new_state) {
+	case TCP_CONNTRACK_SYN_SENT:
+		if (old_state < TCP_CONNTRACK_TIME_WAIT)
+			break;
+		if (conntrack->proto.tcp.seen[!dir].flags &
+			IP_CT_TCP_FLAG_CLOSE_INIT) {
+			/* Attempt to reopen a closed connection.
+			* Delete this connection and look up again. */
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
@@ -879,27 +893,6 @@ static int tcp_packet(struct nf_conn *conntrack,
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
