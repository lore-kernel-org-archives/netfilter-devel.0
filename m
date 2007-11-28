From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: IPT [PATCH] yay, autotools!
Date: Wed, 28 Nov 2007 12:48:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711281246420.16364@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr>
 <474D2B75.9070301@trash.net> <Pine.LNX.4.64.0711281149100.16364@fbirervta.pbzchgretzou.qr>
 <474D5010.10609@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38121 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759906AbXK1Lse (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:48:34 -0500
In-Reply-To: <474D5010.10609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 28 2007 12:25, Patrick McHardy wrote:
>> > >  - I think we should move all manuals to libxt_*.man or perhaps
>> > >  even *.man, would reduce Makefile LOC.
>> > You mean for the ones where we have an IPv4 and IPv6 version, but
>> > no xtables extension? I'm not sure they're all similar ...
>> >
>> I mean libipt_unclean.man -> libxt_unclean.man. The source file
>> libipt_unclean.c will persist. As unclean only matches libipt_%
>> the manpage will only land in iptables.8, not ip6tables.8.
>
> Then whats the advantage? Similar to the kernel, I think we should
> only use xt_ for things that actually support more than one
> address family.

Well, just look at it:

        for ext in $(1); do \
                f="${srcdir}/libxt_$$ext.man"; \
                if [ -f "$$f" ]; then \
                        echo ".SS $$ext"; \
                        cat "$$f"; \
                        continue; \
                fi; \
                f="${srcdir}/libipt_$$ext.man"; \
                if [ -f "$$f" ]; then \
                        echo ".SS $$ext"; \
                        cat "$$f"; \
                        continue; \
                fi; \
                f="${srcdir}/libip6t_$$ext.man"; \
                if [ -f "$$f" ]; then \
                        echo ".SS $$ext"; \
                        cat "$$f"; \
                        continue; \
                fi; \
        done >$@;

could be reduced to 1/3 of its size.

>> BTW, libipq inside iptables seems to be totally unused, is it still needed?
>
> Yes, people are still using it and the nfnetlink_queue compat library
> is still nonfunctional.
>
but *iptables* itself does not use it, does it? in which case
libipq should probably move to its own tarball, that is what
I was proposing.
