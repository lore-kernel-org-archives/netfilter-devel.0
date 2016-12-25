From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/2] netfilter: nf_tables: add missing descriptions in nft_ct_keys
Date: Sun, 25 Dec 2016 19:58:58 +0800
Message-ID: <1482667139-63731-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:55723 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753137AbcLYMAA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Dec 2016 07:00:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We missed to add descriptions about NFT_CT_LABELS, NFT_CT_PKTS and
NFT_CT_BYTES, now add it.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 881d49e..5726f90 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -860,6 +860,9 @@ enum nft_rt_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
+ * @NFT_CT_LABELS: conntrack labels
+ * @NFT_CT_PKTS: conntrack packets
+ * @NFT_CT_BYTES: conntrack bytes
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
-- 
2.5.5


