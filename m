From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/22] netfilter: bridge: remove unneeded rcu_read_lock
Date: Mon, 20 Mar 2017 11:08:36 +0100
Message-ID: <1490004530-9128-9-git-send-email-pablo@netfilter.org>
References: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

as comment says, the function is always called with rcu read lock held.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 95087e6e8258..52739e6c610e 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1016,13 +1016,10 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 	if (!elem)
 		return okfn(net, sk, skb);
 
-	/* We may already have this, but read-locks nest anyway */
-	rcu_read_lock();
 	nf_hook_state_init(&state, hook, NFPROTO_BRIDGE, indev, outdev,
 			   sk, net, okfn);
 
 	ret = nf_hook_slow(skb, &state, elem);
-	rcu_read_unlock();
 	if (ret == 1)
 		ret = okfn(net, sk, skb);
 
-- 
2.1.4
