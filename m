From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: [PATCH] netfilter: nf_tables: fix spelling mistakes
Date: Wed,  4 Jan 2017 23:16:41 +0100
Message-ID: <20170104221641.10477-1-alexander@alemayhu.com>
Cc: pablo@netfilter.org, Alexander Alemayhu <alexander@alemayhu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36201 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935690AbdADWQ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Jan 2017 17:16:56 -0500
Received: by mail-lf0-f43.google.com with SMTP id x140so16266774lfa.3
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jan 2017 14:16:52 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

o s/numerice/numeric
o s/opertaor/operator

Signed-off-by: Alexander Alemayhu <alexander@alemayhu.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b00a05d1ee56..7b730cab99bd 100644
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
2.11.0

