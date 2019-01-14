From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/7] netfilter: nf_tables: Fix for endless loop when dumping ruleset
Date: Mon, 14 Jan 2019 22:29:34 +0100
Message-ID: <20190114212940.5704-2-pablo@netfilter.org>
References: <20190114212940.5704-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190114212940.5704-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

__nf_tables_dump_rules() stores the current idx value into cb->args[0]
before returning to caller. With multiple chains present, cb->args[0] is
therefore updated after each chain's rules have been traversed. This
though causes the final nf_tables_dump_rules() run (which should return
an skb->len of zero since no rules are left to dump) to continue dumping
rules for each but the first chain. Fix this by moving the cb->args[0]
update to nf_tables_dump_rules().

With no final action to be performed anymore in
__nf_tables_dump_rules(), drop 'out_unfinished' jump label and 'rc'
variable - instead return the appropriate value directly.

Fixes: 241faeceb849c ("netfilter: nf_tables: Speed up selective rule dumps")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2b0a93300dd7..e3ddd8e95e58 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2304,7 +2304,6 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	unsigned int s_idx = cb->args[0];
 	const struct nft_rule *rule;
-	int rc = 1;
 
 	list_for_each_entry_rcu(rule, &chain->rules, list) {
 		if (!nft_is_active(net, rule))
@@ -2321,16 +2320,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
 					table, chain, rule) < 0)
-			goto out_unfinished;
+			return 1;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
 		(*idx)++;
 	}
-	rc = 0;
-out_unfinished:
-	cb->args[0] = *idx;
-	return rc;
+	return 0;
 }
 
 static int nf_tables_dump_rules(struct sk_buff *skb,
@@ -2382,6 +2378,8 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	}
 done:
 	rcu_read_unlock();
+
+	cb->args[0] = idx;
 	return skb->len;
 }
 
-- 
2.11.0
