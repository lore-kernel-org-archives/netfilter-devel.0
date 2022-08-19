Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECB0C00140
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Aug 2022 02:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244750AbiHSCkd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 22:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbiHSCkc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 22:40:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABE3C3F58
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 19:40:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso6356827pjl.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 19:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=FHYOI69YsCmZezTdERDv64AqMlCQrvKlNGROdQ5HRas=;
        b=ZXdYULO2QFYwny9u5bWiyOWjWv7rtoJKmw8fvmGzza7SvepUsQ/7NUEq/f0gQbbGgy
         R7MbsM/z1OLLZ3HJxSlLNNxdBfQUdG85LENqwg9ZpSH9IiOGWkHzz3CRXwytfTdG6+Ng
         5XsY1MQPvPGdQKMx6hM7W+oCmv9jfA1hCZWluBlY21QINP8mBe9POUUKjP1ULS93z6MN
         qIbfx9i3gSUMNMm6rOzo1xuC0ShNn3LlR5r/lCRBENZtKEfMwGzqfDL7gG07AfiZTLBI
         SWS2YAMGn+dzABsovT0buBoMWu04qjawrBD3to1WvKzySp8T8p41LDJ5VZCeElwQHlFl
         51qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=FHYOI69YsCmZezTdERDv64AqMlCQrvKlNGROdQ5HRas=;
        b=5BjqqCP5QtWXfDzWSjG9vyzQ++yXq4xMwwLsXcFqRjkEP6HEVw08JWDSTtcspy7aYQ
         B6mo0zi92UngfCrCIVex7/OnfMhjCmKVhXnpIR1m6EdcziNffOqiRLkfavVcUxOJIPTH
         1LXmi6sctJ+IH/c7yN+1uXEO1IQnIfcdgQfVIp9osKJYlbQ6kD8WnsAfnua2UFYsouUP
         dA/bC10Jv+sXc5Pqdav7zUFcccegGu0oMtd4dp9mZA+TYGavWbMfngP4B6oNZBIimjSa
         Ddy1A89HPtcTszbKYsD1toeYFUTm6RIt82ta7XMY5Lpd5v8Yx+oos3+GWBwVKvK8Ncy4
         fmzg==
X-Gm-Message-State: ACgBeo1aG9oUjQ5qVGqMAb6n19sL+FwoBx/doxOh4M1Yr/ffznGR9cLk
        WpcMe+LAievn+CWhzoaDL4LxRCUFKfVQ5A==
X-Google-Smtp-Source: AA6agR62PDI2lpHXFIL9cdieJ/9fm/bRJKKpHdrrBYob5NNJ7VnnE5K4ggfUllsFrmBBdEc4EFzV3g==
X-Received: by 2002:a17:90a:ea0c:b0:1fa:c77a:cb05 with SMTP id w12-20020a17090aea0c00b001fac77acb05mr6013621pjy.228.1660876830730;
        Thu, 18 Aug 2022 19:40:30 -0700 (PDT)
Received: from nova-ws.. ([103.220.11.9])
        by smtp.gmail.com with ESMTPSA id t32-20020a635360000000b00429e093cbadsm1904246pgl.10.2022.08.18.19.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 19:40:30 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3] src: Don't parse string as verdict in map
Date:   Fri, 19 Aug 2022 10:40:23 +0800
Message-Id: <20220819024023.148764-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In verdict map, string values are accidentally treated as verdicts.

For example:

table t {
    map foo {
        type ipv4_addr : verdict
        elements = {
            192.168.0.1 : bar
        }
    }
    chain output {
        type filter hook output priority mangle;
        ip daddr vmap @foo
    }
}

Though "bar" is not a valid verdict (should be "jump bar" or something),
the string is taken as the element value. Then NFTA_DATA_VALUE is sent
to the kernel instead of NFTA_DATA_VERDICT. This would be rejected by
recent kernels. On older ones (e.g. v5.4.x) that don't validate the
type, a warning can be seen when the rule is hit, because of the
corrupted verdict value:

[5120263.467627] WARNING: CPU: 12 PID: 303303 at net/netfilter/nf_tables_core.c:229 nft_do_chain+0x394/0x500 [nf_tables]

Indeed, we don't parse verdicts during evaluation, but only chain names,
which is of type string rather than verdict. For example, "jump $var" is
a verdict while "$var" is a string.

Fixes: c64457cff967 ("src: Allow goto and jump to a variable")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 src/datatype.c                                | 12 -----------
 src/evaluate.c                                |  3 ++-
 tests/shell/testcases/nft-f/0031vmap_string_0 | 21 +++++++++++++++++++
 3 files changed, 23 insertions(+), 13 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/0031vmap_string_0

diff --git a/src/datatype.c b/src/datatype.c
index 2e31c858..002ed46a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -321,23 +321,11 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
-static struct error_record *verdict_type_parse(struct parse_ctx *ctx,
-					       const struct expr *sym,
-					       struct expr **res)
-{
-	*res = constant_expr_alloc(&sym->location, &string_type,
-				   BYTEORDER_HOST_ENDIAN,
-				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
-				   sym->identifier);
-	return NULL;
-}
-
 const struct datatype verdict_type = {
 	.type		= TYPE_VERDICT,
 	.name		= "verdict",
 	.desc		= "netfilter verdict",
 	.print		= verdict_type_print,
-	.parse		= verdict_type_parse,
 };
 
 static const struct symbol_table nfproto_tbl = {
diff --git a/src/evaluate.c b/src/evaluate.c
index 919c38c5..d9c9ca28 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2575,7 +2575,8 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 		if (stmt->expr->verdict != NFT_CONTINUE)
 			stmt->flags |= STMT_F_TERMINAL;
 		if (stmt->expr->chain != NULL) {
-			if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
+			if (stmt_evaluate_arg(ctx, stmt, &string_type, 0, 0,
+					      &stmt->expr->chain) < 0)
 				return -1;
 			if (stmt->expr->chain->etype != EXPR_VALUE) {
 				return expr_error(ctx->msgs, stmt->expr->chain,
diff --git a/tests/shell/testcases/nft-f/0031vmap_string_0 b/tests/shell/testcases/nft-f/0031vmap_string_0
new file mode 100755
index 00000000..2af846a4
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0031vmap_string_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# Tests parse of corrupted verdicts
+
+set -e
+
+RULESET="
+table ip foo {
+	map bar {
+		type ipv4_addr : verdict
+		elements = {
+			192.168.0.1 : ber
+		}
+	}
+
+	chain ber {
+	}
+}"
+
+$NFT -f - <<< "$RULESET" && exit 1
+exit 0
-- 
2.37.1

