From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/11] netfilter: ipt_CLUSTERIP: make symbol 'cip_netdev_notifier' static
Date: Mon, 18 Feb 2019 00:23:56 +0100
Message-ID: <20190217232357.29858-11-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warnings:

net/ipv4/netfilter/ipt_CLUSTERIP.c:867:23: warning:
 symbol 'cip_netdev_notifier' was not declared. Should it be static?

Fixes: 5a86d68bcf02 ("netfilter: ipt_CLUSTERIP: fix deadlock in netns exit routine")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b61977db9b7f..91b369bc44f9 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -864,7 +864,7 @@ static struct pernet_operations clusterip_net_ops = {
 	.size = sizeof(struct clusterip_net),
 };
 
-struct notifier_block cip_netdev_notifier = {
+static struct notifier_block cip_netdev_notifier = {
 	.notifier_call = clusterip_netdev_event
 };
 
-- 
2.11.0
