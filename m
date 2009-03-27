From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] conntrack: ecache: move event cache to conntrack
 extension infrastructure
Date: Fri, 27 Mar 2009 12:37:32 +0100
Message-ID: <49CCBA7C.2090609@netfilter.org>
References: <20090327093822.8259.50902.stgit@Decadence> <20090327094009.8259.64117.stgit@Decadence> <49CCA1DA.7060902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36583 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757467AbZC0LjS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:39:18 -0400
In-Reply-To: <49CCA1DA.7060902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch reworks the event caching infrastructure to use the
>> conntrack extension infrastructure. As a result, you can enable and
>> disable event delivery via /proc/sys/net/netfilter/nf_conntrack_events
>> in runtime opposed to compilation time. The main drawback is that
>> we consume more memory per conntrack if event delivery is enabled.
> 
>>  static inline void
>>  nf_conntrack_event_cache(enum ip_conntrack_events event, struct
>> nf_conn *ct)
>>  {
>> -    struct net *net = nf_ct_net(ct);
>> -    struct nf_conntrack_ecache *ecache;
>> -
>> -    local_bh_disable();
>> -    ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
>> -    if (ct != ecache->ct)
>> -        __nf_ct_event_cache_init(ct);
>> -    ecache->events |= event;
>> -    local_bh_enable();
>> +    spin_lock_bh(&nf_conntrack_lock);
>> +    __nf_conntrack_event_cache(event, ct);
>> +    spin_unlock_bh(&nf_conntrack_lock);
> 
> This defeats all the work we've been doing to make conntrack lockless.
> This needs to be done differenty.
> 
> Generally, I'd say a better approach is to get rid of the notifier
> chain (unnecessary overhead for the single user we have), replace it
> by a function pointer for event delivery and use that as an indication
> that events should be tracked.

I have a fuzzy morning. I get the idea of replacing the notifier chain
by a function pointer but I don't get the idea of the indication.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
