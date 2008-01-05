From: Max Kellermann <max@duempel.org>
Subject: Re: conntrackd won't start, "can't open multicast server!"
Date: Sat, 5 Jan 2008 18:29:56 +0100
Message-ID: <20080105172955.GA14295@swift.blarg.de>
References: <20080104081007.GA30807@swift.blarg.de> <477F94BC.40804@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [78.31.71.42] ([78.31.71.42]:42670 "HELO duempel.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1755443AbYAER35 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 12:29:57 -0500
Content-Disposition: inline
In-Reply-To: <477F94BC.40804@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/05 15:31, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> You forgot the -S option to run it in statistics mode. I know that this
> option is a bit confusing so I have applied a patch to obsolete it.
> Thus, you won't need to pass -S to conntrackd anymore in the upcoming
> 0.9.6 release.

Right, with -S it starts up.  Somehow I must have missed that option
in the --help text.

By the way, it is not possible to run "conntrackd --help" as user.  It
would be nice if users could view the usage information.  Why does
conntrackd check the capability mask at all?

The conntrackd manual page is missing in the source distribution, it
might be in SVN, since it is displayed on the conntrack-tools home
page.

I noticed conntrackd runs select() with a 200ms timeout, i.e. it wakes
up 5 times a second only to see that there is nothing to do.  Why
that?  This leads to increased power consumption for no good.

When I stop the daemon (running in foreground) with Ctrl-C, glibc
detects a heap corruption:

*** glibc detected *** /usr/sbin/conntrackd: corrupted double-linked
    list: 0x0000000000631d40 ***
======= Backtrace: =========
/lib/libc.so.6[0x2afb493221cc]
/lib/libc.so.6(cfree+0x8c)[0x2afb49325b5c]
/usr/lib/libnetfilter_conntrack.so.1(nfct_close+0x6f)[0x2afb48e9db2f]
/usr/sbin/conntrackd[0x4032de]
/lib/libc.so.6[0x2afb492e0040]
/lib/libc.so.6(sigprocmask+0x10)[0x2afb492e0440]
/usr/sbin/conntrackd[0x403350]
/lib/libc.so.6[0x2afb492e0040]
/lib/libc.so.6(__select+0x13)[0x2afb4937eb33]
/usr/sbin/conntrackd[0x402dd5]
/usr/sbin/conntrackd[0x402924]
/lib/libc.so.6(__libc_start_main+0xf4)[0x2afb492cc1c4]
/usr/sbin/conntrackd[0x402239]

I am using libnetfilter_conntrack 0.0.82.

Max

