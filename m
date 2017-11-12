From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 5/5] x_tables: exit_net cleanup check added
Date: Sun, 12 Nov 2017 14:35:07 +0300
Message-ID: <0b798b5c-74c1-386f-805c-9a1be2befc72@virtuozzo.com>
References: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:13637 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbdKLLfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 06:35:12 -0500
In-Reply-To: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that xt.tables array initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/x_tables.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d8571f4..02c1abb 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1714,8 +1714,17 @@ static int __net_init xt_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit xt_net_exit(struct net *net)
+{
+	int i;
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+		WARN_ON_ONCE(!list_empty(&net->xt.tables[i]));
+}
+
 static struct pernet_operations xt_net_ops = {
 	.init = xt_net_init,
+	.exit = xt_net_exit,
 };
 
 static int __init xt_init(void)
-- 
2.7.4

