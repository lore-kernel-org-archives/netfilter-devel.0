From: Patrick McHardy <kaber@trash.net>
Subject: Re: Targets with "mangle" table limiting (Was: Re: Troubles with
 MARK 	target in 2.6.28)
Date: Fri, 16 Jan 2009 09:04:15 +0100
Message-ID: <49703F7F.8040603@trash.net>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>	 <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net>	 <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>	 <496AEEB0.3080905@trash.net>	 <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>	 <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr>	 <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com>	 <496F3E5A.9050607@trash.net>	 <alpine.LSU.2.00.0901151744020.20619@fbirervta.pbzchgretzou.qr> <38bcb3ec0901151438y6f688429y3d7b37e396792589@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61164 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZAPIES (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:04:18 -0500
In-Reply-To: <38bcb3ec0901151438y6f688429y3d7b37e396792589@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James King wrote:
> On Thu, Jan 15, 2009 at 8:44 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> On Thursday 2009-01-15 14:47, Patrick McHardy wrote:
>>>>> Namely that MARK.2 is available for all tables. It looks like an error,
>>>>> given that the previous ones were all limited to the mangle table.
>>>>> But, I would have to ask - what do we gain from limiting it to mangle?
>>>>> [...]
>>>>> I could imagine it having to do with routing (nfmark can be used as
>>>>> a routing key, as can TOS/DSCP):
>>>>> [...]
>>>>> What do others think?
>>> Agreed, it doesn't make sense to restrict it to mangle only.
>>>
>> Are there perhaps other targets besides MARK whose table restriction
>> should be relaxed?
> 
> Could TOS/DSCP just call ip_route_me_harder() directly when necessary
> instead of relying on the mangle hook to do so?  This would allow it
> to be used everywhere.

That doesn't seem like a good idea. Rerouting should be an optional
feature, available in the (misnamed) mangle table. There might be
completely different reasons for changing DSCP. So making them available
in other tables yes, making them responsible for rerouting no.

> 
> Also, I would have thought TTL to be a considered field when
> determining if a reroute is needed, but it looks like only mark, iph,
> saddr, daddr, and tos are checked currently, so there doesn't seem to
> be an obvious benefit to restricting that target to mangle.
> 
> With those targets available everywhere, it might allow for future
> collapse of the tables, since mangle would become somewhat redundant.

Yes, lets just remove all those silly restrictions and just keep
the few ones that actually have a technical reason.
