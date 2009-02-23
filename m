From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] conntrack-tools 0.9.11 released
Date: Mon, 23 Feb 2009 17:55:07 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902231753190.12150@fbirervta.pbzchgretzou.qr>
References: <49A03C73.8010004@netfilter.org> <20090222233433.0dc8f396@liberty.rlwhome.lan> <alpine.LSU.2.00.0902230815570.20446@fbirervta.pbzchgretzou.qr> <49A26A3E.5020707@netfilter.org> <20090223093416.2c63fc02@liberty.rlwhome.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Robby Workman <rw@rlworkman.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47019 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZBWQzK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:55:10 -0500
In-Reply-To: <20090223093416.2c63fc02@liberty.rlwhome.lan>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-23 16:34, Robby Workman wrote:
>On Mon, 23 Feb 2009 10:19:58 +0100
>Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >> I thought I recalled seeing discussion about this already, but I
>> >> don't see it in my archives, so maybe not.   With glibc-2.7, this
>> >> release builds fine; however, with glibc-2.9, both src/mcast.c and
>> >> src/sync-mode.c need limits.h included, or else INT_MAX is
>> >> undefined.
>> > 
>> > This builds fine for me - and I am on glibc 2.9.
>> > Just *what* is it in (which distro? Debian/Ubuntu again?)
>> > again to constantly fail on INT_MAX?
>> 
>> Indeed. This also compiles fine for me in debian. I have committed a
>> patch for this [1]. This issue is unfortunate. Gentoo bugzilla on
>> conntrack-tools had a patch but nobody has sent it to me. I notice it
>> after the release.
>
>
>Weird that it's not affecting Jan then, because it's definitely
>something specific to newer glibc (or perhaps gcc, but it's not
>immediately obvious how that would be the case). I'm on Slackware 
>rather than Gentoo, running quite a bit of prerelease development 
>builds (including gcc-4.3.3 and glibc-2.9 along with 2.6.28.7 kernel).

gcc [long command line as spouted by make] -E mcast.c | grep '^#'

After hand-filtering, the apparent sequence is:

# 5 "../include/mcast.h" 2
# 1 "/usr/include/netinet/in.h" 1 3 4
# 1 "/usr/include/sys/socket.h" 1 3 4
# 31 "/usr/include/bits/socket.h" 2 3 4
# 1 "/usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/limits.h" 1 3 4

so <limits.h> is included via <bits/socket.h> is included via <sys/socket.h>
etc. How is your stack trace?
