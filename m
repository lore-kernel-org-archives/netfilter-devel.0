Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8E9C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Dec 2022 10:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiLLKIn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Dec 2022 05:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiLLKIm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2022 05:08:42 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC649FDB
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Dec 2022 02:08:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p4fjk-0000fA-AF; Mon, 12 Dec 2022 11:08:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] netlink_linearize: fix timeout with map updates
Date:   Mon, 12 Dec 2022 11:04:35 +0100
Message-Id: <20221212100436.84116-3-fw@strlen.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212100436.84116-1-fw@strlen.de>
References: <20221212100436.84116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Map updates can use timeouts, just like with sets, but the
linearization step did not pass this info to the kernel.

meta l4proto tcp update @pinned { ip saddr . ct original proto-src : ip daddr . ct original proto-dst timeout 90s

Listing this won't show the "timeout 90s" because kernel never saw it to
begin with.

NB: The above line attaches the timeout to the data element,
but there are no separate timeouts for the key and the value.

An alternative is to reject "key : value timeout X" from the parser
or evaluation step.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c8bbcb7452b0..765b12263fa3 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1520,6 +1520,13 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
 	nft_rule_add_expr(ctx, nle, &stmt->location);
 
+	if (stmt->map.key->timeout > 0)
+		nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
+				   stmt->map.key->timeout);
+	else if (stmt->map.data->timeout > 0)
+		nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
+				   stmt->map.data->timeout);
+
 	list_for_each_entry(this, &stmt->map.stmt_list, list)
 		num_stmts++;
 
-- 
2.38.1

