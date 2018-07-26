From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 07/18] netlink: Pass groups pointer to .bind()
Date: Thu, 26 Jul 2018 03:31:33 +0100
Message-ID: <20180726023144.31066-8-dima@arista.com>
References: <20180726023144.31066-1-dima@arista.com>
Cc: Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>, netdev@vger.kernel.org,
        Eric Paris <eparis@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Moore <paul@paul-moore.com>, coreteam@netfilter.org,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180726023144.31066-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Netlink messages sent by xfrm differ in size between 64-bit native and
32-bit compatible applications. To know which UABI to use to send the
message from kernel, I'll use the type of bind() syscall.
Xfrm will have hidden from userspace kernel-only groups for compatible
applications.
So, add pointer to groups to netlink_bind().
With later patches xfrm will set a proper compat group for netlink
socket during bind().

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: coreteam@netfilter.org
Cc: linux-audit@redhat.com
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/netlink.h   |  2 +-
 kernel/audit.c            |  2 +-
 net/core/rtnetlink.c      | 14 ++++++--------
 net/core/sock_diag.c      | 25 ++++++++++++-------------
 net/netfilter/nfnetlink.c | 24 ++++++++++++++----------
 net/netlink/af_netlink.c  | 27 ++++++++++-----------------
 net/netlink/af_netlink.h  |  4 ++--
 net/netlink/genetlink.c   | 26 ++++++++++++++++++--------
 8 files changed, 64 insertions(+), 60 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index f3075d6c7e82..19202648e04a 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -46,7 +46,7 @@ struct netlink_kernel_cfg {
 	unsigned int	flags;
 	void		(*input)(struct sk_buff *skb);
 	struct mutex	*cb_mutex;
-	int		(*bind)(struct net *net, int group);
+	int		(*bind)(struct net *net, unsigned long *groups);
 	void		(*unbind)(struct net *net, int group);
 	bool		(*compare)(struct net *net, struct sock *sk);
 };
diff --git a/kernel/audit.c b/kernel/audit.c
index e7478cb58079..87ca0214bcf2 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1523,7 +1523,7 @@ static void audit_receive(struct sk_buff  *skb)
 }
 
 /* Run custom bind function on netlink socket group connect or bind requests. */
-static int audit_bind(struct net *net, int group)
+static int audit_bind(struct net *net, unsigned long *groups)
 {
 	if (!capable(CAP_AUDIT_READ))
 		return -EPERM;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e3f743c141b3..0465e692ae32 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4683,15 +4683,13 @@ static void rtnetlink_rcv(struct sk_buff *skb)
 	netlink_rcv_skb(skb, &rtnetlink_rcv_msg);
 }
 
-static int rtnetlink_bind(struct net *net, int group)
+static int rtnetlink_bind(struct net *net, unsigned long *groups)
 {
-	switch (group) {
-	case RTNLGRP_IPV4_MROUTE_R:
-	case RTNLGRP_IPV6_MROUTE_R:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-			return -EPERM;
-		break;
-	}
+	unsigned long mroute_r;
+
+	mroute_r = 1UL << RTNLGRP_IPV4_MROUTE_R | 1UL << RTNLGRP_IPV6_MROUTE_R;
+	if ((*groups & mroute_r) && !ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
 	return 0;
 }
 
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index c37b5be7c5e4..befa6759f2ad 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -273,20 +273,19 @@ static void sock_diag_rcv(struct sk_buff *skb)
 	mutex_unlock(&sock_diag_mutex);
 }
 
-static int sock_diag_bind(struct net *net, int group)
+static int sock_diag_bind(struct net *net, unsigned long *groups)
 {
-	switch (group) {
-	case SKNLGRP_INET_TCP_DESTROY:
-	case SKNLGRP_INET_UDP_DESTROY:
-		if (!sock_diag_handlers[AF_INET])
-			sock_load_diag_module(AF_INET, 0);
-		break;
-	case SKNLGRP_INET6_TCP_DESTROY:
-	case SKNLGRP_INET6_UDP_DESTROY:
-		if (!sock_diag_handlers[AF_INET6])
-			sock_load_diag_module(AF_INET6, 0);
-		break;
-	}
+	unsigned long inet_mask, inet6_mask;
+
+	inet_mask   = 1UL << SKNLGRP_INET_TCP_DESTROY;
+	inet_mask  |= 1UL << SKNLGRP_INET_UDP_DESTROY;
+	inet6_mask  = 1UL << SKNLGRP_INET6_TCP_DESTROY;
+	inet6_mask |= 1UL << SKNLGRP_INET6_UDP_DESTROY;
+
+	if ((*groups & inet_mask) && !sock_diag_handlers[AF_INET])
+		sock_load_diag_module(AF_INET, 0);
+	if ((*groups & inet6_mask) && !sock_diag_handlers[AF_INET6])
+		sock_load_diag_module(AF_INET6, 0);
 	return 0;
 }
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e1b6be29848d..6a8893df5285 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -556,21 +556,25 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_MODULES
-static int nfnetlink_bind(struct net *net, int group)
+static int nfnetlink_bind(struct net *net, unsigned long *groups)
 {
 	const struct nfnetlink_subsystem *ss;
-	int type;
+	unsigned long _groups = *groups;
+	int type, group_bit, group = -1;
 
-	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
-		return 0;
+	while ((group_bit = __builtin_ffsl(_groups))) {
+		group += group_bit;
 
-	type = nfnl_group2type[group];
+		type = nfnl_group2type[group];
+		rcu_read_lock();
+		ss = nfnetlink_get_subsys(type << 8);
+		rcu_read_unlock();
+		if (!ss)
+			request_module("nfnetlink-subsys-%d", type);
+
+		_groups >>= group_bit;
+	}
 
-	rcu_read_lock();
-	ss = nfnetlink_get_subsys(type << 8);
-	rcu_read_unlock();
-	if (!ss)
-		request_module("nfnetlink-subsys-%d", type);
 	return 0;
 }
 #endif
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index ac805caed2e2..1e11e706c683 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -668,7 +668,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	struct module *module = NULL;
 	struct mutex *cb_mutex;
 	struct netlink_sock *nlk;
-	int (*bind)(struct net *net, int group);
+	int (*bind)(struct net *net, unsigned long *groups);
 	void (*unbind)(struct net *net, int group);
 	int err = 0;
 
@@ -969,8 +969,7 @@ static int netlink_realloc_groups(struct sock *sk)
 	return err;
 }
 
-static void netlink_undo_bind(int group, long unsigned int groups,
-			      struct sock *sk)
+static void netlink_undo_bind(unsigned long groups, struct sock *sk)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
 	int undo;
@@ -978,7 +977,7 @@ static void netlink_undo_bind(int group, long unsigned int groups,
 	if (!nlk->netlink_unbind)
 		return;
 
-	for (undo = 0; undo < group; undo++)
+	for (undo = 0; undo < nlk->ngroups; undo++)
 		if (test_bit(undo, &groups))
 			nlk->netlink_unbind(sock_net(sk), undo + 1);
 }
@@ -991,7 +990,7 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	struct netlink_sock *nlk = nlk_sk(sk);
 	struct sockaddr_nl *nladdr = (struct sockaddr_nl *)addr;
 	int err = 0;
-	long unsigned int groups = nladdr->nl_groups;
+	unsigned long groups = nladdr->nl_groups;
 	bool bound;
 
 	if (addr_len < sizeof(struct sockaddr_nl))
@@ -1021,17 +1020,9 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 
 	netlink_lock_table();
 	if (nlk->netlink_bind && groups) {
-		int group;
-
-		for (group = 0; group < nlk->ngroups; group++) {
-			if (!test_bit(group, &groups))
-				continue;
-			err = nlk->netlink_bind(net, group + 1);
-			if (!err)
-				continue;
-			netlink_undo_bind(group, groups, sk);
+		err = nlk->netlink_bind(net, &groups);
+		if (err)
 			goto unlock;
-		}
 	}
 
 	/* No need for barriers here as we return to user-space without
@@ -1042,7 +1033,7 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 			netlink_insert(sk, nladdr->nl_pid) :
 			netlink_autobind(sock);
 		if (err) {
-			netlink_undo_bind(nlk->ngroups, groups, sk);
+			netlink_undo_bind(groups, sk);
 			goto unlock;
 		}
 	}
@@ -1652,7 +1643,9 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 		if (!val || val - 1 >= nlk->ngroups)
 			return -EINVAL;
 		if (optname == NETLINK_ADD_MEMBERSHIP && nlk->netlink_bind) {
-			err = nlk->netlink_bind(sock_net(sk), val);
+			unsigned long groups = 1UL << val;
+
+			err = nlk->netlink_bind(sock_net(sk), &groups);
 			if (err)
 				return err;
 		}
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index 962de7b3c023..e765172abbb7 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -39,7 +39,7 @@ struct netlink_sock {
 	struct mutex		*cb_mutex;
 	struct mutex		cb_def_mutex;
 	void			(*netlink_rcv)(struct sk_buff *skb);
-	int			(*netlink_bind)(struct net *net, int group);
+	int			(*netlink_bind)(struct net *net, unsigned long *groups);
 	void			(*netlink_unbind)(struct net *net, int group);
 	struct module		*module;
 
@@ -61,7 +61,7 @@ struct netlink_table {
 	unsigned int		groups;
 	struct mutex		*cb_mutex;
 	struct module		*module;
-	int			(*bind)(struct net *net, int group);
+	int			(*bind)(struct net *net, unsigned long *groups);
 	void			(*unbind)(struct net *net, int group);
 	bool			(*compare)(struct net *net, struct sock *sock);
 	int			registered;
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 25eeb6d2a75a..a86b105730cf 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -960,28 +960,38 @@ static struct genl_family genl_ctrl __ro_after_init = {
 	.netnsok = true,
 };
 
-static int genl_bind(struct net *net, int group)
+static int genl_bind(struct net *net, unsigned long *groups)
 {
+	unsigned long mcgrps;
 	struct genl_family *f;
-	int err = -ENOENT;
+	int err = 0;
 	unsigned int id;
 
 	down_read(&cb_lock);
 
 	idr_for_each_entry(&genl_fam_idr, f, id) {
-		if (group >= f->mcgrp_offset &&
-		    group < f->mcgrp_offset + f->n_mcgrps) {
-			int fam_grp = group - f->mcgrp_offset;
+		int fam_grp_bit, fam_grp = -1;
+
+		mcgrps = (1UL << f->n_mcgrps) - 1;
+		mcgrps <<= f->mcgrp_offset;
+		mcgrps &= *groups;
+
+		if (!mcgrps)
+			continue;
+
+		while ((fam_grp_bit = __builtin_ffsl(mcgrps))) {
+			fam_grp += fam_grp_bit;
 
 			if (!f->netnsok && net != &init_net)
 				err = -ENOENT;
 			else if (f->mcast_bind)
 				err = f->mcast_bind(net, fam_grp);
-			else
-				err = 0;
-			break;
+
+			if (err)
+				goto out;
 		}
 	}
+out:
 	up_read(&cb_lock);
 
 	return err;
-- 
2.13.6
