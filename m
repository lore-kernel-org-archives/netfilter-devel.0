From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/9] netfilter: nf_tables: use WARN_ON_ONCE instead of BUG_ON in nft_do_chain()
Date: Wed, 13 Jun 2018 12:56:57 +0200
Message-ID: <20180613105700.12894-7-pablo@netfilter.org>
References: <20180613105700.12894-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

When depth of chain is bigger than NFT_JUMP_STACK_SIZE, the nft_do_chain
crashes. But there is no need to crash hard here.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index deff10adef9c..8de912ca53d3 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -183,7 +183,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 
 	switch (regs.verdict.code) {
 	case NFT_JUMP:
-		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
+		if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
+			return NF_DROP;
 		jumpstack[stackptr].chain = chain;
 		jumpstack[stackptr].rules = rules + 1;
 		stackptr++;
-- 
2.11.0
