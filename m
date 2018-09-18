From: Stefan Agner <stefan@agner.ch>
Subject: [PATCH] netfilter: nft_osf: use enum nft_data_types for nft_validate_register_store
Date: Mon, 17 Sep 2018 22:21:36 -0700
Message-ID: <20180918052136.25978-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
To: ffmancera@riseup.net, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The function nft_validate_register_store requires a struct of type
struct nft_data_types. NFTA_DATA_VALUE is of type enum
nft_verdict_attributes. Pass the correct enum type.

This fixes a warning seen with Clang:
  net/netfilter/nft_osf.c:52:8: warning: implicit conversion from
    enumeration type 'enum nft_data_attributes' to different enumeration
    type 'enum nft_data_types' [-Wenum-conversion]
                                          NFTA_DATA_VALUE, NFT_OSF_MAXGENRELEN);
                                          ^~~~~~~~~~~~~~~

Link: https://github.com/ClangBuiltLinux/linux/issues/103
Signed-off-by: Stefan Agner <stefan@agner.ch>
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
2.19.0
