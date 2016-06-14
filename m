From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_tables: fix a wrong check to skip the inactive rules
Date: Tue, 14 Jun 2016 20:13:04 +0800
Message-ID: <1465906384-55985-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:48812 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbcFNMNs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 08:13:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

nft_genmask_cur has already done left-shift operator on the gencursor,
so there's no need to do left-shift operator on it again.

Fixes: ea4bd995b0f2 ("netfilter: nf_tables: add transaction helper functions")
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
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
2.5.5


