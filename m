From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/11] netfilter: xtables: convert basic nfproto match
 functions into xt matches
Date: Tue, 11 May 2010 15:45:25 +0200
Message-ID: <4BE95F75.8060903@trash.net>
References: <1272880297-11198-1-git-send-email-jengelh@medozas.de> <1272880297-11198-12-git-send-email-jengelh@medozas.de> <4BE95496.1000709@trash.net> <alpine.LSU.2.01.1005111516030.26950@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40010 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533Ab0EKNp3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 09:45:29 -0400
In-Reply-To: <alpine.LSU.2.01.1005111516030.26950@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-05-11 14:59, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> Each table implementation has a private built-in hardwired match
>>> function for its corresponding nfproto data (e.g. ip_tables: struct
>>> ipt6_ip6 processed by ip6_packet_match to match against the IPv6
>>> header, etc.)
>>>
>>> Rewrite the functions so that they are independent xt_matches and can
>>> be used from an nfproto-independent table.
>> No major objections, but I'd like to know where this is going
>> and when, so far this doesn't provide any benefit.
> 
> The plan, as posted last fall[1], is to continue generalizing the 
> different iptables copies into one, bringing Xtables up to the next 
> level, e.g. family-agnostic rulesets, while retaining 
> compatibility.
> 
> [1] http://lwn.net/Articles/345176/
> 
> The "when" originally was 2.6.32, but I got a little slacky in doing 
> requested benchmarks, so it had practically postponed itself to the 
> current cycle, 2.6.35. If my counting is right, ~41 patches of that 
> list[1] have been merged, and while doing that, 46 concurrent 
> commits/ideas of mine have also been merged.
> 
> There are at least 60 patches left however, and that does not include 
> any comments from your side. I guess I don't get to spool and flush the 
> entire queue to 2.6.35 anymore - "better luck next time", or?

Well, I have no problems already merging parts that make sense on
their own, but this patchset kind of stops in the middle.

My suggestions would be for me to merge patches 01-08 and you
include the remaining ones in a series that actually need that
change. If you manage to submit that series in time for 2.6.35,
even better. How does that sound?
