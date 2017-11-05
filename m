From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 16/21] x_tables: exit_net cleanup check added
Date: Sun, 5 Nov 2017 13:02:01 +0300
Message-ID: <3cf1e9ee-0432-0062-5c4f-c287a00de3df@virtuozzo.com>
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

Be sure that xt.tables array initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/x_tables.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d8571f4..7e74b37 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1714,8 +1714,18 @@ static int __net_init xt_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit xt_net_exit(struct net *net)
+{
+	int i;
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+		WARN(!list_empty(&net->xt.tables[i]),
+		     "net %p exit: xt tables list is not empty\n", net);
+}
+
 static struct pernet_operations xt_net_ops = {
 	.init = xt_net_init,
+	.exit = xt_net_exit,
 };
 
 static int __init xt_init(void)
-- 
2.7.4
