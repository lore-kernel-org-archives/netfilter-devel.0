From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: lower timeout to RETRANS seconds if window is 0
Date: Sun, 19 Nov 2017 21:27:28 +0100
Message-ID: <20171119202728.13756-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44534 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750952AbdKSU1Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Nov 2017 15:27:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When zero window is announced we can get into a situation where
connection stays around forever:

1. One side announces zero window.
2. Other side closes.

In this case, no FIN is sent (stuck in send queue).

Unless other side opens the window up again conntrack
stays in ESTABLISHED state for a very long time.

Lets alleviate this by lowering the timeout to RETRANS (5 minutes),
the other end should be sending zero window probes to keep the
connection established as long as a socket still exists.

Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c11b04d269ea..684cc29010a0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1039,6 +1039,9 @@ static int tcp_packet(struct nf_conn *ct,
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
 		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
+	else if (ct->proto.tcp.last_win == 0 &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
+		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else
 		timeout = timeouts[new_state];
 	spin_unlock_bh(&ct->lock);
-- 
2.13.6

