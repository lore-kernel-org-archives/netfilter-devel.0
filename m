From: pablo@netfilter.org
Subject: [PATCH 7/7] netfilter: nf_tables: fix alias for xtables over nftables module
Date: Thu, 10 Jan 2013 16:28:41 +0100
Message-ID: <1357831721-10182-7-git-send-email-pablo@netfilter.org>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37163 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab3AJP3C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:29:02 -0500
In-Reply-To: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

modinfo nft_compat
[...]
alias:        nfnetlink-subsys-NFNL_SUBSYS_NFTA_COMPAT

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 3cd6fd6..e00b05e 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -653,7 +653,7 @@ static void __exit nft_compat_module_exit(void)
 	nft_target_release();
 }
 
-MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFTA_COMPAT);
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);
 
 module_init(nft_compat_module_init);
 module_exit(nft_compat_module_exit);
-- 
1.7.10.4

