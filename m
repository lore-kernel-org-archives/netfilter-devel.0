From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: don't return error in netlink_linearize_rule()
Date: Mon, 18 Aug 2014 22:33:09 +0200
Message-ID: <1408393989-5941-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44573 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaHRUgI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 16:36:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function converts the rule from the list of statements to the
netlink message format. The only two possible errors that can make
this function to fail are memory exhaustion and malformed statements
which inmediately stop the execution of nft.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h       |    6 +++---
 src/netlink.c           |   16 +++++++---------
 src/netlink_linearize.c |    5 ++---
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index af5dcd9..d7d5c2d 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -65,9 +65,9 @@ extern struct expr *netlink_alloc_data(const struct location *loc,
 				       const struct nft_data_delinearize *nld,
 				       enum nft_registers dreg);
 
-extern int netlink_linearize_rule(struct netlink_ctx *ctx,
-				  struct nft_rule *nlr,
-				  const struct rule *rule);
+extern void netlink_linearize_rule(struct netlink_ctx *ctx,
+				   struct nft_rule *nlr,
+				   const struct rule *rule);
 extern struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 					     const struct nft_rule *r);
 
diff --git a/src/netlink.c b/src/netlink.c
index dc7a7c4..102f799 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -354,16 +354,14 @@ int netlink_add_rule_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nlr = alloc_nft_rule(&rule->handle);
-	err = netlink_linearize_rule(ctx, nlr, rule);
-	if (err == 0) {
-		err = mnl_nft_rule_batch_add(nlr, flags | NLM_F_EXCL,
-					     ctx->seqnum);
-		if (err < 0)
-			netlink_io_error(ctx, &rule->location,
-					 "Could not add rule to batch: %s",
-					 strerror(errno));
-	}
+	netlink_linearize_rule(ctx, nlr, rule);
+	err = mnl_nft_rule_batch_add(nlr, flags | NLM_F_EXCL, ctx->seqnum);
 	nft_rule_free(nlr);
+	if (err < 0) {
+		netlink_io_error(ctx, &rule->location,
+				 "Could not add rule to batch: %s",
+				 strerror(errno));
+	}
 	return err;
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 075e243..d950299 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -746,8 +746,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 	}
 }
 
-int netlink_linearize_rule(struct netlink_ctx *ctx, struct nft_rule *nlr,
-			   const struct rule *rule)
+void netlink_linearize_rule(struct netlink_ctx *ctx, struct nft_rule *nlr,
+			    const struct rule *rule)
 {
 	struct netlink_linearize_ctx lctx;
 	const struct stmt *stmt;
@@ -760,5 +760,4 @@ int netlink_linearize_rule(struct netlink_ctx *ctx, struct nft_rule *nlr,
 		netlink_gen_stmt(&lctx, stmt);
 
 	netlink_dump_rule(nlr);
-	return 0;
 }
-- 
1.7.10.4

