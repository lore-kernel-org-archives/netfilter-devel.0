From: JingPiao Chen <chenjingpiao@gmail.com>
Subject: [PATCH] netfilter: nf_tables: fix update chain error
Date: Sat, 23 Sep 2017 17:10:44 +0800
Message-ID: <20170923091044.2947-1-chenjingpiao@gmail.com>
Cc: JingPiao Chen <chenjingpiao@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37165 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdIWJKw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Sep 2017 05:10:52 -0400
Received: by mail-pg0-f68.google.com with SMTP id v5so1996953pgn.4
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Sep 2017 02:10:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9299271..f98ca8c 100644
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
2.7.4

