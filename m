Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E59EB64DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jul 2023 19:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjGYTYl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjGYTYi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 15:24:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F3B1FF2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2023 12:24:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qONe7-0002pj-0j; Tue, 25 Jul 2023 21:24:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink: delinearize: copy set keytype if needed
Date:   Tue, 25 Jul 2023 21:24:27 +0200
Message-ID: <20230725192430.7428-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Output before:
add @dynmark { 0xa020304 [invalid type] timeout 1s : 0x00000002 } comment "also check timeout-gc"

after:
add @dynmark { 10.2.3.4 timeout 1s : 0x00000002 } comment "also check timeout-gc"

This is a followup to 76c358ccfea0 ("src: maps: update data expression dtype based on set"),
which did fix the map expression, but not the key.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Found with an unrelated test case, i will submit that one as well soon.

 src/netlink_delinearize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9241f46622ff..125b6c685f80 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1734,6 +1734,8 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 		expr = netlink_parse_concat_key(ctx, loc, sreg, set->key);
 		if (expr == NULL)
 			return;
+	} else if (expr->dtype == &invalid_type) {
+		expr_set_type(expr, datatype_get(set->key->dtype), set->key->byteorder);
 	}
 
 	expr = set_elem_expr_alloc(&expr->location, expr);
-- 
2.41.0

