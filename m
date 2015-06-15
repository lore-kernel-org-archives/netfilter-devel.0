From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 08/15] netfilter: nf_conntrack: adapt IPv4 and IPv6 trackers to pernet hooks
Date: Mon, 15 Jun 2015 17:46:50 +0200
Message-ID: <1434383217-13732-9-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36863 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbbFOPlv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:51 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since pernet hooks, we need to register the hook for each netnamespace space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h                  |    4 +++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   36 +++++++++++++------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   45 ++++++++++++++++--------
 3 files changed, 59 insertions(+), 26 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 29d6a94..b175886 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -104,6 +104,10 @@ struct netns_ct {
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
 	struct nf_ip_net	nf_ct_proto;
+
+	struct nf_hook_ops	*ipv4_conntrack_ops;
+	struct nf_hook_ops	*ipv6_conntrack_ops;
+
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
 	unsigned int		labels_used;
 	u8			label_words;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 2384975..ba96348 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -424,7 +424,28 @@ static int ipv4_net_init(struct net *net)
 		pr_err("nf_conntrack_ipv4: pernet registration failed\n");
 		goto out_ipv4;
 	}
+
+	net->ct.ipv4_conntrack_ops =
+		kmemdup(&ipv4_conntrack_ops, sizeof(ipv4_conntrack_ops),
+			GFP_KERNEL);
+	if (net->ct.ipv4_conntrack_ops == NULL) {
+		ret = -ENOMEM;
+		goto out_kmemdup;
+	}
+
+	ret = nf_register_hooks(net, net->ct.ipv4_conntrack_ops,
+				ARRAY_SIZE(ipv4_conntrack_ops));
+	if (ret < 0) {
+		pr_err("nf_conntrack_ipv4: can't register hooks.\n");
+		goto out_hook;
+	}
+
 	return 0;
+
+out_hook:
+	kfree(net->ct.ipv4_conntrack_ops);
+out_kmemdup:
+	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv4);
 out_ipv4:
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
 out_icmp:
@@ -437,6 +458,9 @@ out_tcp:
 
 static void ipv4_net_exit(struct net *net)
 {
+	nf_unregister_hooks(net->ct.ipv4_conntrack_ops,
+			    ARRAY_SIZE(ipv4_conntrack_ops));
+	kfree(net->ct.ipv4_conntrack_ops);
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv4);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
@@ -467,17 +491,10 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 		goto cleanup_sockopt;
 	}
 
-	ret = nf_register_hooks(&init_net, ipv4_conntrack_ops,
-				ARRAY_SIZE(ipv4_conntrack_ops));
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register hooks.\n");
-		goto cleanup_pernet;
-	}
-
 	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp4);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv4: can't register tcp4 proto.\n");
-		goto cleanup_hooks;
+		goto cleanup_pernet;
 	}
 
 	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udp4);
@@ -514,8 +531,6 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp4);
  cleanup_tcp4:
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
- cleanup_hooks:
-	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
  cleanup_pernet:
 	unregister_pernet_subsys(&ipv4_net_ops);
  cleanup_sockopt:
@@ -533,7 +548,6 @@ static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmp);
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp4);
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
-	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	unregister_pernet_subsys(&ipv4_net_ops);
 	nf_unregister_sockopt(&so_getorigdst);
 }
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 8bcf625..47a5862 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -366,19 +366,43 @@ static int ipv6_net_init(struct net *net)
 		pr_err("nf_conntrack_ipv6: pernet registration failed.\n");
 		goto cleanup_icmpv6;
 	}
+
+	net->ct.ipv6_conntrack_ops =
+		kmemdup(&ipv6_conntrack_ops, sizeof(ipv6_conntrack_ops),
+			GFP_KERNEL);
+	if (net->ct.ipv6_conntrack_ops == NULL) {
+		ret = -ENOMEM;
+		goto cleanup_ipv6;
+	}
+
+	ret = nf_register_hooks(net, net->ct.ipv6_conntrack_ops,
+				ARRAY_SIZE(ipv6_conntrack_ops));
+	if (ret < 0) {
+		pr_err("nf_conntrack_ipv6: can't register pre-routing defrag hook.\n");
+		goto cleanup_kmemdup;
+	}
+
 	return 0;
- cleanup_icmpv6:
+
+cleanup_kmemdup:
+	kfree(net->ct.ipv6_conntrack_ops);
+cleanup_ipv6:
+	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv6);
+cleanup_icmpv6:
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmpv6);
- cleanup_udp6:
+cleanup_udp6:
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp6);
- cleanup_tcp6:
+cleanup_tcp6:
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp6);
- out:
+out:
 	return ret;
 }
 
 static void ipv6_net_exit(struct net *net)
 {
+	nf_unregister_hooks(net->ct.ipv6_conntrack_ops,
+			    ARRAY_SIZE(ipv6_conntrack_ops));
+	kfree(net->ct.ipv6_conntrack_ops);
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv6);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmpv6);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp6);
@@ -407,18 +431,10 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 	if (ret < 0)
 		goto cleanup_sockopt;
 
-	ret = nf_register_hooks(&init_net, ipv6_conntrack_ops,
-				ARRAY_SIZE(ipv6_conntrack_ops));
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv6: can't register pre-routing defrag "
-		       "hook.\n");
-		goto cleanup_pernet;
-	}
-
 	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp6);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv6: can't register tcp6 proto.\n");
-		goto cleanup_hooks;
+		goto cleanup_pernet;
 	}
 
 	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udp6);
@@ -438,6 +454,7 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 		pr_err("nf_conntrack_ipv6: can't register ipv6 proto.\n");
 		goto cleanup_icmpv6;
 	}
+
 	return ret;
 
  cleanup_icmpv6:
@@ -446,8 +463,6 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp6);
  cleanup_tcp6:
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
- cleanup_hooks:
-	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
  cleanup_pernet:
 	unregister_pernet_subsys(&ipv6_net_ops);
  cleanup_sockopt:
-- 
1.7.10.4

