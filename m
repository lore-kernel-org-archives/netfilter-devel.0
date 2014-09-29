From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/34] netfilter: nf_tables: add NFTA_MASQ_UNSPEC to nft_masq_attributes
Date: Mon, 29 Sep 2014 14:38:51 +0200
Message-ID: <1411994363-8451-3-git-send-email-pablo@netfilter.org>
References: <1411994363-8451-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1411994363-8451-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

To keep this consistent with other nft_*_attributes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index eeec0ae..66d66dd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -806,6 +806,7 @@ enum nft_nat_attributes {
  * @NFTA_MASQ_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
  */
 enum nft_masq_attributes {
+	NFTA_MASQ_UNSPEC,
 	NFTA_MASQ_FLAGS,
 	__NFTA_MASQ_MAX
 };
-- 
1.7.10.4
