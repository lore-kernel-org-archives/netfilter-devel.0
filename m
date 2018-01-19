From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 31/32] netfilter: nf_tables: set flowtable priority and hooknum field
Date: Fri, 19 Jan 2018 20:10:40 +0100
Message-ID: <20180119191041.25804-32-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Otherwise netlink dump sends uninitialized fields to userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1addc401ff7d..f87314c6dcc4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4946,6 +4946,8 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 		goto err1;
 	}
 
+	flowtable->hooknum	= hooknum;
+	flowtable->priority	= priority;
 	flowtable->ops		= ops;
 	flowtable->ops_len	= n;
 
-- 
2.11.0
