From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/2] netfilter: nfnetlink_acct: fix race between
 nfacct del and xt_nfacct destroy
Date: Thu, 18 Aug 2016 00:37:41 +0200
Message-ID: <20160817223741.GA5476@salvia>
References: <1471101182-15294-1-git-send-email-zlpnobody@163.com>
 <20160817222634.GA2798@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50658 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbcHQWpB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 18:45:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AC3B4E8E8D
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:37:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8CD9A1B3237
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:37:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1CEDA1B3329
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:37:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160817222634.GA2798@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 18, 2016 at 12:26:34AM +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 13, 2016 at 11:13:01PM +0800, Liping Zhang wrote:
> > From: Liping Zhang <liping.zhang@spreadtrum.com>
> > 
> > Suppose that we input the following commands at first:
> >   # nfacct add test
> >   # iptables -A INPUT -m nfacct --nfacct-name test
> > 
> > And now "test" acct's refcnt is 2, but later when we try to delete the
> > "test" nfacct and the related iptables rule at the same time, race maybe
> > happen:
> >       CPU0                                    CPU1
> >   nfnl_acct_try_del                      nfnl_acct_put
> >   atomic_dec_and_test //ref=1,testfail          -
> >        -                                 atomic_dec_and_test //ref=0,testok
> >        -                                 kfree_rcu
> >   atomic_inc //ref=1                            -
> > 
> > So after the rcu grace period, nf_acct will be freed but it is still linked
> > in the nfnl_acct_list, and we can access it later, then oops will happen.
> > 
> > Convert atomic_dec_and_test and atomic_inc combinaiton to one atomic
> > operation atomic_cmpxchg here to fix this problem.
> 
> Applied, thanks.

Wait. I noticed we have the same problem in cttimeout, so it would be
good to fix this in the same logical change.

I'm attaching your original patch that I have mangled here, including
the cttimeout chunk.

Let me know if you have any concern, otherwise I'll apply this new
version, thanks!

--2oS5YaxWCcQjTEyO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nfnetlink-fix-race-between-netlink-deletio.patch"

>From b6651665ee7c533bfe4a10060dcd9aee92c80cf6 Mon Sep 17 00:00:00 2001
From: Liping Zhang <liping.zhang@spreadtrum.com>
Date: Sat, 13 Aug 2016 23:13:01 +0800
Subject: [PATCH] netfilter: nfnetlink: fix race between netlink deletion and
 refcnt put via xtables

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_acct.c      | 8 ++++----
 net/netfilter/nfnetlink_cttimeout.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 1b4de4b..54c7d5b 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -326,14 +326,14 @@ static int nfnl_acct_try_del(struct nf_acct *cur)
 {
 	int ret = 0;
 
-	/* we want to avoid races with nfnl_acct_find_get. */
-	if (atomic_dec_and_test(&cur->refcnt)) {
+	/* We want to avoid races with nfnl_acct_put. So only when the current
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
 	return ret;
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 4cdcd96..77c0178 100644
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
-- 
2.1.4


--2oS5YaxWCcQjTEyO--
