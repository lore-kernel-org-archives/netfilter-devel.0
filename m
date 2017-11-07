From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/23] netfilter: nf_tables: performance set policy skips size description in selection
Date: Tue,  7 Nov 2017 01:52:12 +0100
Message-ID: <20171107005213.22618-23-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Use the complexity and space notations if policy is performance, this
results in placing the bitmap set representation over the hashtable for
key <= 16 for better performance as we discussed during the last NFWS in
Faro, Portugal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 929927171426..3b4a0739ee39 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2549,14 +2549,9 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 		case NFT_SET_POL_PERFORMANCE:
 			if (est.lookup < best.lookup)
 				break;
-			if (est.lookup == best.lookup) {
-				if (!desc->size) {
-					if (est.space < best.space)
-						break;
-				} else if (est.size < best.size) {
-					break;
-				}
-			}
+			if (est.lookup == best.lookup &&
+			    est.space < best.space)
+				break;
 			continue;
 		case NFT_SET_POL_MEMORY:
 			if (!desc->size) {
-- 
2.11.0
