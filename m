From: Jan Engelhardt <jengelh@medozas.de>
Subject: poc: link modules into one .ko
Date: Sat, 6 Sep 2008 18:29:19 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809061436440.22690@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43369 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYIFW3W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Sep 2008 18:29:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I went over the suggestion of collapsing module files again [1]. For 
fun and research, instead of combining specific modules, I have set out 
to combine everything into a single module.

[1] http://marc.info/?l=netfilter-devel&m=121148631320895&w=2

All .ko modules together clock in at 1037772 bytes of diskspace, and 
they are likely to use just as much kernel memory when loaded (strip a 
few ELF stuff, and then round up to the next PAGE_SIZE again).

After the patch, the stats are much different:
-rw-r--r-- 1 jengelh 160910 2008-09-06 18:15 xtables_ext.ko
-rw-r--r-- 1 jengelh  57967 2008-09-06 18:15 xtables_xct.ko
-rw-r--r-- 1 jengelh  27295 2008-09-06 18:15 xtables_xnat.ko
-rw-r--r-- 1 jengelh  47550 2008-09-06 18:15 xtables_xv6.ko

293722 bytes, that is approximately a 70% reduction in disk and memory 
usage. (There are three modules not in this POC xtables_*.ko.) However, 
as a result, currently *all* extensions are loaded, which might incur 
extra memory being used.

The proof-of-concept patch is not too pretty, but it extrapolates one 
way to deal with the module flood (which has been inflating compile 
times and whatnot), and it does so without moving tons of code around. I 
think the only way to shove off more bytes is to revamp the API a bit 
and even try to reduce the amount of .o files during build.

The four xtables_*.ko files represent (no dependencies), (dependency on 
conntrack), (dependency on NAT) and (dependency on IPv6). Of course we 
should be keeping an eye on users who want a tiny system and not pull in 
unneeded dependencies - hence the split into actually four .ko files.

Interested parties are directed to the top commit of the koredux 
("reduction of number of .ko files") branch:

  git://dev.medozas.de/linux koredux
  http://dev.medozas.de/gitweb.cgi?p=linux;h=koredux;a=shortlog
