Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F8DC4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiK3TOp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiK3TOo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A9F63D50
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DICZhItptfZ9OVvefJInZmmbG9RmBjPNowkwLp+CT5E=; b=nwysA/byxpbDK1XxS3/azQ/ljk
        BTde3fjkG2fESyLWrdqYtfuWLxi/Kz/8vWqhPvvuHBYGtHjfzEa9B2l6fOtyAe6uGHjCL9KPld82O
        KOYKQd4RIwRI7P1XOFN635H7Ty7fvgLY73D7OMAw6KTAGlpq5/DFbo41AeFtybk61wv+i/8+sPG06
        ojXQ/yocueUQuvS+i0zB6Y3JFmvz8CQ9s8ymOLa1Pqlknp6txt1SjqLclZ99w+OX01F43G45sERn3
        SmiCVpnBG/cli3tv+thZMosSZt/7fMsCzIFydWicGvuN6jBYdJrAP/IuL1Q5TcFYMiW9K11lj5gTI
        2EKWy2cA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SXa-0001CT-CV
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:14:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/9] nft: Plug memleak in nft_rule_zero_counters()
Date:   Wed, 30 Nov 2022 20:13:40 +0100
Message-Id: <20221130191345.14543-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When zeroing a specific rule, valgrind reports:

40 bytes in 1 blocks are definitely lost in loss record 1 of 1
   at 0x484659F: calloc (vg_replace_malloc.c:1328)
   by 0x48DE128: xtables_calloc (xtables.c:434)
   by 0x11C7C6: nft_parse_immediate (nft-shared.c:1071)
   by 0x11C7C6: nft_rule_to_iptables_command_state (nft-shared.c:1236)
   by 0x119AF5: nft_rule_zero_counters (nft.c:2877)
   by 0x11A3CA: nft_prepare (nft.c:3445)
   by 0x11A7A8: nft_commit (nft.c:3479)
   by 0x114258: xtables_main.isra.0 (xtables-standalone.c:94)
   by 0x1142D9: xtables_ip6_main (xtables-standalone.c:118)
   by 0x49F2349: (below main) (in /lib64/libc.so.6)

Have to free the matches/target in populated iptables_command_state object
again. While being at it, call the proper family_ops callbacks since this is
family-agnostic code.

Fixes: a69cc575295ee ("xtables: allow to reset the counters of an existing rule")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4af55341a210f..5def01ad6bfbc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2873,10 +2873,11 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 		goto error;
 	}
 
-	nft_rule_to_iptables_command_state(h, r, &cs);
-
+	h->ops->rule_to_cs(h, r, &cs);
 	cs.counters.pcnt = cs.counters.bcnt = 0;
 	new_rule = nft_rule_new(h, chain, table, &cs);
+	h->ops->clear_cs(&cs);
+
 	if (!new_rule)
 		return 1;
 
-- 
2.38.0

