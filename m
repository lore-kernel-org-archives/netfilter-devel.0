From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 17 Dec 2010 10:35:20 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012171029030.21893@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <4D00C6A4.6090305@netfilter.org> <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr> <4D08C892.3080704@netfilter.org>
 <20101216140537.GA23297@canuck.infradead.org> <alpine.LNX.2.01.1012161514360.20048@obet.zrqbmnf.qr> <20101217072555.GC23297@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45115 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0LQJfV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 04:35:21 -0500
In-Reply-To: <20101217072555.GC23297@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-12-17 08:25, Thomas Graf wrote:
>On Thu, Dec 16, 2010 at 03:22:07PM +0100, Jan Engelhardt wrote:
>> 
>>Oh great, now the confusion is complete. One person says this,
>>another says something else. Best of all, the Netlink RFC leaves it
>>unspecified, so it's all hearsay, beliefs and Perl5-style ("Source
>>acts as normative reference") referencing. I guess we are doomed
>>until the original Netlink3549 authors step up and tell us their
>>intentions.
>> 
>>As I see it, we need a discussion to specify what is to be done
>>with unspecified parts, with 3549 as an origin.
>
>The current netlink code implementation defines the standard. It is
>the standard because we have not been breaking it and will never do.
>
>Netlink is very open minded, it does not care if individual
>protocols define their own semantics.

So in fact, it does allow for preservation of attribute order and 
support for multiple attributes appearing with the same type, since that 
is part of my subprotocol anyway, right?

Cf. http://marc.info/?l=netfilter-devel&m=129068531114996&w=2
