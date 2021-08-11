Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EDBC4320E
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 08:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F038760F41
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 08:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbhHKItp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 04:49:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44052 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbhHKItn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 04:49:43 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id B22486005D;
        Wed, 11 Aug 2021 10:48:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/10] netfilter: ipt_CLUSTERIP: use clusterip_net to store pernet warning
Date:   Wed, 11 Aug 2021 10:49:02 +0200
Message-Id: <20210811084908.14744-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210811084908.14744-1-pablo@netfilter.org>
References: <20210811084908.14744-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need to use struct net for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 6d7ff14b9084..8fd1aba8af31 100644
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
2.20.1

