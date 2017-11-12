From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 3/5] nfnetlink_log: exit_net cleanup check added
Date: Sun, 12 Nov 2017 14:33:41 +0300
Message-ID: <51bcde50-cca2-ccda-1ba0-1d7e5b6e13e4@virtuozzo.com>
References: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:42785 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdKLLdr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 06:33:47 -0500
In-Reply-To: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that instance_table array initialized in net_init hook
was return to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index cad6498..23d75b1 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1093,10 +1093,14 @@ static int __net_init nfnl_log_net_init(struct net *net)
 
 static void __net_exit nfnl_log_net_exit(struct net *net)
 {
+	unsigned int i;
+	struct nfnl_log_net *log = nfnl_log_pernet(net);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", net->nf.proc_netfilter);
 #endif
 	nf_log_unset(net, &nfulnl_logger);
+	for (i = 0; i < INSTANCE_BUCKETS; i++)
+		WARN_ON_ONCE(!hlist_empty(&log->instance_table[i]));
 }
 
 static struct pernet_operations nfnl_log_net_ops = {
-- 
2.7.4

