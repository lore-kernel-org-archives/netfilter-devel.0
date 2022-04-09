Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6440C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242285AbiDIOBH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiDIOBD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:01:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED0DF2B
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:58:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBc6-0008L6-Tv; Sat, 09 Apr 2022 15:58:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 4/9] evaluate: string prefix expression must retain original length
Date:   Sat,  9 Apr 2022 15:58:27 +0200
Message-Id: <20220409135832.17401-5-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To make something like "eth*" work for interval sets (match
eth0, eth1, and so on...) we must treat the string as a 128 bit
integer.

Without this, segtree will do the wrong thing when applying the prefix,
because we generate the prefix based on 'eth*' as input, with a length of 3.

The correct import needs to be done on "eth\0\0\0\0\0\0\0...", i.e., if
the input buffer were an ipv6 address, it should look like "eth\0::",
not "::eth".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a20cc396b33f..788623137e58 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -338,9 +338,11 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		*exprp = value;
 		return 0;
 	}
+
+	data[datalen] = 0;
 	value = constant_expr_alloc(&expr->location, ctx->ectx.dtype,
 				    BYTEORDER_HOST_ENDIAN,
-				    datalen * BITS_PER_BYTE, data);
+				    expr->len, data);
 
 	prefix = prefix_expr_alloc(&expr->location, value,
 				   datalen * BITS_PER_BYTE);
-- 
2.35.1

