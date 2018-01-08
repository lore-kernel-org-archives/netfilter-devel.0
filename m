From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 52/52] netfilter: ipset: Missing nfnl_lock()/nfnl_unlock() is added to ip_set_net_exit()
Date: Mon,  8 Jan 2018 21:20:00 +0100
Message-ID: <20180108202000.12989-53-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Patch "netfilter: ipset: use nfnl_mutex_is_locked" is added the real
mutex locking check, which revealed the missing locking in ip_set_net_exit().

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Reported-by: syzbot+36b06f219f2439fe62e1@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e00299051e79..728bf31bb386 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -2078,6 +2078,7 @@ ip_set_net_exit(struct net *net)
 
 	inst->is_deleted = true; /* flag for ip_set_nfnl_put */
 
+	nfnl_lock(NFNL_SUBSYS_IPSET);
 	for (i = 0; i < inst->ip_set_max; i++) {
 		set = ip_set(inst, i);
 		if (set) {
@@ -2085,6 +2086,7 @@ ip_set_net_exit(struct net *net)
 			ip_set_destroy_set(set);
 		}
 	}
+	nfnl_unlock(NFNL_SUBSYS_IPSET);
 	kfree(rcu_dereference_protected(inst->ip_set_list, 1));
 }
 
-- 
2.11.0
