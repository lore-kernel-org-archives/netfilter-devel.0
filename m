From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Date: Mon, 18 Jul 2011 21:17:00 +0100
Message-ID: <87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
	<20110718191956.GA2489@p183.telecom.by>
	<87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
	<20110718.124638.30010338187296272.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rweikusat@mobileactivedefense.com, adobriyan@gmail.com,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:57533 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GRURQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:17:16 -0400
In-Reply-To: <20110718.124638.30010338187296272.davem@davemloft.net> (David Miller's message of "Mon\, 18 Jul 2011 12\:46\:38 -0700 \(PDT\)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller <davem@davemloft.net> writes:
> From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
> Date: Mon, 18 Jul 2011 20:43:30 +0100
>
>> [rw@sapphire]~/work/linux-2-6/net/netfilter $find -name '*.c' | xargs grep '^#ifdef' | wc -l
>> 239
>> [rw@sapphire]~/work/linux-2-6/net/netfilter $..
>> [rw@sapphire]~/work/linux-2-6/net $find -name '*.c' | xargs grep '^#ifdef' | wc -l
>> 1672
>
> You've shown nothing.  Showing exceptions does not prove that the
> general effort has been to keep ifdef crap out of *.c files.

I've 'shown' that the networking code contains a fair amount of
#ifdefs in .c files. Consequently, 'we did it without' is wrong. At
best, 'we would like to do without in future' seems justified.

> And every developer or maintainer who says no to ifdefs in *.c files
> for new changes is %100 right.

Adding new files filled with ifdefs in order to avoid ifdefs in old
files in favor of lines-looking-like-code-which-arent seems
debatable to me. The same goes for adding unused structure members,
uneeded function calls, indirections through fifteen different other
files that turn out to do nothing etc. I spend much more time trying
to read Linux code than to write Linux code and while I decidedly know
worse things, Linux isn't exactly a prime example of easily accessible
code precisely because so much of it is something completely different
than what it appears to be.

But this is actually a digression that is besides the point: Put
something like 'ifdefs must not be used in new code, no matter what'
plainly into the CodingStyle text, then you can expect other people to
stick to this convention in the same way as to all the others (or at
least try to stick to it).

> We're also specifically talking about namespace stuff, so you should have
> at least refined your match criteria just a little bit.

The person I was replying to wrote 'We did whole networking without
sprinkling ifdefs'.
