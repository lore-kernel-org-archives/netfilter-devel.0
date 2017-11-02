From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] netfilter: conntrack: use power efficient workqueue
Date: Thu,  2 Nov 2017 16:16:07 +0100
Message-ID: <1509635767-12253-1-git-send-email-vincent.guittot@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51572 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933418AbdKBPRw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2017 11:17:52 -0400
Received: by mail-wm0-f68.google.com with SMTP id b9so12206531wmh.0
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Nov 2017 08:17:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

conntrack uses the bounded system_long_wq workqueue for its works that
don't have to run on the cpu they have been queued.
Using bounded workqueue prevents the scheduler to make smart decision about
the best place to schedule the work.

This patch replaces system_long_wq with system_power_efficient_wq. the work
stays bounded to a cpu by default unless the CONFIG_WQ_POWER_EFFICIENT is
enable. In the latter case, the work can be scheduled on the best cpu from
a power or a performance point of view.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0113039..ae7d3e4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1083,7 +1083,7 @@ static void gc_worker(struct work_struct *work)
 	next_run = gc_work->next_gc_run;
 	gc_work->last_bucket = i;
 	gc_work->early_drop = false;
-	queue_delayed_work(system_long_wq, &gc_work->dwork, next_run);
+	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
@@ -2084,7 +2084,7 @@ int nf_conntrack_init_start(void)
 		goto err_proto;
 
 	conntrack_gc_work_init(&conntrack_gc_work);
-	queue_delayed_work(system_long_wq, &conntrack_gc_work.dwork, HZ);
+	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
 
 	return 0;
 
-- 
2.7.4

