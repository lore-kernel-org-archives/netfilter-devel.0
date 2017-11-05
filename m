From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 17/21] hashlimit: exit_net cleanup check added
Date: Sun, 5 Nov 2017 13:02:09 +0300
Message-ID: <32ef6c18-ccf4-39fd-7128-04456da2402e@virtuozzo.com>
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

Be sure that htables array initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/xt_hashlimit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5da8746..78485d1 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -1338,7 +1338,11 @@ static int __net_init hashlimit_net_init(struct net *net)
 
 static void __net_exit hashlimit_net_exit(struct net *net)
 {
+	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
+
 	hashlimit_proc_net_exit(net);
+	WARN(!hlist_empty(&hashlimit_net->htables),
+	     "net %p exit: hashlimit htables hlist is not empty\n", net);
 }
 
 static struct pernet_operations hashlimit_net_ops = {
-- 
2.7.4
