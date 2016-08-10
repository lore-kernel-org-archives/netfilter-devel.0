From: Loganaden Velvindron <logan@hackers.mu>
Subject: [PATCH] nf-next: x_tables: Replace kmalloc(s*n) with
 kmalloc_array(n,s)
Date: Wed, 10 Aug 2016 18:11:51 +0400
Message-ID: <20160810141146.GA22890@void>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from walmailout10.yourhostingaccount.com ([65.254.253.86]:44146 "EHLO
	walmailout10.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938826AbcHJSt3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:49:29 -0400
Received: from mailscan14.yourhostingaccount.com ([10.1.15.14] helo=walmailscan14.yourhostingaccount.com)
	by walmailout10.yourhostingaccount.com with esmtp (Exim)
	id 1bXUEi-0008P9-IV
	for netfilter-devel@vger.kernel.org; Wed, 10 Aug 2016 10:12:00 -0400
Received: from [10.114.3.33] (helo=walimpout13)
	by walmailscan14.yourhostingaccount.com with esmtp (Exim)
	id 1bXUEi-0001L7-EV
	for netfilter-devel@vger.kernel.org; Wed, 10 Aug 2016 10:12:00 -0400
Received: from void.dhcp.mu.afrinic.net ([196.1.0.18]:19686 helo=void)
	by walauthsmtp14.yourhostingaccount.com with esmtpa (Exim)
	id 1bXUEf-0005VM-1R
	for netfilter-devel@vger.kernel.org; Wed, 10 Aug 2016 10:11:57 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is easier to check that the calculation doesn't wrap or return a smaller
allocation.

Signed-off-by: Loganaden Velvindron <logan@hackers.mu>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e0aa7c1..c8f20f2 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1513,7 +1513,7 @@ xt_hook_ops_alloc(const struct xt_table *table, nf_hookfn *fn)
 	if (!num_hooks)
 		return ERR_PTR(-EINVAL);
 
-	ops = kmalloc(sizeof(*ops) * num_hooks, GFP_KERNEL);
+	ops = kmalloc_array(num_hooks, sizeof(*ops), GFP_KERNEL);
 	if (ops == NULL)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.9.2

