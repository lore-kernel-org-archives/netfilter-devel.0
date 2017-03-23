From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf V2] netfilter: nfnl_cthelper: fix a race when walk the nf_ct_helper_hash table
Date: Thu, 23 Mar 2017 22:36:59 +0800
Message-ID: <1490279819-31239-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:48130 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934348AbdCWOiB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2017 10:38:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

The nf_ct_helper_hash table is protected by nf_ct_helper_mutex, while
nfct_helper operation is protected by nfnl_lock(NFNL_SUBSYS_CTHELPER).
So it's possible that one CPU is walking the nf_ct_helper_hash for
cthelper add/get/del, another cpu is doing nf_conntrack_helpers_unregister
at the same time. This is dangrous, and may cause use after free error.

Note, delete operation will flush all cthelpers added via nfnetlink, so
using rcu to do protect is not easy.

Now introduce a dummy list to record all the cthelpers added via
nfnetlink, then we can walk the dummy list instead of walking the
nf_ct_helper_hash. Also, keep nfnl_cthelper_dump_table unchanged, it
may be invoked without nfnl_lock(NFNL_SUBSYS_CTHELPER) held.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: rebase on the latest nf tree

 net/netfilter/nfnetlink_cthelper.c | 182 ++++++++++++++++++-------------------
 1 file changed, 88 insertions(+), 94 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 2b987d2..304aab8 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -32,6 +32,13 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_DESCRIPTION("nfnl_cthelper: User-space connection tracking helpers");
 
+struct nfnl_cthelper {
+	struct list_head		list;
+	struct nf_conntrack_helper	*helper;
+};
+
+static LIST_HEAD(nfnl_cthelper_list);
+
 static int
 nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
@@ -205,14 +212,21 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		     struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_helper *helper;
+	struct nfnl_cthelper *nfcth;
 	int ret;
 
 	if (!tb[NFCTH_TUPLE] || !tb[NFCTH_POLICY] || !tb[NFCTH_PRIV_DATA_LEN])
 		return -EINVAL;
 
+	nfcth = kmalloc(sizeof(struct nfnl_cthelper), GFP_KERNEL);
+	if (nfcth == NULL)
+		return -ENOMEM;
+
 	helper = kzalloc(sizeof(struct nf_conntrack_helper), GFP_KERNEL);
-	if (helper == NULL)
+	if (helper == NULL) {
+		kfree(nfcth);
 		return -ENOMEM;
+	}
 
 	ret = nfnl_cthelper_parse_expect_policy(helper, tb[NFCTH_POLICY]);
 	if (ret < 0)
@@ -249,10 +263,13 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	if (ret < 0)
 		goto err2;
 
+	nfcth->helper = helper;
+	list_add_tail(&nfcth->list, &nfnl_cthelper_list);
 	return 0;
 err2:
 	kfree(helper->expect_policy);
 err1:
+	kfree(nfcth);
 	kfree(helper);
 	return ret;
 }
@@ -379,7 +396,8 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 	const char *helper_name;
 	struct nf_conntrack_helper *cur, *helper = NULL;
 	struct nf_conntrack_tuple tuple;
-	int ret = 0, i;
+	struct nfnl_cthelper *nlcth;
+	int ret = 0;
 
 	if (!tb[NFCTH_NAME] || !tb[NFCTH_TUPLE])
 		return -EINVAL;
@@ -390,31 +408,22 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 	if (ret < 0)
 		return ret;
 
-	rcu_read_lock();
-	for (i = 0; i < nf_ct_helper_hsize && !helper; i++) {
-		hlist_for_each_entry_rcu(cur, &nf_ct_helper_hash[i], hnode) {
+	list_for_each_entry(nlcth, &nfnl_cthelper_list, list) {
+		cur = nlcth->helper;
 
-			/* skip non-userspace conntrack helpers. */
-			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
-				continue;
+		if (strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
+			continue;
 
-			if (strncmp(cur->name, helper_name,
-					NF_CT_HELPER_NAME_LEN) != 0)
-				continue;
+		if ((tuple.src.l3num != cur->tuple.src.l3num ||
+		     tuple.dst.protonum != cur->tuple.dst.protonum))
+			continue;
 
-			if ((tuple.src.l3num != cur->tuple.src.l3num ||
-			     tuple.dst.protonum != cur->tuple.dst.protonum))
-				continue;
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			return -EEXIST;
 
-			if (nlh->nlmsg_flags & NLM_F_EXCL) {
-				ret = -EEXIST;
-				goto err;
-			}
-			helper = cur;
-			break;
-		}
+		helper = cur;
+		break;
 	}
-	rcu_read_unlock();
 
 	if (helper == NULL)
 		ret = nfnl_cthelper_create(tb, &tuple);
@@ -422,9 +431,6 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 		ret = nfnl_cthelper_update(tb, helper);
 
 	return ret;
-err:
-	rcu_read_unlock();
-	return ret;
 }
 
 static int
@@ -588,11 +594,12 @@ static int nfnl_cthelper_get(struct net *net, struct sock *nfnl,
 			     struct sk_buff *skb, const struct nlmsghdr *nlh,
 			     const struct nlattr * const tb[])
 {
-	int ret = -ENOENT, i;
+	int ret = -ENOENT;
 	struct nf_conntrack_helper *cur;
 	struct sk_buff *skb2;
 	char *helper_name = NULL;
 	struct nf_conntrack_tuple tuple;
+	struct nfnl_cthelper *nlcth;
 	bool tuple_set = false;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -613,45 +620,39 @@ static int nfnl_cthelper_get(struct net *net, struct sock *nfnl,
 		tuple_set = true;
 	}
 
-	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_rcu(cur, &nf_ct_helper_hash[i], hnode) {
-
-			/* skip non-userspace conntrack helpers. */
-			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
-				continue;
+	list_for_each_entry(nlcth, &nfnl_cthelper_list, list) {
+		cur = nlcth->helper;
+		if (helper_name &&
+		    strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
+			continue;
 
-			if (helper_name && strncmp(cur->name, helper_name,
-						NF_CT_HELPER_NAME_LEN) != 0) {
-				continue;
-			}
-			if (tuple_set &&
-			    (tuple.src.l3num != cur->tuple.src.l3num ||
-			     tuple.dst.protonum != cur->tuple.dst.protonum))
-				continue;
+		if (tuple_set &&
+		    (tuple.src.l3num != cur->tuple.src.l3num ||
+		     tuple.dst.protonum != cur->tuple.dst.protonum))
+			continue;
 
-			skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-			if (skb2 == NULL) {
-				ret = -ENOMEM;
-				break;
-			}
+		skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+		if (skb2 == NULL) {
+			ret = -ENOMEM;
+			break;
+		}
 
-			ret = nfnl_cthelper_fill_info(skb2, NETLINK_CB(skb).portid,
-						nlh->nlmsg_seq,
-						NFNL_MSG_TYPE(nlh->nlmsg_type),
-						NFNL_MSG_CTHELPER_NEW, cur);
-			if (ret <= 0) {
-				kfree_skb(skb2);
-				break;
-			}
+		ret = nfnl_cthelper_fill_info(skb2, NETLINK_CB(skb).portid,
+					      nlh->nlmsg_seq,
+					      NFNL_MSG_TYPE(nlh->nlmsg_type),
+					      NFNL_MSG_CTHELPER_NEW, cur);
+		if (ret <= 0) {
+			kfree_skb(skb2);
+			break;
+		}
 
-			ret = netlink_unicast(nfnl, skb2, NETLINK_CB(skb).portid,
-						MSG_DONTWAIT);
-			if (ret > 0)
-				ret = 0;
+		ret = netlink_unicast(nfnl, skb2, NETLINK_CB(skb).portid,
+				      MSG_DONTWAIT);
+		if (ret > 0)
+			ret = 0;
 
-			/* this avoids a loop in nfnetlink. */
-			return ret == -EAGAIN ? -ENOBUFS : ret;
-		}
+		/* this avoids a loop in nfnetlink. */
+		return ret == -EAGAIN ? -ENOBUFS : ret;
 	}
 	return ret;
 }
@@ -662,10 +663,10 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 {
 	char *helper_name = NULL;
 	struct nf_conntrack_helper *cur;
-	struct hlist_node *tmp;
 	struct nf_conntrack_tuple tuple;
 	bool tuple_set = false, found = false;
-	int i, j = 0, ret;
+	struct nfnl_cthelper *nlcth, *n;
+	int j = 0, ret;
 
 	if (tb[NFCTH_NAME])
 		helper_name = nla_data(tb[NFCTH_NAME]);
@@ -678,30 +679,28 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 		tuple_set = true;
 	}
 
-	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_safe(cur, tmp, &nf_ct_helper_hash[i],
-								hnode) {
-			/* skip non-userspace conntrack helpers. */
-			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
-				continue;
+	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
+		cur = nlcth->helper;
+		j++;
 
-			j++;
+		if (helper_name &&
+		    strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
+			continue;
 
-			if (helper_name && strncmp(cur->name, helper_name,
-						NF_CT_HELPER_NAME_LEN) != 0) {
-				continue;
-			}
-			if (tuple_set &&
-			    (tuple.src.l3num != cur->tuple.src.l3num ||
-			     tuple.dst.protonum != cur->tuple.dst.protonum))
-				continue;
+		if (tuple_set &&
+		    (tuple.src.l3num != cur->tuple.src.l3num ||
+		     tuple.dst.protonum != cur->tuple.dst.protonum))
+			continue;
 
-			found = true;
-			nf_conntrack_helper_unregister(cur);
-			kfree(cur->expect_policy);
-			kfree(cur);
-		}
+		found = true;
+		nf_conntrack_helper_unregister(cur);
+		kfree(cur->expect_policy);
+		kfree(cur);
+
+		list_del(&nlcth->list);
+		kfree(nlcth);
 	}
+
 	/* Make sure we return success if we flush and there is no helpers */
 	return (found || j == 0) ? 0 : -ENOENT;
 }
@@ -750,22 +749,17 @@ static int __init nfnl_cthelper_init(void)
 static void __exit nfnl_cthelper_exit(void)
 {
 	struct nf_conntrack_helper *cur;
-	struct hlist_node *tmp;
-	int i;
+	struct nfnl_cthelper *nlcth, *n;
 
 	nfnetlink_subsys_unregister(&nfnl_cthelper_subsys);
 
-	for (i=0; i<nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_safe(cur, tmp, &nf_ct_helper_hash[i],
-									hnode) {
-			/* skip non-userspace conntrack helpers. */
-			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
-				continue;
+	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
+		cur = nlcth->helper;
 
-			nf_conntrack_helper_unregister(cur);
-			kfree(cur->expect_policy);
-			kfree(cur);
-		}
+		nf_conntrack_helper_unregister(cur);
+		kfree(cur->expect_policy);
+		kfree(cur);
+		kfree(nlcth);
 	}
 }
 
-- 
2.5.5


