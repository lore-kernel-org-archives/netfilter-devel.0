From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v3 1/6] netfilter: nf_tables: No need to check chain existence when tracing
Date: Thu, 27 Jul 2017 16:56:39 +0200
Message-ID: <20170727145644.16888-2-phil@nwl.cc>
References: <20170727145644.16888-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53675 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbdG0O52 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 10:57:28 -0400
In-Reply-To: <20170727145644.16888-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_trace_notify() is called only from __nft_trace_packet(), which
assigns its parameter 'chain' to info->chain. __nft_trace_packet() in
turn later dereferences 'chain' unconditionally, which indicates that
it's never NULL. Same does nft_do_chain(), the only user of the tracing
infrastructure. Hence it is safe to assume the check removed here is not
needed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_trace.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e1b15e7a5793f..0c3a0049e4aa2 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -217,14 +217,11 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	if (trace_fill_id(skb, pkt->skb))
 		goto nla_put_failure;
 
-	if (info->chain) {
-		if (nla_put_string(skb, NFTA_TRACE_CHAIN,
-				   info->chain->name))
-			goto nla_put_failure;
-		if (nla_put_string(skb, NFTA_TRACE_TABLE,
-				   info->chain->table->name))
-			goto nla_put_failure;
-	}
+	if (nla_put_string(skb, NFTA_TRACE_CHAIN, info->chain->name))
+		goto nla_put_failure;
+
+	if (nla_put_string(skb, NFTA_TRACE_TABLE, info->chain->table->name))
+		goto nla_put_failure;
 
 	if (nf_trace_fill_rule_info(skb, info))
 		goto nla_put_failure;
-- 
2.13.1

