From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables release plans
Date: Tue, 22 Mar 2011 00:22:08 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103212350390.8946@obet.zrqbmnf.qr>
References: <4D879D96.2000904@trash.net> <alpine.LNX.2.01.1103212008460.15338@obet.zrqbmnf.qr> <4D87D48C.7080902@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40356 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab1CUXWK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:22:10 -0400
In-Reply-To: <4D87D48C.7080902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-03-21 23:43, Patrick McHardy wrote:
>> 
>> I find deletions just for the sake of making a release not very
>> aesthetic to the git history. It duplicates commits in a way, but
>> above all, interrupts the flow when tracking changes with "git
>> blame". Better branch off earlier...
>> 	~/envisioning a git topic for the next NFWS.~
>

>> So yeah, time for a release or so. Not for 2.6.38, but for the
>> general benefit.
>
>Yeah, that's my opinion as well. Which means branching and
>removing new extensions from that branch.

The removal can be avoided if it is branched from the right point.
Right, this was not exactly done like that in the last cycle, which
is why I can see why you would like to hold a release.

>That's really not the question, I'm not going to release
>extensions for kernel modules which are so far in -rc.

Makes sense.

So then in that case, let's hold. Most distros had just fixated
their version anyway, so throwing something out the door now
does not yield that much.

Regarding the history tree, let's start doing it with better
branching from now. I offer to take up all the patches (since that's
just minimally more than already doing), and place them into
the right spot in the tree such that there be no deletions
or cherry-picks required in future.
