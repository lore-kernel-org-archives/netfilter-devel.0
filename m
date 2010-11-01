From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: clone packet with new destination address
Date: Mon, 1 Nov 2010 14:09:46 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com> <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com> <4CCEB69B.5080905@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43130 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621Ab0KANJs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:09:48 -0400
In-Reply-To: <4CCEB69B.5080905@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-11-01 13:46, Stephen Clark wrote:
>>
>>Oh, iptables can also do it. Please see iptables target TEE and
>>RAWNAT in xtables-addons. http://xtables-addons.sourceforge.net/
>
>In testing this it looks like, to me anyhow, that the cloned packet
>gets sent to the new gw with the original destination address, so
>now the destination address has to get fixed up on the gw, this
>seems pretty kludgy to me. Why can't the cloned packet simply have
>its destination address replaced with the new destination address?

Because that would incur a loss of information (namely, the
destination address).

>This seems to me like it would make a lot more sense, instead of
>having to make changes to the packet on two different systems.

You can do the changes on a single machine if you want to.
