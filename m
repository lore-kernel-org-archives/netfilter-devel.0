From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 14/24] [NETFILTER]: Use bool in nf_conntrack_l4proto
Date: Thu, 03 Apr 2008 17:49:04 +0200
Message-ID: <47F4FC70.6050008@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <3fe7a3dd723a0f2c303559ef46e3d7d67702db57.1207134547.git.jengelh@computergmbh.de> <47F4F103.5070007@trash.net> <alpine.LNX.1.10.0804031725030.1301@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38657 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484AbYDCPtK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:49:10 -0400
In-Reply-To: <alpine.LNX.1.10.0804031725030.1301@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-04-03 17:00, Patrick McHardy wrote:
>>
>> Some hints for the future to make this easier for both of us:
>>
>> - submit small batches, split into logical units
> 
> This sets me up a bit.. sometimes it's "should have folded these"
> (like the const annotation patches that were at the start of
> the series), then it's "smaller batches" :-/

Folding patches makes the batches smaller (note: batch, not
patch) :) What I meant by this was to not flood me with 30
patches three times at once, if issues come up in one of the
first patches it often results in the later ones not applying.
Logical batches, like

- batch 1: constification
- batch 2: boolean conversions
- batch x: things like rename ipt_recent, add IPv6 support
- batch y: arp_tables userspace interface changes in order
            to achieve X.

>> - avoid style changes like this, especially when the entire file
>>   uses a consistent style:
>>
>>>  -static int icmpv6_pkt_to_tuple(const struct sk_buff *skb,
>>>  -                   unsigned int dataoff,
>>>  -                   struct nf_conntrack_tuple *tuple)
> 
> allow me the remark of "consistently odd", as you can see what a
> change in indent does when spaces are not used in the right
> place. But whatever, yeah.
> 
>>>  +static bool
>>>  +icmpv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
>>>  +                    struct nf_conntrack_tuple *tuple)
>>
>> - run checkpatch
> 
> Not before I rip out that incredibly stupid "use tabs" warning.
> The warning may be right for users who apparently have not dealt
> with patch submitting process a lot, but for longtime contributers
> that get their style right the 1st time it's just wrong.

No, we've fixed up net/ more than once using scripts before
checkpatch even existed. Simple: keep existing style.

>     That program has no sense for when spaces are needed.
> The style I used and use (tabs=indent, spaces=align - it only makes
> sense) was always fine by you, but now it's not because
> checkpatch says so?

See above. I used to use a different indenting style as well,
but I prefer consistency over having it exactly as I like it.

>> - don't mix cleanups with real changes
>> - run sparse with endian checks
>> - compile test all the code your changing, including CONFIG_COMPAT
> 
> Will do.
> 

