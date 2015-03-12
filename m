From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/2 v2] ruleset: add nft_ruleset_ctx_free
Date: Thu, 12 Mar 2015 17:33:09 +0100
Message-ID: <1426177989-7661-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37982 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbbCLQcw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2015 12:32:52 -0400
Received: by wghl18 with SMTP id l18so17570973wgh.5
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2015 09:32:50 -0700 (PDT)
Received: from localhost.localdomain (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id gj16sm11425281wic.24.2015.03.12.09.32.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2015 09:32:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function release the ruleset objects attached in the parse context
(nft_parse_ctx).

Moreover, this patch update the nft_parse_ruleset_file to use it.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Changes in v2]
* Defined nft_ruleset_ctx_free in the correct position in libnftnl.map
* Removed the casting when we use the function nft_ruleset_ctx_free.

 examples/nft-ruleset-parse-file.c |    8 +-------
 include/libnftnl/ruleset.h        |    1 +
 src/libnftnl.map                  |    1 +
 src/ruleset.c                     |   23 +++++++++++++++++++++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/examples/nft-ruleset-parse-file.c b/examples/nft-ruleset-parse-file.c
index 7d9086b..cac7d0d 100644
--- a/examples/nft-ruleset-parse-file.c
+++ b/examples/nft-ruleset-parse-file.c
@@ -77,10 +77,8 @@ static int nft_ruleset_set_elems(const struct nft_parse_ctx *ctx)
 	mnl_nlmsg_batch_next(batch);
 
 	nft_set_elems_iter_destroy(iter_elems);
-	nft_set_free(set);
 	return 0;
 err:
-	nft_set_free(set);
 	return -1;
 }
 
@@ -125,7 +123,6 @@ static int nft_ruleset_set(const struct nft_parse_ctx *ctx)
 	ret = nft_ruleset_set_elems(ctx);
 	return ret;
 err:
-	nft_set_free(set);
 	return -1;
 }
 
@@ -184,7 +181,6 @@ static int nft_ruleset_rule(const struct nft_parse_ctx *ctx)
 		return -1;
 
 	ret = nft_ruleset_rule_build_msg(ctx, cmd, rule);
-	nft_rule_free(rule);
 
 	return ret;
 }
@@ -273,10 +269,8 @@ static int nft_ruleset_chain(const struct nft_parse_ctx *ctx)
 	nft_chain_nlmsg_build_payload(nlh, chain);
 	mnl_nlmsg_batch_next(batch);
 
-	nft_chain_free(chain);
 	return 0;
 err:
-	nft_chain_free(chain);
 	return -1;
 }
 
@@ -327,7 +321,6 @@ static int nft_ruleset_table(const struct nft_parse_ctx *ctx)
 		return -1;
 
 	ret = nft_ruleset_table_build_msg(ctx, cmd, table);
-	nft_table_free(table);
 
 	return ret;
 }
@@ -377,6 +370,7 @@ static int ruleset_elems_cb(const struct nft_parse_ctx *ctx)
 		return -1;
 	}
 
+	nft_ruleset_ctx_free(ctx);
 	return ret;
 }
 
diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
index aa1d92d..fe5e44f 100644
--- a/include/libnftnl/ruleset.h
+++ b/include/libnftnl/ruleset.h
@@ -51,6 +51,7 @@ enum {
 };
 
 struct nft_parse_ctx;
+void nft_ruleset_ctx_free(const struct nft_parse_ctx *ctx);
 bool nft_ruleset_ctx_is_set(const struct nft_parse_ctx *ctx, uint16_t attr);
 void *nft_ruleset_ctx_get(const struct nft_parse_ctx *ctx, uint16_t attr);
 uint32_t nft_ruleset_ctx_get_u32(const struct nft_parse_ctx *ctx,
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 7c74fbc..c0b2031 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -234,4 +234,5 @@ LIBNFTNL_1.2.0 {
   nft_ruleset_ctx_get_u32;
   nft_ruleset_parse_file_cb;
   nft_ruleset_parse_buffer_cb;
+  nft_ruleset_ctx_free;
 } LIBNFTNL_1.2;
diff --git a/src/ruleset.c b/src/ruleset.c
index c8747b6..e7f9204 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -157,6 +157,29 @@ void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_ruleset_attr_get);
 
+void nft_ruleset_ctx_free(const struct nft_parse_ctx *ctx)
+{
+	switch (ctx->type) {
+	case NFT_RULESET_TABLE:
+		nft_table_free(ctx->table);
+		break;
+	case NFT_RULESET_CHAIN:
+		nft_chain_free(ctx->chain);
+		break;
+	case NFT_RULESET_RULE:
+		nft_rule_free(ctx->rule);
+		break;
+	case NFT_RULESET_SET:
+	case NFT_RULESET_SET_ELEMS:
+		nft_set_free(ctx->set);
+		break;
+	case NFT_RULESET_RULESET:
+	case NFT_RULESET_UNSPEC:
+		break;
+	}
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_free);
+
 bool nft_ruleset_ctx_is_set(const struct nft_parse_ctx *ctx, uint16_t attr)
 {
 	return ctx->flags & (1 << attr);
-- 
1.7.10.4

