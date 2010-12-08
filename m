From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Wed, 08 Dec 2010 12:36:16 +0100
Message-ID: <4CFF6DB0.2020703@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org> <alpine.LNX.2.01.1012032156100.26825@obet.zrqbmnf.qr> <4CFDE6FB.4060103@netfilter.org> <alpine.LNX.2.01.1012071424310.22465@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51861 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab0LHLgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Dec 2010 06:36:20 -0500
In-Reply-To: <alpine.LNX.2.01.1012071424310.22465@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/12/10 14:30, Jan Engelhardt wrote:
> 
> On Tuesday 2010-12-07 08:49, Pablo Neira Ayuso wrote:
>>
>>> I am skeptical about shrinkfitting something onto an older
>>> interface (nfnetlink) when there is genetlink..
>>
>> That's an empty argument. Tell me one feature that nfnetlink does not have have
>> but genetlink does.
> 
> I was thinking about the name resolution of netlink subsubsystems. In
> plain netlink and nfnetlink, subsys pointers are kept in a static
> array, which means the more subsystems are defined, the more memory
> is used (for n -> infinity) even if only one subsys is used.
> Would that be a reasonable concern?

The number of nfnetlink subsystem is small and it will remain small
along time I guess. I would not spend time on such optimization.

Anyway, the static subsys ID number is a good thing IMO.

The floating genetlink ID allows to have out-of-tree subsystems, which
is something that I don't like that. Moreover, you have to send an
initial message to resolve the ID number and subscribe to possible
changes in it.
