From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 2/5] nf_tables: exit_net cleanup check added
Date: Sun, 12 Nov 2017 14:33:09 +0300
Message-ID: <5664bc78-a292-a43d-f8d6-aed16017b3ce@virtuozzo.com>
References: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:16905 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750742AbdKLLdW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2017 06:33:22 -0500
In-Reply-To: <cb06dace-88a8-fecf-92ad-02920920a0d3@virtuozzo.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Be sure that lists initialized in net_init hook were return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nf_tables_api.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 64e1ee0..f432b53 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5778,6 +5778,12 @@ static int __net_init nf_tables_init_net(struct net *net)
 	return 0;
 }
 
+static void __net_exit nf_tables_exit_net(struct net *net)
+{
+	WARN_ON_ONCE(!list_empty(&net->nft.af_info));
+	WARN_ON_ONCE(!list_empty(&net->nft.commit_list));
+}
+
 int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
@@ -5848,6 +5854,7 @@ static void __nft_release_afinfo(struct net *net, struct nft_af_info *afi)
 
 static struct pernet_operations nf_tables_net_ops = {
 	.init	= nf_tables_init_net,
+	.exit	= nf_tables_exit_net,
 };
 
 static int __init nf_tables_module_init(void)
-- 
2.7.4

