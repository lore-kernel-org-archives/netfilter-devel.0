From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/6] netfilter: nfnetlink_queue: avoid harmless unnitialized variable warnings
Date: Mon, 14 Dec 2015 12:25:41 +0100
Message-ID: <1450092346-3281-2-git-send-email-pablo@netfilter.org>
References: <1450092346-3281-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1450092346-3281-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Several ARM default configurations give us warnings on recent
compilers about potentially uninitialized variables in the
nfnetlink code in two functions:

net/netfilter/nfnetlink_queue.c: In function 'nfqnl_build_packet_message':
net/netfilter/nfnetlink_queue.c:519:19: warning: 'nfnl_ct' may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)

Moving the rcu_dereference(nfnl_ct_hook) call outside of the
conditional code avoids the warning without forcing us to
preinitialize the variable.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: a4b4766c3ceb ("netfilter: nfnetlink_queue: rename related to nfqueue attaching conntrack info")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7d81d28..3e24054 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -365,8 +365,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		break;
 	}
 
+	nfnl_ct = rcu_dereference(nfnl_ct_hook);
+
 	if (queue->flags & NFQA_CFG_F_CONNTRACK) {
-		nfnl_ct = rcu_dereference(nfnl_ct_hook);
 		if (nfnl_ct != NULL) {
 			ct = nfnl_ct->get_ct(entskb, &ctinfo);
 			if (ct != NULL)
@@ -1064,9 +1065,10 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	if (entry == NULL)
 		return -ENOENT;
 
+	/* rcu lock already held from nfnl->call_rcu. */
+	nfnl_ct = rcu_dereference(nfnl_ct_hook);
+
 	if (nfqa[NFQA_CT]) {
-		/* rcu lock already held from nfnl->call_rcu. */
-		nfnl_ct = rcu_dereference(nfnl_ct_hook);
 		if (nfnl_ct != NULL)
 			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
 	}
-- 
2.1.4
