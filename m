Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71563C47082
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 14:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E376100B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 14:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhFHOok (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 10:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbhFHOok (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 10:44:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8081C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Jun 2021 07:42:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lqcwH-0001sR-EC; Tue, 08 Jun 2021 16:42:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, kernel test robot <lkp@intel.com>
Subject: [PATCH nf-next] nfilter: nf_hooks: fix build failure with NF_TABLES=n
Date:   Tue,  8 Jun 2021 16:42:37 +0200
Message-Id: <20210608144237.5813-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <202106082146.9TmnLWJk-lkp@intel.com>
References: <202106082146.9TmnLWJk-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nfnetlink_hook.c: In function 'nfnl_hook_put_nft_chain_info':
nfnetlink_hook.c:76:7: error: implicit declaration of 'nft_is_active'

This macro is only defined when NF_TABLES is enabled.
Add IS_ENABLED guards for this.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 252956528caa ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_hook.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 04586dfa2acd..d624805e977c 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -61,6 +61,7 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 					unsigned int seq,
 					const struct nf_hook_ops *ops)
 {
+#if IS_ENABLED(CONFIG_NF_TABLES)
 	struct net *net = sock_net(nlskb->sk);
 	struct nlattr *nest, *nest2;
 	struct nft_chain *chain;
@@ -104,6 +105,9 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 cancel_nest:
 	nla_nest_cancel(nlskb, nest);
 	return -EMSGSIZE;
+#else
+	return 0;
+#endif
 }
 
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
-- 
2.31.1

