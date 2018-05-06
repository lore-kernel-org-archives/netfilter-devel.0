From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 35/51] netfilter: xtables: use ipt_get_target_c instead of ipt_get_target
Date: Mon,  7 May 2018 00:46:53 +0200
Message-ID: <20180506224709.29100-36-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

ipt_get_target is used to get struct xt_entry_target
and ipt_get_target_c is used to get const struct xt_entry_target.
However in the ipt_do_table, ipt_get_target is used to get
const struct xt_entry_target. it should be replaced by ipt_get_target_c.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ip_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 44b308d93ec2..444f125f3974 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -300,7 +300,7 @@ ipt_do_table(struct sk_buff *skb,
 		counter = xt_get_this_cpu_counter(&e->counters);
 		ADD_COUNTER(*counter, skb->len, 1);
 
-		t = ipt_get_target(e);
+		t = ipt_get_target_c(e);
 		WARN_ON(!t->u.kernel.target);
 
 #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
-- 
2.11.0
