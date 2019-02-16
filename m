From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] netfilter: ipt_CLUSTERIP: make symbol 'cip_netdev_notifier' static
Date: Sat, 16 Feb 2019 08:16:06 +0000
Message-ID: <20190216081606.91596-1-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Taehee Yoo" <ap420073@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fixes the following sparse warnings:

net/ipv4/netfilter/ipt_CLUSTERIP.c:867:23: warning:
 symbol 'cip_netdev_notifier' was not declared. Should it be static?

Fixes: 5a86d68bcf02 ("netfilter: ipt_CLUSTERIP: fix deadlock in netns exit routine")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b61977d..91b369b 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -864,7 +864,7 @@ static void clusterip_net_exit(struct net *net)
 	.size = sizeof(struct clusterip_net),
 };
 
-struct notifier_block cip_netdev_notifier = {
+static struct notifier_block cip_netdev_notifier = {
 	.notifier_call = clusterip_netdev_event
 };
