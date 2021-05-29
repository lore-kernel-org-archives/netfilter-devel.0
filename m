Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C8EC4708E
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 16:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB90D6105A
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 16:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhE2QwM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 May 2021 12:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhE2QwL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 May 2021 12:52:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CA6C061574
        for <netfilter-devel@vger.kernel.org>; Sat, 29 May 2021 09:50:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ln2AP-0000mn-Rx; Sat, 29 May 2021 18:50:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, kernel test robot <lkp@intel.com>
Subject: [PATCH nf-next] netfilter: nft_compat: fix bridge family target evaluation
Date:   Sat, 29 May 2021 18:50:25 +0200
Message-Id: <20210529165025.146435-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This always evals to true, so all packets get dropped in the ebtables
compat layer. ip(6)tables is fine.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 6d6dbfe7fe1e6e1 ("netfilter: nf_tables: remove xt_action_param from nft_pktinfo")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo, feel free to squash if you prefer that.

 net/netfilter/nft_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 936e244f5aba..3144a9ad2f6a 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -110,7 +110,7 @@ static void nft_target_eval_bridge(const struct nft_expr *expr,
 
 	ret = target->target(skb, &xt);
 
-	if (&xt.hotdrop)
+	if (xt.hotdrop)
 		ret = NF_DROP;
 
 	switch (ret) {
-- 
2.31.1

