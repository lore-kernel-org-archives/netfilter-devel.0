From: Frank Reppin <frank@undermydesk.org>
Subject: [PATCH] fix compilation of xtables 1.37
Date: Mon, 08 Aug 2011 01:03:58 +0200
Message-ID: <4E3F19DE.9040302@undermydesk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030002040705090707040909"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from amazone.undermydesk.org ([213.211.198.100]:14602 "EHLO
	amazone.undermydesk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1HGXKT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 19:10:19 -0400
Received: from amazone.undermydesk.org (localhost [127.0.0.1])
	by amazone.undermydesk.org (Postfix) with ESMTP id F38891D7FDB
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2011 01:04:08 +0200 (CEST)
Received: from amazone.undermydesk.org ([213.211.198.100])
	by amazone.undermydesk.org (amazone.undermydesk.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PHpLtdrYzGOr for <netfilter-devel@vger.kernel.org>;
	Mon,  8 Aug 2011 01:04:05 +0200 (CEST)
Received: from [192.168.0.74] (p4FDDCD38.dip.t-dialin.net [79.221.205.56])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client did not present a certificate)
	by amazone.undermydesk.org (Postfix) with ESMTPSA id 4C4111D7FBF
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2011 01:04:05 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030002040705090707040909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

the attached patch fixes compilation of xtables 1.37.

My scenario is:

1) xtables.h is in /usr/local/iptables/include
2) configure was done as:
      export PKG_CONFIG_PATH=/usr/local/iptables/lib/pkgconfig
      ./configure --with-xtlibdir=/usr/local/iptables/libexec/xtables

The error was:

libxt_ACCOUNT.c:13:21: warning: xtables.h: No such file or directory


HTH
cheers,
Frank Reppin

-- 
43rd Law of Computing:
         Anything that can go wr
fortune: Segmentation violation -- Core dumped

--------------030002040705090707040909
Content-Type: text/plain;
 name="patch-fix-xtables-addons-1.37-compilation.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch-fix-xtables-addons-1.37-compilation.diff"

diff -Naur xtables-addons-1.37.dist/extensions/ACCOUNT/Makefile.in xtables-addons-1.37/extensions/ACCOUNT/Makefile.in
--- xtables-addons-1.37.dist/extensions/ACCOUNT/Makefile.in	2011-06-25 11:24:37.000000000 +0200
+++ xtables-addons-1.37/extensions/ACCOUNT/Makefile.in	2011-08-08 00:43:21.000000000 +0200
@@ -247,7 +247,7 @@
 top_srcdir = @top_srcdir@
 xtlibdir = @xtlibdir@
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${abs_top_srcdir}/extensions
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CFLAGS = ${regular_CFLAGS} ${libxtables_CFLAGS}
 XA_SRCDIR = ${srcdir}
 XA_TOPSRCDIR = ${top_srcdir}
 XA_ABSTOPSRCDIR = ${abs_top_srcdir}
diff -Naur xtables-addons-1.37.dist/extensions/pknock/Makefile.in xtables-addons-1.37/extensions/pknock/Makefile.in
--- xtables-addons-1.37.dist/extensions/pknock/Makefile.in	2011-06-25 11:24:37.000000000 +0200
+++ xtables-addons-1.37/extensions/pknock/Makefile.in	2011-08-08 00:44:03.000000000 +0200
@@ -216,7 +216,7 @@
 top_srcdir = @top_srcdir@
 xtlibdir = @xtlibdir@
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${abs_top_srcdir}/extensions
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CFLAGS = ${regular_CFLAGS} ${libxtables_CFLAGS}
 XA_SRCDIR = ${srcdir}
 XA_TOPSRCDIR = ${top_srcdir}
 XA_ABSTOPSRCDIR = ${abs_top_srcdir}

--------------030002040705090707040909--
