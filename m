From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: don't return garbage pointer on modprobe failure
Date: Sat, 13 Jan 2018 14:06:08 +0100
Message-ID: <20180113130608.13079-1-fw@strlen.de>
References: <94eb2c05629e4a8b0505629c32f0@google.com>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36498 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755104AbeAMNTu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jan 2018 08:19:50 -0500
In-Reply-To: <94eb2c05629e4a8b0505629c32f0@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

request_module may return a positive error result from modprobe,
if we cast this to ERR_PTR this returns a garbage result (it passes
IS_ERR checks).

Fix it by ignoring modprobe return values entirely, just retry the
table lookup instead.

Reported-by: syzbot+980925dbfbc7f93bc2ef@syzkaller.appspotmail.com
Fixes: 03d13b6868a2 ("netfilter: xtables: add and use xt_request_find_table_lock")
Fixes: 20651cefd25f ("netfilter: x_tables: unbreak module auto loading")
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.13.6

