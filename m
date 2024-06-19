Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9816B155336;
	Wed, 19 Jun 2024 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816753; cv=none; b=VnICg1RLOOGeFz8feRw7vUjfTNXl4bDCi09ECfvbMv8V94/NBqZ/Ao+3meFV/Sw0nwCzhfzQlhZJ3bdMer3sguQi+JVv8TmqSvI6u+umQscAbyuEl3hDA/LSU59BYX1nQASwkABgb+jT7KQeL0VHFhEhlnsSKw1/RxX/tJVqKLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816753; c=relaxed/simple;
	bh=ghaDSulpqSeZBH9oCxSvkq4K9zMalcbbcY/PLUHxgAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mM6yG6ftuqsshGteiPlRKD/kqN0S1IJQKYdeDG0b509qriIGLIJH6vywtk8ttqwiPLCl8SQTNx7KToLAJ6hN06eH2w0tL2HlicTBeKI+ZD6YL/TSWVjLfoKKqDaBmlPkb8b2vHWAnJHV51sb8LGP4dKLZ2lovBNi5x8Lux9JxSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 3/5] netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core
Date: Wed, 19 Jun 2024 19:05:35 +0200
Message-Id: <20240619170537.2846-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240619170537.2846-1-pablo@netfilter.org>
References: <20240619170537.2846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianguo Wu <wujianguo@chinatelecom.cn>

Currently, the sysctl net.netfilter.nf_hooks_lwtunnel depends on the
nf_conntrack module, but the nf_conntrack module is not always loaded.
Therefore, accessing net.netfilter.nf_hooks_lwtunnel may have an error.

Move sysctl nf_hooks_lwtunnel into the netfilter core.

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/netfilter.h           |  3 ++
 net/netfilter/core.c                    | 13 ++++-
 net/netfilter/nf_conntrack_standalone.c | 15 ------
 net/netfilter/nf_hooks_lwtunnel.c       | 67 +++++++++++++++++++++++++
 net/netfilter/nf_internals.h            |  6 +++
 5 files changed, 87 insertions(+), 17 deletions(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 02bbdc577f8e..a6a0bf4a247e 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -15,6 +15,9 @@ struct netns_nf {
 	const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO];
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header *nf_log_dir_header;
+#ifdef CONFIG_LWTUNNEL
+	struct ctl_table_header *nf_lwtnl_dir_header;
+#endif
 #endif
 	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
 	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3126911f5042..b00fc285b334 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -815,12 +815,21 @@ int __init netfilter_init(void)
 	if (ret < 0)
 		goto err;
 
+#ifdef CONFIG_LWTUNNEL
+	ret = netfilter_lwtunnel_init();
+	if (ret < 0)
+		goto err_lwtunnel_pernet;
+#endif
 	ret = netfilter_log_init();
 	if (ret < 0)
-		goto err_pernet;
+		goto err_log_pernet;
 
 	return 0;
-err_pernet:
+err_log_pernet:
+#ifdef CONFIG_LWTUNNEL
+	netfilter_lwtunnel_fini();
+err_lwtunnel_pernet:
+#endif
 	unregister_pernet_subsys(&netfilter_net_ops);
 err:
 	return ret;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 74112e9c5dab..6c40bdf8b05a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -22,9 +22,6 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
-#ifdef CONFIG_LWTUNNEL
-#include <net/netfilter/nf_hooks_lwtunnel.h>
-#endif
 #include <linux/rculist_nulls.h>
 
 static bool enable_hooks __read_mostly;
@@ -612,9 +609,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
 #endif
-#ifdef CONFIG_LWTUNNEL
-	NF_SYSCTL_CT_LWTUNNEL,
-#endif
 
 	NF_SYSCTL_CT_LAST_SYSCTL,
 };
@@ -946,15 +940,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.proc_handler   = proc_dointvec_jiffies,
 	},
 #endif
-#ifdef CONFIG_LWTUNNEL
-	[NF_SYSCTL_CT_LWTUNNEL] = {
-		.procname	= "nf_hooks_lwtunnel",
-		.data		= NULL,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
-	},
-#endif
 };
 
 static struct ctl_table nf_ct_netfilter_table[] = {
diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 00e89ffd78f6..7cdb59bb4459 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -3,6 +3,9 @@
 #include <linux/sysctl.h>
 #include <net/lwtunnel.h>
 #include <net/netfilter/nf_hooks_lwtunnel.h>
+#include <linux/netfilter.h>
+
+#include "nf_internals.h"
 
 static inline int nf_hooks_lwtunnel_get(void)
 {
@@ -50,4 +53,68 @@ int nf_hooks_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_sysctl_handler);
+
+static struct ctl_table nf_lwtunnel_sysctl_table[] = {
+	{
+		.procname	= "nf_hooks_lwtunnel",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
+	},
+};
+
+static int __net_init nf_lwtunnel_net_init(struct net *net)
+{
+	struct ctl_table_header *hdr;
+	struct ctl_table *table;
+
+	table = nf_lwtunnel_sysctl_table;
+	if (!net_eq(net, &init_net)) {
+		table = kmemdup(nf_lwtunnel_sysctl_table,
+				sizeof(nf_lwtunnel_sysctl_table),
+				GFP_KERNEL);
+		if (!table)
+			goto err_alloc;
+	}
+
+	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
+				     ARRAY_SIZE(nf_lwtunnel_sysctl_table));
+	if (!hdr)
+		goto err_reg;
+
+	net->nf.nf_lwtnl_dir_header = hdr;
+
+	return 0;
+err_reg:
+	if (!net_eq(net, &init_net))
+		kfree(table);
+err_alloc:
+	return -ENOMEM;
+}
+
+static void __net_exit nf_lwtunnel_net_exit(struct net *net)
+{
+	const struct ctl_table *table;
+
+	table = net->nf.nf_lwtnl_dir_header->ctl_table_arg;
+	unregister_net_sysctl_table(net->nf.nf_lwtnl_dir_header);
+	if (!net_eq(net, &init_net))
+		kfree(table);
+}
+
+static struct pernet_operations nf_lwtunnel_net_ops = {
+	.init = nf_lwtunnel_net_init,
+	.exit = nf_lwtunnel_net_exit,
+};
+
+int __init netfilter_lwtunnel_init(void)
+{
+	return register_pernet_subsys(&nf_lwtunnel_net_ops);
+}
+
+void netfilter_lwtunnel_fini(void)
+{
+	unregister_pernet_subsys(&nf_lwtunnel_net_ops);
+}
 #endif /* CONFIG_SYSCTL */
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 832ae64179f0..25403023060b 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -29,6 +29,12 @@ void nf_queue_nf_hook_drop(struct net *net);
 /* nf_log.c */
 int __init netfilter_log_init(void);
 
+#ifdef CONFIG_LWTUNNEL
+/* nf_hooks_lwtunnel.c */
+int __init netfilter_lwtunnel_init(void);
+void netfilter_lwtunnel_fini(void);
+#endif
+
 /* core.c */
 void nf_hook_entries_delete_raw(struct nf_hook_entries __rcu **pp,
 				const struct nf_hook_ops *reg);
-- 
2.30.2

