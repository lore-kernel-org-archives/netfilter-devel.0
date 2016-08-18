From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: cttimeout: fix use after free error when delete netns
Date: Thu, 18 Aug 2016 20:39:05 +0800
Message-ID: <1471523945-37097-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:34688 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbcHRMlM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2016 08:41:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

In general, when we want to delete a netns, cttimeout_net_exit will
be called before ipt_unregister_table, i.e. before ctnl_timeout_put.

But after call kfree_rcu in cttimeout_net_exit, we will still decrease
the timeout object's refcnt in ctnl_timeout_put, this is incorrect,
and will cause a use after free error.

It is easy to reproduce this problem:
  # while : ; do
  ip netns add xxx
  ip netns exec xxx nfct add timeout testx inet icmp timeout 200
  ip netns exec xxx iptables -t raw -p icmp -I OUTPUT -j CT --timeout testx
  ip netns del xxx
  done

  =======================================================================
  BUG kmalloc-96 (Tainted: G    B       E  ): Poison overwritten
  -----------------------------------------------------------------------
  INFO: 0xffff88002b5161e8-0xffff88002b5161e8. First byte 0x6a instead of
  0x6b
  INFO: Allocated in cttimeout_new_timeout+0xd4/0x240 [nfnetlink_cttimeout]
  age=104 cpu=0 pid=3330
  ___slab_alloc+0x4da/0x540
  __slab_alloc+0x20/0x40
  __kmalloc+0x1c8/0x240
  cttimeout_new_timeout+0xd4/0x240 [nfnetlink_cttimeout]
  nfnetlink_rcv_msg+0x21a/0x230 [nfnetlink]
  [ ... ]

So only when the refcnt decreased to 0, we call kfree_rcu to free the
timeout object. And like nfnetlink_acct do, use atomic_cmpxchg to
avoid race between ctnl_timeout_try_del and ctnl_timeout_put.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
I find that my attachment patch is not showed at patchwork, so I send
it again.

 net/netfilter/nfnetlink_cttimeout.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 4cdcd96..68216cd 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -330,16 +330,16 @@ static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 {
 	int ret = 0;
 
-	/* we want to avoid races with nf_ct_timeout_find_get. */
-	if (atomic_dec_and_test(&timeout->refcnt)) {
+	/* We want to avoid races with ctnl_timeout_put. So only when the
+	 * current refcnt is 1, we decrease it to 0.
+	 */
+	if (atomic_cmpxchg(&timeout->refcnt, 1, 0) == 1) {
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&timeout->head);
 		nf_ct_l4proto_put(timeout->l4proto);
 		ctnl_untimeout(net, timeout);
 		kfree_rcu(timeout, rcu_head);
 	} else {
-		/* still in use, restore reference counter. */
-		atomic_inc(&timeout->refcnt);
 		ret = -EBUSY;
 	}
 	return ret;
@@ -543,7 +543,9 @@ err:
 
 static void ctnl_timeout_put(struct ctnl_timeout *timeout)
 {
-	atomic_dec(&timeout->refcnt);
+	if (atomic_dec_and_test(&timeout->refcnt))
+		kfree_rcu(timeout, rcu_head);
+
 	module_put(THIS_MODULE);
 }
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
@@ -591,7 +593,9 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 	list_for_each_entry_safe(cur, tmp, &net->nfct_timeout_list, head) {
 		list_del_rcu(&cur->head);
 		nf_ct_l4proto_put(cur->l4proto);
-		kfree_rcu(cur, rcu_head);
+
+		if (atomic_dec_and_test(&cur->refcnt))
+			kfree_rcu(cur, rcu_head);
 	}
 }
 
-- 
2.5.5


