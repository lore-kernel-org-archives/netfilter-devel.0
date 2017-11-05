From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 09/21] clusterip: exit_net cleanup check added
Date: Sun, 5 Nov 2017 19:50:24 +0300
Message-ID: <55697aff-a163-de3c-9b31-79d51246866c@virtuozzo.com>
References: <bafb347d-e36e-8b2b-7646-afc458a7a32a@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <bafb347d-e36e-8b2b-7646-afc458a7a32a@virtuozzo.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Be sure that configs list initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 17b4ca5..038f0a9 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -819,6 +819,8 @@ static void clusterip_net_exit(struct net *net)
 	cn->procdir = NULL;
 #endif
 	nf_unregister_net_hook(net, &cip_arp_ops);
+	WARN(!list_empty(&cn->configs),
+	     "%s: configs list is not empty\n"i, __func__);
 }
 
 static struct pernet_operations clusterip_net_ops = {
-- 
2.7.4
