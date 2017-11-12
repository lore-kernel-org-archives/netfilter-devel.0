From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 4/5] nfnetlink_gueue: exit_net cleanup check added
Date: Sun, 12 Nov 2017 14:34:39 +0300
Message-ID: <12cadd19-9559-d9b1-b775-47f6af75a062@virtuozzo.com>
References: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:29451 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbdKLLep (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 06:34:45 -0500
In-Reply-To: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that instance_table array initialized in net_init hook
was return to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c979662..3cae6d8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1512,10 +1512,15 @@ static int __net_init nfnl_queue_net_init(struct net *net)
 
 static void __net_exit nfnl_queue_net_exit(struct net *net)
 {
+	unsigned int i;
+	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
+
 	nf_unregister_queue_handler(net);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_queue", net->nf.proc_netfilter);
 #endif
+	for (i = 0; i < INSTANCE_BUCKETS; i++)
+		WARN_ON_ONCE(!hlist_empty(&q->instance_table[i]));
 }
 
 static void nfnl_queue_net_exit_batch(struct list_head *net_exit_list)
-- 
2.7.4

