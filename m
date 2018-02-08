From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net] ipt_CLUSTERIP: fix a refcount bug in clusterip_config_find_get()
Date: Wed,  7 Feb 2018 21:59:18 -0800
Message-ID: <20180208055918.20411-2-xiyou.wangcong@gmail.com>
References: <20180208055918.20411-1-xiyou.wangcong@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45464 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeBHF7f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Feb 2018 00:59:35 -0500
In-Reply-To: <20180208055918.20411-1-xiyou.wangcong@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In clusterip_config_find_get() we hold RCU read lock so it could
run concurrently with clusterip_config_entry_put(), as a result,
the refcnt could go back to 1 from 0, which leads to a double
list_del()... Just replace refcount_inc() with
refcount_inc_not_zero(), as for c->refcount.

Fixes: d73f33b16883 ("netfilter: CLUSTERIP: RCU conversion")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1ff72b87a066..4537b1686c7c 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -154,8 +154,10 @@ clusterip_config_find_get(struct net *net, __be32 clusterip, int entry)
 #endif
 		if (unlikely(!refcount_inc_not_zero(&c->refcount)))
 			c = NULL;
-		else if (entry)
-			refcount_inc(&c->entries);
+		else if (entry) {
+			if (unlikely(!refcount_inc_not_zero(&c->entries)))
+				c = NULL;
+		}
 	}
 	rcu_read_unlock_bh();
 
-- 
2.13.0

