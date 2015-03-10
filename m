From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/2] src: add nft_ruleset_ctx_free
Date: Tue, 10 Mar 2015 11:03:17 +0100
Message-ID: <1425981797-10280-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39100 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbbCJKDB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 06:03:01 -0400
Received: by wiwl15 with SMTP id l15so28650908wiw.4
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2015 03:02:59 -0700 (PDT)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id m9sm3223986wiz.24.2015.03.10.03.02.58
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2015 03:02:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function release the ruleset objects attached in the parser context
(nft_parse_ctx).

Moreover, this patch update the nft_parse_ruleset_file to use it.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-ruleset-parse-file.c |    8 +-------
 include/libnftnl/ruleset.h        |    1 +
 src/libnftnl.map                  |    1 +
 src/ruleset.c                     |   23 +++++++++++++++++++++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/examples/nft-ruleset-parse-file.c b/examples/nft-ruleset-parse-file.c
index 7d9086b..1b7c8d2 100644
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
 
+	nft_ruleset_ctx_free((struct nft_parse_ctx *)ctx);
 	return ret;
 }
 
diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
index aa1d92d..12c617d 100644
--- a/include/libnftnl/ruleset.h
+++ b/include/libnftnl/ruleset.h
@@ -51,6 +51,7 @@ enum {
 };
 
 struct nft_parse_ctx;
+void nft_ruleset_ctx_free(struct nft_parse_ctx *ctx);
 bool nft_ruleset_ctx_is_set(const struct nft_parse_ctx *ctx, uint16_t attr);
 void *nft_ruleset_ctx_get(const struct nft_parse_ctx *ctx, uint16_t attr);
 uint32_t nft_ruleset_ctx_get_u32(const struct nft_parse_ctx *ctx,
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 7c74fbc..04d2ccb 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -229,6 +229,7 @@ LIBNFTNL_1.2 {
 } LIBNFTNL_1.1;
 
 LIBNFTNL_1.2.0 {
+  nft_ruleset_ctx_free;
   nft_ruleset_ctx_is_set;
   nft_ruleset_ctx_get;
   nft_ruleset_ctx_get_u32;
diff --git a/src/ruleset.c b/src/ruleset.c
index c8747b6..e4cd95c 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -157,6 +157,29 @@ void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_ruleset_attr_get);
 
+void nft_ruleset_ctx_free(struct nft_parse_ctx *ctx)
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

