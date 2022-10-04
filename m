Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC04C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Oct 2022 23:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJDXqL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Oct 2022 19:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiJDXpo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Oct 2022 19:45:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B943205ED
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2022 16:45:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] evaluate: datatype memleak after binop transfer
Date:   Wed,  5 Oct 2022 01:44:42 +0200
Message-Id: <20221004234442.779257-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221004234442.779257-1-pablo@netfilter.org>
References: <20221004234442.779257-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following ruleset:

	ip version vmap { 4 : jump t3, 6 : jump t4 }

results in a memleak.

expr_evaluate_shift() overrides the datatype which results in a datatype
memleak after the binop transfer that triggers a left-shift of the
constant (in the map).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2e2b8df0f004..0bf6a0d1b110 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1189,7 +1189,6 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 	if (byteorder_conversion(ctx, &op->right, BYTEORDER_HOST_ENDIAN) < 0)
 		return -1;
 
-	op->dtype     = &integer_type;
 	op->byteorder = BYTEORDER_HOST_ENDIAN;
 	op->len       = left->len;
 
-- 
2.30.2

