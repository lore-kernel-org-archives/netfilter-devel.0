From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/20]: nf_conntrack_helper/nf_conntrack_netlink:
	convert to expectation hash
Date: Fri, 29 Jun 2007 02:45:14 +0200 (MEST)
Message-ID: <20070629004413.25566.92008.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack_helper/nf_conntrack_netlink: convert to expectation hash

Convert from the global expectation list to the hash table.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f6ae8f4600dff514f6cd766272cd57564fd4a4fe
tree 3cf625280fd34ae01b776fcb4038440944a85673
parent 2141115bac5b86840c97aef9b6a2481764de4779
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:15:53 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:15:53 +0200

 net/netfilter/nf_conntrack_helper.c  |   21 +++++----
 net/netfilter/nf_conntrack_netlink.c |   77 ++++++++++++++++++++--------------
 2 files changed, 57 insertions(+), 41 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index fdabf82..cc8ae74 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -114,22 +114,25 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
-	unsigned int i;
 	struct nf_conntrack_tuple_hash *h;
-	struct nf_conntrack_expect *exp, *tmp;
-	struct hlist_node *n;
+	struct nf_conntrack_expect *exp;
+	struct hlist_node *n, *next;
+	unsigned int i;
 
 	/* Need write lock here, to delete helper. */
 	write_lock_bh(&nf_conntrack_lock);
 	list_del(&me->list);
 
 	/* Get rid of expectations */
-	list_for_each_entry_safe(exp, tmp, &nf_ct_expect_list, list) {
-		struct nf_conn_help *help = nfct_help(exp->master);
-		if ((help->helper == me || exp->helper == me) &&
-		    del_timer(&exp->timeout)) {
-			nf_ct_unlink_expect(exp);
-			nf_ct_expect_put(exp);
+	for (i = 0; i < nf_ct_expect_hsize; i++) {
+		hlist_for_each_entry_safe(exp, n, next,
+					  &nf_ct_expect_hash[i], hnode) {
+			struct nf_conn_help *help = nfct_help(exp->master);
+			if ((help->helper == me || exp->helper == me) &&
+			    del_timer(&exp->timeout)) {
+				nf_ct_unlink_expect(exp);
+				nf_ct_expect_put(exp);
+			}
 		}
 	}
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3707ffe..60af9b6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1237,7 +1237,7 @@ nfattr_failure:
 #endif
 static int ctnetlink_exp_done(struct netlink_callback *cb)
 {
-	if (cb->args[0])
+	if (cb->args[1])
 		nf_ct_expect_put((struct nf_conntrack_expect *)cb->args[1]);
 	return 0;
 }
@@ -1246,35 +1246,37 @@ static int
 ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_conntrack_expect *exp, *last;
-	struct list_head *i;
 	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	struct hlist_node *n;
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	read_lock_bh(&nf_conntrack_lock);
-	last = (struct nf_conntrack_expect *)cb->args[0];
+	last = (struct nf_conntrack_expect *)cb->args[1];
+	for (; cb->args[0] < nf_ct_expect_hsize; cb->args[0]++) {
 restart:
-	list_for_each_prev(i, &nf_ct_expect_list) {
-		exp = (struct nf_conntrack_expect *) i;
-		if (l3proto && exp->tuple.src.l3num != l3proto)
-			continue;
-		if (cb->args[0]) {
-			if (exp != last)
+		hlist_for_each_entry(exp, n, &nf_ct_expect_hash[cb->args[0]],
+				     hnode) {
+			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
-			cb->args[0] = 0;
+			if (cb->args[1]) {
+				if (exp != last)
+					continue;
+				cb->args[1] = 0;
+			}
+			if (ctnetlink_exp_fill_info(skb, NETLINK_CB(cb->skb).pid,
+						    cb->nlh->nlmsg_seq,
+						    IPCTNL_MSG_EXP_NEW,
+						    1, exp) < 0) {
+				atomic_inc(&exp->use);
+				cb->args[1] = (unsigned long)exp;
+				goto out;
+			}
 		}
-		if (ctnetlink_exp_fill_info(skb, NETLINK_CB(cb->skb).pid,
-					    cb->nlh->nlmsg_seq,
-					    IPCTNL_MSG_EXP_NEW,
-					    1, exp) < 0) {
-			atomic_inc(&exp->use);
-			cb->args[0] = (unsigned long)exp;
-			goto out;
+		if (cb->args[1]) {
+			cb->args[1] = 0;
+			goto restart;
 		}
 	}
-	if (cb->args[0]) {
-		cb->args[0] = 0;
-		goto restart;
-	}
 out:
 	read_unlock_bh(&nf_conntrack_lock);
 	if (last)
@@ -1354,11 +1356,13 @@ static int
 ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 		     struct nlmsghdr *nlh, struct nfattr *cda[])
 {
-	struct nf_conntrack_expect *exp, *tmp;
+	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_helper *h;
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+	struct hlist_node *n, *next;
 	u_int8_t u3 = nfmsg->nfgen_family;
+	unsigned int i;
 	int err;
 
 	if (nfattr_bad_size(cda, CTA_EXPECT_MAX, cta_min_exp))
@@ -1390,6 +1394,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 		nf_ct_expect_put(exp);
 	} else if (cda[CTA_EXPECT_HELP_NAME-1]) {
 		char *name = NFA_DATA(cda[CTA_EXPECT_HELP_NAME-1]);
+		struct nf_conn_help *m_help;
 
 		/* delete all expectations for this helper */
 		write_lock_bh(&nf_conntrack_lock);
@@ -1398,22 +1403,30 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 			write_unlock_bh(&nf_conntrack_lock);
 			return -EINVAL;
 		}
-		list_for_each_entry_safe(exp, tmp, &nf_ct_expect_list, list) {
-			struct nf_conn_help *m_help = nfct_help(exp->master);
-			if (m_help->helper == h
-			    && del_timer(&exp->timeout)) {
-				nf_ct_unlink_expect(exp);
-				nf_ct_expect_put(exp);
+		for (i = 0; i < nf_ct_expect_hsize; i++) {
+			hlist_for_each_entry_safe(exp, n, next,
+						  &nf_ct_expect_hash[i],
+						  hnode) {
+				m_help = nfct_help(exp->master);
+				if (m_help->helper == h
+				    && del_timer(&exp->timeout)) {
+					nf_ct_unlink_expect(exp);
+					nf_ct_expect_put(exp);
+				}
 			}
 		}
 		write_unlock_bh(&nf_conntrack_lock);
 	} else {
 		/* This basically means we have to flush everything*/
 		write_lock_bh(&nf_conntrack_lock);
-		list_for_each_entry_safe(exp, tmp, &nf_ct_expect_list, list) {
-			if (del_timer(&exp->timeout)) {
-				nf_ct_unlink_expect(exp);
-				nf_ct_expect_put(exp);
+		for (i = 0; i < nf_ct_expect_hsize; i++) {
+			hlist_for_each_entry_safe(exp, n, next,
+						  &nf_ct_expect_hash[i],
+						  hnode) {
+				if (del_timer(&exp->timeout)) {
+					nf_ct_unlink_expect(exp);
+					nf_ct_expect_put(exp);
+				}
 			}
 		}
 		write_unlock_bh(&nf_conntrack_lock);
