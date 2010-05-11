From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 11/11] netfilter: xtables: convert basic nfproto match
 functions into xt matches
Date: Tue, 11 May 2010 18:08:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005111757410.9254@obet.zrqbmnf.qr>
References: <1272880297-11198-1-git-send-email-jengelh@medozas.de> <1272880297-11198-12-git-send-email-jengelh@medozas.de> <4BE95496.1000709@trash.net> <alpine.LSU.2.01.1005111516030.26950@obet.zrqbmnf.qr> <4BE95F75.8060903@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4BE95F75.8060903@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 2010-05-11 15:45, Patrick McHardy wrote:
>> 
>> The plan, as posted last fall[1], is to continue generalizing the 
>> different iptables copies into one, bringing Xtables up to the next 
>> level, e.g. family-agnostic rulesets, while retaining 
>> compatibility.
>> 
>> [1] http://lwn.net/Articles/345176/
>> 
>> The "when" originally was 2.6.32, but I got a little slacky in doing 
>> requested benchmarks, so it had practically postponed itself to the 
>> current cycle, 2.6.35. If my counting is right, ~41 patches of that 
>> list[1] have been merged, and while doing that, 46 concurrent 
>> commits/ideas of mine have also been merged.
>> 
>> There are at least 60 patches left however, and that does not include 
>> any comments from your side. I guess I don't get to spool and flush the 
>> entire queue to 2.6.35 anymore - "better luck next time", or?
>
>Well, I have no problems already merging parts that make sense on
>their own, but this patchset kind of stops in the middle.

I felt it made more sense to cut at 11 rather than 8. The next
coherent batch would start introducing pure new code and would
already be one of size 29. I mean I don't mind, you will look
through them either way ;-)

>My suggestions would be for me to merge patches 01-08 and you
>include the remaining ones in a series that actually need that
>change. If you manage to submit that series in time for 2.6.35,
>even better. How does that sound?

Always fine by me.
