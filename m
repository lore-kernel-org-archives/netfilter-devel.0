From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/4] netfilter: conntrack: move helper destruction to
	nf_ct_helper_destroy()
Date: Wed, 10 Jun 2009 15:41:06 +0200
Message-ID: <20090610134106.14805.24215.stgit@Decadence>
References: <20090610133716.14805.95308.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54875 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZFJNlM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:41:12 -0400
In-Reply-To: <20090610133716.14805.95308.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the helper destruction to a function that lives
in nf_conntrack_helper.c. This new function is used in the patch
to add ctnetlink reliable event delivery.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_helper.h |    2 ++
 net/netfilter/nf_conntrack_core.c           |   11 +----------
 net/netfilter/nf_conntrack_helper.c         |   14 ++++++++++++++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index ee2a4b3..1b70680 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -50,6 +50,8 @@ extern struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
 extern int __nf_ct_try_assign_helper(struct nf_conn *ct, gfp_t flags);
 
+extern void nf_ct_helper_destroy(struct nf_conn *ct);
+
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 {
 	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 072539e..822c607 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -224,17 +224,8 @@ static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
 	struct net *net = nf_ct_net(ct);
-	struct nf_conn_help *help = nfct_help(ct);
-	struct nf_conntrack_helper *helper;
-
-	if (help) {
-		rcu_read_lock();
-		helper = rcu_dereference(help->helper);
-		if (helper && helper->destroy)
-			helper->destroy(ct);
-		rcu_read_unlock();
-	}
 
+	nf_ct_helper_destroy(ct);
 	spin_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 0fa5a42..65c2a7b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -136,6 +136,20 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 	return 0;
 }
 
+void nf_ct_helper_destroy(struct nf_conn *ct)
+{
+	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_helper *helper;
+
+	if (help) {
+		rcu_read_lock();
+		helper = rcu_dereference(help->helper);
+		if (helper && helper->destroy)
+			helper->destroy(ct);
+		rcu_read_unlock();
+	}
+}
+
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
 	unsigned int h = helper_hash(&me->tuple);

