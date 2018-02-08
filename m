From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net v2] ipt_CLUSTERIP: fix a refcount bug in clusterip_config_find_get()
Date: Thu,  8 Feb 2018 13:53:52 -0800
Message-ID: <20180208215352.8294-1-xiyou.wangcong@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In clusterip_config_find_get() we hold RCU read lock so it could
run concurrently with clusterip_config_entry_put(), as a result,
the refcnt could go back to 1 from 0, which leads to a double
list_del()... Just replace refcount_inc() with
refcount_inc_not_zero(), as for c->refcount.

Fixes: d73f33b16883 ("netfilter: CLUSTERIP: RCU conversion")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1ff72b87a066..4b02ab39ebc5 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -154,8 +154,12 @@ clusterip_config_find_get(struct net *net, __be32 clusterip, int entry)
 #endif
 		if (unlikely(!refcount_inc_not_zero(&c->refcount)))
 			c = NULL;
-		else if (entry)
-			refcount_inc(&c->entries);
+		else if (entry) {
+			if (unlikely(!refcount_inc_not_zero(&c->entries))) {
+				clusterip_config_put(c);
+				c = NULL;
+			}
+		}
 	}
 	rcu_read_unlock_bh();
 
-- 
2.13.0
