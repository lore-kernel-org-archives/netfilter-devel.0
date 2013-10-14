From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH 1/7] netfilter: nf_tables: Fix API documentation on a missing part
Date: Mon, 14 Oct 2013 15:46:50 +0300
Message-ID: <1381754816-28472-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab3JNMrD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:47:03 -0400
In-Reply-To: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the documentation for NFTA_BYTEORDER_SIZE attribute which was left
with a non relevant _TODO_.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index be8a062..b108548 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -398,7 +398,7 @@ enum nft_byteorder_ops {
  * @NFTA_BYTEORDER_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_BYTEORDER_OP: operator (NLA_U32: enum nft_byteorder_ops)
  * @NFTA_BYTEORDER_LEN: length of the data (NLA_U32)
- * @NFTA_BYTEORDER_SIZE: _TODO_ (NLA_U32)
+ * @NFTA_BYTEORDER_SIZE: data size in bytes (NLA_U32: 2 or 4)
  */
 enum nft_byteorder_attributes {
 	NFTA_BYTEORDER_UNSPEC,
-- 
1.8.3.2

