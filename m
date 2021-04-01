Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E001C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 21:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14F6C610FA
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 21:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDAVVe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 17:21:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53796 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbhDAVVc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 17:21:32 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 31E5363E34
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 23:21:16 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: check for NULL chain in cache_init()
Date:   Thu,  1 Apr 2021 23:21:28 +0200
Message-Id: <20210401212128.31768-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Another process might race to add chains after chain_cache_init().
The generation check does not help since it comes after cache_init().
NLM_F_DUMP_INTR only guarantees consistency within one single netlink
dump operation, so it does not help either (cache population requires
several netlink dump commands).

Let's be safe and do not assume the chain exists in the cache when
populating the rule cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index f7187ee7237f..5c21b8958a28 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -338,6 +338,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 				if (!chain)
 					chain = chain_binding_lookup(table,
 							rule->handle.chain.name);
+				if (!chain)
+					goto cache_fails;
+
 				list_move_tail(&rule->list, &chain->rules);
 			}
 			if (ret < 0) {
-- 
2.20.1

