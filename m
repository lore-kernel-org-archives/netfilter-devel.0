From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf 1/1] netfilter: helper: Fix possible panic caused
 by invoking expectfn unloaded
Date: Mon, 20 Mar 2017 11:44:42 +0100
Message-ID: <20170320104442.GA10855@salvia>
References: <1489822845-109818-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753485AbdCTKoy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 06:44:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F0732462B
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:44:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B20DDA848
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:44:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9838DA3AA
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:44:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489822845-109818-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 18, 2017 at 03:40:45PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The helper module could register one helper expectfn by the function
> nf_ct_helper_expectfn_register. When the module is unloaded, it invokes
> the nf_ct_helper_expectfn_unregister to unregister the expectfn. But
> it doesn't remove the expectations which refer to this expectfn. Then
> there is one possible use-after-free issue.
> 
> Because ctnetlink_alloc_expect could create one expecatation whose
> helper and expectfn belong to different modules. So I bring one
> new member expectfn_module in nf_conntrack_expect. Then when unload
> one helper module, we could remove all expectation whose helper or
> expectfn belong to this module.

This looks fine. However, I would clarify here that the problem is
that the conntrack NAT module can be rmmod anytime, so we should
really leave things in clean state if such thing happens and make sure
we don't leave any packet running over code that will be gone after
the removal, ie. the correspoding expectfn may be gone.

Comments below.

> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v2: Create one new function to remove expectations, per Pablo
>  v1: Initial version
> 
>  include/net/netfilter/nf_conntrack_expect.h |  2 +
>  include/net/netfilter/nf_conntrack_helper.h |  1 +
>  net/ipv4/netfilter/nf_nat_h323.c            |  2 +
>  net/netfilter/nf_conntrack_broadcast.c      |  1 +
>  net/netfilter/nf_conntrack_expect.c         |  1 +
>  net/netfilter/nf_conntrack_helper.c         | 63 ++++++++++++++++++-----------
>  net/netfilter/nf_conntrack_netlink.c        |  5 ++-
>  net/netfilter/nf_nat_core.c                 |  1 +
>  net/netfilter/nf_nat_sip.c                  |  1 +
>  9 files changed, 52 insertions(+), 25 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
> index 5ed33ea..76e2858 100644
> --- a/include/net/netfilter/nf_conntrack_expect.h
> +++ b/include/net/netfilter/nf_conntrack_expect.h
> @@ -26,6 +26,8 @@ struct nf_conntrack_expect {
>  	/* Function to call after setup and insertion */
>  	void (*expectfn)(struct nf_conn *new,
>  			 struct nf_conntrack_expect *this);
> +	/* The moudule which expectfn belongs to */

Typo here: 'moudule', instead 'module'.

> +	struct module *expectfn_module;

Please, rename this to nat_module instead, see below why.

>  	/* Helper to assign to new connection */
>  	struct nf_conntrack_helper *helper;
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 1eaac1f..c4d88d4 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -114,6 +114,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb, unsigned int protoff,
>  struct nf_ct_helper_expectfn {

Could you rename nf_ct_helper_expectfn to nf_ct_nat_helper? You have
to do this in an initial patch, so these will result in a series of
two patches: One to rename, and another for this fix.

Look, now this structure provides a description of the ct NAT helper,
not just the expectfn.

Sorry if I look picky, but I would look the structure name shows the
right semantics when reading this code.

>  	struct list_head head;
>  	const char *name;
> +	struct module *me;
>  	void (*expectfn)(struct nf_conn *ct, struct nf_conntrack_expect *exp);
>  };
>  
> diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
> index 574f7eb..a5fa8de 100644
> --- a/net/ipv4/netfilter/nf_nat_h323.c
> +++ b/net/ipv4/netfilter/nf_nat_h323.c
> @@ -569,11 +569,13 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
>  
>  static struct nf_ct_helper_expectfn q931_nat = {
>  	.name		= "Q.931",
> +	.me		= THIS_MODULE,
>  	.expectfn	= ip_nat_q931_expect,
>  };
>  
>  static struct nf_ct_helper_expectfn callforwarding_nat = {
>  	.name		= "callforwarding",
> +	.me		= THIS_MODULE,
>  	.expectfn	= ip_nat_callforwarding_expect,
>  };
>  
> diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
> index 4e99cca..edce551 100644
> --- a/net/netfilter/nf_conntrack_broadcast.c
> +++ b/net/netfilter/nf_conntrack_broadcast.c
> @@ -66,6 +66,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
>  	exp->mask.src.u.udp.port  = htons(0xFFFF);
>  
>  	exp->expectfn             = NULL;
> +	exp->expectfn_module      = NULL;
>  	exp->flags                = NF_CT_EXPECT_PERMANENT;
>  	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
>  	exp->helper               = NULL;
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 4b2e1fb..1e58a0e 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -296,6 +296,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
>  	exp->flags = 0;
>  	exp->class = class;
>  	exp->expectfn = NULL;
> +	exp->expectfn_module = NULL;
>  	exp->helper = NULL;
>  	exp->tuple.src.l3num = family;
>  	exp->tuple.dst.protonum = proto;
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 6dc44d9..6c840af 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -130,6 +130,42 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
>  	return NULL;
>  }
>  
> +static void
> +nf_ct_remove_expect_refer_dying_module(const struct module *me)
> +{
> +	struct nf_conntrack_expect *exp;
> +	const struct hlist_node *next;
> +	u32 i;
> +
> +	if (!me)
> +		return;
> +
> +	/* Make sure no one is still using the moudule unless
> +	 * its a connection in the hash.
> +	 */
> +	synchronize_rcu();
> +
> +	/* Get rid of expectations */
> +	spin_lock_bh(&nf_conntrack_expect_lock);
> +	for (i = 0; i < nf_ct_expect_hsize; i++) {
> +		hlist_for_each_entry_safe(exp, next,
> +					  &nf_ct_expect_hash[i], hnode) {
> +			struct nf_conn_help *master_help = nfct_help(exp->master);
> +
> +			if ((master_help->helper && master_help->helper->me == me) ||
> +			    (exp->helper && exp->helper->me == me) ||
> +			    exp->expectfn_module == me) {
> +				/* This expect belongs to the dying module */
> +				if (del_timer(&exp->timeout)) {
> +					nf_ct_unlink_expect(exp);
> +					nf_ct_expect_put(exp);
> +				}
> +			}
> +		}
> +	}
> +	spin_unlock_bh(&nf_conntrack_expect_lock);
> +}
> +
>  struct nf_conntrack_helper *
>  __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
>  {
> @@ -308,6 +344,8 @@ void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
>  	spin_lock_bh(&nf_conntrack_expect_lock);
>  	list_del_rcu(&n->head);
>  	spin_unlock_bh(&nf_conntrack_expect_lock);
> +
> +	nf_ct_remove_expect_refer_dying_module(n->me);

Shorter name? eg. nf_ct_flush_expect()
