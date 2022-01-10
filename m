Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AEA7C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jan 2022 12:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245450AbiAJM2i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 07:28:38 -0500
Received: from mail.netfilter.org ([217.70.188.207]:43744 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245449AbiAJM2f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 07:28:35 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E7A1C64291
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jan 2022 13:25:42 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH net-next] netfilter: nf_tables: fix compile warnings
Date:   Mon, 10 Jan 2022 13:28:08 +0100
Message-Id: <20220110122808.272697-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove unused variable and fix missing initialization.

>> net/netfilter/nf_tables_api.c:8266:6: warning: variable 'i' set but not used [-Wunused-but-set-variable]
           int i;
               ^
>> net/netfilter/nf_tables_api.c:8277:4: warning: variable 'data_size' is uninitialized when used here [-Wuninitialized]
                           data_size += sizeof(*prule) + rule->dlen;
                           ^~~~~~~~~
   net/netfilter/nf_tables_api.c:8262:30: note: initialize the variable 'data_size' to silence this warning
           unsigned int size, data_size;

Fixes: 2c865a8a28a1 ("netfilter: nf_tables: add rule blob layout")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Please, directly apply this fix to net-next.

 net/netfilter/nf_tables_api.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eb12fc9b803d..1f80a1fae63b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8260,18 +8260,16 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 {
 	const struct nft_expr *expr, *last;
 	struct nft_regs_track track = {};
-	unsigned int size, data_size;
+	unsigned int size, data_size = 0;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
 	struct nft_rule *rule;
-	int i;
 
 	/* already handled or inactive chain? */
 	if (chain->blob_next || !nft_is_active_next(net, chain))
 		return 0;
 
 	rule = list_entry(&chain->rules, struct nft_rule, list);
-	i = 0;
 
 	list_for_each_entry_continue(rule, &chain->rules, list) {
 		if (nft_is_active_next(net, rule)) {
-- 
2.30.2

