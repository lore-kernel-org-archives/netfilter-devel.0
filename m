From: "Nishit Shah" <nishit@elitecore.com>
Subject: RE: Plans for future iptables versions / jumpset feature
Date: Fri, 23 May 2008 17:25:05 +0530
Message-ID: <00d501c8bccb$d7922000$86b66000$@com>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Patrick McHardy'" <kaber@trash.net>,
	"'Thomas Jacob'" <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:39545 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752275AbYEWMBJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 08:01:09 -0400
In-Reply-To: <4835C6F0.5080604@trash.net>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
	I am also looking/working for same thing as something like
"jumpset", even discussed with Patrick in last workshop regarding how to do
it, but it looks difficult to me by just seeing at code or understanding the
code without the overall impact.
	It would be nice if someone can share the idea of how to do it or
give a lead for how to proceed.

Rgds,
Nishit Shah  

-----Original Message-----
From: netfilter-devel-owner@vger.kernel.org
[mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Patrick McHardy
Sent: Friday, May 23, 2008 12:48 AM
To: Thomas Jacob
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Plans for future iptables versions / jumpset feature

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

--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

