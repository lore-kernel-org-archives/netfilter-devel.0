From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC] Bridge: do not defragment packets unless connection tracking
 is enabled
Date: Fri, 02 May 2014 19:40:54 +0400
Message-ID: <5363BC86.6050608@parallels.com>
References: <20140430092905.GA4318@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:42776 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbaEBPmq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:46 -0400
In-Reply-To: <20140430092905.GA4318@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Pablo, Florian,

could you please take look at patch below?
I've added per network namespace flag for manage of ipv4 defragmentation
in bridge. In OpenVZ we can have enabled conntracks in some container and
disabled in another ones. Seems this functionality was not merged into
mainline yet, however I hope it will be done sooner or later.

I'm not sure about name of flag variable and about its location.
I believe you can have better ideas about this.

Also I have one more question -- about defrag user check.

In my patch I use
if ((user >= IP_DEFRAG_CONNTRACK_BRIDGE_IN) && 
    (user <= __IP_DEFRAG_CONNTRACK_BRIDGE_IN))
because nf_ct_defrag_user can add zone.

I've found defrag user check in ip_expire() -- but it does not take
account of zone.
Is it a bug in ip_expire() or I missed something?

---[patch rfc]---
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

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 include/net/netns/conntrack.h                  |    1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   39 ++++++++++++++++++++++-
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
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index d807822..5f773d4 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -87,6 +87,20 @@ static unsigned int ipv4_conntrack_defrag(const struct nf_hook_ops *ops,
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
@@ -110,14 +124,37 @@ static struct nf_hook_ops ipv4_defrag_ops[] = {
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

