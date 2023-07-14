Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A088FEB64DC
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jul 2023 14:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbjGNOyq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbjGNOyo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jul 2023 10:54:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45BC3A95
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jul 2023 07:54:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qKKBQ-00044a-He; Fri, 14 Jul 2023 16:54:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] exthdr: prefer raw_type instead of desc->type
Date:   Fri, 14 Jul 2023 16:53:57 +0200
Message-ID: <20230714145400.27274-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On ancient kernels desc can be NULL, because such kernels do not
understand NFTA_EXTHDR_TYPE.

Thus they don't include it in the reverse dump, so the tcp/ip
option gets treated like an ipv6 exthdr, but no matching
description will be found.

This then gives a crash due to the null deref.

Just use the raw value here, this will at least make nft print
that the exthdr and type is invalid.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/exthdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/exthdr.c b/src/exthdr.c
index f5527ddb4a3f..0358005b1b89 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -405,7 +405,7 @@ bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned i
 		found = tcpopt_find_template(expr, off, mask_len - mask_offset);
 		break;
 	case NFT_EXTHDR_OP_IPV6:
-		exthdr_init_raw(expr, expr->exthdr.desc->type,
+		exthdr_init_raw(expr, expr->exthdr.raw_type,
 				off, mask_len - mask_offset, expr->exthdr.op, 0);
 
 		/* still failed to find a template... Bug. */
-- 
2.41.0

