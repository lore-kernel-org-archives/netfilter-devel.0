From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/21] netfilter: nf_tables: remove unused variable
Date: Sun,  5 Aug 2018 23:21:32 +0200
Message-ID: <20180805212141.3033-13-pablo@netfilter.org>
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

From: YueHaibing <yuehaibing@huawei.com>

Variable 'ext' is being assigned but are never used hence they are
unused and can be removed.

Cleans up clang warnings:
net/netfilter/nf_tables_api.c:4032:28: warning: variable ‘ext’ set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 06d6af067619..debc1680607c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4029,7 +4029,6 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
-	const struct nft_set_ext *ext;
 	struct nft_data_desc desc;
 	struct nft_set_elem elem;
 	struct sk_buff *skb;
@@ -4063,7 +4062,6 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return PTR_ERR(priv);
 
 	elem.priv = priv;
-	ext = nft_set_elem_ext(set, &elem);
 
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
-- 
2.11.0
