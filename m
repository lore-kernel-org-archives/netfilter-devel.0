From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/4] netfilter: nf_tables: add nft_dereference() macro
Date: Tue, 18 Feb 2014 18:06:49 +0000
Message-ID: <1392746810-22456-4-git-send-email-kaber@trash.net>
References: <1392746810-22456-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62026 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaBRSHC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:07:02 -0500
In-Reply-To: <1392746810-22456-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h | 4 ++++
 net/netfilter/nf_tables_api.c     | 3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e7e14ff..81abd61 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netlink.h>
@@ -521,6 +522,9 @@ void nft_unregister_chain_type(const struct nf_chain_type *);
 int nft_register_expr(struct nft_expr_type *);
 void nft_unregister_expr(struct nft_expr_type *);
 
+#define nft_dereference(p)					\
+	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
+
 #define MODULE_ALIAS_NFT_FAMILY(family)	\
 	MODULE_ALIAS("nft-afinfo-" __stringify(family))
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index adce01e..4b7e14d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -794,9 +794,8 @@ nf_tables_counters(struct nft_base_chain *chain, const struct nlattr *attr)
 	stats->pkts = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
 
 	if (chain->stats) {
-		/* nfnl_lock is held, add some nfnl function for this, later */
 		struct nft_stats __percpu *oldstats =
-			rcu_dereference_protected(chain->stats, 1);
+				nft_dereference(chain->stats);
 
 		rcu_assign_pointer(chain->stats, newstats);
 		synchronize_rcu();
-- 
1.8.5.3

