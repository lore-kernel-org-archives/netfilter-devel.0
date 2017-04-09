From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 2/2] netfilter: nfnl_cthelper: reject del request if helper obj is in use
Date: Sun,  9 Apr 2017 16:22:14 +0800
Message-ID: <1491726134-23686-3-git-send-email-zlpnobody@163.com>
References: <1491726134-23686-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:43574 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751901AbdDIIXD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Apr 2017 04:23:03 -0400
In-Reply-To: <1491726134-23686-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We can still delete the ct helper even if it is in use, this will cause
a use-after-free error. In more detail, I mean:
  # nfct helper add ssdp inet udp
  # iptables -t raw -A OUTPUT -p udp -j CT --helper ssdp
  # nfct helper delete ssdp //--> succeed!

So add reference count to fix this issue, if ct helper is used by
others, reject the delete request.

Apply this patch:
  # nfct helper delete ssdp
  nfct v1.4.3: netlink error: Device or resource busy

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 Also note, nft ct helper obj only exists in nf-next tree, so after this
 patch appeared in nf-next, I will send another patch to fix it.

 include/net/netfilter/nf_conntrack_helper.h |  2 ++
 net/netfilter/nf_conntrack_helper.c         |  6 ++++++
 net/netfilter/nfnetlink_cthelper.c          | 17 +++++++++++------
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 65e1dcf..c7a9ad7 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -9,6 +9,7 @@
 
 #ifndef _NF_CONNTRACK_HELPER_H
 #define _NF_CONNTRACK_HELPER_H
+#include <linux/refcount.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -26,6 +27,7 @@ struct nf_conntrack_helper {
 	struct hlist_node hnode;	/* Internal use. */
 
 	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
+	refcount_t refcnt;
 	struct module *me;		/* pointer to self */
 	const struct nf_conntrack_expect_policy *expect_policy;
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 5275e9a..8fdd03b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -167,6 +167,10 @@ nf_conntrack_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
 #endif
 	if (h != NULL && !try_module_get(h->me))
 		h = NULL;
+	if (h != NULL && !refcount_inc_not_zero(&h->refcnt)) {
+		module_put(h->me);
+		h = NULL;
+	}
 
 	return h;
 }
@@ -174,6 +178,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_try_module_get);
 
 void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
 {
+	refcount_dec(&helper->refcnt);
 	module_put(helper->me);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
@@ -398,6 +403,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			goto out;
 		}
 	}
+	refcount_set(&me->refcnt, 1);
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
 	nf_ct_helper_count++;
 out:
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index d455581..6e9e3c4 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -672,6 +672,7 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 		tuple_set = true;
 	}
 
+	ret = -ENOENT;
 	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
 		cur = &nlcth->helper;
 		j++;
@@ -685,16 +686,20 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 		     tuple.dst.protonum != cur->tuple.dst.protonum))
 			continue;
 
-		found = true;
-		nf_conntrack_helper_unregister(cur);
-		kfree(cur->expect_policy);
+		if (refcount_dec_if_one(&cur->refcnt)) {
+			found = true;
+			nf_conntrack_helper_unregister(cur);
+			kfree(cur->expect_policy);
 
-		list_del(&nlcth->list);
-		kfree(nlcth);
+			list_del(&nlcth->list);
+			kfree(nlcth);
+		} else {
+			ret = -EBUSY;
+		}
 	}
 
 	/* Make sure we return success if we flush and there is no helpers */
-	return (found || j == 0) ? 0 : -ENOENT;
+	return (found || j == 0) ? 0 : ret;
 }
 
 static const struct nla_policy nfnl_cthelper_policy[NFCTH_MAX+1] = {
-- 
2.5.5


