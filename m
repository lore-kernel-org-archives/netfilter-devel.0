From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] netfilter: nft_osf: use enum nft_data_types for nft_validate_register_store
Date: Tue,  2 Oct 2018 00:37:41 +0200
Message-ID: <20181001223745.29010-3-pablo@netfilter.org>
References: <20181001223745.29010-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001223745.29010-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

The function nft_validate_register_store requires a struct of type
struct nft_data_types. NFTA_DATA_VALUE is of type enum
nft_verdict_attributes. Pass the correct enum type.

This fixes a warning seen with Clang:
  net/netfilter/nft_osf.c:52:8: warning: implicit conversion from
    enumeration type 'enum nft_data_attributes' to different enumeration
    type 'enum nft_data_types' [-Wenum-conversion]
                                          NFTA_DATA_VALUE, NFT_OSF_MAXGENRELEN);
                                          ^~~~~~~~~~~~~~~

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Link: https://github.com/ClangBuiltLinux/linux/issues/103
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 5af74b37f423..a35fb59ace73 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -49,7 +49,7 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 
 	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
 	err = nft_validate_register_store(ctx, priv->dreg, NULL,
-					  NFTA_DATA_VALUE, NFT_OSF_MAXGENRELEN);
+					  NFT_DATA_VALUE, NFT_OSF_MAXGENRELEN);
 	if (err < 0)
 		return err;
 
-- 
2.11.0
