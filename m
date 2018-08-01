From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] netfilter: nf_tables: remove redundant variables 'create' and 'ext'
Date: Wed, 1 Aug 2018 10:14:00 +0800
Message-ID: <20180801021400.13020-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        YueHaibing <yuehaibing@huawei.com>
To: <davem@davemloft.net>, <pablo@netfilter.org>,
        <kadlec@blackhole.kfki.hu>, <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Variables 'create' and 'ext'  are being assigned but are never used hence
they are redundant and can be removed.

Cleans up clang warnings:
net/netfilter/nf_tables_api.c:3364:7: warning: variable ‘create’ set but not used [-Wunused-but-set-variable]
net/netfilter/nf_tables_api.c:4032:28: warning: variable ‘ext’ set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/netfilter/nf_tables_api.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f180856..4a3085f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3361,7 +3361,6 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 	char *name;
 	unsigned int size;
-	bool create;
 	u64 timeout;
 	u32 ktype, dtype, flags, policy, gc_int, objtype;
 	struct nft_set_desc desc;
@@ -3462,8 +3461,6 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			return err;
 	}
 
-	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
-
 	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
@@ -4029,7 +4026,6 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
-	const struct nft_set_ext *ext;
 	struct nft_data_desc desc;
 	struct nft_set_elem elem;
 	struct sk_buff *skb;
@@ -4063,7 +4059,6 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return PTR_ERR(priv);
 
 	elem.priv = priv;
-	ext = nft_set_elem_ext(set, &elem);
 
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
-- 
2.7.0
