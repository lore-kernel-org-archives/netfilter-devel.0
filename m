From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next v2] netfilter: conntrack: simplify init/uninit of L4 protocol trackers
Date: Fri, 28 Oct 2016 10:42:09 +0200
Message-ID: <2b862e9bc046bc42def1a56611265ddbc640fddd.1477643522.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759631AbcJ1Imb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 04:42:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

modify registration and deregistration of layer-4 protocol trackers to
facilitate inclusion of new elements into the current list of builtin
protocols. Both builtin (TCP, UDP, ICMP) and non-builtin (DCCP, GRE, SCTP,
UDPlite) layer-4 protocol trackers usually register/deregister themselves
using consecutive calls to nf_ct_l4proto_{,pernet}_{,un}register(...).
This sequence is interrupted and rolled back in case of error; in order to
simplify addition of builtin protocols, the input of the above functions
has been modified to allow registering/unregistering multiple protocols.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---

Notes:
    v2:
        - reword commit message
        - change input of nf_ct_l4proto_{,pernet}_{,un}register(...) to
          accept arrays of struct nf_conntrack_l4proto *.
    
    please note:
        checkpatch.pl complains about coding style on some of the lines that
        were moved into a for() loop. This can be fixed too, but I propose to
        do that in a separate commit.

 include/net/netfilter/nf_conntrack_l4proto.h   |  12 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  76 +++-------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  78 ++++------
 net/netfilter/nf_conntrack_proto.c             | 191 +++++++++++++++----------
 net/netfilter/nf_conntrack_proto_dccp.c        |  48 ++-----
 net/netfilter/nf_conntrack_proto_gre.c         |  28 ++--
 net/netfilter/nf_conntrack_proto_sctp.c        |  50 ++-----
 net/netfilter/nf_conntrack_proto_udplite.c     |  50 ++-----
 8 files changed, 222 insertions(+), 311 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index de629f1..28f6d79 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -126,13 +126,17 @@ void nf_ct_l4proto_put(struct nf_conntrack_l4proto *p);
 
 /* Protocol pernet registration. */
 int nf_ct_l4proto_pernet_register(struct net *net,
-				  struct nf_conntrack_l4proto *proto);
+				  struct nf_conntrack_l4proto *proto[],
+				  int num_proto);
 void nf_ct_l4proto_pernet_unregister(struct net *net,
-				     struct nf_conntrack_l4proto *proto);
+				     struct nf_conntrack_l4proto *proto[],
+				     int num_proto);
 
 /* Protocol global registration. */
-int nf_ct_l4proto_register(struct nf_conntrack_l4proto *proto);
-void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *proto);
+int nf_ct_l4proto_register(struct nf_conntrack_l4proto *proto[],
+			   int num_proto);
+void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *proto[],
+			      int num_proto);
 
 /* Generic netlink helpers */
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 713c09a..7130ed5 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -336,47 +336,34 @@ MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_ALIAS("ip_conntrack");
 MODULE_LICENSE("GPL");
 
+static struct nf_conntrack_l4proto *builtin_l4proto4[] = {
+	&nf_conntrack_l4proto_tcp4,
+	&nf_conntrack_l4proto_udp4,
+	&nf_conntrack_l4proto_icmp,
+};
+
 static int ipv4_net_init(struct net *net)
 {
 	int ret = 0;
 
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
-	}
+	ret = nf_ct_l4proto_pernet_register(net, builtin_l4proto4,
+					    ARRAY_SIZE(builtin_l4proto4));
+	if (ret < 0)
+		return ret;
 	ret = nf_ct_l3proto_pernet_register(net, &nf_conntrack_l3proto_ipv4);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv4: pernet registration failed\n");
-		goto out_ipv4;
+		nf_ct_l4proto_pernet_unregister(net, builtin_l4proto4,
+						ARRAY_SIZE(builtin_l4proto4));
 	}
-	return 0;
-out_ipv4:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
-out_icmp:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
-out_udp:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp4);
-out_tcp:
 	return ret;
 }
 
 static void ipv4_net_exit(struct net *net)
 {
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv4);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp4);
+	nf_ct_l4proto_pernet_unregister(net, builtin_l4proto4,
+					ARRAY_SIZE(builtin_l4proto4));
 }
 
 static struct pernet_operations ipv4_net_ops = {
@@ -410,37 +397,21 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 		goto cleanup_pernet;
 	}
 
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register tcp4 proto.\n");
+	ret = nf_ct_l4proto_register(builtin_l4proto4,
+				     ARRAY_SIZE(builtin_l4proto4));
+	if (ret < 0)
 		goto cleanup_hooks;
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
-	}
 
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
+cleanup_l4proto:
+	nf_ct_l4proto_unregister(builtin_l4proto4,
+				 ARRAY_SIZE(builtin_l4proto4));
  cleanup_hooks:
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
  cleanup_pernet:
@@ -454,9 +425,8 @@ static void __exit nf_conntrack_l3proto_ipv4_fini(void)
 {
 	synchronize_net();
 	nf_ct_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmp);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp4);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
+	nf_ct_l4proto_unregister(builtin_l4proto4,
+				 ARRAY_SIZE(builtin_l4proto4));
 	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
 	unregister_pernet_subsys(&ipv4_net_ops);
 	nf_unregister_sockopt(&so_getorigdst);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 963ee38..500be28 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -336,47 +336,35 @@ static struct nf_sockopt_ops so_getorigdst6 = {
 	.owner		= THIS_MODULE,
 };
 
+static struct nf_conntrack_l4proto *builtin_l4proto6[] = {
+	&nf_conntrack_l4proto_tcp6,
+	&nf_conntrack_l4proto_udp6,
+	&nf_conntrack_l4proto_icmpv6,
+};
+
 static int ipv6_net_init(struct net *net)
 {
 	int ret = 0;
 
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
-	}
+	ret = nf_ct_l4proto_pernet_register(net, builtin_l4proto6,
+					    ARRAY_SIZE(builtin_l4proto6));
+	if (ret < 0)
+		return ret;
+
 	ret = nf_ct_l3proto_pernet_register(net, &nf_conntrack_l3proto_ipv6);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv6: pernet registration failed.\n");
-		goto cleanup_icmpv6;
+		nf_ct_l4proto_pernet_unregister(net, builtin_l4proto6,
+						ARRAY_SIZE(builtin_l4proto6));
 	}
-	return 0;
- cleanup_icmpv6:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmpv6);
- cleanup_udp6:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp6);
- cleanup_tcp6:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp6);
- out:
 	return ret;
 }
 
 static void ipv6_net_exit(struct net *net)
 {
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv6);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmpv6);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp6);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_tcp6);
+	nf_ct_l4proto_pernet_unregister(net, builtin_l4proto6,
+					ARRAY_SIZE(builtin_l4proto6));
 }
 
 static struct pernet_operations ipv6_net_ops = {
@@ -409,37 +397,20 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 		goto cleanup_pernet;
 	}
 
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv6: can't register tcp6 proto.\n");
+	ret = nf_ct_l4proto_register(builtin_l4proto6,
+				     ARRAY_SIZE(builtin_l4proto6));
+	if (ret < 0)
 		goto cleanup_hooks;
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
-	}
 
 	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv6);
 	if (ret < 0) {
 		pr_err("nf_conntrack_ipv6: can't register ipv6 proto.\n");
-		goto cleanup_icmpv6;
+		goto cleanup_l4proto;
 	}
 	return ret;
-
- cleanup_icmpv6:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
- cleanup_udp6:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp6);
- cleanup_tcp6:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
+cleanup_l4proto:
+	nf_ct_l4proto_unregister(builtin_l4proto6,
+				 ARRAY_SIZE(builtin_l4proto6));
  cleanup_hooks:
 	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
  cleanup_pernet:
@@ -453,9 +424,8 @@ static void __exit nf_conntrack_l3proto_ipv6_fini(void)
 {
 	synchronize_net();
 	nf_ct_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp6);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp6);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmpv6);
+	nf_ct_l4proto_unregister(builtin_l4proto6,
+				 ARRAY_SIZE(builtin_l4proto6));
 	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
 	unregister_pernet_subsys(&ipv6_net_ops);
 	nf_unregister_sockopt(&so_getorigdst6);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 8d2c7d8..10e609c 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -281,99 +281,136 @@ void nf_ct_l4proto_unregister_sysctl(struct net *net,
 
 /* FIXME: Allow NULL functions and sub in pointers to generic for
    them. --RR */
-int nf_ct_l4proto_register(struct nf_conntrack_l4proto *l4proto)
+int nf_ct_l4proto_register(struct nf_conntrack_l4proto *l4proto[],
+			   int num_proto)
 {
-	int ret = 0;
-
-	if (l4proto->l3proto >= PF_MAX)
-		return -EBUSY;
-
-	if ((l4proto->to_nlattr && !l4proto->nlattr_size)
-		|| (l4proto->tuple_to_nlattr && !l4proto->nlattr_tuple_size))
-		return -EINVAL;
+	struct nf_conntrack_l4proto *l4;
+	int ret = 0, j;
+
+	for (j = 0; j < num_proto; j++) {
+		l4 = l4proto[j];
+		if (l4->l3proto >= PF_MAX)
+			return -EBUSY;
+		if ((l4->to_nlattr && !l4->nlattr_size)
+		    || (l4->tuple_to_nlattr && !l4->nlattr_tuple_size))
+			return -EINVAL;
+	}
 
 	mutex_lock(&nf_ct_proto_mutex);
-	if (!nf_ct_protos[l4proto->l3proto]) {
-		/* l3proto may be loaded latter. */
-		struct nf_conntrack_l4proto __rcu **proto_array;
-		int i;
-
-		proto_array = kmalloc(MAX_NF_CT_PROTO *
-				      sizeof(struct nf_conntrack_l4proto *),
-				      GFP_KERNEL);
-		if (proto_array == NULL) {
-			ret = -ENOMEM;
-			goto out_unlock;
-		}
+	for (j = 0; j < num_proto; j++) {
+		l4 = l4proto[j];
+		if (!nf_ct_protos[l4->l3proto]) {
+			/* l3proto may be loaded latter. */
+			struct nf_conntrack_l4proto __rcu **proto_array;
+			int i;
+
+			proto_array = kmalloc(MAX_NF_CT_PROTO *
+					      sizeof(l4), GFP_KERNEL);
+			if (proto_array == NULL) {
+				ret = -ENOMEM;
+				break;
+			}
 
-		for (i = 0; i < MAX_NF_CT_PROTO; i++)
-			RCU_INIT_POINTER(proto_array[i], &nf_conntrack_l4proto_generic);
+			for (i = 0; i < MAX_NF_CT_PROTO; i++)
+				RCU_INIT_POINTER(proto_array[i],
+						 &nf_conntrack_l4proto_generic);
+
+			/* Before making proto_array visible to lockless readers
+			 * we must make sure its content is committed to memory.
+			 */
+			smp_wmb();
+
+			nf_ct_protos[l4->l3proto] = proto_array;
+		} else if (rcu_dereference_protected(
+				nf_ct_protos[l4->l3proto][l4->l4proto],
+				lockdep_is_held(&nf_ct_proto_mutex)
+				) != &nf_conntrack_l4proto_generic) {
+			ret = -EBUSY;
+			break;
+		}
 
-		/* Before making proto_array visible to lockless readers,
-		 * we must make sure its content is committed to memory.
-		 */
-		smp_wmb();
+		l4->nla_size = 0;
+		if (l4->nlattr_size)
+			l4->nla_size += l4->nlattr_size();
+		if (l4->nlattr_tuple_size)
+			l4->nla_size += 3 * l4->nlattr_tuple_size();
 
-		nf_ct_protos[l4proto->l3proto] = proto_array;
-	} else if (rcu_dereference_protected(
-			nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
-			lockdep_is_held(&nf_ct_proto_mutex)
-			) != &nf_conntrack_l4proto_generic) {
-		ret = -EBUSY;
-		goto out_unlock;
+		rcu_assign_pointer(nf_ct_protos[l4->l3proto][l4->l4proto], l4);
+	}
+	if (j < num_proto) {
+		int ver = l4->l3proto == PF_INET6 ? 6 : 4;
+
+		pr_err("nf_conntrack_ipv%d: can't register %s%d proto.\n",
+		       ver, l4->name, ver);
+		while (--j >= 0) {
+			l4 = l4proto[j];
+			BUG_ON(rcu_dereference_protected(
+					nf_ct_protos[l4->l3proto][l4->l4proto],
+					lockdep_is_held(&nf_ct_proto_mutex)
+					) != l4);
+			rcu_assign_pointer(
+				nf_ct_protos[l4->l3proto][l4->l4proto],
+				&nf_conntrack_l4proto_generic);
+		}
 	}
-
-	l4proto->nla_size = 0;
-	if (l4proto->nlattr_size)
-		l4proto->nla_size += l4proto->nlattr_size();
-	if (l4proto->nlattr_tuple_size)
-		l4proto->nla_size += 3 * l4proto->nlattr_tuple_size();
-
-	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
-			   l4proto);
-out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_register);
 
 int nf_ct_l4proto_pernet_register(struct net *net,
-				  struct nf_conntrack_l4proto *l4proto)
+				  struct nf_conntrack_l4proto *l4proto[],
+				  int num_proto)
 {
-	int ret = 0;
 	struct nf_proto_net *pn = NULL;
+	int i, ret = 0;
 
-	if (l4proto->init_net) {
-		ret = l4proto->init_net(net, l4proto->l3proto);
-		if (ret < 0)
-			goto out;
-	}
+	for (i = 0; i < num_proto; i++) {
+		if (l4proto[i]->init_net) {
+			ret = l4proto[i]->init_net(net, l4proto[i]->l3proto);
+			if (ret < 0)
+				break;
+		}
 
-	pn = nf_ct_l4proto_net(net, l4proto);
-	if (pn == NULL)
-		goto out;
+		pn = nf_ct_l4proto_net(net, l4proto[i]);
+		if (pn == NULL)
+			continue;
 
-	ret = nf_ct_l4proto_register_sysctl(net, pn, l4proto);
-	if (ret < 0)
-		goto out;
+		ret = nf_ct_l4proto_register_sysctl(net, pn, l4proto[i]);
+		if (ret < 0)
+			break;
 
-	pn->users++;
-out:
+		pn->users++;
+	}
+	if (i < num_proto) {
+		pr_err("nf_conntrack_%s%d: pernet registration failed.\n",
+		       l4proto[i]->name,
+		       l4proto[i]->l3proto == PF_INET6 ? 6 : 4);
+		nf_ct_l4proto_pernet_unregister(net, l4proto, i);
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_register);
 
-void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
+void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *l4proto[],
+			      int num_proto)
 {
-	BUG_ON(l4proto->l3proto >= PF_MAX);
+	int i;
+
+	for (i = 0; i < num_proto; i++)
+		BUG_ON(l4proto[i]->l3proto >= PF_MAX);
 
 	mutex_lock(&nf_ct_proto_mutex);
-	BUG_ON(rcu_dereference_protected(
-			nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
-			lockdep_is_held(&nf_ct_proto_mutex)
-			) != l4proto);
-	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
-			   &nf_conntrack_l4proto_generic);
+	while (--num_proto >= 0) {
+		struct nf_conntrack_l4proto *l4 = l4proto[num_proto];
+
+		BUG_ON(rcu_dereference_protected(
+				nf_ct_protos[l4->l3proto][l4->l4proto],
+				lockdep_is_held(&nf_ct_proto_mutex)
+				) != l4);
+		rcu_assign_pointer(nf_ct_protos[l4->l3proto][l4->l4proto],
+				   &nf_conntrack_l4proto_generic);
+	}
 	mutex_unlock(&nf_ct_proto_mutex);
 
 	synchronize_rcu();
@@ -381,19 +418,23 @@ void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister);
 
 void nf_ct_l4proto_pernet_unregister(struct net *net,
-				     struct nf_conntrack_l4proto *l4proto)
+				     struct nf_conntrack_l4proto *l4proto[],
+				     int num_proto)
 {
 	struct nf_proto_net *pn = NULL;
 
-	pn = nf_ct_l4proto_net(net, l4proto);
-	if (pn == NULL)
-		return;
+	while (--num_proto >= 0) {
+		pn = nf_ct_l4proto_net(net, l4proto[num_proto]);
+		if (pn == NULL)
+			continue;
 
-	pn->users--;
-	nf_ct_l4proto_unregister_sysctl(net, pn, l4proto);
+		pn->users--;
+		nf_ct_l4proto_unregister_sysctl(net, pn, l4proto[num_proto]);
 
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(net, kill_l4proto, l4proto, 0, 0);
+		/* Remove all contrack entries for this protocol */
+		nf_ct_iterate_cleanup(net, kill_l4proto, l4proto[num_proto],
+				      0, 0);
+	}
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister);
 
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index a45bee5..ac89769 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -936,30 +936,21 @@ static struct nf_conntrack_l4proto dccp_proto6 __read_mostly = {
 	.init_net		= dccp_init_net,
 };
 
+static struct nf_conntrack_l4proto *dccp_proto[] = {
+	&dccp_proto4,
+	&dccp_proto6,
+};
+
 static __net_init int dccp_net_init(struct net *net)
 {
-	int ret = 0;
-	ret = nf_ct_l4proto_pernet_register(net, &dccp_proto4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_dccp4: pernet registration failed.\n");
-		goto out;
-	}
-	ret = nf_ct_l4proto_pernet_register(net, &dccp_proto6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_dccp6: pernet registration failed.\n");
-		goto cleanup_dccp4;
-	}
-	return 0;
-cleanup_dccp4:
-	nf_ct_l4proto_pernet_unregister(net, &dccp_proto4);
-out:
-	return ret;
+	return nf_ct_l4proto_pernet_register(net, dccp_proto,
+					     ARRAY_SIZE(dccp_proto));
 }
 
 static __net_exit void dccp_net_exit(struct net *net)
 {
-	nf_ct_l4proto_pernet_unregister(net, &dccp_proto6);
-	nf_ct_l4proto_pernet_unregister(net, &dccp_proto4);
+	nf_ct_l4proto_pernet_unregister(net, dccp_proto,
+					ARRAY_SIZE(dccp_proto));
 }
 
 static struct pernet_operations dccp_net_ops = {
@@ -975,29 +966,16 @@ static int __init nf_conntrack_proto_dccp_init(void)
 
 	ret = register_pernet_subsys(&dccp_net_ops);
 	if (ret < 0)
-		goto out_pernet;
-
-	ret = nf_ct_l4proto_register(&dccp_proto4);
-	if (ret < 0)
-		goto out_dccp4;
-
-	ret = nf_ct_l4proto_register(&dccp_proto6);
+		return ret;
+	ret = nf_ct_l4proto_register(dccp_proto, ARRAY_SIZE(dccp_proto));
 	if (ret < 0)
-		goto out_dccp6;
-
-	return 0;
-out_dccp6:
-	nf_ct_l4proto_unregister(&dccp_proto4);
-out_dccp4:
-	unregister_pernet_subsys(&dccp_net_ops);
-out_pernet:
+		unregister_pernet_subsys(&dccp_net_ops);
 	return ret;
 }
 
 static void __exit nf_conntrack_proto_dccp_fini(void)
 {
-	nf_ct_l4proto_unregister(&dccp_proto6);
-	nf_ct_l4proto_unregister(&dccp_proto4);
+	nf_ct_l4proto_unregister(dccp_proto, ARRAY_SIZE(dccp_proto));
 	unregister_pernet_subsys(&dccp_net_ops);
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 9a715f8..3054f73 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -393,18 +393,20 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 __read_mostly = {
 	.init_net	= gre_init_net,
 };
 
+static struct nf_conntrack_l4proto *proto_gre[] = {
+	&nf_conntrack_l4proto_gre4,
+};
+
 static int proto_gre_net_init(struct net *net)
 {
-	int ret = 0;
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_gre4);
-	if (ret < 0)
-		pr_err("nf_conntrack_gre4: pernet registration failed.\n");
-	return ret;
+	return nf_ct_l4proto_pernet_register(net, proto_gre,
+					     ARRAY_SIZE(proto_gre));
 }
 
 static void proto_gre_net_exit(struct net *net)
 {
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_gre4);
+	nf_ct_l4proto_pernet_unregister(net, proto_gre,
+					ARRAY_SIZE(proto_gre));
 	nf_ct_gre_keymap_flush(net);
 }
 
@@ -421,22 +423,16 @@ static int __init nf_ct_proto_gre_init(void)
 
 	ret = register_pernet_subsys(&proto_gre_net_ops);
 	if (ret < 0)
-		goto out_pernet;
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_gre4);
+		return ret;
+	ret = nf_ct_l4proto_register(proto_gre, ARRAY_SIZE(proto_gre));
 	if (ret < 0)
-		goto out_gre4;
-
-	return 0;
-out_gre4:
-	unregister_pernet_subsys(&proto_gre_net_ops);
-out_pernet:
+		unregister_pernet_subsys(&proto_gre_net_ops);
 	return ret;
 }
 
 static void __exit nf_ct_proto_gre_fini(void)
 {
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_gre4);
+	nf_ct_l4proto_unregister(proto_gre, ARRAY_SIZE(proto_gre));
 	unregister_pernet_subsys(&proto_gre_net_ops);
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 982ea62..17c0ade 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -816,32 +816,21 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 	.init_net		= sctp_init_net,
 };
 
+static struct nf_conntrack_l4proto *sctp_proto[] = {
+	&nf_conntrack_l4proto_sctp4,
+	&nf_conntrack_l4proto_sctp6,
+};
+
 static int sctp_net_init(struct net *net)
 {
-	int ret = 0;
-
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_sctp4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_sctp4: pernet registration failed.\n");
-		goto out;
-	}
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_sctp6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_sctp6: pernet registration failed.\n");
-		goto cleanup_sctp4;
-	}
-	return 0;
-
-cleanup_sctp4:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_sctp4);
-out:
-	return ret;
+	return nf_ct_l4proto_pernet_register(net, sctp_proto,
+					     ARRAY_SIZE(sctp_proto));
 }
 
 static void sctp_net_exit(struct net *net)
 {
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_sctp6);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_sctp4);
+	nf_ct_l4proto_pernet_unregister(net, sctp_proto,
+					ARRAY_SIZE(sctp_proto));
 }
 
 static struct pernet_operations sctp_net_ops = {
@@ -857,29 +846,16 @@ static int __init nf_conntrack_proto_sctp_init(void)
 
 	ret = register_pernet_subsys(&sctp_net_ops);
 	if (ret < 0)
-		goto out_pernet;
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_sctp4);
-	if (ret < 0)
-		goto out_sctp4;
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_sctp6);
+		return ret;
+	ret = nf_ct_l4proto_register(sctp_proto, ARRAY_SIZE(sctp_proto));
 	if (ret < 0)
-		goto out_sctp6;
-
-	return 0;
-out_sctp6:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
-out_sctp4:
-	unregister_pernet_subsys(&sctp_net_ops);
-out_pernet:
+		unregister_pernet_subsys(&sctp_net_ops);
 	return ret;
 }
 
 static void __exit nf_conntrack_proto_sctp_fini(void)
 {
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
+	nf_ct_l4proto_unregister(sctp_proto, ARRAY_SIZE(sctp_proto));
 	unregister_pernet_subsys(&sctp_net_ops);
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 029206e..8cdb4b1 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -336,32 +336,21 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
 	.init_net		= udplite_init_net,
 };
 
+static struct nf_conntrack_l4proto *udplite_proto[] = {
+	&nf_conntrack_l4proto_udplite4,
+	&nf_conntrack_l4proto_udplite6,
+};
+
 static int udplite_net_init(struct net *net)
 {
-	int ret = 0;
-
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_udplite4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_udplite4: pernet registration failed.\n");
-		goto out;
-	}
-	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_udplite6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_udplite6: pernet registration failed.\n");
-		goto cleanup_udplite4;
-	}
-	return 0;
-
-cleanup_udplite4:
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udplite4);
-out:
-	return ret;
+	return nf_ct_l4proto_pernet_register(net, udplite_proto,
+					     ARRAY_SIZE(udplite_proto));
 }
 
 static void udplite_net_exit(struct net *net)
 {
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udplite6);
-	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udplite4);
+	nf_ct_l4proto_pernet_unregister(net, udplite_proto,
+					ARRAY_SIZE(udplite_proto));
 }
 
 static struct pernet_operations udplite_net_ops = {
@@ -377,29 +366,16 @@ static int __init nf_conntrack_proto_udplite_init(void)
 
 	ret = register_pernet_subsys(&udplite_net_ops);
 	if (ret < 0)
-		goto out_pernet;
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udplite4);
-	if (ret < 0)
-		goto out_udplite4;
-
-	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udplite6);
+		return ret;
+	ret = nf_ct_l4proto_register(udplite_proto, ARRAY_SIZE(udplite_proto));
 	if (ret < 0)
-		goto out_udplite6;
-
-	return 0;
-out_udplite6:
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udplite4);
-out_udplite4:
-	unregister_pernet_subsys(&udplite_net_ops);
-out_pernet:
+		unregister_pernet_subsys(&udplite_net_ops);
 	return ret;
 }
 
 static void __exit nf_conntrack_proto_udplite_exit(void)
 {
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udplite6);
-	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udplite4);
+	nf_ct_l4proto_unregister(udplite_proto, ARRAY_SIZE(udplite_proto));
 	unregister_pernet_subsys(&udplite_net_ops);
 }
 
-- 
2.7.4

