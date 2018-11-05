From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/14] netfilter: nft_osf: check if attribute is present
Date: Tue,  6 Nov 2018 00:28:20 +0100
Message-ID: <20181105232832.21896-3-pablo@netfilter.org>
References: <20181105232832.21896-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181105232832.21896-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

If the attribute is not sent, eg. old libnftnl binary, then
tb[NFTA_OSF_TTL] is NULL and kernel crashes from the _init path.

Fixes: a218dc82f0b5 ("netfilter: nft_osf: Add ttl option support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index ca5e5d8c5ef8..b13618c764ec 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -50,7 +50,7 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 	int err;
 	u8 ttl;
 
-	if (nla_get_u8(tb[NFTA_OSF_TTL])) {
+	if (tb[NFTA_OSF_TTL]) {
 		ttl = nla_get_u8(tb[NFTA_OSF_TTL]);
 		if (ttl > 2)
 			return -EINVAL;
-- 
2.11.0
