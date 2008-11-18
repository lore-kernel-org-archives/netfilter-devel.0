From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] [PATCH] dynamic calculation of event message size
 for	ctnetlink
Date: Tue, 18 Nov 2008 12:01:12 +0100
Message-ID: <4922A078.5090603@trash.net>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117084141.11368.26975.stgit@Decadence> <49218EA3.8090801@trash.net> <49223799.70505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33835 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYKRLBR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:01:17 -0500
In-Reply-To: <49223799.70505@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> This patch adds dynamic message size calculation for ctnetlink. This
>>> reduces CPU consumption since the overhead in the message trimming
>>> is removed.
>>>
>>>  static int ctnetlink_conntrack_event(struct notifier_block *this,
>>>                       unsigned long events, void *ptr)
>>>  {
>>> @@ -437,7 +538,7 @@ static int ctnetlink_conntrack_event(struct
>>> notifier_block *this,
>>>      if (!nfnetlink_has_listeners(group))
>>>          return NOTIFY_DONE;
>>>  
>>> -    skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
>>> +    skb = alloc_skb(ctnetlink_calculate_room_size(ct, events),
>>> GFP_ATOMIC);
>>>      if (!skb)
>>>          return NOTIFY_DONE;
>> These calculations look somewhat expensive to perform for every message.
>> Do you have any numbers for this new patch that shows the difference
>> in CPU usage compared to the resizing done by af_netlink.c?
> 
> Fabian Hugelshofer reported some reduction (~5%) on an embedded
> environment but he was using top to measure the difference. I'll collect
> some more trustable data and get back to you.

Thanks.

>> Since many of these are static in size an alternative would be to
>> update those sizes during protocol/helper/whatever (un)registration.
>> But if this patch already improves things, we can put it in and work
>> on perfecting it later :)
> 
> We can same save some branches doing so, but still ctnetlink has a lot
> of attributes that are dependent of the message type.

Indeed. But f.i. all the ->size(void) functions could obviously be
constants.

> What if we reduce the size of the skb allocated for netlink to more
> reasonable size instead of the accurate calculation? I'll check this
> possibility.

I don't think we need to be 100% accurate, just find a good middle
ground between grossly overallocating and the resulting unnecessary
copy, potentially expensive size calculations and socket memory waste.

> BTW, probably you already know, but in case that you try to use oprofile
> with your current tree, since it is based on 2.6.28-rc2, oprofile was
> broken here, I had to pull the fixes from somewhere else.

I'll probably merge what I have to Dave soon so I can resync with
his tree.

