Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146E9C48BCF
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 21:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0AAA613F0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 21:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFIVrl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 17:47:41 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60490 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhFIVrd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 17:47:33 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8DF9A64231;
        Wed,  9 Jun 2021 23:44:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/13] netfilter: nfnetlink_hook: add depends-on nftables
Date:   Wed,  9 Jun 2021 23:45:22 +0200
Message-Id: <20210609214523.1678-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nfnetlink_hook.c: In function 'nfnl_hook_put_nft_chain_info':
nfnetlink_hook.c:76:7: error: implicit declaration of 'nft_is_active'

This macro is only defined when NF_TABLES is enabled.
While its possible to also add an ifdef-guard, the infrastructure
is currently not useful without nf_tables.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 252956528caa ("netfilter: add new hook nfnl subsystem")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c81321372198..54395266339d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -22,6 +22,7 @@ config NETFILTER_FAMILY_ARP
 config NETFILTER_NETLINK_HOOK
 	tristate "Netfilter base hook dump support"
 	depends on NETFILTER_ADVANCED
+	depends on NF_TABLES
 	select NETFILTER_NETLINK
 	help
 	  If this option is enabled, the kernel will include support
-- 
2.30.2

