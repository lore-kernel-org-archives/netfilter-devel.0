From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] netfilter: fix clusterip_net_exit build regression
Date: Thu,  7 Dec 2017 14:26:09 +0100
Message-ID: <20171207132636.259066-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Xin Long <lucien.xin@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The added check produces a build error when CONFIG_PROC_FS is
disabled:

net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_net_exit':
net/ipv4/netfilter/ipt_CLUSTERIP.c:822:28: error: 'cn' undeclared (first use in this function)

This moves the variable declaration out of the #ifdef to make it
available to the WARN_ON_ONCE().

Fixes: 613d0776d3fe ("netfilter: exit_net cleanup check added")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index e35b8d074f06..69060e3abe85 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -813,8 +813,8 @@ static int clusterip_net_init(struct net *net)
 
 static void clusterip_net_exit(struct net *net)
 {
-#ifdef CONFIG_PROC_FS
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
+#ifdef CONFIG_PROC_FS
 	proc_remove(cn->procdir);
 	cn->procdir = NULL;
 #endif
-- 
2.9.0
