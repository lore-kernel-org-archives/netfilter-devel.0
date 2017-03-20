From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH v2 nf 1/1] netfilter: helper: Fix possible panic caused by
 invoking expectfn unloaded
Date: Mon, 20 Mar 2017 21:22:53 +0800
Message-ID: <CA+6hz4o+z86NzG=83D3B=daHDvAJ6PgdR3dVQbi2DftFsfyB+w@mail.gmail.com>
References: <1489822845-109818-1-git-send-email-fgao@ikuai8.com>
 <20170320104442.GA10855@salvia> <20170320125040.GA12416@salvia>
 <CA+6hz4qHU7M1DtBT_rNwP1EfZuc5_KqZpP3tq2NBZLtMR5Xv0w@mail.gmail.com>
 <20170320131132.GA12981@salvia> <CA+6hz4qKCX13D94r+oK0cvQKmNempBMUoF8CnZ7Ub89oGKYYxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35654 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755156AbdCTNXB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 09:23:01 -0400
Received: by mail-pg0-f66.google.com with SMTP id g2so20007257pge.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 06:23:00 -0700 (PDT)
In-Reply-To: <CA+6hz4qKCX13D94r+oK0cvQKmNempBMUoF8CnZ7Ub89oGKYYxQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 20, 2017 at 9:17 PM, Gao Feng <fgao@ikuai8.com> wrote:
> On Mon, Mar 20, 2017 at 9:11 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Mon, Mar 20, 2017 at 09:06:22PM +0800, Gao Feng wrote:
>>> On Mon, Mar 20, 2017 at 8:50 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> > On Mon, Mar 20, 2017 at 11:44:42AM +0100, Pablo Neira Ayuso wrote:
>>> >> > diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
>>> >> > index 6dc44d9..6c840af 100644
>>> >> > --- a/net/netfilter/nf_conntrack_helper.c
>>> >> > +++ b/net/netfilter/nf_conntrack_helper.c
>>> >> > @@ -130,6 +130,42 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
>>> >> >     return NULL;
>>> >> >  }
>>> >> >
>>> >> > +static void
>>> >> > +nf_ct_remove_expect_refer_dying_module(const struct module *me)
>>> >> > +{
>>> >> > +   struct nf_conntrack_expect *exp;
>>> >> > +   const struct hlist_node *next;
>>> >> > +   u32 i;
>>> >> > +
>>> >> > +   if (!me)
>>> >> > +           return;
>>> >> > +
>>> >> > +   /* Make sure no one is still using the moudule unless
>>> >> > +    * its a connection in the hash.
>>> >> > +    */
>>> >> > +   synchronize_rcu();
>>> >> > +
>>> >> > +   /* Get rid of expectations */
>>> >> > +   spin_lock_bh(&nf_conntrack_expect_lock);
>>> >> > +   for (i = 0; i < nf_ct_expect_hsize; i++) {
>>> >> > +           hlist_for_each_entry_safe(exp, next,
>>> >> > +                                     &nf_ct_expect_hash[i], hnode) {
>>> >> > +                   struct nf_conn_help *master_help = nfct_help(exp->master);
>>> >> > +
>>> >> > +                   if ((master_help->helper && master_help->helper->me == me) ||
>>> >> > +                       (exp->helper && exp->helper->me == me) ||
>>> >> > +                       exp->expectfn_module == me) {
>>> >
>>> > Are you also sure this is correct?
>>> >
>>> > me can be nf_nat_sip, while exp->helper->me points to
>>> > nf_conntrack_sip.
>>>
>>> I don't read the source codes of ctlink command.
>>> But it seems be correct from the kernel codes.
>>>
>>> Please look at the function "ctnetlink_create_expect".
>>>
>>>         if (cda[CTA_EXPECT_HELP_NAME]) {
>>>                 const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
>>>
>>>                 helper = __nf_conntrack_helper_find(helpname, u3,
>>>                                                     nf_ct_protonum(ct));
>>> The helper is got by cda[CTA_EXPECT_HELP_NAME].
>>>
>>> Then go to the function ctnetlink_alloc_expect,
>>>
>>>         if (cda[CTA_EXPECT_FN]) {
>>>                 const char *name = nla_data(cda[CTA_EXPECT_FN]);
>>>                 struct nf_ct_helper_expectfn *expfn;
>>>
>>>                 expfn = nf_ct_helper_expectfn_find_by_name(name);
>>> The expfn is got by cda[CTA_EXPECT_FN].
>>>
>>> So it is possible that the helper and expfn which they belongs to
>>> different modules.
>>
>> ctnetlink is not the only path to create expressions.
>>
>> We can also create expectations from the packet path, from the helper
>> itself.
>
> Thanks, but I know the data path could create expectation from the helper.
> But I want to show the helper and expfn could belongs to different modules.
> So we need to check them when flush expect.
>
> if (master->helper->module == me ||
>     helper->module == me ||
>     expect_module == me)
>
> These three conditions are necessary.
>
> My regards
> Feng

The helper and expfn belong to the same module at the most time.
But it is possible that they belong to different modules.

Regards
Feng
