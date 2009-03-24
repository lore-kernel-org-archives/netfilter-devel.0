From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Some iptables-1.4.3 issues (was: Release of iptables-1.4.3)
Date: Tue, 24 Mar 2009 09:54:23 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903240951060.25646@fbirervta.pbzchgretzou.qr>
References: <49C79C90.80804@trash.net> <1237882157.9988.2533.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38544 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbZCXIy1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:54:27 -0400
In-Reply-To: <1237882157.9988.2533.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-24 09:09, Peter Volkov wrote:

>There are some issues I experience with [the new iptables release]:
>
>1. build fails:
>
>if i686-pc-linux-gnu-gcc -DHAVE_CONFIG_H -I. -I. -I.    -D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64     -D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations     -Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe   -DXTABLES_LIBDIR=\"/lib/xtables\" -DXTABLES_INTERNAL -I./include -I./include -I no/include -I no/include -DIPTABLES_MULTI -DNO_SHARED_LIBS=1 -O2 -march=i686 -pipe -mtune=i686 -march=pentium-m -ggdb -U_FORTIFY_SOURCE -MT iptables_static-xtables.o -MD -MP -MF ".deps/iptables_static-xtables.Tpo" -c -o iptables_static-xtables.o `test -f 'xtables.c' || echo './'`xtables.c; \
>        then mv -f ".deps/iptables_static-xtables.Tpo" ".deps/iptables_static-xtables.Po"; else rm -f ".deps/iptables_static-xtables.Tpo"; exit 1; fi
>xtables.c: In function 'xtables_find_target':
>xtables.c:641: error: 'LOAD_MUST_SUCCEED' undeclared (first use in this function)

Patrick,

There is a bit of a bigger issue here, I'll fix/queue and send pull req 
asap.
