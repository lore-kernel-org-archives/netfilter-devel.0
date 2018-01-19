From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/32] netfilter: x_tables: unbreak module auto loading
Date: Fri, 19 Jan 2018 20:10:17 +0100
Message-ID: <20180119191041.25804-9-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756203AbeASTK7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:10:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5AFC42EFEB1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:10:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48857DA84E
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:10:58 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

a typo causes module auto load support to never be compiled in.

Fixes: 03d13b6868a2 ("netfilter: xtables: add and use xt_request_find_table_lock")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 10c19a3f4cbd..5b8f3b7358e6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1082,7 +1082,7 @@ struct xt_table *xt_request_find_table_lock(struct net *net, u_int8_t af,
 {
 	struct xt_table *t = xt_find_table_lock(net, af, name);
 
-#ifdef CONFIG_MODULE
+#ifdef CONFIG_MODULES
 	if (IS_ERR(t)) {
 		int err = request_module("%stable_%s", xt_prefix[af], name);
 		if (err)
-- 
2.11.0

