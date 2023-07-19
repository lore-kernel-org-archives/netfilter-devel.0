Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB9EC0015E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 18:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjGSSTv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGSSTu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2023 14:19:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E76161FC8
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 11:19:48 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: skip bound chain in netns release path
Date:   Wed, 19 Jul 2023 20:19:43 +0200
Message-Id: <20230719181943.44199-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip bound chain from netns release path, the rule that owns this chain
releases these objects.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 237f739da3ca..9dafcae0f39c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10799,6 +10799,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	ctx.family = table->family;
 	ctx.table = table;
 	list_for_each_entry(chain, &table->chains, list) {
+		if (nft_chain_is_bound(chain))
+			continue;
+
 		ctx.chain = chain;
 		list_for_each_entry_safe(rule, nr, &chain->rules, list) {
 			list_del(&rule->list);
-- 
2.30.2

