From: gfree.wind@foxmail.com
Subject: [PATCH nf v4 2/2] netfilter: helper: Fix possible panic caused by invoking expectfn unloaded
Date: Wed, 22 Mar 2017 09:03:24 +0800
Message-ID: <031fb2df905062385d3eb887696fd6d9b87b7db6.1490143843.git.fgao@ikuai8.com>
References: <cover.1490143843.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([103.7.28.233]:10320 "EHLO smtpbg65.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757572AbdCVBGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 21:06:13 -0400
In-Reply-To: <cover.1490143843.git.fgao@ikuai8.com>
In-Reply-To: <cover.1490143843.git.fgao@ikuai8.com>
References: <cover.1490143843.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Because the conntrack NAT module could be rmmod anytime, so we should
really leave things in clean state if such thing happens and make sure
we don't leave any packet running over code that will be gone after
the removal.

We only removed the expectations when unregister conntrack helper before.
Actually it is necessary too when remove the nat helper.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v4: Cover the nat_module assignment in dataplane, per Pablo
 v3: Rename the nf_ct_helper_expectfn, func, and member, per Pablo
 v2: Use the module as the identifier when flush expect
 v1: initial version

 include/net/netfilter/nf_conntrack_expect.h |  2 +
 include/net/netfilter/nf_conntrack_helper.h |  1 +
 net/ipv4/netfilter/nf_nat_h323.c            |  8 ++++
 net/netfilter/nf_conntrack_broadcast.c      |  1 +
 net/netfilter/nf_conntrack_expect.c         |  1 +
 net/netfilter/nf_conntrack_helper.c         | 63 ++++++++++++++++++-----------
 net/netfilter/nf_conntrack_netlink.c        |  5 ++-
 net/netfilter/nf_conntrack_pptp.c           |  2 +
 net/netfilter/nf_nat_amanda.c               |  1 +
 net/netfilter/nf_nat_core.c                 |  1 +
 net/netfilter/nf_nat_ftp.c                  |  1 +
 net/netfilter/nf_nat_irc.c                  |  1 +
 net/netfilter/nf_nat_sip.c                  |  4 ++
 net/netfilter/nf_nat_tftp.c                 |  1 +
 14 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 5ed33ea..f2bc64e 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -26,6 +26,8 @@ struct nf_conntrack_expect {
 	/* Function to call after setup and insertion */
 	void (*expectfn)(struct nf_conn *new,
 			 struct nf_conntrack_expect *this);
+	/* The module which expectfn belongs to */
+	struct module *nat_module;
 
 	/* Helper to assign to new connection */
 	struct nf_conntrack_helper *helper;
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index d14fe493..dd1a687 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -113,6 +113,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb, unsigned int protoff,
 
 struct nf_ct_nat_helper {
 	struct list_head head;
+	struct module *me;
 	const char *name;
 	void (*expectfn)(struct nf_conn *ct, struct nf_conntrack_expect *exp);
 };
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 346e764..df57219 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -188,9 +188,11 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	/* Set expectations for NAT */
 	rtp_exp->saved_proto.udp.port = rtp_exp->tuple.dst.u.udp.port;
 	rtp_exp->expectfn = nf_nat_follow_master;
+	rtp_exp->nat_module = THIS_MODULE;
 	rtp_exp->dir = !dir;
 	rtcp_exp->saved_proto.udp.port = rtcp_exp->tuple.dst.u.udp.port;
 	rtcp_exp->expectfn = nf_nat_follow_master;
+	rtcp_exp->nat_module = THIS_MODULE;
 	rtcp_exp->dir = !dir;
 
 	/* Lookup existing expects */
@@ -290,6 +292,7 @@ static int nat_t120(struct sk_buff *skb, struct nf_conn *ct,
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->expectfn = nf_nat_follow_master;
+	exp->nat_module = THIS_MODULE;
 	exp->dir = !dir;
 
 	/* Try to get same port: if not, try to change it. */
@@ -342,6 +345,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->expectfn = nf_nat_follow_master;
+	exp->nat_module = THIS_MODULE;
 	exp->dir = !dir;
 
 	/* Check existing expects */
@@ -434,6 +438,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->expectfn = ip_nat_q931_expect;
+	exp->nat_module = THIS_MODULE;
 	exp->dir = !dir;
 
 	/* Check existing expects */
@@ -528,6 +533,7 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 	exp->tuple.dst.u3.ip = ct->tuplehash[!dir].tuple.dst.u3.ip;
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->expectfn = ip_nat_callforwarding_expect;
+	exp->nat_module = THIS_MODULE;
 	exp->dir = !dir;
 
 	/* Try to get same port: if not, try to change it. */
@@ -569,11 +575,13 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 
 static struct nf_ct_nat_helper q931_nat = {
 	.name		= "Q.931",
+	.me		= THIS_MODULE,
 	.expectfn	= ip_nat_q931_expect,
 };
 
 static struct nf_ct_nat_helper callforwarding_nat = {
 	.name		= "callforwarding",
+	.me		= THIS_MODULE,
 	.expectfn	= ip_nat_callforwarding_expect,
 };
 
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 4e99cca..ca54735 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -66,6 +66,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->mask.src.u.udp.port  = htons(0xFFFF);
 
 	exp->expectfn             = NULL;
+	exp->nat_module           = NULL;
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
 	exp->helper               = NULL;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4b2e1fb..b6d081a 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -296,6 +296,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 	exp->flags = 0;
 	exp->class = class;
 	exp->expectfn = NULL;
+	exp->nat_module = NULL;
 	exp->helper = NULL;
 	exp->tuple.src.l3num = family;
 	exp->tuple.dst.protonum = proto;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 0eaa01e..c25c9be 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -130,6 +130,42 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
 	return NULL;
 }
 
+static void
+nf_ct_flush_expect(const struct module *me)
+{
+	struct nf_conntrack_expect *exp;
+	const struct hlist_node *next;
+	u32 i;
+
+	if (!me)
+		return;
+
+	/* Make sure no one is still using the module unless
+	 * its a connection in the hash.
+	 */
+	synchronize_rcu();
+
+	/* Get rid of expectations */
+	spin_lock_bh(&nf_conntrack_expect_lock);
+	for (i = 0; i < nf_ct_expect_hsize; i++) {
+		hlist_for_each_entry_safe(exp, next,
+					  &nf_ct_expect_hash[i], hnode) {
+			struct nf_conn_help *master_help = nfct_help(exp->master);
+
+			if ((master_help->helper && master_help->helper->me == me) ||
+			    (exp->helper && exp->helper->me == me) ||
+			     exp->nat_module == me) {
+				/* This expect belongs to the dying module */
+				if (del_timer(&exp->timeout)) {
+					nf_ct_unlink_expect(exp);
+					nf_ct_expect_put(exp);
+				}
+			}
+		}
+	}
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+}
+
 struct nf_conntrack_helper *
 __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 {
@@ -308,6 +344,8 @@ void nf_ct_nat_helper_unregister(struct nf_ct_nat_helper *n)
 	spin_lock_bh(&nf_conntrack_expect_lock);
 	list_del_rcu(&n->head);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
+
+	nf_ct_flush_expect(n->me);
 }
 EXPORT_SYMBOL_GPL(nf_ct_nat_helper_unregister);
 
@@ -421,8 +459,6 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_tuple_hash *h;
-	struct nf_conntrack_expect *exp;
-	const struct hlist_node *next;
 	const struct hlist_nulls_node *nn;
 	unsigned int last_hsize;
 	spinlock_t *lock;
@@ -434,28 +470,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	nf_ct_helper_count--;
 	mutex_unlock(&nf_ct_helper_mutex);
 
-	/* Make sure every nothing is still using the helper unless its a
-	 * connection in the hash.
-	 */
-	synchronize_rcu();
-
-	/* Get rid of expectations */
-	spin_lock_bh(&nf_conntrack_expect_lock);
-	for (i = 0; i < nf_ct_expect_hsize; i++) {
-		hlist_for_each_entry_safe(exp, next,
-					  &nf_ct_expect_hash[i], hnode) {
-			struct nf_conn_help *help = nfct_help(exp->master);
-			if ((rcu_dereference_protected(
-					help->helper,
-					lockdep_is_held(&nf_conntrack_expect_lock)
-					) == me || exp->helper == me) &&
-			    del_timer(&exp->timeout)) {
-				nf_ct_unlink_expect(exp);
-				nf_ct_expect_put(exp);
-			}
-		}
-	}
-	spin_unlock_bh(&nf_conntrack_expect_lock);
+	nf_ct_flush_expect(me->me);
 
 	rtnl_lock();
 	for_each_net(net)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 66817a5..50628aa 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3078,8 +3078,11 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 			goto err_out;
 		}
 		exp->expectfn = nat_helper->expectfn;
-	} else
+		exp->nat_module = nat_helper->me;
+	} else {
 		exp->expectfn = NULL;
+		exp->nat_module = NULL;
+	}
 
 	exp->class = class;
 	exp->master = ct;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index f60a475..372dd7f 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -222,6 +222,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 			  &ct->tuplehash[dir].tuple.dst.u3,
 			  IPPROTO_GRE, &peer_callid, &callid);
 	exp_orig->expectfn = pptp_expectfn;
+	exp_orig->nat_module = THIS_MODULE;
 
 	/* reply direction, PAC->PNS */
 	dir = IP_CT_DIR_REPLY;
@@ -231,6 +232,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 			  &ct->tuplehash[dir].tuple.dst.u3,
 			  IPPROTO_GRE, &callid, &peer_callid);
 	exp_reply->expectfn = pptp_expectfn;
+	exp_reply->nat_module = THIS_MODULE;
 
 	nf_nat_pptp_exp_gre = rcu_dereference(nf_nat_pptp_hook_exp_gre);
 	if (nf_nat_pptp_exp_gre && ct->status & IPS_NAT_MASK)
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index eb77238..fad4363 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -42,6 +42,7 @@ static unsigned int help(struct sk_buff *skb,
 	/* When you see the packet, we need to NAT it the same as the
 	 * this one (ie. same IP: it will be TCP and master is UDP). */
 	exp->expectfn = nf_nat_follow_master;
+	exp->nat_module = THIS_MODULE;
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index eae9bec..f337208 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -850,6 +850,7 @@ static void __net_exit nf_nat_net_exit(struct net *net)
 
 static struct nf_ct_nat_helper follow_master_nat = {
 	.name		= "nat-follow-master",
+	.me		= THIS_MODULE,
 	.expectfn	= nf_nat_follow_master,
 };
 
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index e84a578..d004d49 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -81,6 +81,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	/* When you see the packet, we need to NAT it the same as the
 	 * this one. */
 	exp->expectfn = nf_nat_follow_master;
+	exp->nat_module = THIS_MODULE;
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 1fb2258..34b2119 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -45,6 +45,7 @@ static unsigned int help(struct sk_buff *skb,
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
+	exp->nat_module = THIS_MODULE;
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index d27c5a2..208d4d3 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -377,6 +377,7 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
 	exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
 	exp->dir = !dir;
 	exp->expectfn = nf_nat_sip_expected;
+	exp->nat_module = THIS_MODULE;
 
 	for (; port != 0; port++) {
 		int ret;
@@ -562,12 +563,14 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 	rtp_exp->saved_proto.udp.port = rtp_exp->tuple.dst.u.udp.port;
 	rtp_exp->dir = !dir;
 	rtp_exp->expectfn = nf_nat_sip_expected;
+	rtp_exp->nat_module = THIS_MODULE;
 
 	rtcp_exp->saved_addr = rtcp_exp->tuple.dst.u3;
 	rtcp_exp->tuple.dst.u3 = *rtp_addr;
 	rtcp_exp->saved_proto.udp.port = rtcp_exp->tuple.dst.u.udp.port;
 	rtcp_exp->dir = !dir;
 	rtcp_exp->expectfn = nf_nat_sip_expected;
+	rtcp_exp->nat_module = THIS_MODULE;
 
 	/* Try to get same pair of ports: if not, try to change them. */
 	for (port = ntohs(rtp_exp->tuple.dst.u.udp.port);
@@ -620,6 +623,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 
 static struct nf_ct_nat_helper sip_nat = {
 	.name		= "sip",
+	.me		= THIS_MODULE,
 	.expectfn	= nf_nat_sip_expected,
 };
 
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 7f67e1d..865ea04 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -28,6 +28,7 @@ static unsigned int help(struct sk_buff *skb,
 		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
+	exp->nat_module = THIS_MODULE;
 	if (nf_ct_expect_related(exp) != 0) {
 		nf_ct_helper_log(skb, exp->master, "cannot add expectation");
 		return NF_DROP;
-- 
1.9.1



