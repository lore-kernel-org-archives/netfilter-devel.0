From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new
 namespaces
Date: Tue, 27 Oct 2015 17:35:52 +0100
Message-ID: <20151027163552.GC9420@breakpoint.cc>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
 <20151026225522.GA15583@salvia>
 <20151026230938.GA9420@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54912 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964997AbbJ0Qf4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2015 12:35:56 -0400
Content-Disposition: inline
In-Reply-To: <20151026230938.GA9420@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > This work aims to change all major hook users to nf_register_net_hook
> > > so that when a new netns is created it has no hooks at all, even when the
> > > initial namespace uses conntrack, iptables and bridge netfilter.
> > >
> > > To keep behaviour somewhat compatible, xtable hooks are registered once a
> > > iptables set/getsockopt call is made within a net namespace.
> > > This also means that e.g. conntrack behaviour is not yet optimal, we
> > > still create all the data structures and only skip hook registration
> > > at this time.
> > > Caveats:
> > > - conntrack is no longer active just by loading nf_conntrack module -- at
> > > least one (x)tables rule that requires conntrack has to be added, e.g.
> > > conntrack match or S/DNAT target.
> > 
> > So far it was possible to run conntrack without iptables, eg. to
> > collect statistics at per-flow level via ctnetlink. Could you find a
> > way to enable the hooks also from that path?
> 
> Good point, I'll look at this tomorrow.  It should not be too hard to
> add this.

Ahem.  There are strings attached... :-/

So conntrack -L or conntrack -E do not enable connection tracking
if its not enabled (on current kernels).

So one has to load ipv4/ipv6 etc tracker explicitly.

Problem *after* patches is that this doesn't suffice.

So old behaviour:
conntrack -E

(nothing happens)
(modprobe nf_conntrack_ipv4)
(conntrack -E starts to display events)

new behaviour:
(modprobe nf_conntrack_ipv4)
(conntrack -E doesn't display events since conntrack module doesn't
 see packets due to lack of nf hooks).

My first attempt to fix this was to hook into nfnetlink bind,
but that doesn't really work in a backwards-compatible fashion since
it only makes 'modprobe nf_conntrack_ipv4; conntrack -E' work, but
not nf_conntrack_ipv4 module load *after* a event listener is already
running.

Other alternative is to request all the protocol trackers during
ctnetlink bind request but that sucks.

Any suggestion?  I don't really see a way out of this.

For reference, this is the change I have:

Subject: netfilter: ctnetlink: make ctnetlink bind register conntrack hooks

several problems here:

1. conntrack -E & modprobe nf_conntrack_ipv4 will *not* register
ipv4 conntrack hooks
2. since ctnetlink has no dependencies on nf_conntrack_xxx its
possible to rmmod nf_conntrack_xxx while event listener is running
which means the tracker has to force-remove hooks on netns destruction.
---
 include/linux/netfilter/nfnetlink.h            |  1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 13 ++++++
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 13 ++++++
 net/netfilter/nf_conntrack_netlink.c           | 58 ++++++++++++++++++++++++++
 net/netfilter/nfnetlink.c                      | 26 ++++++++----
 5 files changed, 102 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 249d1bb..9049c6a 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -28,6 +28,7 @@ struct nfnetlink_subsystem {
 	const struct nfnl_callback *cb;	/* callback for individual types */
 	int (*commit)(struct sk_buff *skb);
 	int (*abort)(struct sk_buff *skb);
+	int (*bind)(struct net *net);
 };
 
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index d804620..7918b45 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -405,6 +405,9 @@ static void nf_conntrack_l3proto_ipv4_hooks_unregister(struct net *net)
 {
 	struct conntrack4_net *cnet = net_generic(net, conntrack4_net_id);
 
+	if (cnet->users == 0)
+		return;
+
 	mutex_lock(&register_ipv4_hooks);
 	if (--cnet->users == 0)
 		nf_unregister_net_hooks(net, ipv4_conntrack_ops,
@@ -478,6 +481,16 @@ out_tcp:
 
 static void ipv4_net_exit(struct net *net)
 {
+	struct conntrack4_net *cnet = net_generic(net, conntrack4_net_id);
+
+	mutex_lock(&register_ipv4_hooks);
+	if (cnet->users) {
+		cnet->users = 0;
+		nf_unregister_net_hooks(net, ipv4_conntrack_ops,
+					ARRAY_SIZE(ipv4_conntrack_ops));
+	}
+	mutex_unlock(&register_ipv4_hooks);
+
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv4);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index f3e7ca6..dd0fad6 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -344,6 +344,9 @@ static void nf_conntrack_l3proto_ipv6_hooks_unregister(struct net *net)
 {
 	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
 
+	if (cnet->users == 0)
+		return;
+
 	mutex_lock(&register_ipv6_hooks);
 	if (--cnet->users == 0)
 		nf_unregister_net_hooks(net, ipv6_conntrack_ops,
@@ -418,6 +421,16 @@ static int ipv6_net_init(struct net *net)
 
 static void ipv6_net_exit(struct net *net)
 {
+	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
+
+	mutex_lock(&register_ipv6_hooks);
+	if (cnet->users) {
+		cnet->users = 0;
+		nf_unregister_net_hooks(net, ipv6_conntrack_ops,
+					ARRAY_SIZE(ipv6_conntrack_ops));
+	}
+	mutex_unlock(&register_ipv6_hooks);
+
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv6);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmpv6);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp6);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9f52729..f0585e2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -57,6 +57,11 @@
 MODULE_LICENSE("GPL");
 
 static char __initdata version[] = "0.93";
+static int ctnetlink_net_id __read_mostly;
+
+struct ctnl_net {
+	DECLARE_BITMAP(enabled, NFPROTO_NUMPROTO);
+};
 
 static inline int
 ctnetlink_dump_tuples_proto(struct sk_buff *skb,
@@ -3257,6 +3262,37 @@ ctnetlink_stat_exp_cpu(struct sock *ctnl, struct sk_buff *skb,
 	return 0;
 }
 
+static int ctnl_bind(struct net *net)
+{
+	struct ctnl_net *ctnet = net_generic(net, ctnetlink_net_id);
+	int i;
+
+	rcu_read_lock();
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		struct nf_conntrack_l3proto *l3proto;
+		int ret;
+
+		/* don't autoload modules; only ensure those present have
+		 * their hooks registered.
+		 */
+		l3proto = __nf_ct_l3proto_find(i);
+		if (!l3proto || !l3proto->net_ns_get)
+			continue;
+
+		if (test_and_set_bit(i, ctnet->enabled))
+			continue;
+
+		ret = l3proto->net_ns_get(net);
+		if (ret < 0)
+			clear_bit(i, ctnet->enabled);
+	}
+
+	rcu_read_unlock();
+
+	return 0;
+}
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static struct nf_ct_event_notifier ctnl_notifier = {
 	.fcn = ctnetlink_conntrack_event,
@@ -3304,6 +3340,7 @@ static const struct nfnetlink_subsystem ctnl_subsys = {
 	.subsys_id			= NFNL_SUBSYS_CTNETLINK,
 	.cb_count			= IPCTNL_MSG_MAX,
 	.cb				= ctnl_cb,
+	.bind				= ctnl_bind,
 };
 
 static const struct nfnetlink_subsystem ctnl_exp_subsys = {
@@ -3311,6 +3348,7 @@ static const struct nfnetlink_subsystem ctnl_exp_subsys = {
 	.subsys_id			= NFNL_SUBSYS_CTNETLINK_EXP,
 	.cb_count			= IPCTNL_MSG_EXP_MAX,
 	.cb				= ctnl_exp_cb,
+	.bind				= ctnl_bind,
 };
 
 MODULE_ALIAS("ip_conntrack_netlink");
@@ -3346,10 +3384,28 @@ err_out:
 
 static void ctnetlink_net_exit(struct net *net)
 {
+	struct ctnl_net *ctnet = net_generic(net, ctnetlink_net_id);
+	int i;
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	nf_ct_expect_unregister_notifier(net, &ctnl_notifier_exp);
 	nf_conntrack_unregister_notifier(net, &ctnl_notifier);
 #endif
+	rcu_read_lock();
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		struct nf_conntrack_l3proto *l3proto;
+
+		if (!test_bit(i, ctnet->enabled))
+			continue;
+
+		l3proto = __nf_ct_l3proto_find(i);
+		if (WARN_ON(!l3proto || !l3proto->net_ns_get))
+			continue;
+		l3proto->net_ns_put(net);
+	}
+
+	rcu_read_unlock();
 }
 
 static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
@@ -3363,6 +3419,8 @@ static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
 static struct pernet_operations ctnetlink_net_ops = {
 	.init		= ctnetlink_net_init,
 	.exit_batch	= ctnetlink_net_exit_batch,
+	.id   = &ctnetlink_net_id,
+	.size = sizeof(struct ctnl_net),
 };
 
 static int __init ctnetlink_init(void)
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index f1d9e88..d2ad3fd 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -480,11 +480,10 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 	}
 }
 
-#ifdef CONFIG_MODULES
 static int nfnetlink_bind(struct net *net, int group)
 {
 	const struct nfnetlink_subsystem *ss;
-	int type;
+	int type, ret;
 
 	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
 		return 0;
@@ -492,13 +491,24 @@ static int nfnetlink_bind(struct net *net, int group)
 	type = nfnl_group2type[group];
 
 	rcu_read_lock();
-	ss = nfnetlink_get_subsys(type);
-	rcu_read_unlock();
-	if (!ss)
+	ss = nfnetlink_get_subsys(type << 8);
+	ret = -EINVAL;
+#ifdef CONFIG_MODULES
+	if (!ss) {
+		rcu_read_unlock();
 		request_module("nfnetlink-subsys-%d", type);
-	return 0;
-}
+		rcu_read_lock();
+		ss = nfnetlink_get_subsys(type);
+	}
 #endif
+	if (!ss)
+		goto out;
+
+	ret = ss->bind ? ss->bind(net) : 0;
+ out:
+	rcu_read_unlock();
+	return ret;
+}
 
 static int __net_init nfnetlink_net_init(struct net *net)
 {
@@ -506,9 +516,7 @@ static int __net_init nfnetlink_net_init(struct net *net)
 	struct netlink_kernel_cfg cfg = {
 		.groups	= NFNLGRP_MAX,
 		.input	= nfnetlink_rcv,
-#ifdef CONFIG_MODULES
 		.bind	= nfnetlink_bind,
-#endif
 	};
 
 	nfnl = netlink_kernel_create(net, NETLINK_NETFILTER, &cfg);
-- 
2.0.5

