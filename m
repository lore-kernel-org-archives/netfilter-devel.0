From: pablo@netfilter.org
Subject: [PATCH] netfilter: xt_CT: fix crash while destroy ct templates
Date: Tue, 11 Dec 2012 15:07:42 +0100
Message-ID: <1355234862-3476-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44908 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab2LKOHy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:07:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

In (d871bef netfilter: ctnetlink: dump entries from the dying and
unconfirmed lists), we assume that all conntrack objects are
inserted in any of the existing lists. However, template conntrack
objects were not. This results in hitting BUG_ON in the
destroy_conntrack path while removing a rule that uses the CT target.

This patch fixes the situation by adding the template lists, which
is where template conntrack objects reside now.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/conntrack.h     |    1 +
 net/netfilter/nf_conntrack_core.c |    2 ++
 net/netfilter/xt_CT.c             |    8 ++++++++
 3 files changed, 11 insertions(+)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index a1d83cc..923cb20 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -71,6 +71,7 @@ struct netns_ct {
 	struct hlist_head	*expect_hash;
 	struct hlist_nulls_head	unconfirmed;
 	struct hlist_nulls_head	dying;
+	struct hlist_nulls_head tmpl;
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index af17516..70ad220 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1524,6 +1524,7 @@ err_extend:
  */
 #define UNCONFIRMED_NULLS_VAL	((1<<30)+0)
 #define DYING_NULLS_VAL		((1<<30)+1)
+#define TEMPLATE_NULLS_VAL	((1<<30)+2)
 
 static int nf_conntrack_init_net(struct net *net)
 {
@@ -1532,6 +1533,7 @@ static int nf_conntrack_init_net(struct net *net)
 	atomic_set(&net->ct.count, 0);
 	INIT_HLIST_NULLS_HEAD(&net->ct.unconfirmed, UNCONFIRMED_NULLS_VAL);
 	INIT_HLIST_NULLS_HEAD(&net->ct.dying, DYING_NULLS_VAL);
+	INIT_HLIST_NULLS_HEAD(&net->ct.tmpl, TEMPLATE_NULLS_VAL);
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
 	if (!net->ct.stat) {
 		ret = -ENOMEM;
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index ae7f5da..1668f41 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -149,6 +149,10 @@ static int xt_ct_tg_check_v0(const struct xt_tgchk_param *par)
 
 	__set_bit(IPS_TEMPLATE_BIT, &ct->status);
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
+
+	/* Overload tuple linked list to put us in template list. */
+	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+				 &par->net->ct.tmpl);
 out:
 	info->ct = ct;
 	return 0;
@@ -289,6 +293,10 @@ static int xt_ct_tg_check_v1(const struct xt_tgchk_param *par)
 
 	__set_bit(IPS_TEMPLATE_BIT, &ct->status);
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
+
+	/* Overload tuple linked list to put us in template list. */
+	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+				 &par->net->ct.tmpl);
 out:
 	info->ct = ct;
 	return 0;
-- 
1.7.10.4

