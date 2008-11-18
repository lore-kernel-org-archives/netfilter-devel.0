From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 7/8] [PATCH] dynamic calculation of event message size
 for	ctnetlink
Date: Tue, 18 Nov 2008 04:33:45 +0100
Message-ID: <49223799.70505@netfilter.org>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117084141.11368.26975.stgit@Decadence> <49218EA3.8090801@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37149 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751793AbYKRDd6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:33:58 -0500
In-Reply-To: <49218EA3.8090801@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch adds dynamic message size calculation for ctnetlink. This
>> reduces CPU consumption since the overhead in the message trimming
>> is removed.
>>
>>  static int ctnetlink_conntrack_event(struct notifier_block *this,
>>                       unsigned long events, void *ptr)
>>  {
>> @@ -437,7 +538,7 @@ static int ctnetlink_conntrack_event(struct
>> notifier_block *this,
>>      if (!nfnetlink_has_listeners(group))
>>          return NOTIFY_DONE;
>>  
>> -    skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
>> +    skb = alloc_skb(ctnetlink_calculate_room_size(ct, events),
>> GFP_ATOMIC);
>>      if (!skb)
>>          return NOTIFY_DONE;
> 
> These calculations look somewhat expensive to perform for every message.
> Do you have any numbers for this new patch that shows the difference
> in CPU usage compared to the resizing done by af_netlink.c?

Fabian Hugelshofer reported some reduction (~5%) on an embedded
environment but he was using top to measure the difference. I'll collect
some more trustable data and get back to you.

> Since many of these are static in size an alternative would be to
> update those sizes during protocol/helper/whatever (un)registration.
> But if this patch already improves things, we can put it in and work
> on perfecting it later :)

We can same save some branches doing so, but still ctnetlink has a lot
of attributes that are dependent of the message type.

What if we reduce the size of the skb allocated for netlink to more
reasonable size instead of the accurate calculation? I'll check this
possibility.

BTW, probably you already know, but in case that you try to use oprofile
with your current tree, since it is based on 2.6.28-rc2, oprofile was
broken here, I had to pull the fixes from somewhere else.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
