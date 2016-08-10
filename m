From: Loganaden Velvindron <logan@hackers.mu>
Subject: [PATCH] x_tables: Replace kmalloc(s*n) with kmalloc_array(n,s)
Date: Wed, 10 Aug 2016 14:06:13 +0400
Message-ID: <20160810100613.GA8870@void>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail18.yourhostingaccount.com ([65.254.254.79]:58523 "EHLO
	walmailout08.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932533AbcHJTcR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:32:17 -0400
Received: from mailscan02.yourhostingaccount.com ([10.1.15.2] helo=walmailscan02.yourhostingaccount.com)
	by walmailout08.yourhostingaccount.com with esmtp (Exim)
	id 1bXQP0-00016d-4V
	for netfilter-devel@vger.kernel.org; Wed, 10 Aug 2016 06:06:22 -0400
Received: from [10.114.3.33] (helo=walimpout13)
	by walmailscan02.yourhostingaccount.com with esmtp (Exim)
	id 1bXQOz-0004QS-Vc
	for netfilter-devel@vger.kernel.org; Wed, 10 Aug 2016 06:06:21 -0400
Received: from [196.1.0.108] (port=31094 helo=void)
	by walauthsmtp04.yourhostingaccount.com with esmtpa (Exim)
	id 1bXQOw-0006gc-Er
	for netfilter-devel@vger.kernel.org; Wed, 10 Aug 2016 06:06:18 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace kmalloc(s*n) with kmalloc_array(n,s), thus making it
 easier to check that the calculation doesn't wrap or return a smaller
 allocation

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

