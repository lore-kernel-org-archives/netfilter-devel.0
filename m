From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 14/21] nfnetlink_log: exit_net cleanup check added
Date: Sun, 5 Nov 2017 13:01:42 +0300
Message-ID: <ae45057f-dbe2-d614-2172-fefea8876075@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:5491 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbdKEKB6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2017 05:01:58 -0500
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that instance_table array initialized in net_init hook
was return to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nfnetlink_log.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index cad6498..fa97566 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1093,10 +1093,17 @@ static int __net_init nfnl_log_net_init(struct net *net)
 
 static void __net_exit nfnl_log_net_exit(struct net *net)
 {
+	unsigned int i;
+	struct nfnl_log_net *log = nfnl_log_pernet(net);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", net->nf.proc_netfilter);
 #endif
 	nf_log_unset(net, &nfulnl_logger);
+	for (i = 0; i < INSTANCE_BUCKETS; i++)
+		if (WARN(!hlist_empty(&log->instance_table[i]),
+			 "net %p exit: nfnl_log instance_table is not empty\n",
+			 net))
+			break;
 }
 
 static struct pernet_operations nfnl_log_net_ops = {
-- 
2.7.4

