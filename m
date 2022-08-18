Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145B4C00140
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Aug 2022 10:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238860AbiHRKG1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 06:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiHRKG0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 06:06:26 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50DD4D4F3
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 03:06:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x15so200905pfp.4
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 03:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=r8VaUt9sK2WAcGK+cMFQytK1VVe582OHCEez8ulZaCQ=;
        b=KLOGZYzvyhLuz5903RkoF1s9Scay63JHl5+Yxr71gW1fPKf8i1Yt85SNdsYBVXHC4a
         QkilYRwqIBV8vsB1iXibFwfRG18KPnHUFLKKXKNCLChbgYpomVVlI4uk+bb8HVwREZX5
         eR8IavU4+Alzy91LMpMGQHeIYOAl2Qng11U7PSBl14dAmJTcgT+Nx0pn/zHZOCMRgTBf
         jbTFzMfE9ouAzitC3AZUb2mmqHSVxJCT53MFHgA6dkMeezderVs+183XccSxqAMJw9i8
         jw1qidK0qpygoudK2QIwJH30y4FBNRZs9GCmivBV1O0bG+wx0tnigNEVOICYeZ8Ney7D
         nzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=r8VaUt9sK2WAcGK+cMFQytK1VVe582OHCEez8ulZaCQ=;
        b=548ZDqMw9ysfFe+f7bjPCR8wmCEGPLrd+0CATuW2tE8NUgo0JCU0eXqlkCnzb+RUme
         zPV+9xjrc5iOw6nm1iW46iHt/CVBiM+RBbuzhNnbGtuCaL4RuenkS7njte1yMDgQbLar
         2OezvmMEoazJrX2Fl1XXzL3/pJiRfgLUAZkULrizFYsRaeL7ofFM+Cmnta0Dej3Et/ay
         WMJvPLsrz7jAH5cKTGb0lP01PmDJaSon0343W2ROdPrtwgBdbwEqNyykNKm2o/0onBlV
         fdeSJF1hObHk+sECdigbsjDzd3r92uCY2WsZOikQvCsegqNOEcimOi7jC5pIFvtGnFXX
         uJyQ==
X-Gm-Message-State: ACgBeo1uSNab1mieGJ+WAdGH0ojaxkT3Y/hotzWI/l1xt+6EU8T7S+Yz
        DcchpU22LUEjMfteoOfIQ7uRwdHQ5xJZcg==
X-Google-Smtp-Source: AA6agR73xqnzzBty3Ro7EQoACHHIzdWmc2WCiBiMlMPdiZ/kX3aclIZROEJhJk4ucSkYWVa9Q04k3g==
X-Received: by 2002:a05:6a00:850:b0:52e:d1c1:df48 with SMTP id q16-20020a056a00085000b0052ed1c1df48mr2234306pfk.75.1660817184954;
        Thu, 18 Aug 2022 03:06:24 -0700 (PDT)
Received: from nova-ws.. ([103.220.11.9])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902cec900b00170953de050sm1029851plg.50.2022.08.18.03.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 03:06:24 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>
Subject: [PATCH nft] src: Don't parse string as verdict in map
Date:   Thu, 18 Aug 2022 18:06:23 +0800
Message-Id: <20220818100623.22601-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In verdict map, string values are accidentally treated as verdicts.

For example:
    table ip t {
        map foo {
           type mark : verdict
           elements = {
              0 : bar
           }
        }
    }
The value "bar" is sent to kernel as verdict.

Indeed, we don't parse verdicts during evaluation, but only chains,
which is of type string rather than verdict.

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 src/datatype.c | 12 ------------
 src/evaluate.c |  3 ++-
 2 files changed, 2 insertions(+), 13 deletions(-)

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
-- 
2.37.1

