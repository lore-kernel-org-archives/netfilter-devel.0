From: Patrick McHardy <kaber@trash.net>
Subject: Re: IPT [PATCH] yay, autotools!
Date: Wed, 28 Nov 2007 12:58:23 +0100
Message-ID: <474D57DF.1030002@trash.net>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr> <474D2B75.9070301@trash.net> <Pine.LNX.4.64.0711281149100.16364@fbirervta.pbzchgretzou.qr> <474D5010.10609@trash.net> <Pine.LNX.4.64.0711281246420.16364@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45022 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXK1L6Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:58:25 -0500
In-Reply-To: <Pine.LNX.4.64.0711281246420.16364@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 28 2007 12:25, Patrick McHardy wrote:
>>>>>  - I think we should move all manuals to libxt_*.man or perhaps
>>>>>  even *.man, would reduce Makefile LOC.
>>>> You mean for the ones where we have an IPv4 and IPv6 version, but
>>>> no xtables extension? I'm not sure they're all similar ...
>>>>
>>> I mean libipt_unclean.man -> libxt_unclean.man. The source file
>>> libipt_unclean.c will persist. As unclean only matches libipt_%
>>> the manpage will only land in iptables.8, not ip6tables.8.
>> Then whats the advantage? Similar to the kernel, I think we should
>> only use xt_ for things that actually support more than one
>> address family.
> 
> Well, just look at it:
> 
>         for ext in $(1); do \
>                 f="${srcdir}/libxt_$$ext.man"; \
>                 if [ -f "$$f" ]; then \
>                         echo ".SS $$ext"; \
>                         cat "$$f"; \
>                         continue; \
>                 fi; \
>                 f="${srcdir}/libipt_$$ext.man"; \
>                 if [ -f "$$f" ]; then \
>                         echo ".SS $$ext"; \
>                         cat "$$f"; \
>                         continue; \
>                 fi; \
>                 f="${srcdir}/libip6t_$$ext.man"; \
>                 if [ -f "$$f" ]; then \
>                         echo ".SS $$ext"; \
>                         cat "$$f"; \
>                         continue; \
>                 fi; \
>         done >$@;
> 
> could be reduced to 1/3 of its size.

size isn't everything :)

>>> BTW, libipq inside iptables seems to be totally unused, is it still needed?
>> Yes, people are still using it and the nfnetlink_queue compat library
>> is still nonfunctional.
>>
> but *iptables* itself does not use it, does it? in which case
> libipq should probably move to its own tarball, that is what
> I was proposing.


We could do that I guess, though I'm expecting a bunch of complaints
from people who are used to get it from the iptables source.

