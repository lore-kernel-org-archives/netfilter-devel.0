From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_expect: fix possible access to
 uninitialized timer
Date: Thu, 16 Aug 2012 03:17:23 +0200
Message-ID: <20120816011723.GA15129@1984>
References: <1344991422-2514-1-git-send-email-pablo@netfilter.org>
 <Pine.GSO.4.63.1208150304530.2602@stinky-local.trash.net>
 <20120815171413.GA14637@1984>
 <Pine.GSO.4.63.1208160114300.14109@stinky-local.trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40721 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab2HPBR1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:17:27 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.63.1208160114300.14109@stinky-local.trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 16, 2012 at 01:15:24AM +0200, Patrick McHardy wrote:
[...]
> >>Once question remains though - if the scenario you describe happens and
> >>we're just refreshing an existing expectation, should that one actually
> >>get unexpected by the nf_ct_unexpect_related() call?
> >>
> >>The intention is to remove the expectation with that tuple, the refreshing
> >>is just an optimization, so I think that would make sense.
> >
> >Yes, that's another possibility that look better to me as the expect
> >object would be always inserted.
> 
> So we'd just remove the refreshing, kill the old expectation and insert
> the new one instead?

Agreed. Patch attached.

--nFreZHaLTZJo0R7j
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_ct_expect-fix-possible-access-to-uninit.patch"

>From 0da8a43757cff23beb37d92789860f67321a252b Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 16 Aug 2012 02:25:24 +0200
Subject: [PATCH] netfilter: nf_ct_expect: fix possible access to
 uninitialized timer

In __nf_ct_expect_check, the function refresh_timer returns 1
if a matching expectation is found and its timer is successfully
refreshed. This results in nf_ct_expect_related returning 0.
Note that at this point:

- the passed expectation is not inserted in the expectation table
  and its timer was not initialized, since we have refreshed one
  matching/existing expectation.

- nf_ct_expect_alloc uses kmem_cache_alloc, so the expectation
  timer is in some undefined state just after the allocation,
  until it is appropriately initialized.

This can be a problem for the SIP helper during the expectation
addition:

 ...
 if (nf_ct_expect_related(rtp_exp) == 0) {
         if (nf_ct_expect_related(rtcp_exp) != 0)
                 nf_ct_unexpect_related(rtp_exp);
 ...

Note that nf_ct_expect_related(rtp_exp) may return 0 for the timer refresh
case that is detailed above. Then, if nf_ct_unexpect_related(rtcp_exp)
returns != 0, nf_ct_unexpect_related(rtp_exp) is called, which does:

 spin_lock_bh(&nf_conntrack_lock);
 if (del_timer(&exp->timeout)) {
         nf_ct_unlink_expect(exp);
         nf_ct_expect_put(exp);
 }
 spin_unlock_bh(&nf_conntrack_lock);

Note that del_timer always returns false if the timer has been
initialized.  However, the timer was not initialized since setup_timer
was not called, therefore, the expectation timer remains in some
undefined state. If I'm not missing anything, this may lead to the
removal an unexistent expectation.

To fix this, the optimization that allows refreshing an expectation
is removed. Now nf_conntrack_expect_related looks more consistent
to me since it always add the expectation in case that it returns
success.

Thanks to Patrick McHardy for participating in the discussion of
this patch.

I think this may be the source of the problem described by:
http://marc.info/?l=netfilter-devel&m=134073514719421&w=2

Reported-by: Rafal Fitt <rafalf@aplusc.com.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c |   29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 45cf602..527651a 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -361,23 +361,6 @@ static void evict_oldest_expect(struct nf_conn *master,
 	}
 }
 
-static inline int refresh_timer(struct nf_conntrack_expect *i)
-{
-	struct nf_conn_help *master_help = nfct_help(i->master);
-	const struct nf_conntrack_expect_policy *p;
-
-	if (!del_timer(&i->timeout))
-		return 0;
-
-	p = &rcu_dereference_protected(
-		master_help->helper,
-		lockdep_is_held(&nf_conntrack_lock)
-		)->expect_policy[i->class];
-	i->timeout.expires = jiffies + p->timeout * HZ;
-	add_timer(&i->timeout);
-	return 1;
-}
-
 static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 {
 	const struct nf_conntrack_expect_policy *p;
@@ -386,7 +369,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	struct nf_conn_help *master_help = nfct_help(master);
 	struct nf_conntrack_helper *helper;
 	struct net *net = nf_ct_exp_net(expect);
-	struct hlist_node *n;
+	struct hlist_node *n, *next;
 	unsigned int h;
 	int ret = 1;
 
@@ -395,12 +378,12 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 		goto out;
 	}
 	h = nf_ct_expect_dst_hash(&expect->tuple);
-	hlist_for_each_entry(i, n, &net->ct.expect_hash[h], hnode) {
+	hlist_for_each_entry_safe(i, n, next, &net->ct.expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
-			/* Refresh timer: if it's dying, ignore.. */
-			if (refresh_timer(i)) {
-				ret = 0;
-				goto out;
+			if (del_timer(&i->timeout)) {
+				nf_ct_unlink_expect(i);
+				nf_ct_expect_put(i);
+				break;
 			}
 		} else if (expect_clash(i, expect)) {
 			ret = -EBUSY;
-- 
1.7.10.4


--nFreZHaLTZJo0R7j--
