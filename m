From: Patrick McHardy <kaber@trash.net>
Subject: Re: poc: link modules into one .ko
Date: Tue, 09 Sep 2008 07:19:32 +0200
Message-ID: <48C60764.9040400@trash.net>
References: <alpine.LNX.1.10.0809061436440.22690@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61695 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYIIFTf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:19:35 -0400
In-Reply-To: <alpine.LNX.1.10.0809061436440.22690@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> I went over the suggestion of collapsing module files again [1]. For 
> fun and research, instead of combining specific modules, I have set out 
> to combine everything into a single module.
> 
> [1] http://marc.info/?l=netfilter-devel&m=121148631320895&w=2
> 
> All .ko modules together clock in at 1037772 bytes of diskspace, and 
> they are likely to use just as much kernel memory when loaded (strip a 
> few ELF stuff, and then round up to the next PAGE_SIZE again).
> 
> After the patch, the stats are much different:
> -rw-r--r-- 1 jengelh 160910 2008-09-06 18:15 xtables_ext.ko
> -rw-r--r-- 1 jengelh  57967 2008-09-06 18:15 xtables_xct.ko
> -rw-r--r-- 1 jengelh  27295 2008-09-06 18:15 xtables_xnat.ko
> -rw-r--r-- 1 jengelh  47550 2008-09-06 18:15 xtables_xv6.ko
> 
> 293722 bytes, that is approximately a 70% reduction in disk and memory 
> usage. (There are three modules not in this POC xtables_*.ko.) However, 
> as a result, currently *all* extensions are loaded, which might incur 
> extra memory being used.
> 
> The proof-of-concept patch is not too pretty, but it extrapolates one 
> way to deal with the module flood (which has been inflating compile 
> times and whatnot), and it does so without moving tons of code around. I 
> think the only way to shove off more bytes is to revamp the API a bit 
> and even try to reduce the amount of .o files during build.

Its really not pretty :) While I agree that this does make sense
for the commonly used modules and distribution kernels, I don't
think it belongs here. A kbuild option to combine related modules
would be preferrable in my opinion.
