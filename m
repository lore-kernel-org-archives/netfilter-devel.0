Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEEFC43334
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Jul 2022 12:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiGFMH5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Jul 2022 08:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiGFMH5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Jul 2022 08:07:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADB622982F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2022 05:07:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: release pending rules when chain binding lookup fails
Date:   Wed,  6 Jul 2022 14:07:51 +0200
Message-Id: <20220706120751.712173-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the implicit chain is not in the cache, release pending rules in
ctx->list and report EINTR to let the cache core retry to populate a
consistent cache.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1402
Fixes: c330152b7f77 ("src: support for implicit chain bindings")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index fd8df884c095..b6ae2310b175 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -847,12 +847,21 @@ static int rule_init_cache(struct netlink_ctx *ctx, struct table *table,
 			chain = chain_binding_lookup(table,
 						     rule->handle.chain.name);
 		if (!chain)
-			return -1;
+			goto err_ctx_list;
 
 		list_move_tail(&rule->list, &chain->rules);
 	}
 
 	return ret;
+
+err_ctx_list:
+	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
+		list_del(&rule->list);
+		rule_free(rule);
+	}
+	errno = EINTR;
+
+	return -1;
 }
 
 static int implicit_chain_cache(struct netlink_ctx *ctx, struct table *table,
-- 
2.30.2

