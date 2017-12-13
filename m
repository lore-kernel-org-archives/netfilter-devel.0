From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/12] netfilter: ipt_CLUSTERIP: fix clusterip_net_exit build regression
Date: Wed, 13 Dec 2017 19:45:18 +0100
Message-ID: <20171213184520.8193-11-pablo@netfilter.org>
References: <20171213184520.8193-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171213184520.8193-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The added check produces a build error when CONFIG_PROC_FS is
disabled:

net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_net_exit':
net/ipv4/netfilter/ipt_CLUSTERIP.c:822:28: error: 'cn' undeclared (first use in this function)

This moves the variable declaration out of the #ifdef to make it
available to the WARN_ON_ONCE().

Fixes: 613d0776d3fe ("netfilter: exit_net cleanup check added")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0
