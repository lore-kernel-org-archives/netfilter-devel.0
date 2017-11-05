From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 09/21] clusterip: exit_net cleanup check added
Date: Sun, 5 Nov 2017 13:00:39 +0300
Message-ID: <848e8c16-63c4-decd-fb37-e592f89e2bef@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:1887 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751564AbdKEKBH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2017 05:01:07 -0500
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that configs list initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 17b4ca5..aa6ada3 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -819,6 +819,8 @@ static void clusterip_net_exit(struct net *net)
 	cn->procdir = NULL;
 #endif
 	nf_unregister_net_hook(net, &cip_arp_ops);
+	WARN(!list_empty(&cn->configs),
+	     "net %p exit: clusterip configs list is not empty\n", net);
 }
 
 static struct pernet_operations clusterip_net_ops = {
-- 
2.7.4

