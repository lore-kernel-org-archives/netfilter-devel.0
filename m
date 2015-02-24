From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] main: display errors and debugging through stderr
Date: Tue, 24 Feb 2015 19:05:30 +0100
Message-ID: <1424801130-29052-2-git-send-email-pablo@netfilter.org>
References: <1424801130-29052-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35909 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbbBXSCI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 13:02:08 -0500
In-Reply-To: <1424801130-29052-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1000
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |    6 +++---
 src/main.c     |    2 +-
 src/mnl.c      |    4 ++--
 src/netlink.c  |   10 +++++-----
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a3484c6..a128619 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1067,7 +1067,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location, "Evaluate");
-		erec_print(stdout, erec); expr_print(*expr); printf("\n\n");
+		erec_print(stderr, erec); expr_print(*expr); printf("\n\n");
 	}
 #endif
 
@@ -1652,7 +1652,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &stmt->location, "Evaluate");
-		erec_print(stdout, erec); stmt_print(stmt); printf("\n\n");
+		erec_print(stderr, erec); stmt_print(stmt); printf("\n\n");
 	}
 #endif
 
@@ -1951,7 +1951,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &cmd->location, "Evaluate");
-		erec_print(stdout, erec); printf("\n\n");
+		erec_print(stderr, erec); printf("\n\n");
 	}
 #endif
 
diff --git a/src/main.c b/src/main.c
index b447aad..4590c30 100644
--- a/src/main.c
+++ b/src/main.c
@@ -361,7 +361,7 @@ int main(int argc, char * const *argv)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
-	erec_print_list(stdout, &msgs);
+	erec_print_list(stderr, &msgs);
 
 	xfree(buf);
 	return rc;
diff --git a/src/mnl.c b/src/mnl.c
index f48ead5..fdcabff 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -72,7 +72,7 @@ nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 
 #ifdef DEBUG
 	if (debug_level & DEBUG_MNL)
-		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
+		mnl_nlmsg_fprintf(stderr, data, len, sizeof(struct nfgenmsg));
 #endif
 
 	if (mnl_socket_sendto(nf_sock, data, len) < 0)
@@ -283,7 +283,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 		i++;
 #ifdef DEBUG
 		if (debug_level & DEBUG_MNL) {
-			mnl_nlmsg_fprintf(stdout,
+			mnl_nlmsg_fprintf(stderr,
 					  mnl_nlmsg_batch_head(batch_page->batch),
 					  mnl_nlmsg_batch_size(batch_page->batch),
 					  sizeof(struct nfgenmsg));
diff --git a/src/netlink.c b/src/netlink.c
index 84d9d27..32f9fc3 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -410,7 +410,7 @@ void netlink_dump_rule(struct nft_rule *nlr)
 		return;
 
 	nft_rule_snprintf(buf, sizeof(buf), nlr, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	fprintf(stderr, "%s\n", buf);
 #endif
 }
 
@@ -423,7 +423,7 @@ void netlink_dump_expr(struct nft_rule_expr *nle)
 		return;
 
 	nft_rule_expr_snprintf(buf, sizeof(buf), nle, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	fprintf(stderr, "%s\n", buf);
 #endif
 }
 
@@ -487,7 +487,7 @@ void netlink_dump_chain(struct nft_chain *nlc)
 		return;
 
 	nft_chain_snprintf(buf, sizeof(buf), nlc, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	fprintf(stderr, "%s\n", buf);
 #endif
 }
 
@@ -872,7 +872,7 @@ void netlink_dump_table(struct nft_table *nlt)
 		return;
 
 	nft_table_snprintf(buf, sizeof(buf), nlt, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	fprintf(stderr, "%s\n", buf);
 #endif
 }
 
@@ -983,7 +983,7 @@ void netlink_dump_set(struct nft_set *nls)
 		return;
 
 	nft_set_snprintf(buf, sizeof(buf), nls, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	fprintf(stderr, "%s\n", buf);
 #endif
 }
 
-- 
1.7.10.4

