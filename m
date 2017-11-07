From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/23] netfilter: conntrack: use power efficient workqueue
Date: Tue,  7 Nov 2017 01:52:11 +0100
Message-ID: <20171107005213.22618-22-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

conntrack uses the bounded system_long_wq workqueue for its works that
don't have to run on the cpu they have been queued.
Using bounded workqueue prevents the scheduler to make smart decision about
the best place to schedule the work.

This patch replaces system_long_wq with system_power_efficient_wq. the work
stays bounded to a cpu by default unless the CONFIG_WQ_POWER_EFFICIENT is
enable. In the latter case, the work can be scheduled on the best cpu from
a power or a performance point of view.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0e516947c16f..5749fcaa2770 100644
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
@@ -2089,7 +2089,7 @@ int nf_conntrack_init_start(void)
 		goto err_proto;
 
 	conntrack_gc_work_init(&conntrack_gc_work);
-	queue_delayed_work(system_long_wq, &conntrack_gc_work.dwork, HZ);
+	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
 
 	return 0;
 
-- 
2.11.0
