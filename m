From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/7] netfilter: nf_tables: selective rule dump needs table to be specified
Date: Mon, 14 Jan 2019 22:29:36 +0100
Message-ID: <20190114212940.5704-4-pablo@netfilter.org>
References: <20190114212940.5704-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190114212940.5704-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Table needs to be specified for selective rule dumps per chain.

Fixes: 241faeceb849c ("netfilter: nf_tables: Speed up selective rule dumps")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dcea979423bc..fb07f6cfc719 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2350,7 +2350,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 		if (ctx && ctx->table && strcmp(ctx->table, table->name) != 0)
 			continue;
 
-		if (ctx && ctx->chain) {
+		if (ctx && ctx->table && ctx->chain) {
 			struct rhlist_head *list, *tmp;
 
 			list = rhltable_lookup(&table->chains_ht, ctx->chain,
-- 
2.11.0
