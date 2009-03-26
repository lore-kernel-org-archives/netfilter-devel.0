From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch 1/5] net: netfilter conntrack - add per-net
	functionality for ICMP protocol
Date: Fri, 27 Mar 2009 00:05:22 +0300
Message-ID: <20090326210522.GK7950@localhost>
References: <20090326160544.519118777@openvz.org> <20090326160711.826548855@openvz.org> <49CBAA5F.5020907@trash.net> <20090326163444.GA27855@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	xemul@openvz.org, daniel.lezcano@free.fr
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:8838 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZCZVEv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:04:51 -0400
Received: by ti-out-0910.google.com with SMTP id i7so493582tid.23
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 14:04:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20090326163444.GA27855@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[Alexey Dobriyan - Thu, Mar 26, 2009 at 07:34:44PM +0300]
| On Thu, Mar 26, 2009 at 05:16:31PM +0100, Patrick McHardy wrote:
| > Cyrill Gorcunov wrote:
| >> Module specific data moved into per-net site and being allocated/freed
| >> during net namespace creation/deletion. For this reason module_init/exit
| >> calls added.
| >
| > This doesn't work. You can't have multiple module_init functions
| > in one module and nf_connntrack_ivp4 already includes one.
| 
| I thought all sysctl code would be generic in sense it will be done
| during L3 and L4 proto registration, so all those ifdefs will be in one
| place and so on.
| 

Patrick, Alexey,

the temporal solution could be like the inlined below.
Frankly, I don't like it that much but you could take
a look on and maybe some idea reveals?

So I introduced additional calls while registering proto.
Since ICMP is called only once -- no need for ref counter.

For TCP/UDP the same thing is done except call counter added
(we have v4 and v6 protos which are sharing namespace functionality
 and since proto registering/unregisterding is under mutex protection
 reference counter is done via plain int type. I didn't post those
 patches since they are same in idea)

Yes, it seems to look ugly -- but at moment I cant imagine something
else. Brain is almost off. Maybe you could give an advice?

        Cyrill
---
net: netfilter conntrack - add per-net functionality for ICMP protocol

Protocol specific data moved into per-net site and being allocated/freed
during net namespace creation/deletion.

For this we inject register/unregister_hook function pointers
into nf_conntrack_l4proto structure itself and happily use it.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h |    3 
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |  129 +++++++++++++++++++++++++--
 net/netfilter/nf_conntrack_proto.c           |   17 +++
 3 files changed, 140 insertions(+), 9 deletions(-)

Index: linux-2.6.git/include/net/netfilter/nf_conntrack_l4proto.h
===================================================================
--- linux-2.6.git.orig/include/net/netfilter/nf_conntrack_l4proto.h
+++ linux-2.6.git/include/net/netfilter/nf_conntrack_l4proto.h
@@ -80,6 +80,9 @@ struct nf_conntrack_l4proto
 
 	size_t nla_size;
 
+	int (*register_hook)(struct nf_conntrack_l4proto *proto);
+	void (*unregister_hook)(struct nf_conntrack_l4proto *proto);
+
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	**ctl_table_header;
 	struct ctl_table	*ctl_table;
Index: linux-2.6.git/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ linux-2.6.git/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/netfilter.h>
+#include <linux/module.h>
 #include <linux/in.h>
 #include <linux/icmp.h>
 #include <linux/seq_file.h>
@@ -20,7 +21,30 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_log.h>
 
-static unsigned int nf_ct_icmp_timeout __read_mostly = 30*HZ;
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
+static int nf_ct_icmp_proto_init(struct nf_conntrack_l4proto *l4proto);
+static void nf_ct_icmp_proto_fini(struct nf_conntrack_l4proto *l4proto);
+
+/* per-net specifics */
+static int icmp_net_id;
+struct icmp_net {
+	unsigned int icmp_timeout;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *sysctl_header;
+	struct ctl_table *sysctl_table;
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	struct ctl_table_header *compat_sysctl_header;
+	struct ctl_table *compat_sysctl_table;
+#endif
+#endif
+};
+
+static inline struct icmp_net *icmp_pernet(struct net *net)
+{
+	return net_generic(net, icmp_net_id);
+}
 
 static bool icmp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 			      struct nf_conntrack_tuple *tuple)
@@ -90,9 +114,10 @@ static int icmp_packet(struct nf_conn *c
 		if (atomic_dec_and_test(&ct->proto.icmp.count))
 			nf_ct_kill_acct(ct, ctinfo, skb);
 	} else {
+		struct icmp_net *in = icmp_pernet(nf_ct_net(ct));
 		atomic_inc(&ct->proto.icmp.count);
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
+		nf_ct_refresh_acct(ct, ctinfo, skb, in->icmp_timeout);
 	}
 
 	return NF_ACCEPT;
@@ -270,11 +295,10 @@ static int icmp_nlattr_tuple_size(void)
 #endif
 
 #ifdef CONFIG_SYSCTL
-static struct ctl_table_header *icmp_sysctl_header;
+/* templates, data assigned later */
 static struct ctl_table icmp_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_icmp_timeout",
-		.data		= &nf_ct_icmp_timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -287,7 +311,6 @@ static struct ctl_table icmp_sysctl_tabl
 static struct ctl_table icmp_compat_sysctl_table[] = {
 	{
 		.procname	= "ip_conntrack_icmp_timeout",
-		.data		= &nf_ct_icmp_timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -318,11 +341,101 @@ struct nf_conntrack_l4proto nf_conntrack
 	.nlattr_to_tuple	= icmp_nlattr_to_tuple,
 	.nla_policy		= icmp_nla_policy,
 #endif
+	.register_hook		= nf_ct_icmp_proto_init,
+	.unregister_hook	= nf_ct_icmp_proto_fini,
+};
+
+static __net_init int icmp_net_init(struct net *net)
+{
+	struct icmp_net *in;
+	int err;
+
+	in = kmalloc(sizeof(*in), GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	/* default values */
+	in->icmp_timeout = 30 * HZ;
+
+	err = net_assign_generic(net, icmp_net_id, in);
+	if (err)
+		goto out;
+
+#ifdef CONFIG_SYSCTL
+	err = -ENOMEM;
+	in->sysctl_table = kmemdup(icmp_sysctl_table,
+			sizeof(icmp_sysctl_table), GFP_KERNEL);
+	if (!in->sysctl_table)
+		goto out;
+
+	in->sysctl_table[0].data = &in->icmp_timeout;
+
+	in->sysctl_header = register_net_sysctl_table(net,
+			nf_net_netfilter_sysctl_path, in->sysctl_table);
+	if (!in->sysctl_header)
+		goto out_free;
+
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+	in->compat_sysctl_table = kmemdup(icmp_compat_sysctl_table,
+			sizeof(icmp_compat_sysctl_table), GFP_KERNEL);
+	if (!in->compat_sysctl_table)
+		goto out_sysctl;
+
+	in->compat_sysctl_table[0].data = &in->icmp_timeout;
+
+	in->compat_sysctl_header = register_net_sysctl_table(net,
+			nf_net_ipv4_netfilter_sysctl_path,
+			in->compat_sysctl_table);
+	if (!in->compat_sysctl_header)
+		goto out_free_compat;
+#endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
+#endif /* CONFIG_SYSCTL */
+
+	return 0;
+
+#ifdef CONFIG_SYSCTL
+#ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
+out_free_compat:
+	kfree(in->compat_sysctl_table);
+#endif
+out_sysctl:
+	unregister_net_sysctl_table(in->sysctl_header);
+out_free:
+	kfree(in->sysctl_table);
+#endif
+
+out:
+	kfree(in);
+	return err;
+}
+
+static __net_exit void icmp_net_exit(struct net *net)
+{
+	struct icmp_net *in = icmp_pernet(net);
 #ifdef CONFIG_SYSCTL
-	.ctl_table_header	= &icmp_sysctl_header,
-	.ctl_table		= icmp_sysctl_table,
+	unregister_net_sysctl_table(in->sysctl_header);
+	kfree(in->sysctl_table);
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table	= icmp_compat_sysctl_table,
+	unregister_net_sysctl_table(in->compat_sysctl_header);
+	kfree(in->compat_sysctl_table);
 #endif
 #endif
+	kfree(in);
+
+	net_assign_generic(net, icmp_net_id, NULL);
+}
+
+static struct pernet_operations icmp_net_ops = {
+	.init = icmp_net_init,
+	.exit = icmp_net_exit,
 };
+
+static int nf_ct_icmp_proto_init(struct nf_conntrack_l4proto *l4proto)
+{
+	return register_pernet_gen_subsys(&icmp_net_id, &icmp_net_ops);
+}
+
+static void nf_ct_icmp_proto_fini(struct nf_conntrack_l4proto *l4proto)
+{
+	unregister_pernet_gen_subsys(icmp_net_id, &icmp_net_ops);
+}
Index: linux-2.6.git/net/netfilter/nf_conntrack_proto.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_proto.c
+++ linux-2.6.git/net/netfilter/nf_conntrack_proto.c
@@ -296,9 +296,14 @@ int nf_conntrack_l4proto_register(struct
 		goto out_unlock;
 	}
 
+	if (l4proto->register_hook)
+		ret = l4proto->register_hook(l4proto);
+		if (ret < 0)
+			goto out_unlock;
+
 	ret = nf_ct_l4proto_register_sysctl(l4proto);
 	if (ret < 0)
-		goto out_unlock;
+		goto out_unregister_hook;
 
 	l4proto->nla_size = 0;
 	if (l4proto->nlattr_size)
@@ -309,6 +314,10 @@ int nf_conntrack_l4proto_register(struct
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			   l4proto);
 
+out_unregister_hook:
+	if (l4proto->unregister_hook)
+		l4proto->unregister_hook(l4proto);
+
 out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
 	return ret;
@@ -335,6 +344,12 @@ void nf_conntrack_l4proto_unregister(str
 	for_each_net(net)
 		nf_ct_iterate_cleanup(net, kill_l4proto, l4proto);
 	rtnl_unlock();
+
+	if (l4proto->unregister_hook) {
+		mutex_lock(&nf_ct_proto_mutex);
+		l4proto->unregister_hook(l4proto);
+		mutex_unlock(&nf_ct_proto_mutex);
+	}
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_unregister);
 
