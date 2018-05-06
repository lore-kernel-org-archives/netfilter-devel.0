From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 48/51] netfilter: nf_tables: Provide NFT_{RT,CT}_MAX for userspace
Date: Mon,  7 May 2018 00:47:06 +0200
Message-ID: <20180506224709.29100-49-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

These macros allow conveniently declaring arrays which use NFT_{RT,CT}_*
values as indexes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 5a5551a580f7..ce031cf72288 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -831,7 +831,9 @@ enum nft_rt_keys {
 	NFT_RT_NEXTHOP4,
 	NFT_RT_NEXTHOP6,
 	NFT_RT_TCPMSS,
+	__NFT_RT_MAX
 };
+#define NFT_RT_MAX		(__NFT_RT_MAX - 1)
 
 /**
  * enum nft_hash_types - nf_tables hash expression types
@@ -949,7 +951,9 @@ enum nft_ct_keys {
 	NFT_CT_DST_IP,
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
+	__NFT_CT_MAX
 };
+#define NFT_CT_MAX		(__NFT_CT_MAX - 1)
 
 /**
  * enum nft_ct_attributes - nf_tables ct expression netlink attributes
-- 
2.11.0
