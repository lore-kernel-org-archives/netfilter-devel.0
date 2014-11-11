From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: nft_compat: relax chain type validation
Date: Tue, 11 Nov 2014 14:24:56 +0100
Message-ID: <1415712298-8592-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39383 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaKKNXN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:23:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check for nat chain dependency only, which is the one that can
actually crash the kernel. Don't care if mangle, filter and security
specific match and targets are used out of their scope, they are
harmless.

This restores iptables-compat with mangle specific match/target when
used out of the OUTPUT chain, that are actually emulated through filter
chains, which broke when performing strict validation.

Fixes: f3f5dde ("netfilter: nft_compat: validate chain type in match/target")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |   32 ++------------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 9d6d6f6..2bd4ec7 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -21,45 +21,17 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-static const struct {
-       const char	*name;
-       u8		type;
-} table_to_chaintype[] = {
-       { "filter",     NFT_CHAIN_T_DEFAULT },
-       { "raw",        NFT_CHAIN_T_DEFAULT },
-       { "security",   NFT_CHAIN_T_DEFAULT },
-       { "mangle",     NFT_CHAIN_T_ROUTE },
-       { "nat",        NFT_CHAIN_T_NAT },
-       { },
-};
-
-static int nft_compat_table_to_chaintype(const char *table)
-{
-	int i;
-
-	for (i = 0; table_to_chaintype[i].name != NULL; i++) {
-		if (strcmp(table_to_chaintype[i].name, table) == 0)
-			return table_to_chaintype[i].type;
-	}
-
-	return -1;
-}
-
 static int nft_compat_chain_validate_dependency(const char *tablename,
 						const struct nft_chain *chain)
 {
-	enum nft_chain_type type;
 	const struct nft_base_chain *basechain;
 
 	if (!tablename || !(chain->flags & NFT_BASE_CHAIN))
 		return 0;
 
-	type = nft_compat_table_to_chaintype(tablename);
-	if (type < 0)
-		return -EINVAL;
-
 	basechain = nft_base_chain(chain);
-	if (basechain->type->type != type)
+	if (strcmp(tablename, "nat") == 0 &&
+	    basechain->type->type != NFT_CHAIN_T_NAT)
 		return -EINVAL;
 
 	return 0;
-- 
1.7.10.4

