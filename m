From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/10][CTNETLINK] Fix race condition on conntrack creation
Date: Mon, 10 Jul 2006 06:31:40 +0200
Message-ID: <44B1D82C.5070404@trash.net>
References: <44ADC336.1060004@netfilter.org> <44ADE6F4.2090909@trash.net>
	<44AE58CD.6060404@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44AE58CD.6060404@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>> In patch 5 you refer to timer activation and hash insertion. Why does
>> helper lookup needs to be done inside the lock?
> 
> 
> On helper module removal, the conntracks in the hashes are unhelped but
> the conntrack that we are about to create is not yet in hashes, and it
> will be refering to a unexistant helper. To overcome this Harald added
> the function helper_find_get() that uses appropiate module refcounting,
> so the helper can not vanish in the ctnetlink conntrack creation path.
> At the time that I was cooking the patch, I realised that we don't need
> find_get() anymore if we can move the helper lookup inside the locked
> section.

Yes, that seems right.

>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>>
>>> Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
>>> ===================================================================
>>> --- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c   
>>> 2006-07-07 00:15:14.000000000 +0200
>>> +++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c    2006-07-07
>>> 01:52:14.000000000 +0200
>>> @@ -1059,13 +1059,12 @@ ctnetlink_create_conntrack(struct nfattr
>>>         ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
>>> #endif
>>>
>>> -    ct->helper = ip_conntrack_helper_find_get(rtuple);
>>> -
>>> -    add_timer(&ct->timeout);
>>> +    /* we do no want any races on hash insertion */
>>> +    write_lock_bh(&ip_conntrack_lock);
>>> +    ct->helper = ip_conntrack_helper_find(rtuple);
>>>     ip_conntrack_hash_insert(ct);
>>> -
>>> -    if (ct->helper)
>>> -        ip_conntrack_helper_put(ct->helper);
>>> +    add_timer(&ct->timeout);
>>> +    write_unlock_bh(&ip_conntrack_lock);
>>>
>>>     DEBUGP("conntrack with id %u inserted\n", ct->id);
>>>     return 0;
>>
>>
>>
>> I also see another race, the caller of create_conntrack does a lookup
>> within locks, drops the locks and we reaquire them here. The entire
>> lookup-insertion needs to be atomic.
> 
> 
> Not really, the lookup-update must be atomic, as it is now, since the
> conntrack is in the hashes, but for the lookup-creation-insertion I
> don't see why we would need to. The conntrack that we are creating is
> not yet in the hashes, therefore we only need the locking in the step of
> timer activation and insertion.

The insertion doesn't check for existance again, but it might
have already been created asynchrously between the lookup and
the insertion, in which case we end up with two identical
conntracks in the hash table.
