From: gfree.wind@foxmail.com
Subject: [PATCH nf v5 3/3] netfilter: nat_helper: Remove the expectations when its module is unloaded
Date: Fri, 31 Mar 2017 18:38:21 +0800
Message-ID: <916cdf26279f4d894d629ccef1d32034ffd5f024.1490955730.git.fgao@ikuai8.com>
References: <cover.1490955730.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau2.qq.com ([54.206.34.216]:36357 "EHLO smtpbgau2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754345AbdCaKin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 06:38:43 -0400
In-Reply-To: <cover.1490955730.git.fgao@ikuai8.com>
In-Reply-To: <cover.1490955730.git.fgao@ikuai8.com>
References: <cover.1490955730.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Because the conntrack NAT module could be rmmod anytime, so we should
really leave things in clean state if such thing happens and make sure
we don't leave any packet running over code that will be gone after the
removal.

We only removed the expectations when unregister conntrack helper before.
Actually it is necessary too when remove the nat helper.

Now add one new struct module member "me" in the nf_ct_nat_helper to
represent which module it belongs to.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v5: Register one nat_helper for every nat module, per Pablo
 v4: Cover the nat_module assignment in dataplane, per Pablo
 v3: Rename the nf_ct_helper_expectfn, func, and member, per Pablo
 v2: Use the module as the identifier when flush expect
 v1: initial version

 include/net/netfilter/nf_conntrack_helper.h |  1 +
 net/ipv4/netfilter/nf_nat_h323.c            |  3 ++
 net/netfilter/ipvs/ip_vs_nfct.c             |  1 +
 net/netfilter/nf_conntrack_expect.c         |  8 ++++
 net/netfilter/nf_conntrack_helper.c         | 62 +++++++++++++++++++----------
 net/netfilter/nf_conntrack_pptp.c           |  1 +
 net/netfilter/nf_nat_amanda.c               |  1 +
 net/netfilter/nf_nat_core.c                 |  1 +
 net/netfilter/nf_nat_ftp.c                  |  1 +
 net/netfilter/nf_nat_irc.c                  |  1 +
 net/netfilter/nf_nat_sip.c                  |  1 +
 net/netfilter/nf_nat_tftp.c                 |  1 +
 12 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index e8d31ca..d70c5be 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -114,6 +114,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb, unsigned int protoff,
 struct nf_ct_nat_helper {
 	struct list_head head;
 	const char *name;
+	struct module *me;
 	void (*expectfn)(struct nf_conn *ct, struct nf_conntrack_expect *exp);
 };
 
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 9101c48..c75583f 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -28,16 +28,19 @@ static void ip_nat_callforwarding_expect(struct nf_conn *new,
 
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
 
 static struct nf_ct_nat_helper follow_master_nat = {
 	.name		= "h323_follow_master",
+	.me		= THIS_MODULE,
 	.expectfn	= nf_nat_follow_master,
 };
 
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index 83ad79f..44cd98e 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -222,6 +222,7 @@ static void ip_vs_nfct_expect_callback(struct nf_conn *ct,
 
 static struct nf_ct_nat_helper ip_vs_nat = {
 	.name = "ip_vs_nat",
+	.me = THIS_MODULE,
 	.expectfn = ip_vs_nfct_expect_callback,
 };
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index ba5a55e..9653847 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -416,6 +416,14 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 		ret = -ESHUTDOWN;
 		goto out;
 	}
+
+	/* Make sure the helper and nat_helper belong to the same module */
+	if (expect->helper && expect->nat_helper &&
+	    expect->helper->me != expect->nat_helper->me) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 0eaa01e..1a161a6 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -130,6 +130,37 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
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
+	/* Get rid of expectations */
+	spin_lock_bh(&nf_conntrack_expect_lock);
+	for (i = 0; i < nf_ct_expect_hsize; i++) {
+		hlist_for_each_entry_safe(exp, next,
+					  &nf_ct_expect_hash[i], hnode) {
+			struct nf_conn_help *master_help = nfct_help(exp->master);
+
+			if ((master_help->helper && master_help->helper->me == me) ||
+			    (exp->helper && exp->helper->me == me) ||
+			    (exp->nat_helper && exp->nat_helper->me == me)) {
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
@@ -308,6 +339,12 @@ void nf_ct_nat_helper_unregister(struct nf_ct_nat_helper *n)
 	spin_lock_bh(&nf_conntrack_expect_lock);
 	list_del_rcu(&n->head);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
+
+	/* Make sure no one is still using the module unless
+	 * its a connection in the hash.
+	 */
+	synchronize_rcu();
+	nf_ct_flush_expect(n->me);
 }
 EXPORT_SYMBOL_GPL(nf_ct_nat_helper_unregister);
 
@@ -421,8 +458,6 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_tuple_hash *h;
-	struct nf_conntrack_expect *exp;
-	const struct hlist_node *next;
 	const struct hlist_nulls_node *nn;
 	unsigned int last_hsize;
 	spinlock_t *lock;
@@ -434,28 +469,11 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	nf_ct_helper_count--;
 	mutex_unlock(&nf_ct_helper_mutex);
 
-	/* Make sure every nothing is still using the helper unless its a
-	 * connection in the hash.
+	/* Make sure no one is still using the module unless
+	 * its a connection in the hash.
 	 */
 	synchronize_rcu();
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
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 5b5a45e..9d4a3e0 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -104,6 +104,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 
 static struct nf_ct_nat_helper pptp_nat = {
 	.name			= "pptp_nat",
+	.me			= THIS_MODULE,
 	.expectfn		= pptp_expectfn,
 };
 
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 05cd3fb..7263a16 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -26,6 +26,7 @@
 
 static struct nf_ct_nat_helper amanda_nat = {
 	.name = "amanda_nat",
+	.me = THIS_MODULE,
 	.expectfn = nf_nat_follow_master,
 };
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2897bd4..ae1789b 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -850,6 +850,7 @@ static void __net_exit nf_nat_net_exit(struct net *net)
 
 static struct nf_ct_nat_helper follow_master_nat = {
 	.name		= "nat-follow-master",
+	.me		= THIS_MODULE,
 	.expectfn	= nf_nat_follow_master,
 };
 
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index c027d44..90beafa 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -26,6 +26,7 @@
 
 static struct nf_ct_nat_helper ftp_nat = {
 	.name = "ftp_nat",
+	.me = THIS_MODULE,
 	.expectfn = nf_nat_follow_master,
 };
 
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 9eec7f3..ddc3f66 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -28,6 +28,7 @@
 
 static struct nf_ct_nat_helper irc_nat = {
 	.name = "irc_nat",
+	.me = THIS_MODULE,
 	.expectfn = nf_nat_follow_master,
 };
 
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index cd9333c..d13aae6 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -33,6 +33,7 @@ static void nf_nat_sip_expected(struct nf_conn *ct,
 
 static struct nf_ct_nat_helper sip_nat = {
 	.name		= "sip",
+	.me		= THIS_MODULE,
 	.expectfn	= nf_nat_sip_expected,
 };
 
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index f84b937..eb183dc 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -20,6 +20,7 @@
 
 static struct nf_ct_nat_helper tftp_nat = {
 	.name = "tftp_nat",
+	.me = THIS_MODULE,
 	.expectfn = nf_nat_follow_master,
 };
 
-- 
1.9.1




