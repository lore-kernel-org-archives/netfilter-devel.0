From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables branch management
Date: Thu, 8 Sep 2011 13:59:49 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109081243320.11934@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr> <20110905175425.GC32733@1984> <4E68935B.3000401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59565 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206Ab1IHL7x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 07:59:53 -0400
In-Reply-To: <4E68935B.3000401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-09-08 12:05, Patrick McHardy wrote:

>Am 05.09.2011 19:54, schrieb Pablo Neira Ayuso:
>> Hi Jan,
>> 
>> On Fri, Sep 02, 2011 at 04:20:13PM +0200, Jan Engelhardt wrote:
>>> Hei
>>>
>>> I would like to propose a "stable" branch that would be rooted 
>>> in the most recent tag and only receive fixes. Furtheremore, 
>>> the branch is merged time and again into master, so that the 
>>> fix is available in both without cherry-pick. 1.4.12.x releases be made 
>>> from stable, and 1.4.y from master.
>>> How about it?
>> 
>> Hm, I remember that we had this discussion before.
>> 
>> I think it's probably too much overhead for it, looking at how other
>> similar net-tools are maintained, the amount of contributions that
>> er receive and amount of changes that get into every version.
>
>I also think this is probably overkill, what's wrong with simply
>creating stable branches on demand if there are important fixes
>that require a new release?

Nothing wrong, it just has not been done consistently or at all in the 
past. I believe it does not hurt to go ahead with this, also since I am 
statistically taking care of most submissions these days anyway.
