From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] iptables version defines
Date: Mon, 2 Jun 2008 15:49:14 +0200
Message-ID: <200806021549.15005.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ap/QIeqlmuHzy4W"
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:48107 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYFBNtx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:49:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_ap/QIeqlmuHzy4W
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Patrick,

[resent as I somehow sent an HTML email at first]

> >>>> #ifdef _XTABLES_H
> >>>> init(struct xt_entry_target *t)
> >>>> #else
> >>>> init(struct ipt_entry_target *t, unsigned int *nfcache)
> >>>> #endif
> >
> > Woah this is ridiculously ugly. (Remember, such constructs were
> > just eliminated from the kernel in the past years.)
>
> I don't care about uglyness as long as it stays in external
> code. So if someone sends me a patch to add this version
> define, I'll add it.

External code has to be "ugly" if you want to keep the user experience high.
I don't feel like breaking ipt_ACCOUNT for older iptables versions without
any real gain, it should work out of the box with iptables 1.4.0 and 1.4.1.

Attached is a patch to add the new defines. The macro XTABLES_VERSION
is already in use, so I named it XTABLES_VERSION_CHECK. I've also tested
that an empty XTABLES_VERSION_EXTRA in configure.ac works.

Now we can write code like this:

#if XTABLES_VERSION_CODE < XTABLES_VERSION_CHECK(1,5,0)
=A0 =A0 #warning You are obselete and will be assimilated.
#endif

Cheers,
Thomas

--Boundary-00=_ap/QIeqlmuHzy4W
Content-Type: text/x-diff;
  charset="us-ascii";
  name="iptables-add-version.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iptables-add-version.patch"

Add xtables version defines.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

--- iptables-1.4.1-rc2/configure.ac	Mon May 26 14:23:58 2008
+++ iptables.version/configure.ac	Mon Jun  2 15:05:57 2008
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
--- iptables-1.4.1-rc2/include/xtables.h.in	Mon May 26 14:15:40 2008
+++ iptables.version/include/xtables.h.in	Mon Jun  2 15:03:46 2008
@@ -18,6 +18,12 @@
 #endif
 
 #define XTABLES_VERSION "@PACKAGE_VERSION@"
+#define XTABLES_VERSION_CODE (0x10000 * @XTABLES_VERSION_MAJOR@ + 0x100 * @XTABLES_VERSION_MINOR@ + @XTABLES_VERSION_PATCH@)
+
+#define XTABLES_VERSION_CHECK(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
+#define XTABLES_VERSION_MAJOR(x)  (((x)>>16) & 0xFF)
+#define XTABLES_VERSION_MINOR(x)  (((x)>> 8) & 0xFF)
+#define XTABLES_VERSION_PATCH(x)  ( (x)      & 0xFF)
 
 /* Include file for additions: new matches and targets. */
 struct xtables_match

--Boundary-00=_ap/QIeqlmuHzy4W--
