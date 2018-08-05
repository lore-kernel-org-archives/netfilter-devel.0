From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/21] netfilter: nft_tproxy: Add missing config check
Date: Sun,  5 Aug 2018 23:21:34 +0200
Message-ID: <20180805212141.3033-15-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

A config check was missing form the code when using
nf_defrag_ipv6_enable with NFT_TPROXY != n and NF_DEFRAG_IPV6 = n and
this caused the following error:

../net/netfilter/nft_tproxy.c: In function 'nft_tproxy_init':
../net/netfilter/nft_tproxy.c:237:3: error: implicit declaration of function
+'nf_defrag_ipv6_enable' [-Werror=implicit-function-declaration]
   err = nf_defrag_ipv6_enable(ctx->net);

This patch adds a check for NF_TABLES_IPV6 when NF_DEFRAG_IPV6 is
selected by Kconfig.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tproxy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index c6845f7baa08..eff99dffc842 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -234,9 +234,11 @@ static int nft_tproxy_init(const struct nft_ctx *ctx,
 		err = nf_defrag_ipv4_enable(ctx->net);
 		if (err)
 			return err;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 		err = nf_defrag_ipv6_enable(ctx->net);
 		if (err)
 			return err;
+#endif
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.11.0
