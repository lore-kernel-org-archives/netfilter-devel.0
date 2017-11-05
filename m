From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 15/21] nfnetlink_gueue: exit_net cleanup check added
Date: Sun, 5 Nov 2017 13:01:52 +0300
Message-ID: <3deb7ef5-4065-e3ae-14de-0dfabd58635e@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Be sure that instance_table array initialized in net_init hook
was return to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nfnetlink_queue.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c979662..c752eb7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1512,10 +1512,18 @@ static int __net_init nfnl_queue_net_init(struct net *net)
 
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
+			 "net %p exit: nfnl_queue instance_table isn't empty\n",
+			 net))
+			break;
 }
 
 static void nfnl_queue_net_exit_batch(struct list_head *net_exit_list)
-- 
2.7.4
