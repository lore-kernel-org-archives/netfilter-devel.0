From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/3] netfilter: ipset: Missing nfnl_lock()/nfnl_unlock() is added to ip_set_net_exit()
Date: Sat,  6 Jan 2018 16:36:09 +0100
Message-ID: <1515252969-26094-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:46932 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753279AbeAFPnu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 10:43:50 -0500
In-Reply-To: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patch "netfilter: ipset: use nfnl_mutex_is_locked" is added the real
mutex locking check, which revealed the missing locking in ip_set_net_exit().

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Reported-by: syzbot+36b06f219f2439fe62e1@syzkaller.appspotmail.com
---
 net/netfilter/ipset/ip_set_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e002990..728bf31 100644
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
2.1.4

