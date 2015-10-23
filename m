From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 5/9] netfilter: defrag: only register defrag functionality if needed
Date: Fri, 23 Oct 2015 12:43:22 +0200
Message-ID: <1445597006-11264-6-git-send-email-fw@strlen.de>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45003 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbbJWKne (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Oct 2015 06:43:34 -0400
In-Reply-To: <1445597006-11264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_defrag modules for ipv4 and ipv6 export an empty stub function.
Any module that needs the defragmentation hooks registered simply
'calls' this empty function to create a 'phony' module dependency --
modprobe magic will make sure the appropriate defrag module is loaded.

This extends defragmentation to delay the defragmentation hook
registration until the functionality is requested within a network
namespace instead of module load time for all namespaces.

Hooks are only un-registered on module unload or when a namespace
that used such defrag functionality exits.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1

 include/net/netfilter/ipv4/nf_defrag_ipv4.h    |  3 +-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |  3 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  7 +++-
 net/ipv4/netfilter/nf_defrag_ipv4.c            | 49 +++++++++++++++++++++++--
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  7 +++-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      | 50 +++++++++++++++++++++++---
 net/netfilter/xt_TPROXY.c                      | 15 +++++---
 net/netfilter/xt_socket.c                      | 33 ++++++++++++++---
 8 files changed, 146 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_defrag_ipv4.h b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
index f01ef20..db405f7 100644
--- a/include/net/netfilter/ipv4/nf_defrag_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
@@ -1,6 +1,7 @@
 #ifndef _NF_DEFRAG_IPV4_H
 #define _NF_DEFRAG_IPV4_H
 
-void nf_defrag_ipv4_enable(void);
+struct net;
+int nf_defrag_ipv4_enable(struct net *);
 
 #endif /* _NF_DEFRAG_IPV4_H */
diff --git a/include/net/netfilter/ipv6/nf_defrag_ipv6.h b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
index fb7da5b..aa8dfe6 100644
--- a/include/net/netfilter/ipv6/nf_defrag_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
@@ -1,7 +1,8 @@
 #ifndef _NF_DEFRAG_IPV6_H
 #define _NF_DEFRAG_IPV6_H
 
-void nf_defrag_ipv6_enable(void);
+struct net;
+int nf_defrag_ipv6_enable(struct net *);
 
 int nf_ct_frag6_init(void);
 void nf_ct_frag6_cleanup(void);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 2b51a04..d804620 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -385,6 +385,12 @@ static int nf_conntrack_l3proto_ipv4_hooks_register(struct net *net)
 	if (cnet->users > 1)
 		goto out_unlock;
 
+	err = nf_defrag_ipv4_enable(net);
+	if (err) {
+		cnet->users = 0;
+		goto out_unlock;
+	}
+
 	err = nf_register_net_hooks(net, ipv4_conntrack_ops,
 				    ARRAY_SIZE(ipv4_conntrack_ops));
 
@@ -490,7 +496,6 @@ static int __init nf_conntrack_l3proto_ipv4_init(void)
 	int ret = 0;
 
 	need_conntrack();
-	nf_defrag_ipv4_enable();
 
 	ret = nf_register_sockopt(&so_getorigdst);
 	if (ret < 0) {
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 0e5591c..e3df959 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -11,6 +11,7 @@
 #include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <net/netns/generic.h>
 #include <net/route.h>
 #include <net/ip.h>
 
@@ -22,6 +23,13 @@
 #endif
 #include <net/netfilter/nf_conntrack_zones.h>
 
+static int defrag4_net_id __read_mostly;
+static DEFINE_MUTEX(defrag4_mutex);
+
+struct defrag4_net {
+	bool enabled;
+};
+
 static int nf_ct_ipv4_gather_frags(struct net *net, struct sk_buff *skb,
 				   u_int32_t user)
 {
@@ -107,18 +115,53 @@ static struct nf_hook_ops ipv4_defrag_ops[] = {
 	},
 };
 
+static void __net_exit defrag4_net_exit(struct net *net)
+{
+	struct defrag4_net *n = net_generic(net, defrag4_net_id);
+
+	if (n->enabled)
+		nf_unregister_net_hooks(net, ipv4_defrag_ops,
+					ARRAY_SIZE(ipv4_defrag_ops));
+}
+
+static struct pernet_operations defrag4_net_ops = {
+	.exit = defrag4_net_exit,
+	.id = &defrag4_net_id,
+	.size = sizeof(struct defrag4_net),
+};
+
 static int __init nf_defrag_init(void)
 {
-	return nf_register_hooks(ipv4_defrag_ops, ARRAY_SIZE(ipv4_defrag_ops));
+	return register_pernet_subsys(&defrag4_net_ops);
 }
 
 static void __exit nf_defrag_fini(void)
 {
-	nf_unregister_hooks(ipv4_defrag_ops, ARRAY_SIZE(ipv4_defrag_ops));
+	unregister_pernet_subsys(&defrag4_net_ops);
 }
 
-void nf_defrag_ipv4_enable(void)
+int nf_defrag_ipv4_enable(struct net *net)
 {
+	struct defrag4_net *n = net_generic(net, defrag4_net_id);
+	int err = 0;
+
+	might_sleep();
+
+	if (n->enabled)
+		return 0;
+
+	mutex_lock(&defrag4_mutex);
+	if (n->enabled)
+		goto out_unlock;
+
+	err = nf_register_net_hooks(net, ipv4_defrag_ops,
+				    ARRAY_SIZE(ipv4_defrag_ops));
+	if (err == 0)
+		n->enabled = true;
+
+ out_unlock:
+	mutex_unlock(&defrag4_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_defrag_ipv4_enable);
 
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 8916846..f3e7ca6 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -325,6 +325,12 @@ static int nf_conntrack_l3proto_ipv6_hooks_register(struct net *net)
 	if (cnet->users > 1)
 		goto out_unlock;
 
+	err = nf_defrag_ipv6_enable(net);
+	if (err < 0) {
+		cnet->users = 0;
+		goto out_unlock;
+	}
+
 	err = nf_register_net_hooks(net, ipv6_conntrack_ops,
 				    ARRAY_SIZE(ipv6_conntrack_ops));
 	if (err)
@@ -430,7 +436,6 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
 	int ret = 0;
 
 	need_conntrack();
-	nf_defrag_ipv6_enable();
 
 	ret = nf_register_sockopt(&so_getorigdst6);
 	if (ret < 0) {
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 4fdbed5e..bd9077c 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -30,6 +30,13 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 
+static int defrag6_net_id __read_mostly;
+static DEFINE_MUTEX(defrag6_mutex);
+
+struct defrag6_net {
+	bool enabled;
+};
+
 static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
 						struct sk_buff *skb)
 {
@@ -97,6 +104,21 @@ static struct nf_hook_ops ipv6_defrag_ops[] = {
 	},
 };
 
+static void __net_exit defrag6_net_exit(struct net *net)
+{
+	struct defrag6_net *n = net_generic(net, defrag6_net_id);
+
+	if (n->enabled)
+		nf_unregister_net_hooks(net, ipv6_defrag_ops,
+					ARRAY_SIZE(ipv6_defrag_ops));
+}
+
+static struct pernet_operations defrag6_net_ops = {
+	.exit = defrag6_net_exit,
+	.id = &defrag6_net_id,
+	.size = sizeof(struct defrag6_net),
+};
+
 static int __init nf_defrag_init(void)
 {
 	int ret = 0;
@@ -106,9 +128,9 @@ static int __init nf_defrag_init(void)
 		pr_err("nf_defrag_ipv6: can't initialize frag6.\n");
 		return ret;
 	}
-	ret = nf_register_hooks(ipv6_defrag_ops, ARRAY_SIZE(ipv6_defrag_ops));
+	ret = register_pernet_subsys(&defrag6_net_ops);
 	if (ret < 0) {
-		pr_err("nf_defrag_ipv6: can't register hooks\n");
+		pr_err("nf_defrag_ipv6: can't register pernet ops\n");
 		goto cleanup_frag6;
 	}
 	return ret;
@@ -121,12 +143,32 @@ cleanup_frag6:
 
 static void __exit nf_defrag_fini(void)
 {
-	nf_unregister_hooks(ipv6_defrag_ops, ARRAY_SIZE(ipv6_defrag_ops));
+	unregister_pernet_subsys(&defrag6_net_ops);
 	nf_ct_frag6_cleanup();
 }
 
-void nf_defrag_ipv6_enable(void)
+int nf_defrag_ipv6_enable(struct net *net)
 {
+	struct defrag6_net *n = net_generic(net, defrag6_net_id);
+	int err = 0;
+
+	might_sleep();
+
+	if (n->enabled)
+		return 0;
+
+	mutex_lock(&defrag6_mutex);
+	if (n->enabled)
+		goto out_unlock;
+
+	err = nf_register_net_hooks(net, ipv6_defrag_ops,
+				    ARRAY_SIZE(ipv6_defrag_ops));
+	if (err == 0)
+		n->enabled = true;
+
+ out_unlock:
+	mutex_unlock(&defrag6_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_defrag_ipv6_enable);
 
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 3ab591e..f091244 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -516,6 +516,11 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 static int tproxy_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_ip6 *i = par->entryinfo;
+	int err;
+
+	err = nf_defrag_ipv6_enable(par->net);
+	if (err)
+		return err;
 
 	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
 	    !(i->invflags & IP6T_INV_PROTO))
@@ -530,6 +535,11 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
 static int tproxy_tg4_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_ip *i = par->entryinfo;
+	int err;
+
+	err = nf_defrag_ipv4_enable(par->net);
+	if (err)
+		return err;
 
 	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
 	    && !(i->invflags & IPT_INV_PROTO))
@@ -581,11 +591,6 @@ static struct xt_target tproxy_tg_reg[] __read_mostly = {
 
 static int __init tproxy_tg_init(void)
 {
-	nf_defrag_ipv4_enable();
-#ifdef XT_TPROXY_HAVE_IPV6
-	nf_defrag_ipv6_enable();
-#endif
-
 	return xt_register_targets(tproxy_tg_reg, ARRAY_SIZE(tproxy_tg_reg));
 }
 
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 2ec08f0..d0f0064 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -418,9 +418,28 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
 }
 #endif
 
+static int socket_mt_enable_defrag(struct net *net, int family)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+		return nf_defrag_ipv4_enable(net);
+#ifdef XT_SOCKET_HAVE_IPV6
+	case NFPROTO_IPV6:
+		return nf_defrag_ipv6_enable(net);
+#endif
+	}
+	WARN_ONCE(1, "Unknown family %d\n", family);
+	return 0;
+}
+
 static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
+	int err;
+
+	err = socket_mt_enable_defrag(par->net, par->family);
+	if (err)
+		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V1) {
 		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V1);
@@ -432,6 +451,11 @@ static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 static int socket_mt_v2_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo2 *info = (struct xt_socket_mtinfo2 *) par->matchinfo;
+	int err;
+
+	err = socket_mt_enable_defrag(par->net, par->family);
+	if (err)
+		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V2) {
 		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V2);
@@ -444,7 +468,11 @@ static int socket_mt_v3_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo3 *info =
 				    (struct xt_socket_mtinfo3 *)par->matchinfo;
+	int err;
 
+	err = socket_mt_enable_defrag(par->net, par->family);
+	if (err)
+		return err;
 	if (info->flags & ~XT_SOCKET_FLAGS_V3) {
 		pr_info("unknown flags 0x%x\n",
 			info->flags & ~XT_SOCKET_FLAGS_V3);
@@ -539,11 +567,6 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 
 static int __init socket_mt_init(void)
 {
-	nf_defrag_ipv4_enable();
-#ifdef XT_SOCKET_HAVE_IPV6
-	nf_defrag_ipv6_enable();
-#endif
-
 	return xt_register_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
 }
 
-- 
2.0.5

