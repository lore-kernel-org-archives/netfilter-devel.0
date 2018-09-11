From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/12] netfilter: nfnetlink_queue: Solve the NFQUEUE/conntrack clash for NF_REPEAT
Date: Tue, 11 Sep 2018 02:20:43 +0200
Message-ID: <20180911002044.9100-12-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Michal 'vorner' Vaner <michal.vaner@avast.com>

NF_REPEAT places the packet at the beginning of the iptables chain
instead of accepting or rejecting it right away. The packet however will
reach the end of the chain and continue to the end of iptables
eventually, so it needs the same handling as NF_ACCEPT and NF_DROP.

Fixes: 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for unconfirmed conntracks")
Signed-off-by: Michal 'vorner' Vaner <michal.vaner@avast.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index ea4ba551abb2..d33094f4ec41 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -233,6 +233,7 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	int err;
 
 	if (verdict == NF_ACCEPT ||
+	    verdict == NF_REPEAT ||
 	    verdict == NF_STOP) {
 		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
-- 
2.11.0
