From: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Subject: Re: initial (im)port of ipt_ACCOUNT, ipt_pknock and ipt_stealth to
 xtables-addons-1.17
Date: Mon, 31 Aug 2009 18:34:00 +0200 (MEST)
Message-ID: <alpine.LNX.2.00.0908311728240.28790@cedric.unob.cz>
References: <alpine.LNX.2.00.0908262011580.20390@cedric.unob.cz> <200908311727.26512.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>,
	Jan Engelhardt / xtables-addons <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cedric.unob.cz ([160.216.40.10]:35189 "EHLO cedric.unob.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZHaQeK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2009 12:34:10 -0400
In-Reply-To: <200908311727.26512.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello Thomas,

On Mon, 31 Aug 2009, Thomas Jarosch wrote:

> Hello Jan Rafaj,
>
> On Thursday, 27. August 2009 17:53:33 Jan Rafaj wrote:
>> - files have all been renamed from {lib,}ipt_* to {lib,}xt_*
>>    (I know, they are still IPv4-only projects, but thats the policy
>>    of Xt-a)
>
> Thanks for your effort.

NP.

> ipt_ACCOUNT is IPv4 only. Giving it a name of xt_ACCOUNT
> will give the impression it works for IPv6, right?

Well, yes and no - as you can see, some other target/match modules 
in xtables-addons are IPv4-only too, yet all of them have name {lib,}xt_* .
The apparent aim is to have them all internally prepared for adding IPv6
later, though. Feel free to ask Jan Engelhardt, who does good job in 
maintaining Xt-a.

>> By releasing this, I only strongly (and selfishly, I admit) hope the
>> authors of these projects will eventually see advantages of being part of
>> xtables-addons, and will hopefully start to maintain these projects in
>> xtables-addons tree from now on.
>
> Well, I don't use xtables-addons myself :o)
>
> ipt_ACCOUNT is maintained in it's own git tree here:
> http://www.intra2net.com/en/developer/ipt_ACCOUNT/repository.php
>
> As development is currently in maintenance mode only,
> it shouldn't hurt to have a copy in Xtables-addons, too.

That alone would already be great I think, thanks.

> Though I'm not sure if having two versions with different names
> (xt_ACCOUNT, ipt_ACCOUNT) is a good idea.

I hope having it in Xt-a primarily would be for the benefit of most other 
people who dont like to patch their kernel with varying success using 
pom-ng, like me. My intention was (and is) to have every useful 
third-party extension in just 1 place. I was always unhappy with pom-ng, 
as it never gave me the level of confidentiality that it would work with 
whatever newer kernel I'd decide to use (besides - from developer's PoV - 
the need to hack in support for whatever kernel I pick up, myself, becouse 
the original author didnt care, using a ton of those ugly #if's to 
interface with particular kernel API). 
In Xtables-addons, all appears to be maintained uniformly and towards the 
latest netfilter API, so I can be sure that anything thats part of it I'd 
want to use, will just work for me (plus eventual added benefit of 
*someone else* porting my favourite extension in it forward in the 
future... :).
But I also understand your eventual concerns - you may want not to
allow diverting the development line somewhere where you do not prefer to.

If you prefer to maintain ACCOUNT in a separate tree, well of course I
can't object. But first please try to realise the benefits of Xt-a model
over pom-ng, and what this can mean for other people (I hardly see anyone 
using pom-ng these days). Perhaps you could try to maintain it in a 
standalone branch of Xt-a git tree? (Please do not under any circumstance
take this as that I'm forcing you to do something; God save, I'm far 
from that. I just wish if you could give it a try to *start* maintaining 
it in the framework used for majority of other projects, even if you
though do not find Xt-a useful right now...).

All in all, I did this port with the hope many people will find this 
effort towards unifying base of all third-party extensions useful. At 
least I do. And also becouse I want to use ACCOUNT, but I'm not 
simply willing to patch my kernel (and hand fix what didnt apply) using 
pom-ng just becouse 1 or 2 extra extensions do require it, becouse
that has always been a nightmare for me.

Best regards,

Jan
