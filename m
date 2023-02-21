Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C0AC636D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Feb 2023 18:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjBUSV7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 13:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjBUSVz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 13:21:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0148303E9
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 10:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kYnI3WDkNmwm7Eq8RXqTJT1aFu2QDE4Udt8OvMjOUF4=; b=Q8mAPwYJGZlTpSAg5/xh9orL6g
        xC/gGfNNkyN4YyYPz1hEGRwrWpLU7cG+8PLayYU0cgD91PozR8lUxEZPcilWrAvRmoLWDSHO14KfI
        vcSoTF0Yuo0dWiwHXAOAfu8zztEB5i7PoJllcFvZoAHSf77INel1O1YduSWYcrXbQ/5cdjw5SFWIu
        0H4pdDAMsr7X8+Vk33WJwBf21Gs2SFuPahAdPT9MAm9USeovXKd4jqd2p1fgKtj4ltpblQstDmKJm
        LxHt1Oru4d9FpovHTvb7VvX7GE5o3WXyRvOPjTlyMM8uTqYXPBZ57cO9UOt9o7ADCqrReSX7uIbXK
        vgMn7Z1A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pUXGo-0006iT-9s; Tue, 21 Feb 2023 19:21:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nft PATCH] netlink_delinearize: Sanitize concat data element decoding
Date:   Tue, 21 Feb 2023 19:21:33 +0100
Message-Id: <20230221182133.11746-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The call to netlink_get_register() might return NULL, catch this before
dereferencing the pointer.

Fixes: db59a5c1204c9 ("netlink_delinearize: fix decoding of concat data element")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f4ab476e03455..00221505f2899 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1749,7 +1749,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 		sreg_data = netlink_parse_register(nle, NFTNL_EXPR_DYNSET_SREG_DATA);
 		expr_data = netlink_get_register(ctx, loc, sreg_data);
 
-		if (expr_data->len < set->data->len) {
+		if (expr_data && expr_data->len < set->data->len) {
 			expr_free(expr_data);
 			expr_data = netlink_parse_concat_expr(ctx, loc, sreg_data, set->data->len);
 			if (expr_data == NULL)
-- 
2.38.0

