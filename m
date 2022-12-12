Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304A6C04FDE
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Dec 2022 10:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiLLKIk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Dec 2022 05:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiLLKIj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2022 05:08:39 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFB02D9
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Dec 2022 02:08:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p4fjg-0000es-Rn; Mon, 12 Dec 2022 11:08:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] netlink_delinearize: fix decoding of concat data element
Date:   Mon, 12 Dec 2022 11:04:34 +0100
Message-Id: <20221212100436.84116-2-fw@strlen.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212100436.84116-1-fw@strlen.de>
References: <20221212100436.84116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its possible to use update as follows:

 meta l4proto tcp update @pinned { ip saddr . ct original proto-src : ip daddr . ct original proto-dst }

... but when listing, only the first element of the concatenation is
shown.

Check if the element size is too small and parse subsequent registers as
well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0b6cf1072294..376b3550f9e2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1660,6 +1660,14 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_DYNSET_SREG_DATA)) {
 		sreg_data = netlink_parse_register(nle, NFTNL_EXPR_DYNSET_SREG_DATA);
 		expr_data = netlink_get_register(ctx, loc, sreg_data);
+
+		if (expr_data->len < set->data->len) {
+			expr_free(expr_data);
+			expr_data = netlink_parse_concat_expr(ctx, loc, sreg_data, set->data->len);
+			if (expr_data == NULL)
+				netlink_error(ctx, loc,
+					      "Could not parse dynset map data expessions");
+		}
 	}
 
 	if (expr_data != NULL) {
-- 
2.38.1

