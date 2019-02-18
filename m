From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nf_tables: fix flush after rule deletion in the same batch
Date: Tue, 19 Feb 2019 00:08:22 +0100
Message-ID: <20190218230823.8114-2-pablo@netfilter.org>
References: <20190218230823.8114-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190218230823.8114-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Flush after rule deletion bogusly hits -ENOENT. Skip rules that have
been already from nft_delrule_by_chain() which is always called from the
flush path.

Fixes: cf9dc09d0949 ("netfilter: nf_tables: fix missing rules flushing per table")
Reported-by: Phil Sutter <phil@nwl.cc>
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5a92f23f179f..4893f248dfdc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -313,6 +313,9 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 	int err;
 
 	list_for_each_entry(rule, &ctx->chain->rules, list) {
+		if (!nft_is_active_next(ctx->net, rule))
+			continue;
+
 		err = nft_delrule(ctx, rule);
 		if (err < 0)
 			return err;
-- 
2.11.0
