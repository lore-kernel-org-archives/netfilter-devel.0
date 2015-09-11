From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-4.2] netfilter: nf_tables: Use 32 bit addressing register from nft_type_to_reg()
Date: Fri, 11 Sep 2015 15:00:42 +0200
Message-ID: <1441976447-8338-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[ upstream commit bf798657eb5ba57552096843c315f096fdf9b715 ]

nft_type_to_reg() needs to return the register in the new 32 bit addressing,
otherwise we hit EINVAL when using mappings.

Fixes: 49499c3 ("netfilter: nf_tables: switch registers to 32 bit addressing")
Cc: <stable@vger.kernel.org> # 4.1.x
Cc: <stable@vger.kernel.org> # 4.2.x
Reported-by: Andreas Schultz <aschultz@tpip.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2a24668..aa8bee7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -125,7 +125,7 @@ static inline enum nft_data_types nft_dreg_to_type(enum nft_registers reg)
 
 static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
 {
-	return type == NFT_DATA_VERDICT ? NFT_REG_VERDICT : NFT_REG_1;
+	return type == NFT_DATA_VERDICT ? NFT_REG_VERDICT : NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE;
 }
 
 unsigned int nft_parse_register(const struct nlattr *attr);
-- 
1.7.10.4
