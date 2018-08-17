From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/15] netfilter: nft_tproxy: Fix missing-braces warning
Date: Fri, 17 Aug 2018 21:41:05 +0200
Message-ID: <20180817194106.2878-5-pablo@netfilter.org>
References: <20180817194106.2878-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817194106.2878-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

This patch fixes a warning reported by the kbuild test robot (from linux-next
tree):
   net/netfilter/nft_tproxy.c: In function 'nft_tproxy_eval_v6':
>> net/netfilter/nft_tproxy.c:85:9: warning: missing braces around initializer [-Wmissing-braces]
     struct in6_addr taddr = {0};
            ^
   net/netfilter/nft_tproxy.c:85:9: warning: (near initialization for 'taddr.in6_u') [-Wmissing-braces]

This warning is actually caused by a gcc bug already resolved in newer
versions (kbuild used 4.9) so this kind of initialization is omitted and
memset is used instead.

Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tproxy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index eff99dffc842..f92a82c73880 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -82,13 +82,15 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	const struct nft_tproxy *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct in6_addr taddr = {0};
+	struct in6_addr taddr;
 	int thoff = pkt->xt.thoff;
 	struct udphdr _hdr, *hp;
 	__be16 tport = 0;
 	struct sock *sk;
 	int l4proto;
 
+	memset(&taddr, 0, sizeof(taddr));
+
 	if (!pkt->tprot_set) {
 		regs->verdict.code = NFT_BREAK;
 		return;
-- 
2.11.0
