From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] netfilter: ipt_ah: return boolean instead of integer
Date: Tue, 13 Feb 2018 08:25:57 -0600
Message-ID: <20180213142557.GA9008@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Return statements in functions returning bool should use
true/false instead of 1/0.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 net/ipv4/netfilter/ipt_ah.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index a787d07..7c6c20e 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -47,7 +47,7 @@ static bool ah_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 */
 		pr_debug("Dropping evil AH tinygram.\n");
 		par->hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return spi_match(ahinfo->spis[0], ahinfo->spis[1],
-- 
2.7.4
