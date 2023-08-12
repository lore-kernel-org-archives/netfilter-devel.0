Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13207C0015E
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Aug 2023 11:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbjHLLFv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Aug 2023 07:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbjHLLFa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Aug 2023 07:05:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053C0136
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Aug 2023 04:05:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qUmR0-0006JB-8E; Sat, 12 Aug 2023 13:05:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, lonial con <kongln9170@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: deactivate catchall elements in next generation
Date:   Sat, 12 Aug 2023 13:05:16 +0200
Message-ID: <20230812110526.49808-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When flushing, individual set elements are disabled in the next
generation via the ->flush callback.

Catchall elements are not disabled.  This is incorrect and may lead to
double-deactivations of catchall elements which then results in memory
leaks:

WARNING: CPU: 1 PID: 3300 at include/net/netfilter/nf_tables.h:1172 nft_map_deactivate+0x549/0x730
CPU: 1 PID: 3300 Comm: nft Not tainted 6.5.0-rc5+ #60
RIP: 0010:nft_map_deactivate+0x549/0x730
 [..]
 ? nft_map_deactivate+0x549/0x730
 nf_tables_delset+0xb66/0xeb0

(the warn is due to nft_use_dec() detecting underflow).

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c62227ae7746..6f31022cacc6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7091,6 +7091,7 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 		ret = __nft_set_catchall_flush(ctx, set, &elem);
 		if (ret < 0)
 			break;
+		nft_set_elem_change_active(ctx->net, set, ext);
 	}
 
 	return ret;
-- 
2.41.0

