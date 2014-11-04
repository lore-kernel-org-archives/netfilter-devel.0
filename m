From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH v4 2/3] Do error handling if __build_packet_message fails
Date: Tue, 04 Nov 2014 16:52:31 -0200
Message-ID: <5459206F.7080702@redhat.com>
References: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com> <8dcee609af0015c15d2a99ab6d076a65d6ec01a8.1414586968.git.mleitner@redhat.com> <20141104164757.GA15508@salvia> <54591492.5090205@redhat.com> <20141104182609.GA26344@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaKDSwi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:52:38 -0500
In-Reply-To: <20141104182609.GA26344@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04-11-2014 16:26, Pablo Neira Ayuso wrote:
> On Tue, Nov 04, 2014 at 04:01:54PM -0200, Marcelo Ricardo Leitner wrote:
>>>> @@ -708,8 +707,9 @@ nfulnl_log_packet(struct net *net,
>>>>
>>>>   	inst->qlen++;
>>>>
>>>> -	__build_packet_message(log, inst, skb, data_len, pf,
>>>> -				hooknum, in, out, prefix, plen);
>>>> +	if (__build_packet_message(log, inst, skb, data_len, pf,
>>>> +				   hooknum, in, out, prefix, plen))
>>>> +		goto build_failure;
>>>>
>>>>   	if (inst->qlen >= qthreshold)
>>>>   		__nfulnl_flush(inst);
>>>> @@ -726,6 +726,15 @@ unlock_and_release:
>>>>   	instance_put(inst);
>>>>   	return;
>>>>
>>>> +build_failure:
>>>> +	/* If no other messages in it, we're good to free it. */
>>>> +	if (!inst->skb->len) {
>>>> +		kfree_skb(inst->skb);
>>>> +		inst->skb = NULL;
>>>> +	}
>>>> +
>>>> +	inst->qlen--;
>>>
>>> For each message that we put into the batch, we increase inst->qlen in
>>> one, so I think this decrement isn't enough to leave things in
>>> consistent state. If we at least have one message already in the
>>> batch, I think it's good to give it a try to deliver it to userspace:
>>>
>>>          if (inst->skb)
>>>                  __nfulnl_flush(inst);
>>
>> The idea was to undo just the last attempt and leave the older ones
>> where they were...
>>
>> Currently we:
>> - allocate skb, if needed
>> - increment inst->qlen
>> - call __build_packet_message
>> - if (inst->qlen >= qthreshold)
>>    we flush..
>>
>> Considering __build_packet_message now will call nlmsg_cancel and
>> undo all its work on fails, I thought on just dec'ing inst->qlen and
>> releasing the skbuff, if it's empty.
>>
>> I see your point on attempting the flush, good idea. Otherwise we
>> could hit a situation that it would be stuck on undoing the last
>> message and this situation would be fixed only after inst->timer
>> expires.
>>
>> It could be like:
>> build_failure:
>>      inst->qlen--;
>
> We can inst->qlen++ after build_packet_message, so you can skip this
> line above.

Ack, okay

>
>>      /* If no other messages in it, we're good to free it. */
>>      if (!inst->skb->len) {
>
> Now I'd suggest:
>
>        if (inst->qlen == 0) {

ack

>
>>          kfree_skb(inst->skb);
>>          inst->skb = NULL;
>>      }
>>      else {
>>          __nfulnl_flush(inst);
>>      }
>>
>> What do you think?
>>
>>> Then, the WARN_ON that Florian added recently should catch that we
>>> have size miscalculations from __nfulnl_send().
>>
>> Good point. It may not catch it always. If the failed message was
>> bigger than the DONE message, it may go on unnoticed. Actually, even
>> if it warns, we would have no idea that a message was dropped a bit
>> earlier, as the stats aren't there yet. Maybe another WARN_ONCE on
>> build_failure label?
>
> That will catch possible miscalculations too, I don't like we're
> polluting this with many WARN_ONCE, but I don't see any better way to
> catch this size miscalculation bugs, so ahead add it.
>
> BTW, we should also signal the userspace when we fail to build the
> message via:
>
> nfnetlink_set_err(net, 0, group, -ENOBUFS);
>
> so it knows that we're losing log messages for whatever reason.
> Basically, userspace hits -ENOBUFS when calling recv(), which means
> netlink is losing messages. I don't think we really need the
> statistics.

Cool. Then we probably don't need the WARN_ON unless we really want those 
numbers, or even so. As we will be calling nfnetlink_set_err, we have other 
ways of debugging. Wouldn't be as ready as a WARN_ONCE in there, yes.. but a 
systemtap script can easily get a hold in there.

So no WARN_ONCE, just the nfnetlink_set_err() call? Like this?

 >        if (inst->qlen == 0) {
 >>          kfree_skb(inst->skb);
 >>          inst->skb = NULL;
 >>      }
 >>      else {
 >>          __nfulnl_flush(inst);
 >>      }
         nfnetlink_set_err(net, 0, group, -ENOBUFS);

So we send whatever we had, and signal the failure..

>
> I can also see this line:
>
> nlh->nlmsg_len = inst->skb->tail - old_tail;
>
> that can be replaced by nlmsg_end(skb, nlh);
>
> It seems this code needs some care.

Agreed. I'll try :)

Thanks,
Marcelo

