From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/8] [PATCH] deliver events for conntracks created via
 ctnetlink
Date: Sat, 11 Oct 2008 14:05:26 +0200
Message-ID: <48F09686.5060201@netfilter.org>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083506.9824.48734.stgit@Decadence> <48EF593B.30208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43001 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752222AbYJKMFg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Oct 2008 08:05:36 -0400
In-Reply-To: <48EF593B.30208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Looks pretty good, some minor issues:
> 
> - there are quite a lot of trailing whitespaces in this
>   patch, please remove those.

I have added a tweak for vim to remove them automatically when I write
the file, so this should not happen anymore. BTW, does git complain on
this by default when I apply one patch or I have to tweak something?

>> +/* This structure is passed to event handler */
>> +struct nf_ct_event {
>> +    struct nf_conn *ct;
>> +    u32 pid;
>> +    int report;
>> +};
> 
> Just a suggestion: passing the nlmsghdr instead of the ECHO
> flag and doing the approriate handling in the event functions
> seems more logical to me. I think I know why you did it this
> way (no reporting on unload, no netlink context there), see
> below about that.

Indeed.

>> diff --git a/net/netfilter/nf_conntrack_core.c
>> b/net/netfilter/nf_conntrack_core.c
>> index f465090..aab2618 100644
>> --- a/net/netfilter/nf_conntrack_core.c
>> +++ b/net/netfilter/nf_conntrack_core.c
>> @@ -174,7 +174,8 @@ destroy_conntrack(struct nf_conntrack *nfct)
>>      NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
>>      NF_CT_ASSERT(!timer_pending(&ct->timeout));
>>  
>> -    nf_conntrack_event(IPCT_DESTROY, ct);
>> +    if (!test_bit(IPS_DYING_BIT, &ct->status))
>> +        nf_conntrack_event(IPCT_DESTROY, ct);
> 
> Whats the idea behind this change? Is it simply an optimization?

If we remove a conntrack entry via ctnetlink, we get the event report
twice, one from ctnetlink and another one from death_by_timeout, so we
set the dying bit in ctnetlink to avoid this double reporting in
death_by_timeout. This idea is actually yours :)

>>      set_bit(IPS_DYING_BIT, &ct->status);
>>  
>>      /* To make sure we don't get any weird locking issues here:
>> @@ -963,8 +964,24 @@ void nf_ct_iterate_cleanup(struct net *net,
>>  }
>>  EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
>>  
>> +struct __nf_ct_flush_report {
>> +    u32 pid;
>> +    int report;
>> +};
>> +
>>  static int kill_all(struct nf_conn *i, void *data)
>>  {
>> +    struct __nf_ct_flush_report *fr = (struct __nf_ct_flush_report
>> *)data;
>> +
>> +    if (!fr->report)
>> +        return 1;
> 
> Whats the reasoning behind not reporting destroy events on unload?
> I don't think there's anything special about module unload, so it
> seems inconsistent.

OK, I'll fix this. I'm going to prepare another patch round to cover
this issues.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
