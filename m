Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61D0C4743D
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 15:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF1DD6128E
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 15:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhFHPgK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:36:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38698 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhFHPgJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 11:36:09 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lqdk0-0006NO-AB; Tue, 08 Jun 2021 15:34:08 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] etfilter: fix array index out-of-bounds error
Date:   Tue,  8 Jun 2021 16:34:08 +0100
Message-Id: <20210608153408.160652-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
2.31.1

