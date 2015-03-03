From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] netfilter: nf_tables: fix transaction race condition
Date: Tue,  3 Mar 2015 20:04:18 +0000
Message-ID: <1425413060-6187-2-git-send-email-kaber@trash.net>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44926 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbbCCUE0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 15:04:26 -0500
In-Reply-To: <1425413060-6187-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A race condition exists in the rule transaction code for rules that
get added and removed within the same transaction.

The new rule starts out as inactive in the current and active in the
next generation and is inserted into the ruleset. When it is deleted,
it is additionally set to inactive in the next generation as well.

On commit the next generation is begun, then the actions are finalized.
For the new rule this would mean clearing out the inactive bit for
the previously current, now next generation.

However nft_rule_clear() clears out the bits for *both* generations,
activating the rule in the current generation, where it should be
deactivated due to being deleted. The rule will thus be active until
the deletion is finalized, removing the rule from the ruleset.

Similarly, when aborting a transaction for the same case, the undo
of insertion will remove it from the RCU protected rule list, the
deletion will clear out all bits. However until the next RCU
synchronization after all operations have been undone, the rule is
active on CPUs which can still see the rule on the list.

Generally, there may never be any modifications of the current
generations' inactive bit since this defeats the entire purpose of
atomicity. Change nft_rule_clear() to only touch the next generations
bit to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a8c9462..6fb532b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -227,7 +227,7 @@ nft_rule_deactivate_next(struct net *net, struct nft_rule *rule)
 
 static inline void nft_rule_clear(struct net *net, struct nft_rule *rule)
 {
-	rule->genmask = 0;
+	rule->genmask &= ~(1 << gencursor_next(net));
 }
 
 static int
-- 
2.1.0

