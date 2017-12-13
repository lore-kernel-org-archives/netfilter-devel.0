From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/12] netfilter: exthdr: add missign attributes to policy
Date: Wed, 13 Dec 2017 19:45:19 +0100
Message-ID: <20171213184520.8193-12-pablo@netfilter.org>
References: <20171213184520.8193-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171213184520.8193-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add missing netlink attribute policy.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a0a93d987a3b..47ec1046ad11 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -214,6 +214,8 @@ static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
 	[NFTA_EXTHDR_OFFSET]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_LEN]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_OP]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_SREG]		= { .type = NLA_U32 },
 };
 
 static int nft_exthdr_init(const struct nft_ctx *ctx,
-- 
2.11.0
