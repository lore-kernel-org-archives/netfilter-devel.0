From: Gao Feng <fgao@ikuai8.com>
Subject: Re: [PATCH nf 1/1] netfilter: helper: Fix possible panic caused by
 invoking expectfn unloaded
Date: Fri, 17 Mar 2017 22:09:29 +0800
Message-ID: <CA+6hz4qc3TW+NzeiXZi7GSXLd1QHtTpTv4Ama8ksp8YGsfKiZA@mail.gmail.com>
References: <1489472766-89568-1-git-send-email-fgao@ikuai8.com> <20170317130833.GA11538@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpproxy19.qq.com ([184.105.206.84]:44803 "EHLO
        smtpproxy19.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdCQOJh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 10:09:37 -0400
Received: from mail-pf0-f178.google.com (unknown [209.85.192.178])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 22:09:31 +0800 (CST)
Received: by mail-pf0-f178.google.com with SMTP id p189so17200576pfp.1
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 07:09:31 -0700 (PDT)
In-Reply-To: <20170317130833.GA11538@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, Mar 17, 2017 at 9:08 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 14, 2017 at 02:26:06PM +0800, fgao@ikuai8.com wrote:
>> From: Gao Feng <fgao@ikuai8.com>
>>
>> The helper module permits the helper modules register expectfn, and
>> it could be hold by external caller. But when the module is unloaded,
>> there may be some pending expect nodes which still hold the function
>> reference. It may cause unexpected behavior, even panic.
>>
>> Now it would delete the expect nodes which uses the expectfn when
>> unregister expectfn. And it must use the rcu_read_lock to protect
>> the expectfn until insert it or doesn't access it ever.
>>
>> There is only one caller which doesn't hold the rcu lock now.
>> It is ctnetlink_create_expect.
>>
>> BTW, nf_ct_helper_expectfn_find_by_name/symbol invokes the rcu lock
>> to protect the lookup. But it is not enough, because it returns the
>> nf_ct_helper_expectfn pointer which should be protected by rcu lock.
>> Actually the caller should hold the rcu lock instead of these funcs.
>> I will refine it in the cleanup patch.
>>
>> Signed-off-by: Gao Feng <fgao@ikuai8.com>
>> ---
>>  net/netfilter/nf_conntrack_helper.c  | 23 +++++++++++++++++++++++
>>  net/netfilter/nf_conntrack_netlink.c |  3 +++
>>  2 files changed, 26 insertions(+)
>>
>> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
>> index 6dc44d9..2be820b 100644
>> --- a/net/netfilter/nf_conntrack_helper.c
>> +++ b/net/netfilter/nf_conntrack_helper.c
>> @@ -305,9 +305,32 @@ void nf_ct_helper_expectfn_register(struct nf_ct_helper_expectfn *n)
>>
>>  void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
>>  {
>> +     struct nf_conntrack_expect *exp;
>> +     const struct hlist_node *next;
>> +     u32 i;
>> +
>>       spin_lock_bh(&nf_conntrack_expect_lock);
>>       list_del_rcu(&n->head);
>>       spin_unlock_bh(&nf_conntrack_expect_lock);
>> +
>> +     /* Make sure everyone who holds the expect func already
>> +      * has inserted it
>> +      */
>> +     synchronize_rcu();
>> +
>> +     /* Get rid of expectations used the dying expectfn */
>> +     spin_lock_bh(&nf_conntrack_expect_lock);
>> +     for (i = 0; i < nf_ct_expect_hsize; i++) {
>> +             hlist_for_each_entry_safe(exp, next,
>> +                                       &nf_ct_expect_hash[i], hnode) {
>> +                     if (exp->expectfn == n->expectfn &&
>> +                         del_timer(&exp->timeout)) {
>> +                             nf_ct_unlink_expect(exp);
>> +                             nf_ct_expect_put(exp);
>> +                     }
>> +             }
>> +     }
>
> Hm. So the problem is when, eg. nf_nat_sip, gets removed via rmmod.
>
> I think we should do very similar as it happens in
> nf_conntrack_helper_unregister().
>
> Actually not use the exp->expectfn as reference, but:
>
> 1) remove any expectation that belong to this helper.
> 2) remove any conntrack entry, with NAT is place, that belongs to this
>    helper.
>
> I would like to see a function that we can call both from
> nf_conntrack_helper_unregister() and the exit path (module removal) of
> conntrack NAT helpers, so we consolidate the code.
>
> Does this look good to you?

It is good to use one function to deal with the
nf_conntrack_helper_unregister and nf_ct_helper_expectfn_unregister.

But there is one problem for nf_ct_helper_expectfn_unregister.
Let's look at the caller ctnetlink_alloc_expect, it only saves expectfn pointer.
And there is no any relation between the exp->expectfn and
exp->helper, because they could be specified by different nlattr data.
For example, the helper name could be "pptp", while the expectfn could
be "sip". Actually they are different helper modules.
Even though it is valid that the exp->help is NULL, because ctlink
accepts that the cda[CTA_EXPECT_HELP_NAME] is NULL.

So I think it could not use the helper as the identifier when remove
the expectations in nf_ct_helper_expectfn_unregister. Unless we
introduce another member in expectation to save which module it
belongs to.

Best Regards
Feng


