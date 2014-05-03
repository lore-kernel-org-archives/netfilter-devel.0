From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2] Bridge: do not defragment packets unless connection
 tracking is enabled
Date: Sat, 03 May 2014 11:18:32 +0400
Message-ID: <53649848.2010506@parallels.com>
References: <20140502225522.GA12404@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:14143 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaECHUE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 May 2014 03:20:04 -0400
In-Reply-To: <20140502225522.GA12404@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently bridge can silently drop ipv4 fragments.
If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
br_nf_pre_routing defragments incoming ipv4 fragments, but skb->nfct check
in br_nf_dev_queue_xmit does not allow to re-fragment combined packet back,
and therefore it is dropped in br_dev_queue_push_xmit without incrementing
of any failcounters.

According to Patrick McHardy, bridge should not defragment and fragment
packets unless conntrack is enabled.

This patch adds per network namespace flag to manage ipv4 defragmentation
in bridge.

v2: added missed hooks: nf_conntrack pernet_operations hooks changes flag state

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 include/net/netns/conntrack.h                  |    1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   39 +++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 773cce3..7589937 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -25,6 +25,7 @@ struct nf_proto_net {
 struct nf_generic_net {
 	struct nf_proto_net pn;
 	unsigned int timeout;
+	bool br_ipv4_defrag_disabled;
 };
 
 struct nf_tcp_net {
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 8127dc8..9ca9333 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -432,6 +432,7 @@ static int ipv4_net_init(struct net *net)
 		pr_err("nf_conntrack_ipv4: pernet registration failed\n");
 		goto out_ipv4;
 	}
+	net->ct.nf_ct_proto.generic.br_ipv4_defrag_disabled = false;
 	return 0;
 out_ipv4:
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
@@ -445,6 +446,7 @@ out_tcp:
 
 static void ipv4_net_exit(struct net *net)
 {
+	net->ct.nf_ct_proto.generic.br_ipv4_defrag_disabled = true;
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv4);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 12e13bd..0bd499b 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -86,6 +86,20 @@ static unsigned int ipv4_conntrack_defrag(const struct nf_hook_ops *ops,
 		enum ip_defrag_users user =
 			nf_ct_defrag_user(ops->hooknum, skb);
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK) && defined (CONFIG_BRIDGE_NETFILTER)
+		if ((user >= IP_DEFRAG_CONNTRACK_BRIDGE_IN) &&
+		    (user <= __IP_DEFRAG_CONNTRACK_BRIDGE_IN)) {
+#ifdef CONFIG_NET_NS
+			struct net *net = skb->sk->sk_net;
+#else
+			struct net *net = &init_net;
+#endif
+			/* A bridge should not defragment and fragment packets. 
+			   We only do it if connection tracking is enabled. */
+			if (net->ct.nf_ct_proto.generic.br_ipv4_defrag_disabled)
+				return NF_ACCEPT;
+		}
+#endif
 		if (nf_ct_ipv4_gather_frags(skb, user))
 			return NF_STOLEN;
 	}
@@ -109,14 +123,37 @@ static struct nf_hook_ops ipv4_defrag_ops[] = {
 	},
 };
 
+static int nf_defrag_ipv4_net_init(struct net *net)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	net->ct.nf_ct_proto.generic.br_ipv4_defrag_disabled = true;
+#endif
+	return 0;
+}
+
+static struct pernet_operations nf_defrag_ipv4_net_ops = {
+	.init = nf_defrag_ipv4_net_init,
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

