From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/12] netfilter: nf_tables: fix update chain error
Date: Mon,  9 Oct 2017 18:25:40 +0200
Message-ID: <1507566346-32553-7-git-send-email-pablo@netfilter.org>
References: <1507566346-32553-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755210AbdJIQ0B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2017 12:26:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C36B6C0B27
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 18:25:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B641FDA38B
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2017 18:25:59 +0200 (CEST)
In-Reply-To: <1507566346-32553-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: JingPiao Chen <chenjingpiao@gmail.com>

 # nft add table filter
 # nft add chain filter c1
 # nft rename chain filter c1 c2

Error: Could not process rule: No such file or directory
rename chain filter c1 c2
^^^^^^^^^^^^^^^^^^^^^^^^^^

 # nft add chain filter c2
 # nft rename chain filter c1 c2
 # nft list table filter

table ip filter {
	chain c2 {
	}

	chain c2 {
	}
}

Fixes: 664b0f8cd8 ("netfilter: nf_tables: add generation mask to chains")
Signed-off-by: JingPiao Chen <chenjingpiao@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 929927171426..f98ca8c6aa59 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1487,8 +1487,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 		chain2 = nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME],
 						genmask);
-		if (IS_ERR(chain2))
-			return PTR_ERR(chain2);
+		if (!IS_ERR(chain2))
+			return -EEXIST;
 	}
 
 	if (nla[NFTA_CHAIN_COUNTERS]) {
-- 
2.1.4

