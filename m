From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next] netfilter: conntrack: simplify init/uninit of L4 protocol trackers
Date: Fri, 21 Oct 2016 16:42:40 +0200
Message-ID: <22bf211a6755d8179835f707ed6e665ecb7ffbfc.1477060478.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934355AbcJUOnA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 10:43:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

modify registration and deregistration of layer-4 protocol trackers to
facilitate inclusion of new elements into the current list of built-in
protocols.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 93 +++++++++++---------------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 93 +++++++++++---------------
 2 files changed, 78 insertions(+), 108 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 713c09a..6ffe3dc 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -336,47 +336,44 @@ MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_ALIAS("ip_conntrack");
 MODULE_LICENSE("GPL");
 
+static struct nf_conntrack_l4proto *nf_conntrack_l4proto4[] = {
+	&nf_conntrack_l4proto_tcp4,
+	&nf_conntrack_l4proto_udp4,
+	&nf_conntrack_l4proto_icmp,
+};
+
 static int ipv4_net_init(struct net *net)
 {
-	int ret = 0;
+	int i, ret = 0;
 
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_tcp4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_tcp4: pernet registration failed\n");
-		goto out_tcp;
-	}
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_udp4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_udp4: pernet registration failed\n");
-		goto out_udp;
-	}
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_icmp);
-	if (ret < 0) {
-		pr_err("nf_conntrack_icmp4: pernet registration failed\n");
-		goto out_icmp;
+	for (i = 0; i < ARRAY_SIZE(nf_conntrack_l4proto4); i++) {
+		ret = nf_ct_l4proto_pernet_register(net,
+						    nf_conntrack_l4proto4[i]);
+		if (ret < 0)
+			goto cleanup_l4proto;
 	}
 	ret = nf_ct_l3proto_pernet_register(net, &nf_conntrack_l3proto_ipv4);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv4: pernet registration failed\n");
-		goto out_ipv4;
+		goto cleanup_l4proto;
 	}
 	return 0;
-out_ipv4:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
-out_icmp:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
-out_udp:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp4);
-out_tcp:
+cleanup_l4proto:
+	if (i < ARRAY_SIZE(nf_conntrack_l4proto4))
+		pr_err("nf_conntrack_%s4: pernet registration failed\n",
+		       nf_conntrack_l4proto4[i]->name);
+	while (--i >= 0)
+		nf_ct_l4proto_pernet_unregister(net, nf_conntrack_l4proto4[i]);
 	return ret;
 }
 
 static void ipv4_net_exit(struct net *net)
 {
+	int i;
+
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv4);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp4);
+	for (i = ARRAY_SIZE(nf_conntrack_l4proto4) - 1; i >= 0 ; i--)
+		nf_ct_l4proto_pernet_unregister(net, nf_conntrack_l4proto4[i]);
 }
 
 static struct pernet_operations ipv4_net_ops = {
@@ -386,7 +383,7 @@ static struct pernet_operations ipv4_net_ops = {
 
 static int __init nf_conntrack_l3proto_ipv4_init(void)
 {
-	int ret = 0;
+	int ret = 0, i;
 
 	need_conntrack();
 	nf_defrag_ipv4_enable();
@@ -410,38 +407,25 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 		goto cleanup_pernet;
 	}
 
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register tcp4 proto.\n");
-		goto cleanup_hooks;
-	}
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udp4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register udp4 proto.\n");
-		goto cleanup_tcp4;
-	}
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_icmp);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register icmpv4 proto.\n");
-		goto cleanup_udp4;
+	for (i = 0; i < ARRAY_SIZE(nf_conntrack_l4proto4); i++) {
+		ret = nf_ct_l4proto_register(nf_conntrack_l4proto4[i]);
+		if (ret < 0)
+			goto cleanup_l4proto;
 	}
 
 	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv4);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv4: can't register ipv4 proto.\n");
-		goto cleanup_icmpv4;
+		goto cleanup_l4proto;
 	}
 
 	return ret;
- cleanup_icmpv4:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmp);
- cleanup_udp4:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp4);
- cleanup_tcp4:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
- cleanup_hooks:
+cleanup_l4proto:
+	if (i < ARRAY_SIZE(nf_conntrack_l4proto4))
+		pr_err("nf_conntrack_ipv4: can't register %s4 proto.\n",
+		       nf_conntrack_l4proto4[i]->name);
+	while (--i >= 0)
+		nf_ct_l4proto_unregister(nf_conntrack_l4proto4[i]);
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
  cleanup_pernet:
 	unregister_pernet_subsys(&ipv4_net_ops);
@@ -452,11 +436,12 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 
 static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 {
+	int i;
+
 	synchronize_net();
 	nf_ct_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmp);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp4);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
+	for (i = ARRAY_SIZE(nf_conntrack_l4proto4) - 1; i >= 0; i--)
+		nf_ct_l4proto_unregister(nf_conntrack_l4proto4[i]);
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	unregister_pernet_subsys(&ipv4_net_ops);
 	nf_unregister_sockopt(&so_getorigdst);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 963ee38..4e219a1 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -336,47 +336,44 @@ static struct nf_sockopt_ops so_getorigdst6 = {
 	.owner		= THIS_MODULE,
 };
 
+static struct nf_conntrack_l4proto *nf_conntrack_l4proto6[] = {
+	&nf_conntrack_l4proto_tcp6,
+	&nf_conntrack_l4proto_udp6,
+	&nf_conntrack_l4proto_icmpv6,
+};
+
 static int ipv6_net_init(struct net *net)
 {
-	int ret = 0;
+	int i, ret = 0;
 
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_tcp6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_tcp6: pernet registration failed\n");
-		goto out;
-	}
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_udp6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_udp6: pernet registration failed\n");
-		goto cleanup_tcp6;
-	}
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_icmpv6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_icmp6: pernet registration failed\n");
-		goto cleanup_udp6;
+	for (i = 0; i < ARRAY_SIZE(nf_conntrack_l4proto6); i++) {
+		ret = nf_ct_l4proto_pernet_register(net,
+						    nf_conntrack_l4proto6[i]);
+		if (ret < 0)
+			goto cleanup_l4proto;
 	}
 	ret = nf_ct_l3proto_pernet_register(net, &nf_conntrack_l3proto_ipv6);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv6: pernet registration failed.\n");
-		goto cleanup_icmpv6;
+		goto cleanup_l4proto;
 	}
 	return 0;
- cleanup_icmpv6:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmpv6);
- cleanup_udp6:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp6);
- cleanup_tcp6:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp6);
- out:
+cleanup_l4proto:
+	if (i < ARRAY_SIZE(nf_conntrack_l4proto6))
+		pr_err("nf_conntrack_%s6: pernet registration failed.\n",
+		       nf_conntrack_l4proto6[i]->name);
+	while (--i >= 0)
+		nf_ct_l4proto_pernet_unregister(net, nf_conntrack_l4proto6[i]);
 	return ret;
 }
 
 static void ipv6_net_exit(struct net *net)
 {
+	int i;
+
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv6);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmpv6);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp6);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp6);
+	for (i = ARRAY_SIZE(nf_conntrack_l4proto6) - 1; i >= 0; i--)
+		nf_ct_l4proto_pernet_unregister(net, nf_conntrack_l4proto6[i]);
 }
 
 static struct pernet_operations ipv6_net_ops = {
@@ -386,7 +383,7 @@ static struct pernet_operations ipv6_net_ops = {
 
 static int __init nf_conntrack_l3proto_ipv6_init(void)
 {
-	int ret = 0;
+	int ret = 0, i;
 
 	need_conntrack();
 	nf_defrag_ipv6_enable();
@@ -409,38 +406,25 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 		goto cleanup_pernet;
 	}
 
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv6: can't register tcp6 proto.\n");
-		goto cleanup_hooks;
-	}
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udp6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv6: can't register udp6 proto.\n");
-		goto cleanup_tcp6;
-	}
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_icmpv6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv6: can't register icmpv6 proto.\n");
-		goto cleanup_udp6;
+	for (i = 0; i < ARRAY_SIZE(nf_conntrack_l4proto6); i++) {
+		ret = nf_ct_l4proto_register(nf_conntrack_l4proto6[i]);
+		if (ret < 0)
+			goto cleanup_l4proto;
 	}
 
 	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv6);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv6: can't register ipv6 proto.\n");
-		goto cleanup_icmpv6;
+		goto cleanup_l4proto;
 	}
 	return ret;
 
- cleanup_icmpv6:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
- cleanup_udp6:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp6);
- cleanup_tcp6:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
- cleanup_hooks:
+cleanup_l4proto:
+	if (i < ARRAY_SIZE(nf_conntrack_l4proto6))
+		pr_err("nf_conntrack_ipv6: can't register %s6 proto.\n",
+		       nf_conntrack_l4proto6[i]->name);
+	while (--i >= 0)
+		nf_ct_l4proto_unregister(nf_conntrack_l4proto6[i]);
 	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
  cleanup_pernet:
 	unregister_pernet_subsys(&ipv6_net_ops);
@@ -451,11 +435,12 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 
 static void __exit nf_conntrack_l3proto_ipv6_fini(void)
 {
+	int i;
+
 	synchronize_net();
 	nf_ct_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp6);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
+	for (i = 0; i < ARRAY_SIZE(nf_conntrack_l4proto6); i++)
+		nf_ct_l4proto_unregister(nf_conntrack_l4proto6[i]);
 	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
 	unregister_pernet_subsys(&ipv6_net_ops);
 	nf_unregister_sockopt(&so_getorigdst6);
-- 
2.5.5

