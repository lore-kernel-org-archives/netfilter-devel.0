From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: x_tables: unbreak module auto loading
Date: Tue,  9 Jan 2018 14:30:48 +0100
Message-ID: <20180109133048.9145-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44822 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751885AbeAINlF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 08:41:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

a typo causes module auto load support to never be compiled in.

Fixes: 03d13b6868a2 ("netfilter: xtables: add and use xt_request_find_table_lock")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.13.6

