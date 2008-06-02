From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] iptables version defines
Date: Mon, 2 Jun 2008 17:32:56 +0200
Message-ID: <200806021732.57124.thomas.jarosch@intra2net.com>
References: <200806021549.15005.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0806021646350.4055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pKBRIm7d3X3Zb/P"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:33697 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYFBPdI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:33:08 -0400
In-Reply-To: <alpine.LNX.1.10.0806021646350.4055@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_pKBRIm7d3X3Zb/P
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Jan,

On Monday, 2. June 2008 16:54:57 you wrote:
> > #define XTABLES_VERSION "@PACKAGE_VERSION@"
> >+#define XTABLES_VERSION_CODE (0x10000 * @XTABLES_VERSION_MAJOR@ + 0x100 *
> > @XTABLES_VERSION_MINOR@ + @XTABLES_VERSION_PATCH@) +
> >+#define XTABLES_VERSION_CHECK(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
>
> Mh.... too much arithmetic for my taste, just use bitops like
> linux/version.h. Also, regarding the _CHECK name, I'd propose
> "XTABLES_API_VERSION" instead, which should look nicer on
> 	#if XTABLES_VERSION_CODE < XTABLES_API_VERSION(1,4,0)
> 	#error Upgrade, yo!
> 	#endif
>
>
> #define XTABLES_API_VERSION(a,b,c) (((a) << 16) | ((b) << 8) | (c))

As you already pointed out, it's a matter of taste and neither
of both versions will hurt as it will be expanded at compile time.

Infact, imagine we would add another version level like "(x) << 32",
on x86 it is only valid to do a left shift operation for 0-31 bits
and so it could fail...

> >+#define XTABLES_VERSION_MAJOR(x)  (((x)>>16) & 0xFF)
> >+#define XTABLES_VERSION_MINOR(x)  (((x)>> 8) & 0xFF)
> >+#define XTABLES_VERSION_PATCH(x)  ( (x)      & 0xFF)
>
> I do not see a need for these three. The linux kernel does not
> have such either, so please don't overdesign :)

Well, I've created the same macros as there are already in include/iptables.h.

I'm alright with your proposed change to XTABLES_API_VERSION
and the drop of _MAJOR, _MINOR and _PATCH macros as
one can easily check for same thing via "xyz < XTABLES_API_VERSION(2,6,0)"

Attached is an updated patch.

Thomas

--Boundary-00=_pKBRIm7d3X3Zb/P
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="iptables-add-version.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iptables-add-version.patch"

Add xtables version defines.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

diff -u -r iptables-1.4.1-rc2/configure.ac iptables.version/configure.ac
--- iptables-1.4.1-rc2/configure.ac	Mon May 26 14:23:58 2008
+++ iptables.version/configure.ac	Mon Jun  2 17:19:42 2008
@@ -1,5 +1,11 @@
+define([_XTABLES_VERSION_MAJOR], 1)
+define([_XTABLES_VERSION_MINOR], 4)
+define([_XTABLES_VERSION_PATCH], 1)
+define([_XTABLES_VERSION_EXTRA], -rc2)
 
-AC_INIT([iptables], [1.4.1-rc2])
+define([_XTABLES_VERSION],_XTABLES_VERSION_MAJOR._XTABLES_VERSION_MINOR._XTABLES_VERSION_PATCH[]_XTABLES_VERSION_EXTRA)
+
+AC_INIT([iptables], _XTABLES_VERSION)
 AC_CONFIG_HEADERS([config.h])
 AC_PROG_INSTALL
 AM_INIT_AUTOMAKE
@@ -56,4 +62,14 @@
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
 AC_SUBST([xtlibdir])
+
+XTABLES_VERSION_MAJOR=_XTABLES_VERSION_MAJOR
+XTABLES_VERSION_MINOR=_XTABLES_VERSION_MINOR
+XTABLES_VERSION_PATCH=_XTABLES_VERSION_PATCH
+XTABLES_VERSION_EXTRA=_XTABLES_VERSION_EXTRA
+AC_SUBST([XTABLES_VERSION_MAJOR])
+AC_SUBST([XTABLES_VERSION_MINOR])
+AC_SUBST([XTABLES_VERSION_PATCH])
+AC_SUBST([XTABLES_VERSION_EXTRA])
+
 AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile include/xtables.h])
diff -u -r iptables-1.4.1-rc2/include/xtables.h.in iptables.version/include/xtables.h.in
--- iptables-1.4.1-rc2/include/xtables.h.in	Mon May 26 14:15:40 2008
+++ iptables.version/include/xtables.h.in	Mon Jun  2 17:20:55 2008
@@ -18,6 +18,9 @@
 #endif
 
 #define XTABLES_VERSION "@PACKAGE_VERSION@"
+#define XTABLES_VERSION_CODE (0x10000 * @XTABLES_VERSION_MAJOR@ + 0x100 * @XTABLES_VERSION_MINOR@ + @XTABLES_VERSION_PATCH@)
+
+#define XTABLES_API_VERSION(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
 
 /* Include file for additions: new matches and targets. */
 struct xtables_match

--Boundary-00=_pKBRIm7d3X3Zb/P--
