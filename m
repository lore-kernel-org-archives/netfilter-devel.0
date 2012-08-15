From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_ct_expect: fix possible access to
 uninitialized timer
Date: Wed, 15 Aug 2012 03:25:39 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1208150304530.2602@stinky-local.trash.net>
References: <1344991422-2514-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52357 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab2HOBZl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:25:41 -0400
In-Reply-To: <1344991422-2514-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 15 Aug 2012, pablo@netfilter.org wrote:

> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> In __nf_ct_expect_check, the function refresh_timer returns 1
> if a matching expectation is found and its timer is successfully
> refreshed. This results in nf_ct_expect_related returning 0.
> Note that at this point:
>
> - the passed expectation is not inserted in the expectation table
>  and its timer was not initialized, since we have refreshed one
>  matching/existing expectation.
>
> - nf_ct_expect_alloc uses kmem_cache_alloc, so the expectation
>  timer is in some undefined state just after the allocation,
>  until it is appropriately initialized.
>
> This can be a problem for the SIP helper during the expectation
> addition:
>
> ...
> if (nf_ct_expect_related(rtp_exp) == 0) {
>         if (nf_ct_expect_related(rtcp_exp) != 0)
>                 nf_ct_unexpect_related(rtp_exp);
> ...
>
> Note that nf_ct_expect_related(rtp_exp) may return 0 for the timer refresh
> case that is detailed above. Then, if nf_ct_unexpect_related(rtcp_exp)
> returns != 0, nf_ct_unexpect_related(rtp_exp) is called, which does:
>
> spin_lock_bh(&nf_conntrack_lock);
> if (del_timer(&exp->timeout)) {
>         nf_ct_unlink_expect(exp);
>         nf_ct_expect_put(exp);
> }
> spin_unlock_bh(&nf_conntrack_lock);
>
> Note that del_timer always returns false if the timer has been
> initialized.  However, the timer was not initialized since setup_timer
> was not called, therefore, the expectation timer remains in some
> undefined state. If I'm not missing anything, this may lead to the
> removal an unexistent expectation.
>
> I think this can be the source of the problem described by:
> http://marc.info/?l=netfilter-devel&m=134073514719421&w=2

OK, so we assume del_timer returned success since otherwise this
would have no effect. This means that detach_timer() was called
and does a

__list_del(entry->prev, entry->next);
entry->prev = LIST_POISON2;

If the expectation from the slab was just uninitialized memory, it
would very likely crash in __list_del(). But even if the memory was 
reused, it would still crash since entry->prev would be set to
LIST_POISON2.

The same applies to the hlist_del/hlist_del_rcu calls in
nf_ct_unlink_expect_report().

So you fix a real bug, but I don't see how it can explain that report.

> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 45cf602..b16e70d 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -436,6 +436,13 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
> {
> 	int ret;
>
> +	/* Make sure that nf_ct_unexpect_related always gets an initialized
> +	 * timer for the case in which one matching expectation is refreshed
> +	 * (and thus, this expectation is not inserted).
> +	 */
> +	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
> +		    (unsigned long)exp);
> +

We're setting the timer up twice now. I'd suggest to just do it once,
either in nf_ct_expect_alloc() or nf_ct_expect_init().

Once question remains though - if the scenario you describe happens and
we're just refreshing an existing expectation, should that one actually
get unexpected by the nf_ct_unexpect_related() call?

The intention is to remove the expectation with that tuple, the refreshing
is just an optimization, so I think that would make sense.

> 	spin_lock_bh(&nf_conntrack_lock);
> 	ret = __nf_ct_expect_check(expect);
> 	if (ret <= 0)
> -- 
> 1.7.10.4
>
