From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: fix chain filter in nf_tables_dump_rules()
Date: Tue, 19 Dec 2017 12:04:43 +0100
Message-ID: <20171219110443.3286-1-pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55998 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759974AbdLSLE7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 06:04:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0452E2492E
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 12:04:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ECA16114D69
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 12:04:52 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ctx->chain may be null now that we have very large object names,
so we cannot check for ctx->chain[0] here.

Fixes: e46abbcc05aa ("netfilter: nf_tables: Allow table names of up to 255 chars")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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

