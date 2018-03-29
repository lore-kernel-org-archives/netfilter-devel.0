From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH net-next 1/3] xfrm: Register xfrm_dev_notifier in
 appropriate place
Date: Thu, 29 Mar 2018 17:03:25 +0300
Message-ID: <152233220552.1654.7358556679252438991.stgit@localhost.localdomain>
References: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        daniel@iogearbox.net, jakub.kicinski@netronome.com, ast@kernel.org,
        brouer@redhat.com, linux@rasmusvillemoes.dk,
        john.fastabend@gmail.com, dsahern@gmail.com,
        netdev@vger.kernel.org, ktkhai@virtuozzo.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Currently, driver registers it from pernet_operations::init method,
and this breaks modularity, because initialization of net namespace
and netdevice notifiers are orthogonal actions. We don't have
per-namespace netdevice notifiers; all of them are global for all
devices in all namespaces.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 include/net/xfrm.h     |    2 +-
 net/xfrm/xfrm_device.c |    2 +-
 net/xfrm/xfrm_policy.c |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index aa027ba1d032..a872379b69da 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1894,7 +1894,7 @@ static inline struct xfrm_offload *xfrm_offload(struct sk_buff *skb)
 #endif
 }
 
-void __net_init xfrm_dev_init(void);
+void __init xfrm_dev_init(void);
 
 #ifdef CONFIG_XFRM_OFFLOAD
 void xfrm_dev_resume(struct sk_buff *skb);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index e87d6c4dd5b6..175941e15a6e 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -350,7 +350,7 @@ static struct notifier_block xfrm_dev_notifier = {
 	.notifier_call	= xfrm_dev_event,
 };
 
-void __net_init xfrm_dev_init(void)
+void __init xfrm_dev_init(void)
 {
 	register_netdevice_notifier(&xfrm_dev_notifier);
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 625b3fca5704..f29c8d588116 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2895,8 +2895,6 @@ static int __net_init xfrm_policy_init(struct net *net)
 	INIT_LIST_HEAD(&net->xfrm.policy_all);
 	INIT_WORK(&net->xfrm.policy_hash_work, xfrm_hash_resize);
 	INIT_WORK(&net->xfrm.policy_hthresh.work, xfrm_hash_rebuild);
-	if (net_eq(net, &init_net))
-		xfrm_dev_init();
 	return 0;
 
 out_bydst:
@@ -2999,6 +2997,7 @@ void __init xfrm_init(void)
 		INIT_WORK(&xfrm_pcpu_work[i], xfrm_pcpu_work_fn);
 
 	register_pernet_subsys(&xfrm_net_ops);
+	xfrm_dev_init();
 	seqcount_init(&xfrm_policy_hash_generation);
 	xfrm_input_init();
 }
