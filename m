From: Patrick McHardy <kaber@trash.net>
Subject: Re: IPT [PATCH] yay, autotools!
Date: Wed, 28 Nov 2007 09:48:53 +0100
Message-ID: <474D2B75.9070301@trash.net>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40633 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbXK1Is7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:48:59 -0500
In-Reply-To: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> 	"The Reason For Holding Off 1.4.0"
> 
> Converts the iptables build infrastructure to autotools.

Oh joy :)

> Many important changes. Should read INSTALL as a start.
> 
> 	- iptables-static will be a multi binary. I doubt you want split
> 	binaries on embedded anyway (diskspace constraints).
> 
> 	- A new binary, iptables-mtss is built (semi-static, with glibc but
> 	without plugins).
> 
> 	I do not think iptables-static makes any sense (neither now nor
> 	before this move to autotools), because ld rightly tells me that
> 	building with -static will cause loading of glibc parts /anyway/
> 	because of getserv*() in xt_dccp and so on.

Well, the reason for linking statically is IMO not to be able to run
without a libc but to avoid having tons of shared object files.

> 
> 	- Can build both (full, semi-)static and dynamic at the same time
> 
> 	- not so happy with .*-test yet, but I really wanted to get rid of
> 	the fixed module list in extensions/Makefile because it's just a
> 	.rej PITA.


We only have two .test files left, and frankly I think the concept
sucks, if you look at the lists you'll find plenty of reports of
people missing extensions because their distribution built against
an old kernel. Thats why I included the headers and moved to
unconditional building for every single extension that is or has
been supported by mainline kernel.

> 	- any reason not to always build ipv6 unconditionally?

I can't think of one.
> 
> 	- I think we should move all manuals to libxt_*.man or perhaps
> 	even *.man, would reduce Makefile LOC.

You mean for the ones where we have an IPv4 and IPv6 version, but
no xtables extension? I'm not sure they're all similar ...

> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> Patch instructions:
>  delete Makefile
>  delete extensions/Makefile
>  delete libiptc/Makefile
>  create autogen.sh with mode 0755
>  rename libipt_dscp_helper.c to dscp_helper.c (delete hunks before applying)


In general, I don't have an opinion on this patch other that
I think all the autotool stuff is way to complicated. Your
patch looks reasonable simple, so I'm not objecting, but I'd
like to hear some arguments what this is buying us. I assume
the changes above could also be achieved with some simple
changes to the existing Makefile.
