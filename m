From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4 09/18] clusterip: exit_net cleanup check added
Date: Sun, 12 Nov 2017 11:44:38 +0300
Message-ID: <48e377dc-e31f-1526-1e65-1049cc7251dc@virtuozzo.com>
References: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Be sure that configs list initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 17b4ca5..e35b8d0 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -819,6 +819,7 @@ static void clusterip_net_exit(struct net *net)
 	cn->procdir = NULL;
 #endif
 	nf_unregister_net_hook(net, &cip_arp_ops);
+	WARN_ON_ONCE(!list_empty(&cn->configs));
 }
 
 static struct pernet_operations clusterip_net_ops = {
-- 
2.7.4
