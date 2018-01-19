From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/32] netfilter: x_tables: don't return garbage pointer on modprobe failure
Date: Fri, 19 Jan 2018 20:10:27 +0100
Message-ID: <20180119191041.25804-19-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45294 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932444AbeASTLL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71B602EFEB3
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60385DA85A
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:06 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

request_module may return a positive error result from modprobe,
if we cast this to ERR_PTR this returns a garbage result (it passes
IS_ERR checks).

Fix it by ignoring modprobe return values entirely, just retry the
table lookup instead.

Reported-by: syzbot+980925dbfbc7f93bc2ef@syzkaller.appspotmail.com
Fixes: 03d13b6868a2 ("netfilter: xtables: add and use xt_request_find_table_lock")
Fixes: 20651cefd25f ("netfilter: x_tables: unbreak module auto loading")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 5b8f3b7358e6..3c2548787d78 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1085,7 +1085,7 @@ struct xt_table *xt_request_find_table_lock(struct net *net, u_int8_t af,
 #ifdef CONFIG_MODULES
 	if (IS_ERR(t)) {
 		int err = request_module("%stable_%s", xt_prefix[af], name);
-		if (err)
+		if (err < 0)
 			return ERR_PTR(err);
 		t = xt_find_table_lock(net, af, name);
 	}
-- 
2.11.0

