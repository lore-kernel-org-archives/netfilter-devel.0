From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: conntrack: move event cache to conntrack
 extension infrastructure
Date: Fri, 05 Jun 2009 15:06:43 +0200
Message-ID: <4A291863.4090604@netfilter.org>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110818.6702.51833.stgit@Decadence> <4A28FBCB.4070100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59953 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbZFEMzi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:55:38 -0400
In-Reply-To: <4A28FBCB.4070100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> -/* Connection tracking event bits */
>> +/* Connection tracking event types */
>>  enum ip_conntrack_events
>>  {
>> -    /* New conntrack */
>> -    IPCT_NEW_BIT = 0,
>> -    IPCT_NEW = (1 << IPCT_NEW_BIT),
>> -
>> -...
>> +    IPCT_NEW        = 0,    /* new conntrack */
> 
> Why this change? Further down, you change the code to use
> (1 << IPCT_*), which isn't really an improvement.

Oh, this is not intended to be an improvement. I needed to change this 
to use bitopts operations, that's all. Or I could use IPCT_*_BIT and 
change every reference to this in the whole conntrack table, but the 
patch would be much bigger and noisy :).

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
>> +    struct nf_conntrack_ecache *e;
>> +    struct nf_ct_event_notifier *notify;
>> +
>> +    rcu_read_lock();
>> +    notify = rcu_dereference(nf_conntrack_event_cb);
>> +    if (notify == NULL) {
>> +        rcu_read_unlock();
>> +        return;
>> +    }
>> +    rcu_read_unlock();
> 
> Why the rcu handling? Its not dereferenced, so its not necessary.

I'll remove this.

>> +
>> +    e = nf_ct_ecache_find(ct);
>> +    if (e == NULL)
>> +        return;
>> +
>> +    set_bit(event, &e->cache);
> 
> This looks quite expensive, given how often this operation is performed.
> Did you benchmark this?

I'll do that benchmark. I was initially using nf_conntrack_lock to 
protect the per-conntrack event cache, I think that use bitops is a bit 
better?

>> diff --git a/include/net/netfilter/nf_conntrack_extend.h 
>> b/include/net/netfilter/nf_conntrack_extend.h
>> index da8ee52..7f8fc5d 100644
>> --- a/include/net/netfilter/nf_conntrack_extend.h
>> +++ b/include/net/netfilter/nf_conntrack_extend.h
>> @@ -8,12 +8,14 @@ enum nf_ct_ext_id
>>      NF_CT_EXT_HELPER,
>>      NF_CT_EXT_NAT,
>>      NF_CT_EXT_ACCT,
>> +    NF_CT_EXT_ECACHE,
>>      NF_CT_EXT_NUM,
> 
> Quoting nf_conntrack_extend.c:
> 
> /* This assumes that extended areas in conntrack for the types
>    whose NF_CT_EXT_F_PREALLOC bit set are allocated in order */
> 
> Is that actually the case here? It might be beneficial to move
> this before accounting if possible, I guess its used more often.

I think that accounting information is updated more often. Events are 
only updated for very few packet specifically the setup and the 
tear-down packets of a flow.

>> @@ -738,6 +739,9 @@ nf_conntrack_in(struct net *net, u_int8_t pf, 
>> unsigned int hooknum,
>>  
>>      NF_CT_ASSERT(skb->nfct);
>>  
>> +    /* We may have pending events, deliver them and clear the cache */
>> +    nf_ct_deliver_cached_events(ct);
> 
> How does this guarantee that an event will be delivered in time?
> As far as I can see, it might never be delivered, or at least not
> until a timeout occurs.

Yes, that's the idea. In short, if we have cached events, we trigger a 
delivery via ctnetlink. If the delivery fails, we keep the cached events 
and the next packet will trigger a new delivery. We can lose events but 
at worse case, the destroy will be delivered.

If we add a new conntrack extension to store the creation and 
destruction time of the conntrack entries, we can have reliable 
flow-accouting since, at least, the destroy event will be delivered. In 
the case of the state synchronization, we aim to ensure that 
long-standing flows survive failures, thus, under event loss, the backup 
nodes would gett the state after some tries, specially for long-standing 
flows since every packet would trigger another delivery in case of problems.

BTW, I have removed that line locally. So the next delivery try for 
pending events is done only in nf_conntrack_confirm(), not twice, one in 
nf_conntrack_in() and nf_conntrack_confirm() as it happens in this patch.

>> +void nf_ct_deliver_cached_events_report(struct nf_conn *ct, u32 pid, 
>> int report)
>>  {
>>      struct nf_ct_event_notifier *notify;
>> +    struct nf_conntrack_ecache *e;
>>  
>>      rcu_read_lock();
>>      notify = rcu_dereference(nf_conntrack_event_cb);
>>      if (notify == NULL)
>>          goto out_unlock;
>>  
>> -    if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
>> -        && ecache->events) {
>> +    e = nf_ct_ecache_find(ct);
>> +    if (e == NULL)
>> +        goto out_unlock;
>> +
>> +    if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct) && e->cache) {
>>          struct nf_ct_event item = {
>> -            .ct     = ecache->ct,
>> -            .pid    = 0,
>> -            .report    = 0
>> +            .ct    = ct,
>> +            .pid    = pid,
>> +            .report    = report
>>          };
>>  
>> -        notify->fcn(ecache->events, &item);
>> +        notify->fcn(e->cache, &item);
>>      }
>> -
>> -    ecache->events = 0;
>> -    nf_ct_put(ecache->ct);
>> -    ecache->ct = NULL;
>> +    xchg(&e->cache, 0);
> 
> This races with delivery. There's no guarantee that it didn't cache
> another event between delivery and clearing the bits.

Yes, I can do something like:

long events;
events = xchg(&e->cache, 0);

at the very beginning of this function, and then use "events" instead of 
e->cache along this function.

>> +static int nf_ct_events_switch __read_mostly = NF_CT_EVENTS_DEFAULT;
>> +
>> +module_param_named(event, nf_ct_events_switch, bool, 0644);
>> +MODULE_PARM_DESC(event, "Enable connection tracking event delivery");
> 
> I think its actually possible to use a bool type for the variable
> nowadays. But I don't think we need the _switch suffix.

OK, I'll remove that prefix and I'll use bool (before making sure that 
it's possible :).

> Actually
> I don't really see the need for a module parameter at all, we already
> have the sysctl.

OK, I'll remove it.

>> diff --git a/net/netfilter/nf_conntrack_netlink.c 
>> b/net/netfilter/nf_conntrack_netlink.c
>> index 4448b06..2dd2910 100644
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -468,10 +468,10 @@ ctnetlink_conntrack_event(unsigned int events, 
>> struct nf_ct_event *item)
>>      if (ct == &nf_conntrack_untracked)
>>          return 0;
>>  
>> -    if (events & IPCT_DESTROY) {
>> +    if (events & (1 << IPCT_DESTROY)) {
> 
> This is really no improvement :)

The other choice is to use __test_bit().

>> @@ -1123,6 +1123,8 @@ ctnetlink_change_conntrack(struct nf_conn *ct, 
>> struct nlattr *cda[])
>>          err = ctnetlink_change_helper(ct, cda);
>>          if (err < 0)
>>              return err;
>> +
>> +        nf_conntrack_event_cache(IPCT_HELPER, ct);
> 
> Why are we suddenly caching a lot more events manually?

Currently, in user-space triggered events, we are including in the event 
message some fields that may not have been updated. Now we can provide 
more accurante events by notifying only the conntrack object fields that 
have been updated.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
