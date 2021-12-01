Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372C3C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbhLAMDe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 07:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347818AbhLAMD1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 07:03:27 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19101C06174A
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 04:00:07 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1msOHN-0005FZ-K5; Wed, 01 Dec 2021 13:00:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] netlink_delinearize: use correct member type
Date:   Wed,  1 Dec 2021 12:59:54 +0100
Message-Id: <20211201115956.13252-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201115956.13252-1-fw@strlen.de>
References: <20211201115956.13252-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

expr is a map, so this should use expr->map, not expr->left.
These fields are aliased, so this would break if that is ever changed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0c2b439eac6f..66120d659dc3 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2300,7 +2300,7 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 
 static void map_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 {
-	struct expr *binop = expr->left;
+	struct expr *binop = expr->map;
 
 	if (binop->op != OP_AND)
 		return;
-- 
2.32.0

