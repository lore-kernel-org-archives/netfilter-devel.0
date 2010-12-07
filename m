From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Tue, 7 Dec 2010 14:30:30 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012071424310.22465@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org>
 <alpine.LNX.2.01.1012032156100.26825@obet.zrqbmnf.qr> <4CFDE6FB.4060103@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39121 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab0LGNab (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:30:31 -0500
In-Reply-To: <4CFDE6FB.4060103@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-12-07 08:49, Pablo Neira Ayuso wrote:
>
>> I am skeptical about shrinkfitting something onto an older
>> interface (nfnetlink) when there is genetlink..
>
> That's an empty argument. Tell me one feature that nfnetlink does not have have
> but genetlink does.

I was thinking about the name resolution of netlink subsubsystems. In
plain netlink and nfnetlink, subsys pointers are kept in a static
array, which means the more subsystems are defined, the more memory
is used (for n -> infinity) even if only one subsys is used.
Would that be a reasonable concern?
