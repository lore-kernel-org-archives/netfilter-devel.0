From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next] netfilter: conntrack: Change to deferable work queue
Date: Thu, 20 Jul 2017 19:42:19 -0600
Message-ID: <1500601339-3088-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47920 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965551AbdGUBnZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2017 21:43:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Delayed workqueue causes wakeups to idle CPUs. This was
causing a power impact for devices. Use deferable work
queue instead so that gc_worker runs when CPU is active only.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9979f46..2a51ef9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1084,7 +1084,7 @@ static void gc_worker(struct work_struct *work)
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
-	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
+	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
 	gc_work->next_gc_run = HZ;
 	gc_work->exiting = false;
 }
-- 
1.9.1

