Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B00C56201
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 15:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5222924695
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 15:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgKSPfG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKSPfG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 10:35:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4577C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2020 07:35:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kflxe-000311-9E; Thu, 19 Nov 2020 16:35:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH nf] netfilter: nf_tables: avoid false-postive lockdep splat
Date:   Thu, 19 Nov 2020 16:34:54 +0100
Message-Id: <20201119153454.28089-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are reports wrt lockdep splat in nftables, e.g.:
------------[ cut here ]------------
WARNING: CPU: 2 PID: 31416 at net/netfilter/nf_tables_api.c:622
lockdep_nfnl_nft_mutex_not_held+0x28/0x38 [nf_tables]
...

These are caused by an earlier, unrelated bug such as a n ABBA deadlock
in a different subsystem.
In such an event, lockdep is disabled and lockdep_is_held returns true
unconditionally.  This then causes the WARN() in nf_tables.

Make the WARN conditional on lockdep still active to avoid this.

Fixes: f102d66b335a417 ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Link: https://lore.kernel.org/linux-kselftest/CA+G9fYvFUpODs+NkSYcnwKnXm62tmP=ksLeBPmB+KFrB2rvCtQ@mail.gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0f58e98542be..23abf1578594 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -619,7 +619,8 @@ static int nft_request_module(struct net *net, const char *fmt, ...)
 static void lockdep_nfnl_nft_mutex_not_held(void)
 {
 #ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+	if (debug_locks)
+		WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
 #endif
 }
 
-- 
2.26.2

