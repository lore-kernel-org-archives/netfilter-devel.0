From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v3 11/21] clusterip: exit_net cleanup check added
Date: Mon, 6 Nov 2017 16:24:42 +0300
Message-ID: <66995620-efe8-59ed-9097-a4fd96e30ae1@virtuozzo.com>
References: <4fdc4264-e338-6ee8-a662-7d98b45733a1@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:38646 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752749AbdKFNZC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 08:25:02 -0500
In-Reply-To: <4fdc4264-e338-6ee8-a662-7d98b45733a1@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that configs list initialized in net_init hook was return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 17b4ca5..4364a88 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -819,6 +819,9 @@ static void clusterip_net_exit(struct net *net)
 	cn->procdir = NULL;
 #endif
 	nf_unregister_net_hook(net, &cip_arp_ops);
+	WARN_ONCE(!list_empty(&cn->configs),
+		  "net %x %s: configs list is not empty\n",
+		  net->ns.inum, __func__);
 }
 
 static struct pernet_operations clusterip_net_ops = {
-- 
2.7.4

