From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/8] [PATCH] deliver events for conntracks created via
 ctnetlink
Date: Sat, 11 Oct 2008 16:53:21 +0200
Message-ID: <48F0BDE1.7040409@trash.net>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083506.9824.48734.stgit@Decadence> <48EF593B.30208@trash.net> <48F09686.5060201@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51753 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbYJKOxZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:53:25 -0400
In-Reply-To: <48F09686.5060201@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Looks pretty good, some minor issues:
>>
>> - there are quite a lot of trailing whitespaces in this
>>   patch, please remove those.
> 
> I have added a tweak for vim to remove them automatically when I write
> the file, so this should not happen anymore. BTW, does git complain on
> this by default when I apply one patch or I have to tweak something?

I think it only does when importing a patch, not when doing commits.

>>> +/* This structure is passed to event handler */
>>> +struct nf_ct_event {
>>> +    struct nf_conn *ct;
>>> +    u32 pid;
>>> +    int report;
>>> +};
>> Just a suggestion: passing the nlmsghdr instead of the ECHO
>> flag and doing the approriate handling in the event functions
>> seems more logical to me. I think I know why you did it this
>> way (no reporting on unload, no netlink context there), see
>> below about that.
> 
> Indeed.
> 
>>> diff --git a/net/netfilter/nf_conntrack_core.c
>>> b/net/netfilter/nf_conntrack_core.c
>>> index f465090..aab2618 100644
>>> --- a/net/netfilter/nf_conntrack_core.c
>>> +++ b/net/netfilter/nf_conntrack_core.c
>>> @@ -174,7 +174,8 @@ destroy_conntrack(struct nf_conntrack *nfct)
>>>      NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
>>>      NF_CT_ASSERT(!timer_pending(&ct->timeout));
>>>  
>>> -    nf_conntrack_event(IPCT_DESTROY, ct);
>>> +    if (!test_bit(IPS_DYING_BIT, &ct->status))
>>> +        nf_conntrack_event(IPCT_DESTROY, ct);
>> Whats the idea behind this change? Is it simply an optimization?
> 
> If we remove a conntrack entry via ctnetlink, we get the event report
> twice, one from ctnetlink and another one from death_by_timeout, so we
> set the dying bit in ctnetlink to avoid this double reporting in
> death_by_timeout. This idea is actually yours :)

I see, thanks for the explanation :)

>>> +    struct __nf_ct_flush_report *fr = (struct __nf_ct_flush_report
>>> *)data;
>>> +
>>> +    if (!fr->report)
>>> +        return 1;
>> Whats the reasoning behind not reporting destroy events on unload?
>> I don't think there's anything special about module unload, so it
>> seems inconsistent.
> 
> OK, I'll fix this. I'm going to prepare another patch round to cover
> this issues.

Unfortunately the networking merge window is closed already.

The NAT decoupling qualifies as a bugfix in my opinion and
we can get that one in, the others unfortunately will have
to wait.


