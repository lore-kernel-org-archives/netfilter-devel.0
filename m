From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: nf_tables: fix chain filter in nf_tables_dump_rules()
Date: Fri,  5 Jan 2018 16:08:23 +0100
Message-ID: <20180105150825.18460-2-pablo@netfilter.org>
References: <20180105150825.18460-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38760 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751720AbeAEPIe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jan 2018 10:08:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31586C5156
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jan 2018 16:08:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21C49DA3AA
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jan 2018 16:08:33 +0100 (CET)
In-Reply-To: <20180105150825.18460-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ctx->chain may be null now that we have very large object names,
so we cannot check for ctx->chain[0] here.

Fixes: b7263e071aba7 ("netfilter: nf_tables: Allow table names of up to 255 chars")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 10798b357481..8d4526651661 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2072,7 +2072,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				continue;
 
 			list_for_each_entry_rcu(chain, &table->chains, list) {
-				if (ctx && ctx->chain[0] &&
+				if (ctx && ctx->chain &&
 				    strcmp(ctx->chain, chain->name) != 0)
 					continue;
 
-- 
2.11.0

