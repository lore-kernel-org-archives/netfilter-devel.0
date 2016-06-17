From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/7] netfilter: nf_tables: fix a wrong check to skip the inactive rules
Date: Fri, 17 Jun 2016 20:25:17 +0200
Message-ID: <1466187919-12800-6-git-send-email-pablo@netfilter.org>
References: <1466187919-12800-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1466187919-12800-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <liping.zhang@spreadtrum.com>

nft_genmask_cur has already done left-shift operator on the gencursor,
so there's no need to do left-shift operator on it again.

Fixes: ea4bd995b0f2 ("netfilter: nf_tables: add transaction helper functions")
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index e9f8dff..fb8b589 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -143,7 +143,7 @@ next_rule:
 	list_for_each_entry_continue_rcu(rule, &chain->rules, list) {
 
 		/* This rule is not active, skip. */
-		if (unlikely(rule->genmask & (1 << gencursor)))
+		if (unlikely(rule->genmask & gencursor))
 			continue;
 
 		rulenum++;
-- 
2.1.4
