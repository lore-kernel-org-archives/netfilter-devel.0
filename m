From: Greg KH <gregkh@suse.de>
Subject: [patch 16/23] NETFILTER: nf_conntrack_tcp: fix connection reopening
Date: Wed, 14 Nov 2007 22:20:54 -0800
Message-ID: <20071115062054.GQ8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
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
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46023 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763156AbXKOGWY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:24 -0500
Content-Disposition: inline; filename="netfilter-nf_conntrack_tcp-fix-connection-reopening.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------


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
@@ -831,6 +831,22 @@ static int tcp_packet(struct nf_conn *co
 	tuple = &conntrack->tuplehash[dir].tuple;
 
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
@@ -879,27 +895,6 @@ static int tcp_packet(struct nf_conn *co
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
@@ -932,6 +927,7 @@ static int tcp_packet(struct nf_conn *co
      in_window:
 	/* From now on we have got in-window packets */
 	conntrack->proto.tcp.last_index = index;
+	conntrack->proto.tcp.last_dir = dir;
 
 	pr_debug("tcp_conntracks: ");
 	NF_CT_DUMP_TUPLE(tuple);

-- 
