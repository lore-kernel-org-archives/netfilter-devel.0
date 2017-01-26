From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/14] netfilter: nf_tables: fix spelling mistakes
Date: Thu, 26 Jan 2017 17:37:56 +0100
Message-ID: <1485448687-6072-4-git-send-email-pablo@netfilter.org>
References: <1485448687-6072-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753380AbdAZQjX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 11:39:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B6EA7651
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 17:38:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71F951B2FE5
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 17:38:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A980A7BEC
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 17:38:25 +0100 (CET)
In-Reply-To: <1485448687-6072-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Alexander Alemayhu <alexander@alemayhu.com>

o s/numerice/numeric
o s/opertaor/operator

Signed-off-by: Alexander Alemayhu <alexander@alemayhu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 881d49e94569..e3f27e09eb2b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -235,7 +235,7 @@ enum nft_rule_compat_flags {
 /**
  * enum nft_rule_compat_attributes - nf_tables rule compat attributes
  *
- * @NFTA_RULE_COMPAT_PROTO: numerice value of handled protocol (NLA_U32)
+ * @NFTA_RULE_COMPAT_PROTO: numeric value of handled protocol (NLA_U32)
  * @NFTA_RULE_COMPAT_FLAGS: bitmask of enum nft_rule_compat_flags (NLA_U32)
  */
 enum nft_rule_compat_attributes {
@@ -499,7 +499,7 @@ enum nft_bitwise_attributes {
  * enum nft_byteorder_ops - nf_tables byteorder operators
  *
  * @NFT_BYTEORDER_NTOH: network to host operator
- * @NFT_BYTEORDER_HTON: host to network opertaor
+ * @NFT_BYTEORDER_HTON: host to network operator
  */
 enum nft_byteorder_ops {
 	NFT_BYTEORDER_NTOH,
-- 
2.1.4

