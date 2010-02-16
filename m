From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons suggestions
Date: Tue, 16 Feb 2010 21:23:28 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002162057390.20293@obet.zrqbmnf.qr>
References: <20100216215128.1c154cdb@outerspace>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44408 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab0BPUX3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:23:29 -0500
In-Reply-To: <20100216215128.1c154cdb@outerspace>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-02-16 20:51, Jonas Berlin wrote:
>
>Hi, I am using xtables-addons-1.22 and needed to do some changes to get
>it to compile in my setup. I thus present a few suggestions below:
>
>1. When using --with-xtables, I got problems at linking time, failing
>to find libxtables.. By changing configure.ac like below I was able to
>solve the issue.
>
>  libxtables_LIBS="-lxtables";
>   to
>  libxtables_LIBS="-lxtables -L $xtables_location/lib";

 --with-xtables is supposed to specify an iptables directory directly;
if at all, -L$xtables_location/.libs would have been the right option
(due to how libtool stores its files).

I guess it makes more sense to just remove --with-xtables and let the
user set PKG_CONFIG_PATH and/or CFLAGS,LDFLAGS accordingly instead,
which should have the same result.

>Currently only the include search paths are affected by the
>- --with-xtables argument. It seems there could have been an option to
>instruct pkg-config to look for the xtables.pc file in the non-standard
>location, but I noticed that too late.
>
>2. When using --with-kbuild, I got some strange compile errors which
>ended up being because it used header files from /usr/include/linux
>instead of from the path given to --with-kbuild.

 --with-kbuild only affects the build of the kernel modules (which
does not use /usr/include at all) and this is intentional. Userspace
should only use exported headers such as those from /usr/include
or linux-2.6.xy/usr/include.

>In fact, I was unable
>to find anything that would use the --with-kbuild argument.

extensions/Makefile.am:_kcall = -C ${kbuilddir} M=${abs_srcdir}
