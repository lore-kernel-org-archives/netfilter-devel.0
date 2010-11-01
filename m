From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: clone packet with new destination address
Date: Mon, 1 Nov 2010 20:29:34 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011012015340.655@obet.zrqbmnf.qr>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com> <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com> <4CCEB69B.5080905@earthlink.net> <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr>
 <4CCECEDD.2030107@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58412 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab0KAT3f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:29:35 -0400
In-Reply-To: <4CCECEDD.2030107@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-11-01 15:29, Stephen Clark wrote:
> On 11/01/2010 09:09 AM, Jan Engelhardt wrote:
>>
>>> This seems to me like it would make a lot more sense, instead of
>>> having to make changes to the packet on two different systems.
>>
>> You can do the changes on a single machine if you want to.
>  
>I am not sure on how to go about doing that, looking at the code for
>TEE it looks like the cloned packet bypasses any of the remaining
>iptables chains. So where would I change the destination address?

Right. You need a kernel >= 2.6.35 (xt_TEE is included)
for cloned packets to go through the tables again.

>Also if I am mistaken and it does hit one of the remaining iptables
>chains how do I tell it is not the original but the cloned packet I
>want to change to the new destination address?

Good question. Given the possibilities I think an extra route towards
the logging server that specifies a realm value, that is then
matchable in -A OUTPUT -m realm, is in order.
