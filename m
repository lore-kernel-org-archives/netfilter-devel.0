Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E0AC48BE0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 21:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E611361009
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 21:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhFIVrk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 17:47:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60504 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhFIVrd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 17:47:33 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0D1716422E;
        Wed,  9 Jun 2021 23:44:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 11/13] netfilter: nfnetlink_hook: fix array index out-of-bounds error
Date:   Wed,  9 Jun 2021 23:45:21 +0200
Message-Id: <20210609214523.1678-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the array net->nf.hooks_ipv6 is accessed by index hook
before hook is sanity checked. Fix this by moving the sanity check
to before the array access.

Addresses-Coverity: ("Out-of-bounds access")
Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 04586dfa2acd..58fda6ac663b 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -181,9 +181,9 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
 		hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
 		break;
 	case NFPROTO_IPV6:
-		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
 		if (hook >= ARRAY_SIZE(net->nf.hooks_ipv6))
 			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
 		break;
 	case NFPROTO_ARP:
 #ifdef CONFIG_NETFILTER_FAMILY_ARP
-- 
2.30.2

