From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4 10/18] nf_tables: exit_net cleanup check added
Date: Sun, 12 Nov 2017 11:45:00 +0300
Message-ID: <90230d64-748a-5347-6cf7-4273e07e37eb@virtuozzo.com>
References: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
