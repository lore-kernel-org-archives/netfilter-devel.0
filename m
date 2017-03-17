From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: helper: Fix possible panic caused by
 invoking expectfn unloaded
Date: Fri, 17 Mar 2017 14:08:33 +0100
Message-ID: <20170317130833.GA11538@salvia>
References: <1489472766-89568-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbdCQNKG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 09:10:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2A19DED609
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:08:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B22FDA877
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:08:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 320F5DA848
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 14:08:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489472766-89568-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 02:26:06PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The helper module permits the helper modules register expectfn, and
> it could be hold by external caller. But when the module is unloaded,
> there may be some pending expect nodes which still hold the function
> reference. It may cause unexpected behavior, even panic.
> 
> Now it would delete the expect nodes which uses the expectfn when
> unregister expectfn. And it must use the rcu_read_lock to protect
> the expectfn until insert it or doesn't access it ever.
> 
> There is only one caller which doesn't hold the rcu lock now.
> It is ctnetlink_create_expect.
> 
> BTW, nf_ct_helper_expectfn_find_by_name/symbol invokes the rcu lock
> to protect the lookup. But it is not enough, because it returns the
> nf_ct_helper_expectfn pointer which should be protected by rcu lock.
> Actually the caller should hold the rcu lock instead of these funcs.
> I will refine it in the cleanup patch.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_conntrack_helper.c  | 23 +++++++++++++++++++++++
>  net/netfilter/nf_conntrack_netlink.c |  3 +++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 6dc44d9..2be820b 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -305,9 +305,32 @@ void nf_ct_helper_expectfn_register(struct nf_ct_helper_expectfn *n)
>  
>  void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
>  {
> +	struct nf_conntrack_expect *exp;
> +	const struct hlist_node *next;
> +	u32 i;
> +
>  	spin_lock_bh(&nf_conntrack_expect_lock);
>  	list_del_rcu(&n->head);
>  	spin_unlock_bh(&nf_conntrack_expect_lock);
> +
> +	/* Make sure everyone who holds the expect func already
> +	 * has inserted it
> +	 */
> +	synchronize_rcu();
> +
> +	/* Get rid of expectations used the dying expectfn */
> +	spin_lock_bh(&nf_conntrack_expect_lock);
> +	for (i = 0; i < nf_ct_expect_hsize; i++) {
> +		hlist_for_each_entry_safe(exp, next,
> +					  &nf_ct_expect_hash[i], hnode) {
> +			if (exp->expectfn == n->expectfn &&
> +			    del_timer(&exp->timeout)) {
> +				nf_ct_unlink_expect(exp);
> +				nf_ct_expect_put(exp);
> +			}
> +		}
> +	}

Hm. So the problem is when, eg. nf_nat_sip, gets removed via rmmod.

I think we should do very similar as it happens in
nf_conntrack_helper_unregister().

Actually not use the exp->expectfn as reference, but:

1) remove any expectation that belong to this helper.
2) remove any conntrack entry, with NAT is place, that belongs to this
   helper.

I would like to see a function that we can call both from
nf_conntrack_helper_unregister() and the exit path (module removal) of
conntrack NAT helpers, so we consolidate the code.

Does this look good to you?
