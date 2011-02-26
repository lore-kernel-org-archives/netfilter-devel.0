From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_ct_tcp: better handling for SYN retransmissions
	after SYN+ACK
Date: Sat, 26 Feb 2011 04:33:24 +0100
Message-ID: <20110226033324.4335.53000.stgit@decadence>
References: <20110226032834.4335.74168.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54740 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab1BZDjr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Feb 2011 22:39:47 -0500
In-Reply-To: <20110226032834.4335.74168.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Consider the following scenario:

  client         firewall       server
     |              |             |
     |     syn      |     syn     |
     |------------->|------------>|
     |              |             |
     |   syn+ack    |   syn+ack   |
     |      x<------|<------------|      syn+ack got lost!
     |              |             |
     |     syn      |     syn     |
     |------------->|------------>|
     |              |             |
     |   syn+ack    |   syn+ack   |
     |<-------------|<------------|
     |              |             |

Note that the syn+ack is lost after we have seen it. Without this
patch, the TCP tracking ignores the retransmitted SYN without
checking if the sequence number is in the window.

This patch also helps a lot to conntrackd in stress scenarios
(assumming a client that generates lots of small TCP connections).
During the failover, consider that the new primary has injected
one outdated flow in SYN_RECV state (this is likely to happen if
the conntrack event rate is high because the backup will be a bit
delayed from the primary). With the current code, if the client
starts a new fresh connection that matches the tuple, the SYN
packet will be ignored without updating the state tracking, and
the SYN+ACK in reply will blocked as it will not pass checkings
III or IV (since all state tracking in the original direction is
not initialized because of the SYN packet was ignored).

Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3fb2b73..be0b84d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -142,12 +142,12 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
 	{
 /* ORIGINAL */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
-/*syn*/	   { sSS, sSS, sIG, sIG, sIG, sIG, sIG, sSS, sSS, sS2 },
+/*syn*/	   { sSS, sSS, sSR, sIG, sIG, sIG, sIG, sSS, sSS, sS2 },
 /*
  *	sNO -> sSS	Initialize a new connection
  *	sSS -> sSS	Retransmitted SYN
  *	sS2 -> sS2	Late retransmitted SYN
- *	sSR -> sIG
+ *	sSR -> sSR	Retransmitted SYN, SYN/ACK got lost?
  *	sES -> sIG	Error: SYNs in window outside the SYN_SENT state
  *			are errors. Receiver will reply with RST
  *			and close the connection.

