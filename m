From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/4] netfilter: ctnetlink: add support for user-space
	expectation helpers
Date: Tue, 21 Sep 2010 11:35:29 +0200
Message-ID: <20100921093529.3279.30748.stgit@decadence>
References: <20100921092843.3279.6914.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33962 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079Ab0IUJfd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:35:33 -0400
In-Reply-To: <20100921092843.3279.6914.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the basic infrastructure to support user-space
expectation helpers via ctnetlink and the netfilter queuing
infrastructure NFQUEUE. Basically, this patch:

* adds NF_CT_EXPECT_USERSPACE flag to identify user-space
created expectations. I have also added a sanity check in
__nf_ct_expect_check() to avoid that kernel-space helpers
may create an expectation if the master conntrack has no
helper assigned.
* adds some branches to check if the master conntrack helper
exists, otherwise we skip the code that refers to kernel-space
helper such as the local expectation list and the expectation
policy.
* allows to set the timeout for user-space expectations with
no helper assigned.

This patch also modifies ctnetlink to skip including the helper
name in the Netlink messages if no kernel-space helper is set
(since no user-space expectation has not kernel-space kernel
assigned).

You can access an example user-space FTP conntrack helper at:
http://people.netfilter.org/pablo/nf-ftp-helper-userspace-POC.tar.bz

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h |    1 +
 net/netfilter/nf_conntrack_expect.c           |   40 ++++++++++++++++---------
 net/netfilter/nf_conntrack_netlink.c          |   38 ++++++++++++++----------
 3 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index fdc50ca..23a1a08 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -103,6 +103,7 @@ enum ip_conntrack_expect_events {
 /* expectation flags */
 #define NF_CT_EXPECT_PERMANENT		0x1
 #define NF_CT_EXPECT_INACTIVE		0x2
+#define NF_CT_EXPECT_USERSPACE		0x4
 
 #ifdef __KERNEL__
 struct ip_conntrack_stat {
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index acb29cc..b53e817 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -44,14 +44,15 @@ void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 	struct nf_conn_help *master_help = nfct_help(exp->master);
 	struct net *net = nf_ct_exp_net(exp);
 
-	NF_CT_ASSERT(master_help);
 	NF_CT_ASSERT(!timer_pending(&exp->timeout));
 
 	hlist_del_rcu(&exp->hnode);
 	net->ct.expect_count--;
 
-	hlist_del(&exp->lnode);
-	master_help->expecting[exp->class]--;
+	if (master_help) {
+		hlist_del(&exp->lnode);
+		master_help->expecting[exp->class]--;
+	}
 	nf_ct_expect_put(exp);
 
 	NF_CT_STAT_INC(net, expect_delete);
@@ -320,16 +321,20 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 
 	atomic_inc(&exp->use);
 
-	hlist_add_head(&exp->lnode, &master_help->expectations);
-	master_help->expecting[exp->class]++;
+	if (master_help) {
+		hlist_add_head(&exp->lnode, &master_help->expectations);
+		master_help->expecting[exp->class]++;
+	}
 
 	hlist_add_head_rcu(&exp->hnode, &net->ct.expect_hash[h]);
 	net->ct.expect_count++;
 
 	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
 		    (unsigned long)exp);
-	p = &master_help->helper->expect_policy[exp->class];
-	exp->timeout.expires = jiffies + p->timeout * HZ;
+	if (master_help) {
+		p = &master_help->helper->expect_policy[exp->class];
+		exp->timeout.expires = jiffies + p->timeout * HZ;
+	}
 	add_timer(&exp->timeout);
 
 	atomic_inc(&exp->use);
@@ -380,7 +385,9 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	unsigned int h;
 	int ret = 1;
 
-	if (!master_help->helper) {
+	/* Don't allow expectations created from kernel-space with no helper */
+	if (!(expect->flags & NF_CT_EXPECT_USERSPACE) &&
+	    (!master_help || (master_help && !master_help->helper))) {
 		ret = -ESHUTDOWN;
 		goto out;
 	}
@@ -398,13 +405,16 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 		}
 	}
 	/* Will be over limit? */
-	p = &master_help->helper->expect_policy[expect->class];
-	if (p->max_expected &&
-	    master_help->expecting[expect->class] >= p->max_expected) {
-		evict_oldest_expect(master, expect);
-		if (master_help->expecting[expect->class] >= p->max_expected) {
-			ret = -EMFILE;
-			goto out;
+	if (master_help) {
+		p = &master_help->helper->expect_policy[expect->class];
+		if (p->max_expected &&
+		    master_help->expecting[expect->class] >= p->max_expected) {
+			evict_oldest_expect(master, expect);
+			if (master_help->expecting[expect->class]
+						>= p->max_expected) {
+				ret = -EMFILE;
+				goto out;
+			}
 		}
 	}
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 82363f0..cddf4b6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1560,8 +1560,8 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
-	struct nf_conntrack_helper *helper;
 	long timeout = (exp->timeout.expires - jiffies) / HZ;
+	struct nf_conn_help *help;
 
 	if (timeout < 0)
 		timeout = 0;
@@ -1577,9 +1577,14 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 
 	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout));
 	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
-	helper = rcu_dereference(nfct_help(master)->helper);
-	if (helper)
-		NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
+	help = nfct_help(master);
+	if (help) {
+		struct nf_conntrack_helper *helper;
+
+		helper = rcu_dereference(help->helper);
+		if (helper)
+			NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
+	}
 
 	return 0;
 
@@ -1920,24 +1925,25 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	if (!h)
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
-	help = nfct_help(ct);
-
-	if (!help || !help->helper) {
-		/* such conntrack hasn't got any helper, abort */
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
 	exp = nf_ct_expect_alloc(ct);
 	if (!exp) {
 		err = -ENOMEM;
 		goto out;
 	}
-
-	if (cda[CTA_EXPECT_FLAGS])
+	help = nfct_help(ct);
+	if (!help) {
+		if (!cda[CTA_EXPECT_TIMEOUT]) {
+			err = -EINVAL;
+			goto out;
+		}
+		exp->timeout.expires =
+		  jiffies + ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
+	}
+	if (cda[CTA_EXPECT_FLAGS]) {
 		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
-	else
-		exp->flags = 0;
+		exp->flags |= NF_CT_EXPECT_USERSPACE;
+	} else
+		exp->flags = NF_CT_EXPECT_USERSPACE;
 
 	exp->class = 0;
 	exp->expectfn = NULL;

