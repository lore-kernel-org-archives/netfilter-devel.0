From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/15] netfilter: nf_tables: fix memory leak on error exit return
Date: Mon, 14 May 2018 00:36:56 +0200
Message-ID: <20180513223656.10077-16-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the -EBUSY error return path is not free'ing resources
allocated earlier, leaving a memory leak. Fix this by exiting via the
error exit label err5 that performs the necessary resource clean
up.

Detected by CoverityScan, CID#1432975 ("Resource leak")

Fixes: 9744a6fcefcb ("netfilter: nf_tables: check if same extensions are set when adding elements")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3806db31cbbf..91e80aa852d6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4080,8 +4080,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
 			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
 			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
-			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF))
-				return -EBUSY;
+			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF)) {
+				err = -EBUSY;
+				goto err5;
+			}
 			if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
 			     memcmp(nft_set_ext_data(ext),
-- 
2.11.0
