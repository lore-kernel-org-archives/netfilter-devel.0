From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release plans
Date: Mon, 21 Mar 2011 23:43:24 +0100
Message-ID: <4D87D48C.7080902@trash.net>
References: <4D879D96.2000904@trash.net> <alpine.LNX.2.01.1103212008460.15338@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37972 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1CUWnf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:43:35 -0400
In-Reply-To: <alpine.LNX.2.01.1103212008460.15338@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.03.2011 20:48, Jan Engelhardt wrote:
> 
> On Monday 2011-03-21 19:48, Patrick McHardy wrote:
>>
>> So the options basically are:
>>
>> - branch off the current HEAD, remove all new extension for upcoming
>>  features and release that branch
> 
> I find deletions just for the sake of making a release not very
> aesthetic to the git history. It duplicates commits in a way, but
> above all, interrupts the flow when tracking changes with "git
> blame". Better branch off earlier...
> 	~/envisioning a git topic for the next NFWS.~

That's really not the question, I'm not going to release
extensions for kernel modules which are so far in -rc.
There's a reason for -rc, one of them is that we still
have a chance to fix things in case we messed up.

>> - skip the release for 2.6.38
>>
>> Any opinions?
> 
> Since there was no iptables release for 2.6.37 was skipped, features
> do have accumulated. In fact, there were features added (socket r1)
> in 2.6.31 that were not made available up to iptables-1.4.10+git. In
> reverse chronological order:
> 
> ...
> Not to mention a handful of actual program fixes to parsing and
> slightly improved robustness (like NULL deref avoidance, I think
> there was at least one).
> 
> So yeah, time for a release or so. Not for 2.6.38, but for the
> general benefit.

Yeah, that's my opinion as well. Which means branching and
removing new extensions from that branch.
