From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/47] netfilter: conntrack: Change to deferable work queue
Date: Mon,  4 Sep 2017 00:25:49 +0200
Message-ID: <1504477589-12045-8-git-send-email-pablo@netfilter.org>
References: <1504477589-12045-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1504477589-12045-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "subashab@codeaurora.org" <subashab@codeaurora.org>

Delayed workqueue causes wakeups to idle CPUs. This was
causing a power impact for devices. Use deferable work
queue instead so that gc_worker runs when CPU is active only.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 69746928cc0a..c6f1cf0bff56 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1081,7 +1081,7 @@ static void gc_worker(struct work_struct *work)
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
-	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
+	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
 	gc_work->next_gc_run = HZ;
 	gc_work->exiting = false;
 }
-- 
2.1.4
