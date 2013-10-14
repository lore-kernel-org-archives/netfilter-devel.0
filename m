From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH 4/7] netfilter: nf_tables: Use a semantically relevant name on chain's refs
Date: Mon, 14 Oct 2013 15:46:53 +0300
Message-ID: <1381754816-28472-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab3JNMrH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:47:07 -0400
In-Reply-To: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFTA_CHAIN_USE is less semantically self-explaining than
NFTA_CHAIN_REFS.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 4 ++--
 net/netfilter/nf_tables_api.c            | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 28f0ffb..81eec3b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -129,7 +129,7 @@ enum nft_table_attributes {
  * @NFTA_CHAIN_NAME: name of the chain (NLA_STRING)
  * @NFTA_CHAIN_HOOK: hook specification for basechains (NLA_NESTED: nft_hook_attributes)
  * @NFTA_CHAIN_POLICY: numeric policy of the chain (NLA_U32)
- * @NFTA_CHAIN_USE: number of references to this chain (NLA_U32)
+ * @NFTA_CHAIN_REFS: number of references to this chain (NLA_U32)
  * @NFTA_CHAIN_TYPE: type name of the string (NLA_NUL_STRING)
  * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
  */
@@ -140,7 +140,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_NAME,
 	NFTA_CHAIN_HOOK,
 	NFTA_CHAIN_POLICY,
-	NFTA_CHAIN_USE,
+	NFTA_CHAIN_REFS,
 	NFTA_CHAIN_TYPE,
 	NFTA_CHAIN_COUNTERS,
 	__NFTA_CHAIN_MAX
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 482b689..951c264 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -614,7 +614,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, u32 portid, u32 seq,
 			goto nla_put_failure;
 	}
 
-	if (nla_put_be32(skb, NFTA_CHAIN_USE, htonl(chain->use)))
+	if (nla_put_be32(skb, NFTA_CHAIN_REFS, htonl(chain->use)))
 		goto nla_put_failure;
 
 	return nlmsg_end(skb, nlh);
-- 
1.8.3.2

