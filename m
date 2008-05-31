From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] deliver events for conntracks created/updated via
 ctnetlink
Date: Sat, 31 May 2008 19:11:13 +0200
Message-ID: <484186B1.80200@netfilter.org>
References: <483350D9.7010809@netfilter.org> <48335339.2050007@netfilter.org> <48340BFA.2030307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54856 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751352AbYEaRLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 May 2008 13:11:19 -0400
In-Reply-To: <48340BFA.2030307@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Sorry for the delay, I couldn't manage to reply before.

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Pablo Neira Ayuso wrote:
>>> As for now, the creation and update of conntracks via ctnetlink do not
>>> propagate an event to userspace. This can result in inconsistent
>>> situations if several userspace processes modify the connection tracking
>>> table by means of ctnetlink at the same time. Specifically, using the
>>> conntrack-cli while running an instance of conntrackde unsynchronizes
>>> the cache of conntrackd with the kernel conntrack table. Note that
>>> deletions do not suffer from this problem.
>>>
> 
> Thanks for working on this. I have a couple of comments/questions
> about the patch:
> 
>> @@ -529,6 +529,11 @@ nla_put_failure:
>>      kfree_skb(skb);
>>      return NOTIFY_DONE;
>>  }
>> +
>> +static struct notifier_block ctnl_notifier = {
>> +    .notifier_call    = ctnetlink_conntrack_event,
>> +};
> 
> Why are the notifier blocks moved? It doesn't look necessary
> for this patch.

I moved it there because of it is the first parameter of
ctnetlink_conntrack_event() in ctnetlink_create_conntrack() and
ctnetlink_new_conntrack(). However, we can just pass NULL as it is not used.

>>  static int
>> -ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
>> +ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[], int
>> *events)
>>  {
>>      unsigned long d;
>>      unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
>> @@ -930,12 +935,15 @@ ctnetlink_change_status(struct nf_conn *
>>       * so don't let users modify them directly if they don't pass
>>       * nf_nat_range. */
>>      ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
>> +
>> +    *events |= IPCT_STATUS;
> 
> I have some doubts whether we should really do this by
> keeping track of the events outside of the cache.
> 
> Some changes are not performed manually, but by calling NAT
> and conntrack functions, like nf_nat_setup_info(). These
> might cache events for the conntrack, which will cause the
> events to be delivered again some (unknown) time later.
> For now things look fine, but for example nf_nat_setup_info()
> should really cache the NAT event instead of
> nf_conntrack_confirm(), at which point the above would happen.

I forgot about the internal call of event_cache inside nf_setup_info().
Well, my intention was to avoid doubled event notification that may
arise if an interruption preempts an user process walking in the
ctnetlink bits. However, as for now, the double notification may also
occur if a local process sends a packet that triggers a conntrack event.

> This makes me think that ctnetlink should simply use the
> normal event caching functions and trigger delivery once
> its done.

I agree, thinking it well, the double notification that I was trying to
avoid seems unlikely to happen.

>> +        spin_unlock_bh(&nf_conntrack_lock);
>> +
>> +        if (err == 0) {
>> +            atomic_inc(&ct->ct_general.use);
>> +            ctnetlink_conntrack_event(&ctnl_notifier, &events, ct);
>> +            nf_ct_put(ct);
>> +        }
> 
> This doesn't look right. The conntrack might already be gone,
> no?

Indeed. I'll fix it.

> One final thing: event messages generated after changes requested
> by userspace should include the pid of the requesting socket
> in nlmsg_pid. If a unicast report is requested, the socket should
> be excluded from receiving the multicast message again.
> 
> Check out nlmsg_notify() and nlmsg_report() for reference.

I'll have a look at those. I'll send you another patch this week.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
