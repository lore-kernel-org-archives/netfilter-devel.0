From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf V2 2/2] netfilter: nfnl_cthelper: reject del request if helper obj is in use
Date: Sun,  7 May 2017 22:01:56 +0800
Message-ID: <20170507140156.16487-3-zlpnobody@163.com>
References: <20170507140156.16487-1-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:38341 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752838AbdEGVsu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2017 17:48:50 -0400
In-Reply-To: <20170507140156.16487-1-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We can still delete the ct helper even if it is in use, this will cause
a use-after-free error. In more detail, I mean:
  # nfct helper add ssdp inet udp
  # iptables -t raw -A OUTPUT -p udp -j CT --helper ssdp
  # nfct helper delete ssdp //--> oops, succeed!
  BUG: unable to handle kernel paging request at 000026ca
  IP: 0x26ca
  [...]
  Call Trace:
   ? ipv4_helper+0x62/0x80 [nf_conntrack_ipv4]
   nf_hook_slow+0x21/0xb0
   ip_output+0xe9/0x100
   ? ip_fragment.constprop.54+0xc0/0xc0
   ip_local_out+0x33/0x40
   ip_send_skb+0x16/0x80
   udp_send_skb+0x84/0x240
   udp_sendmsg+0x35d/0xa50

So add reference count to fix this issue, if ct helper is used by
others, reject the delete request.

Apply this patch:
  # nfct helper delete ssdp
  nfct v1.4.3: netlink error: Device or resource busy

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: rebase on the latest nf tree and update git commit log.

 include/net/netfilter/nf_conntrack_helper.h |  2 ++
 net/netfilter/nf_conntrack_helper.c         |  6 ++++++
 net/netfilter/nfnetlink_cthelper.c          | 17 +++++++++++------
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index c1c12411..c519bb5 100644
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
index e17006b..7f6100c 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -174,6 +174,10 @@ nf_conntrack_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
 #endif
 	if (h != NULL && !try_module_get(h->me))
 		h = NULL;
+	if (h != NULL && !refcount_inc_not_zero(&h->refcnt)) {
+		module_put(h->me);
+		h = NULL;
+	}
 
 	rcu_read_unlock();
 
@@ -183,6 +187,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_try_module_get);
 
 void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
 {
+	refcount_dec(&helper->refcnt);
 	module_put(helper->me);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
@@ -423,6 +428,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			}
 		}
 	}
+	refcount_set(&me->refcnt, 1);
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
 	nf_ct_helper_count++;
 out:
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 950bf6e..be678a3 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -686,6 +686,7 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 		tuple_set = true;
 	}
 
+	ret = -ENOENT;
 	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
 		cur = &nlcth->helper;
 		j++;
@@ -699,16 +700,20 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
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
2.9.3


