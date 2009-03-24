From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Some iptables-1.4.3 issues
Date: Tue, 24 Mar 2009 12:20:15 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903241219200.15443@fbirervta.pbzchgretzou.qr>
References: <49C79C90.80804@trash.net> <1237882157.9988.2533.camel@localhost> <alpine.LSU.2.00.0903240951060.25646@fbirervta.pbzchgretzou.qr> <49C8C146.3040507@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Volkov <pva@gentoo.org>, Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54562 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbZCXLUS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:20:18 -0400
In-Reply-To: <49C8C146.3040507@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-24 12:17, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> On Tuesday 2009-03-24 09:09, Peter Volkov wrote:
>> 
>>> There are some issues I experience with [the new iptables release]:
>>>
>>> 1. build fails:
>>>
>>> if i686-pc-linux-gnu-gcc -DHAVE_CONFIG_H -I. -I. -I.    -D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64     -D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations     -Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe   -DXTABLES_LIBDIR=\"/lib/xtables\" -DXTABLES_INTERNAL -I./include -I./include -I no/include -I no/include -DIPTABLES_MULTI -DNO_SHARED_LIBS=1 -O2 -march=i686 -pipe -mtune=i686 -march=pentium-m -ggdb -U_FORTIFY_SOURCE -MT iptables_static-xtables.o -MD -MP -MF ".deps/iptables_static-xtables.Tpo" -c -o iptables_static-xtables.o `test -f 'xtables.c' || echo './'`xtables.c; \
>>>        then mv -f ".deps/iptables_static-xtables.Tpo" ".deps/iptables_static-xtables.Po"; else rm -f ".deps/iptables_static-xtables.Tpo"; exit 1; fi
>>> xtables.c: In function 'xtables_find_target':
>>> xtables.c:641: error: 'LOAD_MUST_SUCCEED' undeclared (first use in this function)
>> 
>> Patrick,
>> 
>> There is a bit of a bigger issue here, I'll fix/queue and send pull req 
>> asap.
>
>I can apply Peter Volkov patches now. Is there anything that Peter did
>not cover?

Nope, it is complete as far as posted. But no patches were supplied
for issue (1) and (3)  :-)

Please pull from  git://dev.medozas.de/iptables master

to recive

Jan Engelhardt (2):
      iptables-save: minor corrections to the manpage markup
      libxt_hashlimit: add missing space for iptables-save output

Peter Volkov (2):
      libxtables: fix compile error due to incomplete change
      build: fix linker issue when LDFLAGS contains --as-needed

Updating c9477d0..1288bf7
Fast forward
 Makefile.am                  |    8 ++++----
 extensions/libxt_hashlimit.c |    2 +-
 ip6tables-save.8             |    9 ++++-----
 iptables-save.8              |    9 ++++-----
 xtables.c                    |    2 +-
 5 files changed, 14 insertions(+), 16 deletions(-)
