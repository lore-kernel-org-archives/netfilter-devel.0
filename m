Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A36AC7EE21
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 23:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjDUXCU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 19:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbjDUXCT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 19:02:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92B8DE57;
        Fri, 21 Apr 2023 16:02:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 03/20] netfilter: nf_tables: don't store address of last rule on jump
Date:   Sat, 22 Apr 2023 01:01:54 +0200
Message-Id: <20230421230211.214635-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Walk the rule headers until the trailer one (last_bit flag set) instead
of stopping at last_rule address.

This avoids the need to store the address when jumping to another chain.

This cuts size of jumpstack array by one third, on 64bit from
384 to 256 bytes.  Still, stack usage is still quite large:

scripts/stackusage:
nf_tables_core.c:258 nft_do_chain    496     static

Next patch will also remove chain pointer.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 6ecd0ba2e546..ec3bab751092 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -205,7 +205,6 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 struct nft_jumpstack {
 	const struct nft_chain *chain;
 	const struct nft_rule_dp *rule;
-	const struct nft_rule_dp *last_rule;
 };
 
 static void expr_call_ops_eval(const struct nft_expr *expr,
@@ -259,9 +258,9 @@ unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 {
 	const struct nft_chain *chain = priv, *basechain = chain;
-	const struct nft_rule_dp *rule, *last_rule;
 	const struct net *net = nft_net(pkt);
 	const struct nft_expr *expr, *last;
+	const struct nft_rule_dp *rule;
 	struct nft_regs regs = {};
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
@@ -279,10 +278,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		blob = rcu_dereference(chain->blob_gen_0);
 
 	rule = (struct nft_rule_dp *)blob->data;
-	last_rule = (void *)blob->data + blob->size;
 next_rule:
 	regs.verdict.code = NFT_CONTINUE;
-	for (; rule < last_rule; rule = nft_rule_next(rule)) {
+	for (; !rule->is_last ; rule = nft_rule_next(rule)) {
 		nft_rule_dp_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
@@ -327,7 +325,6 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 			return NF_DROP;
 		jumpstack[stackptr].chain = chain;
 		jumpstack[stackptr].rule = nft_rule_next(rule);
-		jumpstack[stackptr].last_rule = last_rule;
 		stackptr++;
 		fallthrough;
 	case NFT_GOTO:
@@ -344,7 +341,6 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		stackptr--;
 		chain = jumpstack[stackptr].chain;
 		rule = jumpstack[stackptr].rule;
-		last_rule = jumpstack[stackptr].last_rule;
 		goto next_rule;
 	}
 
-- 
2.30.2

