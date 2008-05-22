From: Patrick McHardy <kaber@trash.net>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 21:18:08 +0200
Message-ID: <4835C6F0.5080604@trash.net>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44761 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYEVTTw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 15:19:52 -0400
In-Reply-To: <1211482843.28066.40.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jacob wrote:
> Hello list,
>
> In a reply to a post last week about netfilter/iptables's performance
> (see below for link), Patrick McHardy wrote about him working 
> on a successor to iptables that would be able to manipulate
> single rules in a set without any need to replace the whole
> ruleset, and that would also include native support
> for match sets and the like:
>
> http://marc.info/?l=netfilter-devel&m=121085934512644
>
> Are the plans for that online somewhere? Is there
> a envisioned time line?
>   

The plans come mostly from multiple discussions on this list
and in private, as well as my dislikes of certains aspects
of iptables (like the insane amount of modules).

The time line is vague, I originally wanted to have something
to publish this month, but other things are keeping me busy.
So to be safe I'll not promise anything before the next netfilter
workshop.

I might publish an outline of the new design though if I'll
find some time.

> I'm asking because I'm thinking about whether or not
> it's feasible and/or sensibly to write some kind
> of target module that I'm choosing to call "jumpset" for now, that
> would act as a fast (>O(log(n)) "jump diststribution point".
>   

Thats one of the things I also want to add (halfway finished yet).
Jumps are regular verdicts in my new design and verdicts can be
gathered though lookups in sets, hashes etc. So you could do:

unnamed ... -j { 192.168.0.1:chain_1, 192.168.0.2:chain_2, ...}

I also want to have the same working for mark etc:

unnamed ... -j MARK --set-mark { 192.168.0.1:1, 192.168.0.2: 2, .. }

or alternatively:

unnamed ... -j MARK --set-mark ip-dst & 0xFF

> The idea is to have a mapping between a a potentially large set of IP
> addresses and the chain/target space, so one could have a different
> "next chain" for each  different source/target IP or possibly
> source/target network. The internal implementation of the necessary
> data structures would be something along the lines of the ipset
> extension. 
>
> The application would be being able to provide customized
> rule sets for lots of different machines at just a few central netfilter
> boxen. Or perhaps to block traffic from different attack sources in
> completely different ways in an IDS/IPS system.
>
> In some cases one could of course achieve a similar functionality by
> constructing rule trees with the existing standard distribution but that
> could create a huge number of rules that simply link to the next chain
> and in general looks rather messy.
>   

Doing this in iptables might get a bit hairy, but it shouldn't be
that hard.

> But if iptables will be fundamentally different next year or if
> it will already contain something similar, it would probably not be very
> productive to work on such a module.

It would be great to have this in shape by next year, but I won't
promise anything. Should be doable though.

