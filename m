Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0BEC6377D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D812961351
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhGVIIW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 04:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhGVIIW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 04:08:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94374C061575
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jul 2021 01:48:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1m6UO0-0000yc-56; Thu, 22 Jul 2021 10:48:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: ipt_CLUSTERIP: use clusterip_net to store pernet warning
Date:   Thu, 22 Jul 2021 10:48:33 +0200
Message-Id: <20210722084834.27027-3-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722084834.27027-1-fw@strlen.de>
References: <20210722084834.27027-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to use struct net for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 11bcf599358d..e6f65885d12b 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -66,6 +66,7 @@ struct clusterip_net {
 	/* lock protects the configs list */
 	spinlock_t lock;
 
+	bool clusterip_deprecated_warning;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *procdir;
 	/* mutex protects the config->pde*/
@@ -544,10 +545,10 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 
 	cn->hook_users++;
 
-	if (!par->net->xt.clusterip_deprecated_warning) {
+	if (!cn->clusterip_deprecated_warning) {
 		pr_info("ipt_CLUSTERIP is deprecated and it will removed soon, "
 			"use xt_cluster instead\n");
-		par->net->xt.clusterip_deprecated_warning = true;
+		cn->clusterip_deprecated_warning = true;
 	}
 
 	cipinfo->config = config;
-- 
2.31.1

