From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 13/21] nf_tables: exit_net cleanup check added
Date: Sun, 5 Nov 2017 13:01:29 +0300
Message-ID: <b146838b-3d95-2d0f-a859-a1689fb8ee0e@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:48682 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbdKEKBu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2017 05:01:50 -0500
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that lists initialized in net_init hook were return to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nf_tables_api.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 64e1ee0..60cbf0a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5778,6 +5778,14 @@ static int __net_init nf_tables_init_net(struct net *net)
 	return 0;
 }
 
+static void __net_exit nf_tables_exit_net(struct net *net)
+{
+	WARN(!list_empty(&net->nft.af_info),
+	     "net %p exit: nf_tables af_info list is not empty\n", net);
+	WARN(!list_empty(&net->nft.commit_list),
+	     "net %p exit: nf_tables commit_list is not empty\n", net);
+}
+
 int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
@@ -5848,6 +5856,7 @@ static void __nft_release_afinfo(struct net *net, struct nft_af_info *afi)
 
 static struct pernet_operations nf_tables_net_ops = {
 	.init	= nf_tables_init_net,
+	.exit	= nf_tables_exit_net,
 };
 
 static int __init nf_tables_module_init(void)
-- 
2.7.4

