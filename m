From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 1/7] netlink: make dump functions object argument constant
Date: Wed, 27 Apr 2016 12:29:44 +0100
Message-ID: <1461756590-22880-2-git-send-email-kaber@trash.net>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33522 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbcD0L3z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 07:29:55 -0400
In-Reply-To: <1461756590-22880-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/netlink.h  | 10 +++++-----
 include/nftables.h |  2 +-
 src/netlink.c      | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 8444742..80b7c60 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -149,11 +149,11 @@ extern int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle
 extern int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc, struct set *set);
 
-extern void netlink_dump_table(struct nftnl_table *nlt);
-extern void netlink_dump_chain(struct nftnl_chain *nlc);
-extern void netlink_dump_rule(struct nftnl_rule *nlr);
-extern void netlink_dump_expr(struct nftnl_expr *nle);
-extern void netlink_dump_set(struct nftnl_set *nls);
+extern void netlink_dump_table(const struct nftnl_table *nlt);
+extern void netlink_dump_chain(const struct nftnl_chain *nlc);
+extern void netlink_dump_rule(const struct nftnl_rule *nlr);
+extern void netlink_dump_expr(const struct nftnl_expr *nle);
+extern void netlink_dump_set(const struct nftnl_set *nls);
 
 extern int netlink_batch_send(struct list_head *err_list);
 
diff --git a/include/nftables.h b/include/nftables.h
index cf19de8..d3f471b 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -52,7 +52,7 @@ struct location {
 			unsigned int		last_column;
 		};
 		struct {
-			void			*nle;
+			const void		*nle;
 		};
 	};
 };
diff --git a/src/netlink.c b/src/netlink.c
index 6e88ddb..13fb82f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -429,7 +429,7 @@ int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-void netlink_dump_rule(struct nftnl_rule *nlr)
+void netlink_dump_rule(const struct nftnl_rule *nlr)
 {
 #ifdef DEBUG
 	char buf[4096];
@@ -442,7 +442,7 @@ void netlink_dump_rule(struct nftnl_rule *nlr)
 #endif
 }
 
-void netlink_dump_expr(struct nftnl_expr *nle)
+void netlink_dump_expr(const struct nftnl_expr *nle)
 {
 #ifdef DEBUG
 	char buf[4096];
@@ -506,7 +506,7 @@ static int netlink_flush_rules(struct netlink_ctx *ctx, const struct handle *h,
 	return netlink_del_rule_batch(ctx, h, loc);
 }
 
-void netlink_dump_chain(struct nftnl_chain *nlc)
+void netlink_dump_chain(const struct nftnl_chain *nlc)
 {
 #ifdef DEBUG
 	char buf[4096];
@@ -920,7 +920,7 @@ int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 		return netlink_del_table_compat(ctx, h, loc);
 }
 
-void netlink_dump_table(struct nftnl_table *nlt)
+void netlink_dump_table(const struct nftnl_table *nlt)
 {
 #ifdef DEBUG
 	char buf[4096];
@@ -1035,7 +1035,7 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 	}
 }
 
-void netlink_dump_set(struct nftnl_set *nls)
+void netlink_dump_set(const struct nftnl_set *nls)
 {
 #ifdef DEBUG
 	char buf[4096];
-- 
2.5.5

