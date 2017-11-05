From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 14/21] nfnetlink_log: exit_net cleanup check added
Date: Sun, 5 Nov 2017 19:51:07 +0300
Message-ID: <2f4f3f01-7e0e-2c8e-3070-8cabc5f269f6@virtuozzo.com>
References: <bafb347d-e36e-8b2b-7646-afc458a7a32a@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:25105 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750769AbdKEQvN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2017 11:51:13 -0500
In-Reply-To: <bafb347d-e36e-8b2b-7646-afc458a7a32a@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that instance_table array initialized in net_init hook
was return to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nfnetlink_log.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index cad6498..c99f427 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1093,10 +1093,16 @@ static int __net_init nfnl_log_net_init(struct net *net)
 
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
+			 "%s: instance_table is not empty\n", __func__))
+			break;
 }
 
 static struct pernet_operations nfnl_log_net_ops = {
-- 
2.7.4

