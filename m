From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4 11/18] nfnetlink_log: exit_net cleanup check added
Date: Sun, 12 Nov 2017 11:46:20 +0300
Message-ID: <9702fe4f-6b5d-bd5c-de87-6bf7ded4fbf2@virtuozzo.com>
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
 net/netfilter/nfnetlink_log.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index cad6498..80236a2 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1093,10 +1093,15 @@ static int __net_init nfnl_log_net_init(struct net *net)
 
 static void __net_exit nfnl_log_net_exit(struct net *net)
 {
+	unsigned int i;
+	struct nfnl_log_net *log = nfnl_log_pernet(net);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", net->nf.proc_netfilter);
 #endif
 	nf_log_unset(net, &nfulnl_logger);
+	for (i = 0; i < INSTANCE_BUCKETS; i++)
+		if (WARN_ON_ONCE(!hlist_empty(&log->instance_table[i])))
+			break;
 }
 
 static struct pernet_operations nfnl_log_net_ops = {
-- 
2.7.4
