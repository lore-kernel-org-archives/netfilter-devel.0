Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025E1C00140
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Aug 2022 02:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbiHSCei (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 22:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiHSCei (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 22:34:38 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC80CB5DD
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 19:34:36 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s206so2702517pgs.3
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 19:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Y+9XskWUKVyD0SylCLdXjWTSILZFfO2Y+oELusmeej0=;
        b=nQ/depy/aZPYdphBwfhWrimxiSLTru59sM53YCfJdcrQOnznAstAVpTDE2RZfI6Eu7
         7iTf7l9xRKGFrRs5zNQ83+c0F2O8GaftMOUZqazdYs/RsdIxORDiWwCJ1uBmGbs1cgxJ
         0FlxdsdMhc/kN3SwQIcyeFWPm0p5kkIW8DmTtGangDV/cLfb7Qx2ZJB8YfXT8hK71Wle
         5Goy8vo7GHRftJol/I9fP2mgBlKvXxH5x/A7oBr95uOx4uBhFyL3cpL+mvyKG3H5pK+Q
         VWcootKjgtTVire6bp0aB89meU+wo2TtZtIEqDn/giLOROmHnz62IaI1uaZTLP7ymRIt
         UjEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Y+9XskWUKVyD0SylCLdXjWTSILZFfO2Y+oELusmeej0=;
        b=K9qYPyLGXttLlKmtDDsspiKFsJdp+t6OwP7RueqMDPmz6XkarNuAAshPLclrnDQQoB
         NPSA/hzR9Sq9D8PJ3UCgl9Y9e/xumheUljEkVJGQBYtpz5lk8MOvvM6WHy1t9UipNkE7
         baVPWBoBQzcLfbMSURR/fDqntdiDSWFUu84t11Y8lxzgwdD3hvY0s3pZN+w+0D4Z9xe+
         Ahf/TD4novoTPSvRaKvaEejpcqzRFmkMRzFnvHOIag4xktcilFDXeP7piuSOLP3KOyXL
         JjIejY6VCYev7lpH8QZv/x5iAm6xYau/GPDX1lrv4xcUzj0Z9qna6OXJoGbBUbW13T1t
         2Mdw==
X-Gm-Message-State: ACgBeo3sIDXYGJC1DCBsb3u+lTNDEPbTDBgNdWme0WzxKm2vHbeeS5jV
        RXQNHw50ogQQGAcCaT4y2mvpzQADUlyAvw==
X-Google-Smtp-Source: AA6agR7kyf42kiryYUccObkVYsyvXBuCKN7LKWT1gKLaLvhUUtZGhX0vUmYuYgmMnXc8ZJKkEBTcgA==
X-Received: by 2002:a05:6a00:189d:b0:52d:d4ae:d9f2 with SMTP id x29-20020a056a00189d00b0052dd4aed9f2mr5698818pfh.2.1660876475965;
        Thu, 18 Aug 2022 19:34:35 -0700 (PDT)
Received: from nova-ws.. ([103.220.11.9])
        by smtp.gmail.com with ESMTPSA id s185-20020a625ec2000000b0052e82c7d91bsm2319860pfb.135.2022.08.18.19.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 19:34:35 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] src: Don't parse string as verdict in map
Date:   Fri, 19 Aug 2022 10:33:36 +0800
Message-Id: <20220819023336.148516-1-shaw.leon@gmail.com>
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
index 00000000..615cdbea
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0031vmap_string_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# Tests use of variables in jump statements
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

