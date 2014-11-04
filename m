From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH v4 2/3] Do error handling if __build_packet_message fails
Date: Tue, 04 Nov 2014 16:01:54 -0200
Message-ID: <54591492.5090205@redhat.com>
References: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com> <8dcee609af0015c15d2a99ab6d076a65d6ec01a8.1414586968.git.mleitner@redhat.com> <20141104164757.GA15508@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaKDSB7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:01:59 -0500
In-Reply-To: <20141104164757.GA15508@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 04-11-2014 14:47, Pablo Neira Ayuso wrote:
> Hi Marcelo,
>
> On Wed, Oct 29, 2014 at 10:51:14AM -0200, Marcelo Ricardo Leitner wrote:
>> Currently, we don't check if __build_packet_message fails or not and
>> that leaves it prone to sending incomplete messages to userspace.
>>
>> This commit fixes it by canceling the new message if there was any issue
>> while building it and makes sure the skb is freed if it was the only
>> message in it.
>>
>> Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
>> ---
>>   net/netfilter/nfnetlink_log.c | 21 +++++++++++++++------
>>   1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
>> index b1e3a05794169283ed50d1c0fb4f44d9e7753eeb..045c5956611f61a3f5dad3e15ca7cf19365e5afa 100644
>> --- a/net/netfilter/nfnetlink_log.c
>> +++ b/net/netfilter/nfnetlink_log.c
>> @@ -568,10 +568,8 @@ __build_packet_message(struct nfnl_log_net *log,
>>   		struct nlattr *nla;
>>   		int size = nla_attr_size(data_len);
>>
>> -		if (skb_tailroom(inst->skb) < nla_total_size(data_len)) {
>> -			printk(KERN_WARNING "nfnetlink_log: no tailroom!\n");
>> -			return -1;
>> -		}
>> +		if (skb_tailroom(inst->skb) < nla_total_size(data_len))
>> +			goto nla_put_failure;
>>
>>   		nla = (struct nlattr *)skb_put(inst->skb, nla_total_size(data_len));
>>   		nla->nla_type = NFULA_PAYLOAD;
>> @@ -586,6 +584,7 @@ __build_packet_message(struct nfnl_log_net *log,
>>
>>   nla_put_failure:
>>   	PRINTR(KERN_ERR "nfnetlink_log: error creating log nlmsg\n");
>> +	nlmsg_cancel(skb, nlh);
>>   	return -1;
>>   }
>>
>> @@ -708,8 +707,9 @@ nfulnl_log_packet(struct net *net,
>>
>>   	inst->qlen++;
>>
>> -	__build_packet_message(log, inst, skb, data_len, pf,
>> -				hooknum, in, out, prefix, plen);
>> +	if (__build_packet_message(log, inst, skb, data_len, pf,
>> +				   hooknum, in, out, prefix, plen))
>> +		goto build_failure;
>>
>>   	if (inst->qlen >= qthreshold)
>>   		__nfulnl_flush(inst);
>> @@ -726,6 +726,15 @@ unlock_and_release:
>>   	instance_put(inst);
>>   	return;
>>
>> +build_failure:
>> +	/* If no other messages in it, we're good to free it. */
>> +	if (!inst->skb->len) {
>> +		kfree_skb(inst->skb);
>> +		inst->skb = NULL;
>> +	}
>> +
>> +	inst->qlen--;
>
> For each message that we put into the batch, we increase inst->qlen in
> one, so I think this decrement isn't enough to leave things in
> consistent state. If we at least have one message already in the
> batch, I think it's good to give it a try to deliver it to userspace:
>
>          if (inst->skb)
>                  __nfulnl_flush(inst);

The idea was to undo just the last attempt and leave the older ones where they 
were...

Currently we:
- allocate skb, if needed
- increment inst->qlen
- call __build_packet_message
- if (inst->qlen >= qthreshold)
   we flush..

Considering __build_packet_message now will call nlmsg_cancel and undo all its 
work on fails, I thought on just dec'ing inst->qlen and releasing the skbuff, 
if it's empty.

I see your point on attempting the flush, good idea. Otherwise we could hit a 
situation that it would be stuck on undoing the last message and this 
situation would be fixed only after inst->timer expires.

It could be like:
build_failure:
     inst->qlen--;

     /* If no other messages in it, we're good to free it. */
     if (!inst->skb->len) {
         kfree_skb(inst->skb);
         inst->skb = NULL;
     }
     else {
         __nfulnl_flush(inst);
     }

What do you think?

> Then, the WARN_ON that Florian added recently should catch that we
> have size miscalculations from __nfulnl_send().

Good point. It may not catch it always. If the failed message was bigger than 
the DONE message, it may go on unnoticed. Actually, even if it warns, we would 
have no idea that a message was dropped a bit earlier, as the stats aren't 
there yet. Maybe another WARN_ONCE on build_failure label?

Thanks,
Marcelo

