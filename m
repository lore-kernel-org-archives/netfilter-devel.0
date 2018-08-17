From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/15] netfilter: nf_tables: fix register ordering
Date: Fri, 17 Aug 2018 21:38:42 +0200
Message-ID: <20180817193850.2796-8-pablo@netfilter.org>
References: <20180817193850.2796-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817193850.2796-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We must register nfnetlink ops last, as that exposes nf_tables to
userspace.  Without this, we could theoretically get nfnetlink request
before net->nft state has been initialized.

Fixes: 99633ab29b213 ("netfilter: nf_tables: complete net namespace support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 29 ++++++++++++++++++++++-------
 net/netfilter/nft_chain_filter.c  |  2 +-
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 552bfbef1bf1..0f39ac487012 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1374,6 +1374,6 @@ struct nft_trans_flowtable {
 	(((struct nft_trans_flowtable *)trans->data)->flowtable)
 
 int __init nft_chain_filter_init(void);
-void __exit nft_chain_filter_fini(void);
+void nft_chain_filter_fini(void);
 
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3008f93469c4..80636cc59686 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7273,21 +7273,36 @@ static int __init nf_tables_module_init(void)
 {
 	int err;
 
-	nft_chain_filter_init();
+	err = register_pernet_subsys(&nf_tables_net_ops);
+	if (err < 0)
+		return err;
+
+	err = nft_chain_filter_init();
+	if (err < 0)
+		goto err1;
 
 	err = nf_tables_core_module_init();
 	if (err < 0)
-		return err;
+		goto err2;
 
-	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	err = register_netdevice_notifier(&nf_tables_flowtable_notifier);
 	if (err < 0)
-		goto err;
+		goto err3;
 
-	register_netdevice_notifier(&nf_tables_flowtable_notifier);
+	/* must be last */
+	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	if (err < 0)
+		goto err4;
 
-	return register_pernet_subsys(&nf_tables_net_ops);
-err:
+	return err;
+err4:
+	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
+err3:
 	nf_tables_core_module_exit();
+err2:
+	nft_chain_filter_fini();
+err1:
+	unregister_pernet_subsys(&nf_tables_net_ops);
 	return err;
 }
 
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index ea5b7c4944f6..9d07b277b9ee 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -392,7 +392,7 @@ int __init nft_chain_filter_init(void)
 	return 0;
 }
 
-void __exit nft_chain_filter_fini(void)
+void nft_chain_filter_fini(void)
 {
 	nft_chain_filter_bridge_fini();
 	nft_chain_filter_inet_fini();
-- 
2.11.0
