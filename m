From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH] netfilter: nf_tables: Expose the table's chain usage to the netlink API
Date: Thu, 12 Dec 2013 15:00:42 +0200
Message-ID: <1386853244-16783-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31068 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3LLNAx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:00:53 -0500
In-Reply-To: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

User space can therefore know whether a table is in use or not, and by
how many chains.

Suggested by Pablo Neira Ayuso.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c            | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 256d36b..b25481e 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -110,11 +110,13 @@ enum nft_table_flags {
  *
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
+ * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
 	NFTA_TABLE_FLAGS,
+	NFTA_TABLE_USE,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dcddc49..604512d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -180,7 +180,8 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, u32 portid, u32 seq,
 	nfmsg->res_id		= 0;
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
-	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)))
+	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
+	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)))
 		goto nla_put_failure;
 
 	return nlmsg_end(skb, nlh);
-- 
1.8.4.4

