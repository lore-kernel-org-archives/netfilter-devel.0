From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4 12/18] nfnetlink_gueue: exit_net cleanup check added
Date: Sun, 12 Nov 2017 11:47:01 +0300
Message-ID: <c0d49d64-d46b-21e6-02e4-4c445600bd39@virtuozzo.com>
References: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Be sure that instance_table array initialized in net_init hook
was return to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nfnetlink_queue.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c979662..fd41077 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1512,10 +1512,16 @@ static int __net_init nfnl_queue_net_init(struct net *net)
 
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
+		if (WARN_ON_ONCE(!hlist_empty(&q->instance_table[i])))
+			break;
 }
 
 static void nfnl_queue_net_exit_batch(struct list_head *net_exit_list)
-- 
2.7.4
