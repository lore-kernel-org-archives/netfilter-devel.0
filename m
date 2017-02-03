From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/27] netfilter: nf_tables: add missing descriptions in nft_ct_keys
Date: Fri,  3 Feb 2017 13:25:14 +0100
Message-ID: <1486124738-3013-4-git-send-email-pablo@netfilter.org>
References: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <zlpnobody@gmail.com>

We missed to add descriptions about NFT_CT_LABELS, NFT_CT_PKTS and
NFT_CT_BYTES, now add it.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 881d49e94569..5726f90bfc2f 100644
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
2.1.4
