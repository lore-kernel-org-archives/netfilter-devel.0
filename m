From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 1/5] netfilter: nf_tables: reset rule number counter after jump and goto
Date: Mon, 12 May 2014 16:40:01 +0200
Message-ID: <1399905605-6394-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36564 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758714AbaELOlO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 10:41:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise we start incrementing the rule number counter from the
previous chain iteration.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 8041053..4368c58 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -123,7 +123,7 @@ nft_do_chain(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 	struct nft_data data[NFT_REG_MAX + 1];
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
-	int rulenum = 0;
+	int rulenum;
 	/*
 	 * Cache cursor to avoid problems in case that the cursor is updated
 	 * while traversing the ruleset.
@@ -131,6 +131,7 @@ nft_do_chain(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 	unsigned int gencursor = ACCESS_ONCE(chain->net->nft.gencursor);
 
 do_chain:
+	rulenum = 0;
 	rule = list_entry(&chain->rules, struct nft_rule, list);
 next_rule:
 	data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
-- 
1.7.10.4

