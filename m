From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] iptables version defines
Date: Mon, 2 Jun 2008 16:54:57 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806021646350.4055@fbirervta.pbzchgretzou.qr>
References: <200806021549.15005.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48629 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYFBOy7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:54:59 -0400
In-Reply-To: <200806021549.15005.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-06-02 15:49, Thomas Jarosch wrote:
>> I don't care about uglyness as long as it stays in external
>> code. So if someone sends me a patch to add this version
>> define, I'll add it.
>
>External code has to be "ugly" if you want to keep the user
>experience high. I don't feel like breaking ipt_ACCOUNT for older
>iptables versions without any real gain, it should work out of the
>box with iptables 1.4.0 and 1.4.1.

External code does not _necessarily_ have to be ugly; at least
one can make it so as to reduce the lot of redundant #if hackery;
xt-a does this for the kernel interface already, it should not be
hard to do the same for the iptables API once it becomes necessary.
For that to work, we need a XTABLES_VERSION_CODE, and since your
patch does just that, you get my approval. Comments follow...

>Add xtables version defines.
>
>Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
>
>--- iptables-1.4.1-rc2/configure.ac	Mon May 26 14:23:58 2008
>+++ iptables.version/configure.ac	Mon Jun  2 15:05:57 2008
>@@ -1,5 +1,11 @@
>+define([_XTABLES_VERSION_MAJOR], 1)
>+define([_XTABLES_VERSION_MINOR], 4)
>+define([_XTABLES_VERSION_PATCH], 1)
>+define([_XTABLES_VERSION_EXTRA], -rc2)
> 
>-AC_INIT([iptables], [1.4.1-rc2])
>+define([_XTABLES_VERSION],_XTABLES_VERSION_MAJOR._XTABLES_VERSION_MINOR._XTABLES_VERSION_PATCH[]_XTABLES_VERSION_EXTRA)
>+
>+AC_INIT([iptables], _XTABLES_VERSION)
> AC_CONFIG_HEADERS([config.h])
> AC_PROG_INSTALL
> AM_INIT_AUTOMAKE
>@@ -56,4 +62,14 @@
> AC_SUBST([kbuilddir])
> AC_SUBST([ksourcedir])
> AC_SUBST([xtlibdir])
>+
>+XTABLES_VERSION_MAJOR=_XTABLES_VERSION_MAJOR
>+XTABLES_VERSION_MINOR=_XTABLES_VERSION_MINOR
>+XTABLES_VERSION_PATCH=_XTABLES_VERSION_PATCH
>+XTABLES_VERSION_EXTRA=_XTABLES_VERSION_EXTRA
>+AC_SUBST([XTABLES_VERSION_MAJOR])
>+AC_SUBST([XTABLES_VERSION_MINOR])
>+AC_SUBST([XTABLES_VERSION_PATCH])
>+AC_SUBST([XTABLES_VERSION_EXTRA])
>+
> AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile include/xtables.h])
>--- iptables-1.4.1-rc2/include/xtables.h.in	Mon May 26 14:15:40 2008
>+++ iptables.version/include/xtables.h.in	Mon Jun  2 15:03:46 2008
>@@ -18,6 +18,12 @@
> #endif
> 
> #define XTABLES_VERSION "@PACKAGE_VERSION@"
>+#define XTABLES_VERSION_CODE (0x10000 * @XTABLES_VERSION_MAJOR@ + 0x100 * @XTABLES_VERSION_MINOR@ + @XTABLES_VERSION_PATCH@)
>+
>+#define XTABLES_VERSION_CHECK(x,y,z)    (0x10000*(x) + 0x100*(y) + z)

Mh.... too much arithmetic for my taste, just use bitops like
linux/version.h. Also, regarding the _CHECK name, I'd propose
"XTABLES_API_VERSION" instead, which should look nicer on
	#if XTABLES_VERSION_CODE < XTABLES_API_VERSION(1,4,0)
	#error Upgrade, yo!
	#endif


#define XTABLES_API_VERSION(a,b,c) (((a) << 16) | ((b) << 8) | (c))


>+#define XTABLES_VERSION_MAJOR(x)  (((x)>>16) & 0xFF)
>+#define XTABLES_VERSION_MINOR(x)  (((x)>> 8) & 0xFF)
>+#define XTABLES_VERSION_PATCH(x)  ( (x)      & 0xFF)

I do not see a need for these three. The linux kernel does not
have such either, so please don't overdesign :)

