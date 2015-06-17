From: Daniel Mack <daniel@zonque.org>
Subject: [PATCH nf-next 2/3] netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN sk lookups
Date: Wed, 17 Jun 2015 02:08:11 +0200
Message-ID: <1434499692-9832-3-git-send-email-daniel@zonque.org>
References: <1434499692-9832-1-git-send-email-daniel@zonque.org>
Cc: fw@strlen.de, daniel@iogearbox.net, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:39581 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbbFQARc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 20:17:32 -0400
In-Reply-To: <1434499692-9832-1-git-send-email-daniel@zonque.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Daniel Borkmann <daniel@iogearbox.net>

While originally only being intended for outgoing traffic, commit
a00e76349f35 ("netfilter: x_tables: allow to use cgroup match for
LOCAL_IN nf hooks") enabled xt_cgroups for the NF_INET_LOCAL_IN hook
as well, in order to allow for nfacct accounting.

This basically was under the assumption that socket early demux will
resolve it. It's correct that demux happens after PRE_ROUTING, but
before LOCAL_IN.

However, that as-is only partially works, i.e. it works for the case
of established TCP and connected UDP sockets when early demux is
enabled, but not for various other ingress scenarios.

Instead of reverting commit a00e76349f35, I think it's worth to fix
it up as there are applications requiring xt_cgroup to match on
ingress and egress side. In order to do so, we need to perform a
full lookup on skb->sk (ingress) miss, similarly as being done in
xt_socket.

Therefore, we need to make use of shared helpers nf_socket_lookup_v4()
and nf_socket_lookup_v6().

Reported-by: Daniel Mack <daniel@zonque.org>
Fixes: a00e76349f35 ("netfilter: x_tables: allow to use cgroup match for LOCAL_IN nf hooks")
Reference: http://thread.gmane.org/gmane.linux.network/355527
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Daniel Mack <daniel@zonque.org>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Florian Westphal <fw@strlen.de>
[daniel@zonque.org: rebased and adopted to new function names]
---
 net/netfilter/Kconfig     |  2 +
 net/netfilter/xt_cgroup.c | 95 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 79 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f08e7a8..11c7e37 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -981,6 +981,8 @@ config NETFILTER_XT_MATCH_CGROUP
 	tristate '"control group" match support'
 	depends on NETFILTER_ADVANCED
 	depends on CGROUPS
+	select NF_SOCK_IPV4
+	select NF_SOCK_IPV6 if IP6_NF_IPTABLES
 	select CGROUP_NET_CLASSID
 	---help---
 	Socket/process control group matching allows you to match locally
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index a1d126f..14144cd 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -16,6 +16,10 @@
 #include <linux/module.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_cgroup.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/sock.h>
 
 MODULE_LICENSE("GPL");
@@ -34,38 +38,93 @@ static int cgroup_mt_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
-static bool
-cgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
+typedef struct sock *(*cgroup_lookup_t)(const struct sk_buff *skb,
+					const struct net_device *indev);
+
+static bool cgroup_mt(const struct sk_buff *skb,
+		      const struct xt_action_param *par,
+		      cgroup_lookup_t cgroup_mt_slow)
 {
 	const struct xt_cgroup_info *info = par->matchinfo;
+	struct sock *sk = skb->sk;
+	u32 sk_classid;
+
+	if (sk && sk_fullsock(skb->sk)) {
+		sk_classid = sk->sk_classid;
+	} else {
+		if (par->in)
+			sk = cgroup_mt_slow(skb, par->in);
+
+		if (!sk)
+			return false;
 
-	if (skb->sk == NULL || !sk_fullsock(skb->sk))
-		return false;
+		if (!sk_fullsock(sk)) {
+			sock_gen_put(sk);
+			return false;
+		}
+
+		sk_classid = sk->sk_classid;
+		sock_gen_put(sk);
+	}
+
+	return (info->id == sk_classid) ^ info->invert;
+}
 
-	return (info->id == skb->sk->sk_classid) ^ info->invert;
+static bool
+cgroup_mt_v4(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	return cgroup_mt(skb, par, nf_socket_lookup_v4);
+}
+
+#ifdef XT_HAVE_IPV6
+static bool
+cgroup_mt_v6(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	return cgroup_mt(skb, par, nf_socket_lookup_v6);
 }
+#endif
 
-static struct xt_match cgroup_mt_reg __read_mostly = {
-	.name       = "cgroup",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = cgroup_mt_check,
-	.match      = cgroup_mt,
-	.matchsize  = sizeof(struct xt_cgroup_info),
-	.me         = THIS_MODULE,
-	.hooks      = (1 << NF_INET_LOCAL_OUT) |
-		      (1 << NF_INET_POST_ROUTING) |
-		      (1 << NF_INET_LOCAL_IN),
+static struct xt_match cgroup_mt_reg[] __read_mostly = {
+	{
+		.name       = "cgroup",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.checkentry = cgroup_mt_check,
+		.match      = cgroup_mt_v4,
+		.matchsize  = sizeof(struct xt_cgroup_info),
+		.me         = THIS_MODULE,
+		.hooks      = (1 << NF_INET_LOCAL_OUT) |
+			      (1 << NF_INET_POST_ROUTING) |
+			      (1 << NF_INET_LOCAL_IN),
+	},
+#ifdef XT_HAVE_IPV6
+	{
+		.name       = "cgroup",
+		.revision   = 0,
+		.family     = NFPROTO_IPV6,
+		.checkentry = cgroup_mt_check,
+		.match      = cgroup_mt_v6,
+		.matchsize  = sizeof(struct xt_cgroup_info),
+		.me         = THIS_MODULE,
+		.hooks      = (1 << NF_INET_LOCAL_OUT) |
+			      (1 << NF_INET_POST_ROUTING) |
+			      (1 << NF_INET_LOCAL_IN),
+	}
+#endif
 };
 
 static int __init cgroup_mt_init(void)
 {
-	return xt_register_match(&cgroup_mt_reg);
+	nf_defrag_ipv4_enable();
+#ifdef XT_HAVE_IPV6
+	nf_defrag_ipv6_enable();
+#endif
+	return xt_register_matches(cgroup_mt_reg, ARRAY_SIZE(cgroup_mt_reg));
 }
 
 static void __exit cgroup_mt_exit(void)
 {
-	xt_unregister_match(&cgroup_mt_reg);
+	xt_unregister_matches(cgroup_mt_reg, ARRAY_SIZE(cgroup_mt_reg));
 }
 
 module_init(cgroup_mt_init);
-- 
2.4.0

