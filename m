From: fgao@ikuai8.com
Subject: [PATCH nf-next v3 1/1] netfilter: nf_tables: Eliminate duplicated codes in nf_tables_table_enable
Date: Fri, 20 Jan 2017 15:36:43 +0800
Message-ID: <1484897803-118987-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg320.qq.com ([14.17.32.29]:44583 "EHLO smtpbg320.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdATHpB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2017 02:45:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Feng <fgao@ikuai8.com>

When something failed in nf_tables_table_enable, it would unregister
the chains. But the rollback codes are same as nf_tables_table_disable
almostly, except there is one counter check.
Now create one wrapper function to eliminate the duplicated codes.

Signed-off-by: Feng <fgao@ikuai8.com>
---
 v3: Use "cnt--" instead of "--cnt";
 v2: Use cnt "0" as unlimited rules counter, per Pablo;
 v1: Initial version;

 net/netfilter/nf_tables_api.c | 47 ++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a019a87..b313c85 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -576,6 +576,27 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+static void _nf_tables_table_disable(struct net *net,
+				     const struct nft_af_info *afi,
+				     struct nft_table *table,
+				     u32 cnt)
+{
+	struct nft_chain *chain;
+
+	list_for_each_entry(chain, &table->chains, list) {
+		if (!nft_is_active_next(net, chain))
+			continue;
+		if (!(chain->flags & NFT_BASE_CHAIN))
+			continue;
+
+		if (cnt && cnt-- == 0)
+			break;
+
+		nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
+					afi->nops);
+	}
+}
+
 static int nf_tables_table_enable(struct net *net,
 				  const struct nft_af_info *afi,
 				  struct nft_table *table)
@@ -598,18 +619,8 @@ static int nf_tables_table_enable(struct net *net,
 	}
 	return 0;
 err:
-	list_for_each_entry(chain, &table->chains, list) {
-		if (!nft_is_active_next(net, chain))
-			continue;
-		if (!(chain->flags & NFT_BASE_CHAIN))
-			continue;
-
-		if (i-- <= 0)
-			break;
-
-		nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
-					afi->nops);
-	}
+	if (i)
+		_nf_tables_table_disable(net, afi, table, i);
 	return err;
 }
 
@@ -617,17 +628,7 @@ static void nf_tables_table_disable(struct net *net,
 				    const struct nft_af_info *afi,
 				    struct nft_table *table)
 {
-	struct nft_chain *chain;
-
-	list_for_each_entry(chain, &table->chains, list) {
-		if (!nft_is_active_next(net, chain))
-			continue;
-		if (!(chain->flags & NFT_BASE_CHAIN))
-			continue;
-
-		nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
-					afi->nops);
-	}
+	_nf_tables_table_disable(net, afi, table, 0);
 }
 
 static int nf_tables_updtable(struct nft_ctx *ctx)
-- 
1.9.1


