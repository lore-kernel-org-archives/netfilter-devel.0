From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/15] netfilter: nft_ct: make l3 protocol field optional for timeout object
Date: Fri, 17 Aug 2018 21:41:03 +0200
Message-ID: <20180817194106.2878-3-pablo@netfilter.org>
References: <20180817194106.2878-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817194106.2878-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Harsha Sharma <harshasharmaiitr@gmail.com>

If l3 protocol value is not specified for ct timeout object then use the
value from nft_ctx protocol family.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 4855d4ce1c8f..26a8baebd072 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -832,12 +832,13 @@ static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 	__u8 l4num;
 	int ret;
 
-	if (!tb[NFTA_CT_TIMEOUT_L3PROTO] ||
-	    !tb[NFTA_CT_TIMEOUT_L4PROTO] ||
+	if (!tb[NFTA_CT_TIMEOUT_L4PROTO] ||
 	    !tb[NFTA_CT_TIMEOUT_DATA])
 		return -EINVAL;
 
-	l3num = ntohs(nla_get_be16(tb[NFTA_CT_TIMEOUT_L3PROTO]));
+	if (tb[NFTA_CT_TIMEOUT_L3PROTO])
+		l3num = ntohs(nla_get_be16(tb[NFTA_CT_TIMEOUT_L3PROTO]));
+
 	l4num = nla_get_u8(tb[NFTA_CT_TIMEOUT_L4PROTO]);
 	priv->l4proto = l4num;
 
-- 
2.11.0
