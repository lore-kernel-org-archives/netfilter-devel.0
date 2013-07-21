From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: additional include path required after UAPI changes
Date: Sun, 21 Jul 2013 08:30:49 -0700
Message-ID: <20130721153049.GA8444@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44245 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3GUPaq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:30:46 -0400
Received: by mail-pb0-f53.google.com with SMTP id xb12so6188197pbc.12
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2013 08:30:46 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

After kernel commit 607ca46e (UAPI: (Scripted) Disintegrate include/linux),
using the "--with-kernel" argument to build iptables stopped working due
to the missing #ifdefs in the original files.  We need to make sure the
UAPI include dir is listed before the original location.  Leaving both
allows support for old and new kernels.

This fixes bug #833.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipt-uapi

diff --git a/configure.ac b/configure.ac
index be216b0..5ed5165 100644
--- a/configure.ac
+++ b/configure.ac
@@ -114,10 +114,10 @@ regular_CPPFLAGS="${largefile_cppflags} -D_REENTRANT \
 	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\" -DXTABLES_INTERNAL";
 kinclude_CPPFLAGS="";
 if [[ -n "$kbuilddir" ]]; then
-	kinclude_CPPFLAGS="$kinclude_CPPFLAGS -I$kbuilddir/include";
+	kinclude_CPPFLAGS="$kinclude_CPPFLAGS -I$kbuilddir/include/uapi -I$kbuilddir/include";
 fi;
 if [[ -n "$ksourcedir" ]]; then
-	kinclude_CPPFLAGS="$kinclude_CPPFLAGS -I$ksourcedir/include";
+	kinclude_CPPFLAGS="$kinclude_CPPFLAGS -I$ksourcedir/include/uapi -I$ksourcedir/include";
 fi;
 pkgdatadir='${datadir}/xtables';
 

--WIyZ46R2i8wDzkSu--
