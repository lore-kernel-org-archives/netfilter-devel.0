From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 15/21] nfnetlink_gueue: exit_net cleanup check added
Date: Sun, 5 Nov 2017 19:51:16 +0300
Message-ID: <f17fd3ab-cb9d-d038-3ba4-8af90b4dd2c0@virtuozzo.com>
References: <bafb347d-e36e-8b2b-7646-afc458a7a32a@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <bafb347d-e36e-8b2b-7646-afc458a7a32a@virtuozzo.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Be sure that instance_table array initialized in net_init hook
was return to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nfnetlink_queue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c979662..0fa56d9 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1512,10 +1512,17 @@ static int __net_init nfnl_queue_net_init(struct net *net)
 
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
+		if (WARN(!hlist_empty(&q->instance_table[i]),
+			 "%s: instance_table isn't empty\n", __func__))
+			break;
 }
 
 static void nfnl_queue_net_exit_batch(struct list_head *net_exit_list)
-- 
2.7.4
