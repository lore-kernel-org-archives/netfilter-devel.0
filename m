From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 18/21] recent: exit_net cleanup check added
Date: Sun, 5 Nov 2017 19:51:41 +0300
Message-ID: <466c6e4e-063e-6edc-6eda-cb83150fea9c@virtuozzo.com>
References: <bafb347d-e36e-8b2b-7646-afc458a7a32a@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <bafb347d-e36e-8b2b-7646-afc458a7a32a@virtuozzo.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Be sure that tables list initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/xt_recent.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 245fa35..230d00f 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -681,7 +681,11 @@ static int __net_init recent_net_init(struct net *net)
 
 static void __net_exit recent_net_exit(struct net *net)
 {
+	struct recent_net *recent_net = recent_pernet(net);
+
 	recent_proc_net_exit(net);
+	WARN(!list_empty(&recent_net->tables),
+	     "%s: tables list is not empty\n", __func__);
 }
 
 static struct pernet_operations recent_net_ops = {
-- 
2.7.4
