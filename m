From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 1/5] clusterip: exit_net cleanup check added
Date: Sun, 12 Nov 2017 14:32:37 +0300
Message-ID: <289f473d-9410-01fd-0623-7ae6905734b6@virtuozzo.com>
References: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:34893 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdKLLct (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 06:32:49 -0500
In-Reply-To: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

