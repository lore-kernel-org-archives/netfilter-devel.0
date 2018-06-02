From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/20] netfilter: nf_tables: remove unused variables
Date: Sat,  2 Jun 2018 02:22:50 +0200
Message-ID: <20180602002259.4024-12-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

The comment and trace_loginfo are not used anymore.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 0548cd50ec26..47cf667b15ca 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -23,22 +23,6 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_log.h>
 
-static const char *const comments[__NFT_TRACETYPE_MAX] = {
-	[NFT_TRACETYPE_POLICY]	= "policy",
-	[NFT_TRACETYPE_RETURN]	= "return",
-	[NFT_TRACETYPE_RULE]	= "rule",
-};
-
-static const struct nf_loginfo trace_loginfo = {
-	.type = NF_LOG_TYPE_LOG,
-	.u = {
-		.log = {
-			.level = LOGLEVEL_WARNING,
-			.logflags = NF_LOG_DEFAULT_MASK,
-	        },
-	},
-};
-
 static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 					const struct nft_chain *chain,
 					enum nft_trace_types type)
-- 
2.11.0
