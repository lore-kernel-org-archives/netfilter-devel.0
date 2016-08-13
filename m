From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 1/2] netfilter: nfnetlink_acct: fix race between nfacct del and xt_nfacct destroy
Date: Sat, 13 Aug 2016 23:13:01 +0800
Message-ID: <1471101182-15294-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:42082 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbcHMPN4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2016 11:13:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Suppose that we input the following commands at first:
  # nfacct add test
  # iptables -A INPUT -m nfacct --nfacct-name test

And now "test" acct's refcnt is 2, but later when we try to delete the
"test" nfacct and the related iptables rule at the same time, race maybe
happen:
      CPU0                                    CPU1
  nfnl_acct_try_del                      nfnl_acct_put
  atomic_dec_and_test //ref=1,testfail          -
       -                                 atomic_dec_and_test //ref=0,testok
       -                                 kfree_rcu
  atomic_inc //ref=1                            -

So after the rcu grace period, nf_acct will be freed but it is still linked
in the nfnl_acct_list, and we can access it later, then oops will happen.

Convert atomic_dec_and_test and atomic_inc combinaiton to one atomic
operation atomic_cmpxchg here to fix this problem.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nfnetlink_acct.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 1b4de4b..1f15535 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -326,16 +326,18 @@ static int nfnl_acct_try_del(struct nf_acct *cur)
 {
 	int ret = 0;
 
-	/* we want to avoid races with nfnl_acct_find_get. */
-	if (atomic_dec_and_test(&cur->refcnt)) {
+	/*
+	 * We want to avoid races with nfnl_acct_put. So only when the current
+	 * refcnt is 1, we decrease it to 0.
+	 */
+	if (atomic_cmpxchg(&cur->refcnt, 1, 0) == 1) {
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&cur->head);
 		kfree_rcu(cur, rcu_head);
 	} else {
-		/* still in use, restore reference counter. */
-		atomic_inc(&cur->refcnt);
 		ret = -EBUSY;
 	}
+
 	return ret;
 }
 
-- 
2.5.5


