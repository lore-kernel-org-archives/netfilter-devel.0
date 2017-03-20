From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf 1/1] netfilter: helper: Fix possible panic caused
 by invoking expectfn unloaded
Date: Mon, 20 Mar 2017 14:11:32 +0100
Message-ID: <20170320131132.GA12981@salvia>
References: <1489822845-109818-1-git-send-email-fgao@ikuai8.com>
 <20170320104442.GA10855@salvia>
 <20170320125040.GA12416@salvia>
 <CA+6hz4qHU7M1DtBT_rNwP1EfZuc5_KqZpP3tq2NBZLtMR5Xv0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Gao Feng <fgao@ikuai8.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39778 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753285AbdCTNMm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 09:12:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B9CC96EC7
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 14:11:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8763BDA848
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 14:11:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FC3ADA871
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 14:11:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CA+6hz4qHU7M1DtBT_rNwP1EfZuc5_KqZpP3tq2NBZLtMR5Xv0w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 20, 2017 at 09:06:22PM +0800, Gao Feng wrote:
> On Mon, Mar 20, 2017 at 8:50 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Mar 20, 2017 at 11:44:42AM +0100, Pablo Neira Ayuso wrote:
> >> > diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> >> > index 6dc44d9..6c840af 100644
> >> > --- a/net/netfilter/nf_conntrack_helper.c
> >> > +++ b/net/netfilter/nf_conntrack_helper.c
> >> > @@ -130,6 +130,42 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
> >> >     return NULL;
> >> >  }
> >> >
> >> > +static void
> >> > +nf_ct_remove_expect_refer_dying_module(const struct module *me)
> >> > +{
> >> > +   struct nf_conntrack_expect *exp;
> >> > +   const struct hlist_node *next;
> >> > +   u32 i;
> >> > +
> >> > +   if (!me)
> >> > +           return;
> >> > +
> >> > +   /* Make sure no one is still using the moudule unless
> >> > +    * its a connection in the hash.
> >> > +    */
> >> > +   synchronize_rcu();
> >> > +
> >> > +   /* Get rid of expectations */
> >> > +   spin_lock_bh(&nf_conntrack_expect_lock);
> >> > +   for (i = 0; i < nf_ct_expect_hsize; i++) {
> >> > +           hlist_for_each_entry_safe(exp, next,
> >> > +                                     &nf_ct_expect_hash[i], hnode) {
> >> > +                   struct nf_conn_help *master_help = nfct_help(exp->master);
> >> > +
> >> > +                   if ((master_help->helper && master_help->helper->me == me) ||
> >> > +                       (exp->helper && exp->helper->me == me) ||
> >> > +                       exp->expectfn_module == me) {
> >
> > Are you also sure this is correct?
> >
> > me can be nf_nat_sip, while exp->helper->me points to
> > nf_conntrack_sip.
> 
> I don't read the source codes of ctlink command.
> But it seems be correct from the kernel codes.
> 
> Please look at the function "ctnetlink_create_expect".
> 
>         if (cda[CTA_EXPECT_HELP_NAME]) {
>                 const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
> 
>                 helper = __nf_conntrack_helper_find(helpname, u3,
>                                                     nf_ct_protonum(ct));
> The helper is got by cda[CTA_EXPECT_HELP_NAME].
> 
> Then go to the function ctnetlink_alloc_expect,
> 
>         if (cda[CTA_EXPECT_FN]) {
>                 const char *name = nla_data(cda[CTA_EXPECT_FN]);
>                 struct nf_ct_helper_expectfn *expfn;
> 
>                 expfn = nf_ct_helper_expectfn_find_by_name(name);
> The expfn is got by cda[CTA_EXPECT_FN].
> 
> So it is possible that the helper and expfn which they belongs to
> different modules.

ctnetlink is not the only path to create expressions.

We can also create expectations from the packet path, from the helper
itself.
