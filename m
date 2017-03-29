From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf v4 2/2] netfilter: helper: Fix possible panic caused by invoking expectfn unloaded
Date: Wed, 29 Mar 2017 20:19:17 +0800
Message-ID: <000401d2a886$b035b700$10a12500$@foxmail.com>
References: <cover.1490143843.git.fgao@ikuai8.com> <031fb2df905062385d3eb887696fd6d9b87b7db6.1490143843.git.fgao@ikuai8.com> <20170329095345.GA3533@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, "'Gao Feng'" <fgao@ikuai8.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:56264 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755855AbdC2MTX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 08:19:23 -0400
In-Reply-To: <20170329095345.GA3533@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org
> [mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Pablo Neira
Ayuso
> Sent: Wednesday, March 29, 2017 5:54 PM
> To: gfree.wind@foxmail.com
> Cc: netfilter-devel@vger.kernel.org; Gao Feng <fgao@ikuai8.com>
> Subject: Re: [PATCH nf v4 2/2] netfilter: helper: Fix possible panic
caused by
> invoking expectfn unloaded
> 
> Hi Feng,
> 
> Still two concerns with this.
> 
> On Wed, Mar 22, 2017 at 09:03:24AM +0800, gfree.wind@foxmail.com wrote:
> > diff --git a/net/netfilter/nf_conntrack_helper.c
> > b/net/netfilter/nf_conntrack_helper.c
> > index 0eaa01e..c25c9be 100644
> > --- a/net/netfilter/nf_conntrack_helper.c
> > +++ b/net/netfilter/nf_conntrack_helper.c
> > @@ -130,6 +130,42 @@ static unsigned int helper_hash(const struct
> nf_conntrack_tuple *tuple)
> >  	return NULL;
> >  }
> >
> > +static void
> > +nf_ct_flush_expect(const struct module *me) {
> > +	struct nf_conntrack_expect *exp;
> > +	const struct hlist_node *next;
> > +	u32 i;
> > +
> > +	if (!me)
> > +		return;
> > +
> > +	/* Make sure no one is still using the module unless
> > +	 * its a connection in the hash.
> > +	 */
> > +	synchronize_rcu();
> 
> I think it's more readable if you keep this synchronize_rcu() call in
> nf_conntrack_helper_unregister() and nf_ct_nat_helper_unregister()
> respectively, before calling nf_ct_flush_expect().
> 
> See below more reasons for this change I'm requesting at the end of this
email.
> 
> > +	/* Get rid of expectations */
> > +	spin_lock_bh(&nf_conntrack_expect_lock);
> > +	for (i = 0; i < nf_ct_expect_hsize; i++) {
> > +		hlist_for_each_entry_safe(exp, next,
> > +					  &nf_ct_expect_hash[i], hnode) {
> > +			struct nf_conn_help *master_help =
nfct_help(exp->master);
> > +
> > +			if ((master_help->helper && master_help->helper->me
== me) ||
> 
> There used to be a rcu_dereference_protected() here to fetch
> help->helper that now is gone.

I have one question about it.
We have hold the nf_conntrack_expect_lock here, so still need the
rcu_dereference_protected?

> 
> > +			    (exp->helper && exp->helper->me == me) ||
> 
> Can we really have exp->helper set to NULL or you're just being defensive
here?
> I think all expectations are guaranteed to have a
> exp->helper.
When the expect is created by ctlink, the expectfn is valid with helper is
NULL according to the ctnetlink_alloc_expect.
So I add this check.

> 
> > +			     exp->nat_module == me) {
> > +				/* This expect belongs to the dying module
*/
> > +				if (del_timer(&exp->timeout)) {
> > +					nf_ct_unlink_expect(exp);
> > +					nf_ct_expect_put(exp);
> > +				}
> > +			}
> > +		}
> > +	}
> > +	spin_unlock_bh(&nf_conntrack_expect_lock);
> > +}
> > +
> >  struct nf_conntrack_helper *
> >  __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
> > {
> [...]
> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > index eae9bec..f337208 100644
> > --- a/net/netfilter/nf_nat_core.c
> > +++ b/net/netfilter/nf_nat_core.c
> > @@ -850,6 +850,7 @@ static void __net_exit nf_nat_net_exit(struct net
> > *net)
> >
> >  static struct nf_ct_nat_helper follow_master_nat = {
> >  	.name		= "nat-follow-master",
> > +	.me		= THIS_MODULE,
> 
> Look, this follow_master_nat structure belongs to nf_nat_core. I think
> expectations using this will not suffer from the problem you describe in
this
> patch, given expectfn() will still be there.
> 
> However, with your patch I think two different helpers using
nat-follow-master
> will get both of their expectations removed if one their nat modules is
remove
> given that:
> 
>         exp->nat_module == me
> 
> will stand true since THIS_MODULE points to nf_nat core module for
> nat-follow-master.
> 
> You mentioned another problem here that is: We currently allow to set
> *any* expectfn to expectation and that is wrong. I think we need to extend
this
> nf_ct_nat_helper structure to make it look like:
> 
> static struct nf_ct_nat_helper irc_nat = {
>         .name           = "irc",
>         .expectfn	= "nat-follow-master", /* this used to be .name
before */
>         .me		= THIS_MODULE,
> };
> 
> So we register one of this nf_ct_nat_helper structures per module.
> Thus, we have a 1:1 mapping between nf_ct_nat_helper structure and
> modules that we need to:
> 
> 1) Fix this problem you describe in this patch.
> 2) Don't allow setting expectfn of h323 to a irc expectation using
>    ctnetlink.
> 
> I suggest you send revamp this batch with patches to:
> 
> 1) Rename nf_ct_helper_expectfn to nf_ct_nat_helper, no changes there
>    just like your v4 1/2.
> 2) Register one nf_ct_nat_helper structure per NAT helper module.
>    Validate from ctnetlink that we don't attach the wrong expectfn to
>    the expectation we create there. This would be a new patch that
>    introduces the 1:1 mapping between NAT modules and struct
>    nf_ct_nat_helper.
> 3) Fix possible panic caused by removing NAT module (I'm refering to this
>    patch 2/2). Now that we have the 1:1 mapping, we don't accidentally
>    remove expectations that use nat-follow-master.

Ok, I would implement this solution.

Best Regards
Feng

> 
> Let me know,
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html



