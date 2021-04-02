Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492FBC433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 19:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C71661056
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 19:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhDBTE6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 15:04:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55606 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBTEz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 15:04:55 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CD71F63E4A
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Apr 2021 21:04:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] cache: bail out if chain list cannot be fetched from kernel
Date:   Fri,  2 Apr 2021 21:04:47 +0200
Message-Id: <20210402190447.20689-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210402190447.20689-1-pablo@netfilter.org>
References: <20210402190447.20689-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not report success if chain cache list cannot be built.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index 80632c86caa6..f032171a95ff 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -365,7 +365,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 	if (flags & NFT_CACHE_CHAIN_BIT) {
 		chain_list = chain_cache_dump(ctx, &ret);
 		if (!chain_list)
-			return ret;
+			return -1;
 	}
 
 	list_for_each_entry(table, &ctx->nft->cache.list, list) {
-- 
2.20.1

