From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/7] netfilter: ipt_CLUSTERIP: fix warning unused variable cn
Date: Mon, 28 Jan 2019 15:04:05 +0100
Message-ID: <20190128140405.15020-8-pablo@netfilter.org>
References: <20190128140405.15020-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128140405.15020-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

When CONFIG_PROC_FS isn't set the variable cn isn't used.

net/ipv4/netfilter/ipt_CLUSTERIP.c: In function ‘clusterip_net_exit’:
net/ipv4/netfilter/ipt_CLUSTERIP.c:849:24: warning: unused variable ‘cn’ [-Wunused-variable]
  struct clusterip_net *cn = clusterip_pernet(net);
                        ^~

Rework so the variable 'cn' is declared inside "#ifdef CONFIG_PROC_FS".

Fixes: b12f7bad5ad3 ("netfilter: ipt_CLUSTERIP: remove wrong WARN_ON_ONCE in netns exit routine")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b61977db9b7f..2a909e5f9ba0 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -846,9 +846,9 @@ static int clusterip_net_init(struct net *net)
 
 static void clusterip_net_exit(struct net *net)
 {
+#ifdef CONFIG_PROC_FS
 	struct clusterip_net *cn = clusterip_pernet(net);
 
-#ifdef CONFIG_PROC_FS
 	mutex_lock(&cn->mutex);
 	proc_remove(cn->procdir);
 	cn->procdir = NULL;
-- 
2.11.0
