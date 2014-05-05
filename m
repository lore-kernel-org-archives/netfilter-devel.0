From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 2/7] nf: initialization of ipv4 defragmentation users counter
Date: Mon, 05 May 2014 16:55:50 +0400
Message-ID: <53678A56.8060005@parallels.com>
References: <20140503233908.GA6297@localhost> <cover.1399292146.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:28422 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbaEEM5X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 08:57:23 -0400
In-Reply-To: <cover.1399292146.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/ipv4/netfilter/nf_defrag_ipv4.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index f40f321..f82685c 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -110,14 +110,44 @@ static struct nf_hook_ops ipv4_defrag_ops[] = {
 	},
 };
 
+static int nf_defrag_ipv4_net_init(struct net *net)
+{
+	atomic_set(&net->br_defrag_ipv4_users_count, 0);
+	return 0;
+}
+
+static void nf_defrag_ipv4_net_exit(struct net *net)
+{
+	if (unlikely(atomic_read(&net->br_defrag_ipv4_users_count) != 0)) {
+		pr_warn("net %p cleanup: br_defrag_users_count = %d\n",
+			net, atomic_read(&net->br_defrag_ipv4_users_count));
+	}
+}
+
+static struct pernet_operations nf_defrag_ipv4_net_ops = {
+	.init = nf_defrag_ipv4_net_init,
+	.exit = nf_defrag_ipv4_net_exit,
+};
+
 static int __init nf_defrag_init(void)
 {
-	return nf_register_hooks(ipv4_defrag_ops, ARRAY_SIZE(ipv4_defrag_ops));
+	int ret = 0;
+
+	ret = register_pernet_subsys(&nf_defrag_ipv4_net_ops);
+	if (ret)
+		goto out;
+
+	ret = nf_register_hooks(ipv4_defrag_ops, ARRAY_SIZE(ipv4_defrag_ops));
+	if (ret)
+		unregister_pernet_subsys(&nf_defrag_ipv4_net_ops);
+out:
+	return ret;
 }
 
 static void __exit nf_defrag_fini(void)
 {
 	nf_unregister_hooks(ipv4_defrag_ops, ARRAY_SIZE(ipv4_defrag_ops));
+	unregister_pernet_subsys(&nf_defrag_ipv4_net_ops);
 }
 
 void nf_defrag_ipv4_enable(void)
-- 
1.7.5.4

