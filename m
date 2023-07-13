Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6023BC0015E
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jul 2023 08:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbjGMItv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbjGMItY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jul 2023 04:49:24 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63A1910FA;
        Thu, 13 Jul 2023 01:49:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.10 v3 11/11] netfilter: nf_tables: fix scheduling-while-atomic splat
Date:   Thu, 13 Jul 2023 10:48:59 +0200
Message-Id: <20230713084859.71541-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230713084859.71541-1-pablo@netfilter.org>
References: <20230713084859.71541-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2024439bd5ceb145eeeb428b2a59e9b905153ac3 ]

nf_tables_check_loops() can be called from rhashtable list
walk so cond_resched() cannot be used here.

Fixes: 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 25b834868eac..7e037daaa613 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8684,13 +8684,9 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 				break;
 			}
 		}
-
-		cond_resched();
 	}
 
 	list_for_each_entry(set, &ctx->table->sets, list) {
-		cond_resched();
-
 		if (!nft_is_active_next(ctx->net, set))
 			continue;
 		if (!(set->flags & NFT_SET_MAP) ||
-- 
2.30.2

