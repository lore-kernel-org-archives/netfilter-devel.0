From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: core: remove erroneous warn_on
Date: Wed,  6 Sep 2017 14:47:57 +0200
Message-ID: <20170906124757.13934-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34952 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753484AbdIFMri (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 08:47:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kernel test robot reported:

WARNING: CPU: 0 PID: 1244 at net/netfilter/core.c:218 __nf_hook_entries_try_shrink+0x49/0xcd
[..]

After allowing batching in nf_unregister_net_hooks its possible that an earlier
call to __nf_hook_entries_try_shrink already compacted the list.
If this happens we don't need to do anything.

Fixes: d3ad2c17b4047 ("netfilter: core: batch nf_unregister_net_hooks synchronize_net calls")
Reported-by: kernel test robot <xiaolong.ye@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 04fe25abc5f6..52cd2901a097 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -215,7 +215,7 @@ static void *__nf_hook_entries_try_shrink(struct nf_hook_entries __rcu **pp)
 	if (skip == hook_entries)
 		goto out_assign;
 
-	if (WARN_ON(skip == 0))
+	if (skip == 0)
 		return NULL;
 
 	hook_entries -= skip;
-- 
2.13.0

