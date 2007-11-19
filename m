From: <gregkh@suse.de>
Subject: patch netfilter-nf_conntrack_tcp-fix-connection-reopening.patch queued to -stable tree
Date: Mon, 19 Nov 2007 09:36:36 -0800
Message-ID: <20071119173703.49A9014544CD@imap.suse.de>
References: <472F0093.6040508@trash.net>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: kadlec@blackhole.kfki.hu, davem@davemloft.net, gregkh@suse.de,
	kaber@trash.net, netfilter-devel@vger.kernel.org, ole@ans.pl
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:56453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbXKSRhH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:37:07 -0500
In-Reply-To: <472F0093.6040508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: NETFILTER: nf_conntrack_tcp: fix connection reopening

to the 2.6.22-stable tree.  Its filename is

     netfilter-nf_conntrack_tcp-fix-connection-reopening.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Mon Nov  5 03:38:25 2007
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Mon, 05 Nov 2007 12:37:55 +0100
Subject: NETFILTER: nf_conntrack_tcp: fix connection reopening
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Krzysztof Piotr Oledzki <ole@ans.pl>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Message-ID: <472F0093.6040508@trash.net>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Upstream commits: 17311393 + bc34b841 merged together.  Merge done by
Patrick McHardy <kaber@trash.net>

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/netfilter/nf_conntrack_proto_tcp.c |   38 ++++++++++++++-------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -839,6 +839,22 @@ static int tcp_packet(struct nf_conn *co
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
@@ -888,27 +904,6 @@ static int tcp_packet(struct nf_conn *co
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
@@ -941,6 +936,7 @@ static int tcp_packet(struct nf_conn *co
      in_window:
 	/* From now on we have got in-window packets */
 	conntrack->proto.tcp.last_index = index;
+	conntrack->proto.tcp.last_dir = dir;
 
 	DEBUGP("tcp_conntracks: src=%u.%u.%u.%u:%hu dst=%u.%u.%u.%u:%hu "
 	       "syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",


Patches currently in stable-queue which might be from kadlec@blackhole.kfki.hu are

queue-2.6.22/netfilter-nf_conntrack_tcp-fix-connection-reopening.patch
