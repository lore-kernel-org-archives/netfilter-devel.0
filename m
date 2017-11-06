From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v3 18/21] x_tables: exit_net cleanup check added
Date: Mon, 6 Nov 2017 16:25:40 +0300
Message-ID: <9e933fa0-0493-a1b4-1700-8b0763946979@virtuozzo.com>
References: <4fdc4264-e338-6ee8-a662-7d98b45733a1@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4fdc4264-e338-6ee8-a662-7d98b45733a1@virtuozzo.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Be sure that xt.tables array initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/x_tables.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d8571f4..dcdaf96 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1714,8 +1714,20 @@ static int __net_init xt_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit xt_net_exit(struct net *net)
+{
+	int i;
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++)
+		if (WARN_ONCE(!list_empty(&net->xt.tables[i]),
+			      "net %x %s: tables list is not empty\n",
+			      net->ns.inum. __func__)
+			break;
+}
+
 static struct pernet_operations xt_net_ops = {
 	.init = xt_net_init,
+	.exit = xt_net_exit,
 };
 
 static int __init xt_init(void)
-- 
2.7.4
