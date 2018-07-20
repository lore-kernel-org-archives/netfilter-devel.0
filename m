From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/38] netfilter: flowtables: use fixed renew timeout on teardown
Date: Fri, 20 Jul 2018 15:08:30 +0200
Message-ID: <20180720130906.27687-3-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This is one of the very few external callers of ->get_timeouts(),

We can use a fixed timeout instead, conntrack core will refresh this in
case a new packet comes within this period.

Use of ESTABLISHED timeout seems way too huge anyway.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index eb0d1658ac05..d8125616edc7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -107,11 +107,12 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 	tcp->seen[1].td_maxwin = 0;
 }
 
+#define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
+#define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
+
 static void flow_offload_fixup_ct_state(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
-	struct net *net = nf_ct_net(ct);
-	unsigned int *timeouts;
 	unsigned int timeout;
 	int l4num;
 
@@ -123,14 +124,10 @@ static void flow_offload_fixup_ct_state(struct nf_conn *ct)
 	if (!l4proto)
 		return;
 
-	timeouts = l4proto->get_timeouts(net);
-	if (!timeouts)
-		return;
-
 	if (l4num == IPPROTO_TCP)
-		timeout = timeouts[TCP_CONNTRACK_ESTABLISHED];
+		timeout = NF_FLOWTABLE_TCP_PICKUP_TIMEOUT;
 	else if (l4num == IPPROTO_UDP)
-		timeout = timeouts[UDP_CT_REPLIED];
+		timeout = NF_FLOWTABLE_UDP_PICKUP_TIMEOUT;
 	else
 		return;
 
-- 
2.11.0
