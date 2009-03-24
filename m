From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Some iptables-1.4.3 issues
Date: Tue, 24 Mar 2009 12:38:10 +0100
Message-ID: <49C8C622.3060805@netfilter.org>
References: <49C79C90.80804@trash.net> <1237882157.9988.2533.camel@localhost> <alpine.LSU.2.00.0903240951060.25646@fbirervta.pbzchgretzou.qr> <49C8C146.3040507@netfilter.org> <alpine.LSU.2.00.0903241219200.15443@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Peter Volkov <pva@gentoo.org>, Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41161 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755836AbZCXLiY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:38:24 -0400
In-Reply-To: <alpine.LSU.2.00.0903241219200.15443@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-03-24 12:17, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> On Tuesday 2009-03-24 09:09, Peter Volkov wrote:
>>>
>>>> There are some issues I experience with [the new iptables release]:
>>>>
>>>> 1. build fails:
>>>>
>>>> if i686-pc-linux-gnu-gcc -DHAVE_CONFIG_H -I. -I. -I.    -D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64     -D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations     -Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe   -DXTABLES_LIBDIR=\"/lib/xtables\" -DXTABLES_INTERNAL -I./include -I./include -I no/include -I no/include -DIPTABLES_MULTI -DNO_SHARED_LIBS=1 -O2 -march=i686 -pipe -mtune=i686 -march=pentium-m -ggdb -U_FORTIFY_SOURCE -MT iptables_static-xtables.o -MD -MP -MF ".deps/iptables_static-xtables.Tpo" -c -o iptables_static-xtables.o `test -f 'xtables.c' || echo './'`xtables.c; \
>>>>        then mv -f ".deps/iptables_static-xtables.Tpo" ".deps/iptables_static-xtables.Po"; else rm -f ".deps/iptables_static-xtables.Tpo"; exit 1; fi
>>>> xtables.c: In function 'xtables_find_target':
>>>> xtables.c:641: error: 'LOAD_MUST_SUCCEED' undeclared (first use in this function)
>>> Patrick,
>>>
>>> There is a bit of a bigger issue here, I'll fix/queue and send pull req 
>>> asap.
>> I can apply Peter Volkov patches now. Is there anything that Peter did
>> not cover?
> 
> Nope, it is complete as far as posted. But no patches were supplied
> for issue (1) and (3)  :-)
> 
> Please pull from  git://dev.medozas.de/iptables master

Pulled and pushed. Thanks. If there's no more complains, we can release
the 1.4.3.1.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
