From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables kernel - PATCH 2/2] netfilter: nf_tables: Fix the netlink attributes policy for chain
Date: Mon,  7 Oct 2013 12:58:00 +0300
Message-ID: <1381139880-20311-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1381139880-20311-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3JGJ6H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:58:07 -0400
In-Reply-To: <1381139880-20311-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- Reorder them as they appear in enum nft_chain_attributes
- Add NFTA_CHAIN_COUNTERS

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7cab11d..dcddc49 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -520,13 +520,14 @@ static struct nft_chain *nf_tables_chain_lookup(const struct nft_table *table,
 }
 
 static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
+	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING },
 	[NFTA_CHAIN_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
-	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
 	[NFTA_CHAIN_TYPE]	= { .type = NLA_NUL_STRING },
+	[NFTA_CHAIN_COUNTERS]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nft_hook_policy[NFTA_HOOK_MAX + 1] = {
-- 
1.8.3.2

