From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/12] netfilter: conntrack: lower timeout to RETRANS seconds if window is 0
Date: Wed, 13 Dec 2017 19:45:13 +0100
Message-ID: <20171213184520.8193-6-pablo@netfilter.org>
References: <20171213184520.8193-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171213184520.8193-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b12fc07111d0..37ef35b861f2 100644
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
2.11.0
