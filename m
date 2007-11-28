From: Patrick McHardy <kaber@trash.net>
Subject: Re: IPT [PATCH] yay, autotools!
Date: Wed, 28 Nov 2007 12:25:04 +0100
Message-ID: <474D5010.10609@trash.net>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr> <474D2B75.9070301@trash.net> <Pine.LNX.4.64.0711281149100.16364@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44312 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275AbXK1LZM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:25:12 -0500
In-Reply-To: <Pine.LNX.4.64.0711281149100.16364@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 28 2007 09:48, Patrick McHardy wrote:
>>> Converts the iptables build infrastructure to autotools.
>> Oh joy :)
>>
>>> Many important changes. Should read INSTALL as a start.
>>>
>>>  - iptables-static will be a multi binary. I doubt you want split
>>>  binaries on embedded anyway (diskspace constraints).
>>>
>>>  - A new binary, iptables-mtss is built (semi-static, with glibc but
>>>  without plugins).
>>>
>>>  I do not think iptables-static makes any sense (neither now nor
>>>  before this move to autotools), because ld rightly tells me that
>>>  building with -static will cause loading of glibc parts /anyway/
>>>  because of getserv*() in xt_dccp and so on.
>> Well, the reason for linking statically is IMO not to be able to run
>> without a libc but to avoid having tons of shared object files.
>>
> Ah. Then I'll just move -mtss to -static.
> 
>>>  - not so happy with .*-test yet, but I really wanted to get rid of
>>>  the fixed module list in extensions/Makefile because it's just a
>>>  .rej PITA.
>> We only have two .test files left, and frankly I think the concept
>> sucks, if you look at the lists you'll find plenty of reports of
>> people missing extensions because their distribution built against
>> an old kernel. Thats why I included the headers and moved to
>> unconditional building for every single extension that is or has
>> been supported by mainline kernel.
>>
> If I can throw the three .*-tests out, the better. But would need to
> add ipt_condition.h, ip6t_conditoin, ipt_set and ipt_SET, which
> all are not in the kernel at this point. Nuke the modules?


For condition, sure. For set lets hear Jozsef's opinion, but since
the kernel has to be patched anyway I think it shouldn't be much
trouble to move the userspace part to pomng as well if it can't
be supported.

>>> 	- any reason not to always build ipv6 unconditionally?
>> I can't think of one.
> 
> Then I'll nuke DO_IPV6, simplifies makefiles.
> 
>>>  - I think we should move all manuals to libxt_*.man or perhaps
>>>  even *.man, would reduce Makefile LOC.
>> You mean for the ones where we have an IPv4 and IPv6 version, but
>> no xtables extension? I'm not sure they're all similar ...
>>
> I mean libipt_unclean.man -> libxt_unclean.man. The source file
> libipt_unclean.c will persist. As unclean only matches libipt_%
> the manpage will only land in iptables.8, not ip6tables.8.


Then whats the advantage? Similar to the kernel, I think we should
only use xt_ for things that actually support more than one
address family.

>> In general, I don't have an opinion on this patch other that
>> I think all the autotool stuff is way to complicated. Your
>> patch looks reasonable simple, so I'm not objecting, but I'd
>> like to hear some arguments what this is buying us.
> 
> I followed the shout-out in the original Makefile:
> 
> # Need libc6 for this.  FIXME: Should covert to autoconf.
> ifeq ($(shell [ -f /usr/include/netinet/ip6.h ] && echo YES), YES)
> DO_IPV6:=1
> endif

Fair enough :)

> So I did that. Though now that is gone, it has lost a bit of appeal,
> but it is still very nice. Main benefit is that you only need to
> specify what to build, and do not care about the 'install' target, or
> how to call GCC. Just the bare minimum, which is cflags,
> ldflags/ldadd (and then not always).
> 
> Makfile: 272 LOC
> Makefile.am: 101 LOC (with ipv6 ifdef)
> 
> In the old days, I used to compile my kernels from scratch, but that
> got tedius when having more than a handful of machines.
> 
> Same for makefiles, once I had a fair number of them, updating every
> single Makefile with a new idea I had (quick autodeps using -MMD,
> silence (AM_VERBOSE_*), common compiler flags), I had to dig up all
> Makefiles and adjust them.  It took much convincing to go autotools
> there, but if a program just does not compile because two linux
> distros have their stuff in different places and there is no
> pkgconfig, you will be thankful. 
> 
>> I assume
>> the changes above could also be achieved with some simple
>> changes to the existing Makefile.
> 
> You would have to pass all flags to make on every invocation (bitten
> me before, forgot to use COPT_FLAGSwhat=-ggdb3), with ./configure you
> can specify it once for all (and during make, if you really desire
> so).
> You can also run make from within extensions/ which was not
> previously possible.
> Building static and shared besides each other would require yet
> more compilation rules in the toplevel ./Makefile where autotools can
> take over doing the right thing.


OK fine.

> BTW, libipq inside iptables seems to be totally unused, is it still needed?


Yes, people are still using it and the nfnetlink_queue compat library
is still nonfunctional.

