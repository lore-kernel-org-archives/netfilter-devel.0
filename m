From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v3 15/21] nf_tables: exit_net cleanup check added
Date: Mon, 6 Nov 2017 16:25:15 +0300
Message-ID: <0fa951d6-3df2-d747-def6-ab996a38907b@virtuozzo.com>
References: <4fdc4264-e338-6ee8-a662-7d98b45733a1@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4fdc4264-e338-6ee8-a662-7d98b45733a1@virtuozzo.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Be sure that lists initialized in net_init hook were return
to initial state.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nf_tables_api.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 64e1ee0..3b7f518 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5778,6 +5778,16 @@ static int __net_init nf_tables_init_net(struct net *net)
 	return 0;
 }
 
+static void __net_exit nf_tables_exit_net(struct net *net)
+{
+	WARN_ONCE(!list_empty(&net->nft.af_info),
+		  "net %x %s: af_info list is not empty\n",
+		  net->ns.inum, __func__);
+	WARN_ONCE(!list_empty(&net->nft.commit_list),
+		  "net %x %s: commit_list is not empty\n",
+		  net->ns.inum, __func__);
+}
+
 int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
@@ -5848,6 +5858,7 @@ static void __nft_release_afinfo(struct net *net, struct nft_af_info *afi)
 
 static struct pernet_operations nf_tables_net_ops = {
 	.init	= nf_tables_init_net,
+	.exit	= nf_tables_exit_net,
 };
 
 static int __init nf_tables_module_init(void)
-- 
2.7.4
