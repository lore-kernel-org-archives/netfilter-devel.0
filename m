From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables 1,4,1 install error
Date: Thu, 12 Jun 2008 08:43:20 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806120842340.23098@fbirervta.pbzchgretzou.qr>
References: <66c5208e0806112212o47bc2c54l87be5d49b4548834@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: michael <mteicher@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48847 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922AbYFLGnW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:43:22 -0400
In-Reply-To: <66c5208e0806112212o47bc2c54l87be5d49b4548834@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2008-06-12 07:12, michael wrote:

>Hello,
>
>Can anyone shed some light on installing iptables1.4.1 on a linux kernel 2.4.34.
>make install fails with the following:
>Making install in extensions
>make[1]: Entering directory `/home/src/iptables-1.4.1/extensions'
>install -pm0755 "usr/local/libexec/xtables/";
>install: too few arguments
>Try `install --help' for more information
>make[1]: *** [install] error 1
>make[1]: Leaving directory `home/src/iptables-1.4.1/extensions'
>make; *** [install-reecursive] Error 1
>
>Thanks,
>
>Michael...
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

commit f22764c8b9c08abcea002f3c52a8493d3c4ee75f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jun 12 08:43:06 2008 +0200

build: fix `make install` when --disable-shared is used

When --disable-shared is used, there are no .so files to install, and
the argument order for install would get messed up.

Reported-by: Michael Teicher <mteicher@gmail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 8d44e4e..4a3bf4e 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -67,7 +67,7 @@ all: ${targets}
 
 install: ${targets_install}
 	@mkdir -p "${DESTDIR}${xtlibdir}";
-	install -pm0755 $^ "${DESTDIR}${xtlibdir}/";
+	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
 
 clean:
 	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext4.c initext6.c;
