From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH nf v2] netfilter: conntrack: refine gc worker heuristics
Date: Thu, 3 Nov 2016 17:57:44 +0100
Message-ID: <8aad7dbf-da86-9afc-805c-879833aa2883@6wind.com>
References: <1478127895-32540-1-git-send-email-fw@strlen.de>
 <9b8a1258-1ecd-daf8-ffd2-1acc70e2ebbb@6wind.com>
 <20161103163133.GA26355@breakpoint.cc>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37888 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757738AbcKCQ5r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 12:57:47 -0400
Received: by mail-wm0-f41.google.com with SMTP id n67so113728617wme.1
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Nov 2016 09:57:47 -0700 (PDT)
In-Reply-To: <20161103163133.GA26355@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 03/11/2016 à 17:31, Florian Westphal a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>>>  Change since v1: use system_long_wq instead of normal system wq (suggested by
>>>  Eric Dumazet).
>>>
>>>  Nicholas is currently away; I would like to get his feedback on this one
>>>  before it gets applied.
>> Thank you for the update.
>> With that patch, some events still have a delay > 2 minutes, which I think is
>> too much.
> 
> Too bad, in my tests it was < 1 minute.
> 
>> If I'm not wrong, the worst delay with this patch is:
>> 10 (GC_INTERVAL_MAX) + 0,001 + 5,001 + 5,002 + 5,003 + ... +  6,024 (= 5 secs +
>> 1024 mecs)
> 
> Worst case is over 3 hours (assuming no eviction happened at all and we
> have one stale entry that needs the full scan).
3 hours to get a netlink event is really no acceptable ;-)

> 
>> Previously (in private discussions), you propose a algorithm which guarantee a
>> full table scan in a predefined delay. A "good" solution may have such guarantee.
> 
> Now that this uses system_long_wq prolonged a long scan time might not
> be that bad anymore, so we might consider lowering the divisor and/or the
> max interval.
> 
> However, I will not send a new iteration of this change since I don't
> know how to test this.  Its easy to make the delay low, but it will come
> at additonal cpu cost.  I have no idea where to make the tradeoff.
For me, the priority is to deliver events with a reasonnable delay (and I think
Pablo also asks for this in a previous email). I understand that the cpu cost
need to be taken into account, but it's a tradeoff of the new design I think.

Regards,
Nicolas
