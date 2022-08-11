Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453A0C19F2D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Aug 2022 07:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbiHKHLG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Aug 2022 03:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKHLF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Aug 2022 03:11:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A58661D90
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2022 00:11:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oM2LL-0005aM-At; Thu, 11 Aug 2022 09:10:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: allow implicit ether -> vlan dep
Date:   Thu, 11 Aug 2022 09:10:55 +0200
Message-Id: <20220811071055.101362-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft add rule inet filter input vlan id 2
Error: conflicting protocols specified: ether vs. vlan

Refresh the current dependency after superseding the dummy
dependency to make this work.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 919c38c5604e..da06ad7e9c7d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -665,6 +665,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 			if (err < 0)
 				return err;
 
+			desc = payload->payload.desc;
 			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 		} else {
 			unsigned int i;
-- 
2.37.1

