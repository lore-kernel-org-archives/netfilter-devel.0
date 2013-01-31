From: pablo@netfilter.org
Subject: [nftables 01/10] netfilter: nf_tables: fix alias for xtables over nftables module
Date: Thu, 31 Jan 2013 01:01:48 +0100
Message-ID: <1359590517-4651-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:51733 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3AaACH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:02:07 -0500
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
index 33975a3..591bba0 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -666,7 +666,7 @@ static void __exit nft_compat_module_exit(void)
 	nft_target_release();
 }
 
-MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFTA_COMPAT);
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);
 
 module_init(nft_compat_module_init);
 module_exit(nft_compat_module_exit);
-- 
1.7.10.4

