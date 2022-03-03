Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92322C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 13:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiCCNz5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 08:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCCNz4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 08:55:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9FA18BA6E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 05:55:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nPlvA-0001XN-QW; Thu, 03 Mar 2022 14:55:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [RFC v3 nf-next 10/15] netfilter: cttimeout: decouple unlink and free on netns destruction
Date:   Thu,  3 Mar 2022 14:54:14 +0100
Message-Id: <20220303135419.10837-11-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220303135419.10837-1-fw@strlen.de>
References: <20220303135419.10837-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make it so netns pre_exit unlinks the objects from the pernet list, so
they cannot be found anymore.

netns core issues a synchronize_rcu() before calling the exit hooks so
any the time the exit hooks run unconfirmed nf_conn entries have been
free'd or they have been committed to the hashtable.

The exit hook still tags unconfirmed entries as dying, this can
now be removed in a followup change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_timeout.h |  8 ------
 net/netfilter/nfnetlink_cttimeout.c          | 30 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 3ea94f6f3844..fea258983d23 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -17,14 +17,6 @@ struct nf_ct_timeout {
 	char			data[];
 };
 
-struct ctnl_timeout {
-	struct list_head	head;
-	struct rcu_head		rcu_head;
-	refcount_t		refcnt;
-	char			name[CTNL_TIMEOUT_NAME_MAX];
-	struct nf_ct_timeout	timeout;
-};
-
 struct nf_conn_timeout {
 	struct nf_ct_timeout __rcu *timeout;
 };
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index c9cdc605f486..5bd660b45976 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -33,8 +33,19 @@
 
 static unsigned int nfct_timeout_id __read_mostly;
 
+struct ctnl_timeout {
+	struct list_head	head;
+	struct rcu_head		rcu_head;
+	refcount_t		refcnt;
+	char			name[CTNL_TIMEOUT_NAME_MAX];
+	struct nf_ct_timeout	timeout;
+
+	struct list_head	free_head;
+};
+
 struct nfct_timeout_pernet {
 	struct list_head	nfct_timeout_list;
+	struct list_head	nfct_timeout_freelist;
 };
 
 MODULE_LICENSE("GPL");
@@ -575,10 +586,24 @@ static int __net_init cttimeout_net_init(struct net *net)
 	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 
 	INIT_LIST_HEAD(&pernet->nfct_timeout_list);
+	INIT_LIST_HEAD(&pernet->nfct_timeout_freelist);
 
 	return 0;
 }
 
+static void __net_exit cttimeout_net_pre_exit(struct net *net)
+{
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
+	struct ctnl_timeout *cur, *tmp;
+
+	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_list, head) {
+		list_del_rcu(&cur->head);
+		list_add(&cur->free_head, &pernet->nfct_timeout_freelist);
+	}
+
+	/* core calls synchronize_rcu() after this */
+}
+
 static void __net_exit cttimeout_net_exit(struct net *net)
 {
 	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
@@ -587,8 +612,8 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 	nf_ct_unconfirmed_destroy(net);
 	nf_ct_untimeout(net, NULL);
 
-	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_list, head) {
-		list_del_rcu(&cur->head);
+	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_freelist, head) {
+		list_del(&cur->free_head);
 
 		if (refcount_dec_and_test(&cur->refcnt))
 			kfree_rcu(cur, rcu_head);
@@ -597,6 +622,7 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 
 static struct pernet_operations cttimeout_ops = {
 	.init	= cttimeout_net_init,
+	.pre_exit = cttimeout_net_pre_exit,
 	.exit	= cttimeout_net_exit,
 	.id     = &nfct_timeout_id,
 	.size   = sizeof(struct nfct_timeout_pernet),
-- 
2.34.1

