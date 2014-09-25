From: Vadim Kochan <vadim4j@gmail.com>
Subject: [PATCH] Allow to compile for < 3.17 kernel version
Date: Thu, 25 Sep 2014 03:57:04 +0300
Message-ID: <1411606624-8411-1-git-send-email-vadim4j@gmail.com>
Cc: Vadim Kochan <vadim4j@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42722 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaIYBFc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:05:32 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so7984280wiv.8
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2014 18:05:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added declaration checking for NFT_EXPR_LOG_LEVEL enum
which was added for 3.17 kernel version.

Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
---
 configure.ac              | 2 ++
 src/netlink_delinearize.c | 2 ++
 src/netlink_linearize.c   | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/configure.ac b/configure.ac
index 3a7647f..d3971c7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -99,6 +99,8 @@ AC_TYPE_UINT16_T
 AC_TYPE_UINT32_T
 AC_TYPE_UINT64_T
 
+AC_CHECK_DECLS([NFT_EXPR_LOG_LEVEL],[],[],[[#include <libnftnl/expr.h>]])
+
 # Checks for library functions.
 AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 796b632..cf2ec00 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -447,11 +447,13 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 			nft_rule_expr_get_u16(nle, NFT_EXPR_LOG_QTHRESHOLD);
 		stmt->log.flags |= STMT_LOG_QTHRESHOLD;
 	}
+#if HAVE_DECL_NFT_EXPR_LOG_LEVEL
 	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOG_LEVEL)) {
 		stmt->log.level =
 			nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_LEVEL);
 		stmt->log.flags |= STMT_LOG_LEVEL;
 	}
+#endif
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c46b6d4..2b116f9 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -586,10 +586,12 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 			nft_rule_expr_set_u16(nle, NFT_EXPR_LOG_QTHRESHOLD,
 					      stmt->log.qthreshold);
 	} else {
+#if HAVE_DECL_NFT_EXPR_LOG_LEVEL
 		if (stmt->log.flags & STMT_LOG_LEVEL) {
 			nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_LEVEL,
 					      stmt->log.level);
 		}
+#endif
 	}
 	nft_rule_add_expr(ctx->nlr, nle);
 }
-- 
2.1.0

