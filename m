From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_tables: destroy the set if fail to add transaction
Date: Sat, 29 Oct 2016 22:03:05 +0800
Message-ID: <1477749785-14092-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:39033 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964851AbcJ2ODg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 10:03:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When the memory is exhausted, then we will fail to add the NFT_MSG_NEWSET
transaction. In such case, we should destroy the set before we free it.

Fixes: 958bee14d071 ("netfilter: nf_tables: use new transaction infrastructure to handle sets")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 365d31b..7d6a626 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2956,12 +2956,14 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	list_add_tail_rcu(&set->list, &table->sets);
 	table->use++;
 	return 0;
 
+err3:
+	ops->destroy(set);
 err2:
 	kfree(set);
 err1:
-- 
2.5.5


