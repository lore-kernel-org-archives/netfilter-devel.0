From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: x_tables: suppress kmemcheck warning
Date: Mon, 17 Oct 2016 21:50:23 +0200
Message-ID: <1476733823-10714-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49672 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758657AbcJQTvt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 15:51:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Markus Trippelsdorf reports:

WARNING: kmemcheck: Caught 64-bit read from uninitialized memory (ffff88001e605480)
4055601e0088ffff000000000000000090686d81ffffffff0000000000000000
 u u u u u u u u u u u u u u u u i i i i i i i i u u u u u u u u
 ^
|RIP: 0010:[<ffffffff8166e561>]  [<ffffffff8166e561>] nf_register_net_hook+0x51/0x160
[..]
 [<ffffffff8166e561>] nf_register_net_hook+0x51/0x160
 [<ffffffff8166eaaf>] nf_register_net_hooks+0x3f/0xa0
 [<ffffffff816d6715>] ipt_register_table+0xe5/0x110
[..]

This warning is harmless; we copy 'uninitialized' data from the hook ops
but it will not be used.
Long term the structures keeping run-time data should be disentangled
from those only containing config-time data (such as where in the list
to insert a hook), but thats -next material.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Suggested-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e0aa7c1d0224..fc4977456c30 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1513,7 +1513,7 @@ xt_hook_ops_alloc(const struct xt_table *table, nf_hookfn *fn)
 	if (!num_hooks)
 		return ERR_PTR(-EINVAL);
 
-	ops = kmalloc(sizeof(*ops) * num_hooks, GFP_KERNEL);
+	ops = kcalloc(num_hooks, sizeof(*ops), GFP_KERNEL);
 	if (ops == NULL)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.7.3

