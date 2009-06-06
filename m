From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Sat, 06 Jun 2009 08:34:33 +0200
Message-ID: <4A2A0DF9.8030108@netfilter.org>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49372 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZFFGfI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:35:08 -0400
In-Reply-To: <4A292DB7.4000000@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> @@ -240,6 +225,60 @@ static void death_by_timeout(unsigned long
>> ul_conntrack)
>>      NF_CT_STAT_INC(net, delete_list);
>>      clean_from_lists(ct);
>>      spin_unlock_bh(&nf_conntrack_lock);
>> +}
>> +
>> +static void death_by_event(unsigned long ul_conntrack)
>> +{
>> +    struct nf_conn *ct = (void *)ul_conntrack;
>> +    struct net *net = nf_ct_net(ct);
>> +
>> +    if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
>> +        /* bad luck, let's retry again */
>> +        ct->timeout.expires = jiffies +
>> +            (random32() % net->ct.sysctl_events_retry_timeout);
>> +        add_timer(&ct->timeout);
>> +        return;
>> +    }
>> +    /* we've got the event delivered, now it's dying */
>> +    set_bit(IPS_DYING_BIT, &ct->status);
>> +    spin_lock_bh(&nf_conntrack_lock);
> 
> _bh is not needed here, the timer is already running in BH context.
> 
>> +    hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
> 
> Why is _rcu used? The lists are never used for a lookup.

I'll fix these two.

>> +    spin_unlock_bh(&nf_conntrack_lock);
>> +    nf_ct_helper_destroy(ct);
>> +    nf_ct_put(ct);
>> +}
>> +
>> +void nf_ct_setup_event_timer(struct nf_conn *ct)
>> +{
>> +    struct net *net = nf_ct_net(ct);
>> +
>> +    nf_ct_delete_from_lists(ct);
> 
> This doesn't really belong here. I realize its because of ctnetlink,
> but I think I'd rather have an additional export.

I'll do.

>> +    /* add this conntrack to the dying list */
>> +    spin_lock_bh(&nf_conntrack_lock);
>> +    hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
>> +                 &net->ct.dying);
>> +    /* set a new timer to retry event delivery */
>> +    setup_timer(&ct->timeout, death_by_event, (unsigned long)ct);
>> +    ct->timeout.expires = jiffies +
>> +        (random32() % net->ct.sysctl_events_retry_timeout);
>> +    add_timer(&ct->timeout);
>> +    spin_unlock_bh(&nf_conntrack_lock);
> 
> Its not necessary to hold the lock around the timer setup. There's
> only this single reference left to the conntrack - at least it should
> be that way.

Indeed.

>> +}
>> +EXPORT_SYMBOL_GPL(nf_ct_setup_event_timer);
>> +
>> +static void death_by_timeout(unsigned long ul_conntrack)
>> +{
>> +    struct nf_conn *ct = (void *)ul_conntrack;
>> +
>> +    if (!test_bit(IPS_DYING_BIT, &ct->status) && +       
>> unlikely(nf_conntrack_event(IPCT_DESTROY, ct) < 0)) {
>> +        /* destroy event was not delivered */
>> +        nf_ct_setup_event_timer(ct);
>> +        return;
>> +    }
>> +    set_bit(IPS_DYING_BIT, &ct->status);
>> +    nf_ct_helper_destroy(ct);
>> +    nf_ct_delete_from_lists(ct);
> 
> The helpers might keep global data themselves thats cleaned
> up by ->destroy() (gre keymap for instance). The cleanup step
> might need to be done immediately to avoid clashes with new data
> or incorrectly returning data thats supposed to be gone.

This is a good catch that I have missed :-). I'll move this before the
event delivery since the internal protocol helper data is not used by
ctnetlink. I can include a comment here to warn about this if we do it
in the future.

>>      nf_ct_put(ct);
>>  }
>>  
>> @@ -1030,6 +1069,22 @@ void nf_conntrack_flush_report(struct net *net,
>> u32 pid, int report)
>>  }
>>  EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
>>  
>> +static void nf_ct_release_dying_list(void)
>> +{
>> +    struct nf_conntrack_tuple_hash *h;
>> +    struct nf_conn *ct;
>> +    struct hlist_nulls_node *n;
>> +
>> +    spin_lock_bh(&nf_conntrack_lock);
>> +    hlist_nulls_for_each_entry(h, n, &init_net.ct.dying, hnnode) {
>> +        ct = nf_ct_tuplehash_to_ctrack(h);
>> +        /* never fails to remove them, no listeners at this point */
>> +        if (del_timer(&ct->timeout))
>> +            ct->timeout.function((unsigned long)ct);
> 
> nf_ct_kill()?

I'll do. I have a patch here to replace a couple of similar invocation
by nf_ct_kill(), I'll send it to you once we're done with this patchset.

>> +    }
>> +    spin_unlock_bh(&nf_conntrack_lock);
>> +}
> 
>> diff --git a/net/netfilter/nf_conntrack_helper.c
>> b/net/netfilter/nf_conntrack_helper.c
>> index 0fa5a42..5fc1fe7 100644
>> --- a/net/netfilter/nf_conntrack_helper.c
>> +++ b/net/netfilter/nf_conntrack_helper.c
>> @@ -136,6 +136,21 @@ static inline int unhelp(struct
>> nf_conntrack_tuple_hash *i,
>>      return 0;
>>  }
>>  
>> +void nf_ct_helper_destroy(struct nf_conn *ct)
>> +{
>> +    struct nf_conn_help *help = nfct_help(ct);
>> +    struct nf_conntrack_helper *helper;
>> +
>> +    if (help) {
>> +        rcu_read_lock();
>> +        helper = rcu_dereference(help->helper);
>> +        if (helper && helper->destroy)
>> +            helper->destroy(ct);
>> +        rcu_read_unlock();
>> +    }
>> +}
>> +EXPORT_SYMBOL_GPL(nf_ct_helper_destroy);
> 
> The export looks unnecessary, its only used in nf_conntrack_core.c
> unless I've missed something

Indeed, the only client in nf_conntrack_core.c

>> diff --git a/net/netfilter/nf_conntrack_netlink.c
>> b/net/netfilter/nf_conntrack_netlink.c
>> index 2dd2910..6695e4b 100644
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -558,7 +559,10 @@ ctnetlink_conntrack_event(unsigned int events,
>> struct nf_ct_event *item)
>>      rcu_read_unlock();
>>  
>>      nlmsg_end(skb, nlh);
>> -    nfnetlink_send(skb, item->pid, group, item->report, GFP_ATOMIC);
>> +    err = nfnetlink_send(skb, item->pid, group, item->report,
>> GFP_ATOMIC);
>> +    if ((err == -ENOBUFS) || (err == -EAGAIN))
> 
> minor nit: unnecessary parens

I'll remove them. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
