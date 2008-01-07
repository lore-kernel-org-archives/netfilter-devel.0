From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd won't start, "can't open multicast server!"
Date: Mon, 07 Jan 2008 12:09:42 +0100
Message-ID: <47820876.8030204@netfilter.org>
References: <20080104081007.GA30807@swift.blarg.de> <477F94BC.40804@netfilter.org> <20080105172955.GA14295@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50470 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753997AbYAGLJy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:09:54 -0500
In-Reply-To: <20080105172955.GA14295@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> On 2008/01/05 15:31, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> You forgot the -S option to run it in statistics mode. I know that this
>> option is a bit confusing so I have applied a patch to obsolete it.
>> Thus, you won't need to pass -S to conntrackd anymore in the upcoming
>> 0.9.6 release.
> 
> Right, with -S it starts up.  Somehow I must have missed that option
> in the --help text.
> 
> By the way, it is not possible to run "conntrackd --help" as user.  It
> would be nice if users could view the usage information.  Why does
> conntrackd check the capability mask at all?

Netlink requires CAP_NET_ADMIN. conntrackd checks for it before
starting. I'm going to do the capability checking later so that the help
message can be shown. I'll commit a patch later.

> The conntrackd manual page is missing in the source distribution, it
> might be in SVN, since it is displayed on the conntrack-tools home
> page.

The conntrackd page wasn't available in 0.9.5, but it will in 0.9.6.
It's impossible that we can bundle something to a package when it didn't
exist at that time :)

> I noticed conntrackd runs select() with a 200ms timeout, i.e. it wakes
> up 5 times a second only to see that there is nothing to do.  Why
> that?  This leads to increased power consumption for no good.

I have implemented alarms based on times slices so I use select to wake
up expired alarms once the slice has been consumed. Are you really
observing this power consumption increment?

> When I stop the daemon (running in foreground) with Ctrl-C, glibc
> detects a heap corruption:
> 
> *** glibc detected *** /usr/sbin/conntrackd: corrupted double-linked
>     list: 0x0000000000631d40 ***
> ======= Backtrace: =========
> /lib/libc.so.6[0x2afb493221cc]
> /lib/libc.so.6(cfree+0x8c)[0x2afb49325b5c]
> /usr/lib/libnetfilter_conntrack.so.1(nfct_close+0x6f)[0x2afb48e9db2f]
> /usr/sbin/conntrackd[0x4032de]
> /lib/libc.so.6[0x2afb492e0040]
> /lib/libc.so.6(sigprocmask+0x10)[0x2afb492e0440]
> /usr/sbin/conntrackd[0x403350]
> /lib/libc.so.6[0x2afb492e0040]
> /lib/libc.so.6(__select+0x13)[0x2afb4937eb33]
> /usr/sbin/conntrackd[0x402dd5]
> /usr/sbin/conntrackd[0x402924]
> /lib/libc.so.6(__libc_start_main+0xf4)[0x2afb492cc1c4]
> /usr/sbin/conntrackd[0x402239]

I'll investigate this. Are you using 0.9.5 or a SVN snapshot? Are you
using the `alarm' mode (formely known as `persistent')?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
