From: Peter Volkov <pva@gentoo.org>
Subject: xtables-addons: fix installation in case only modules in subdirs
 of extensions are enabled
Date: Mon, 18 Jan 2010 12:08:36 +0300
Message-ID: <1263805716.31396.1018.camel@tablet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-uw6Bm1haU2jQN6ZrjSHR"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54618 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab0ARJKa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:10:30 -0500
Received: from [192.168.1.35] (unknown [77.246.104.171])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.gentoo.org (Postfix) with ESMTP id BDBD71B40CD
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Jan 2010 09:10:20 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-uw6Bm1haU2jQN6ZrjSHR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

In case only modules that are built in subdirectories of extensions are
enabled (and thus nothing is build in extensions directory itself)
installation fails with the error (only build_ACCOUNT=y in mconfig):

install -pm0755
"/vt/portage/tmp/portage/net-firewall/xtables-addons-1.21/image///usr/local/libexec/xtables";
install: missing destination file operand after
`/vt/portage/tmp/portage/net-firewall/xtables-addons-1.21/image///usr/local/libexec/xtables'
Try `install --help' for more information.
make[3]: *** [install] Error 1

Patch in attachment fixes this.

-- 
Peter.

--=-uw6Bm1haU2jQN6ZrjSHR
Content-Disposition: attachment; filename="0001-build-don-t-fail-if-only-modules-in-subdirs-of-exten.patch"
Content-Type: text/x-patch; name="0001-build-don-t-fail-if-only-modules-in-subdirs-of-exten.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 0bb3a77b27e9006c4227913cc3b38bb6d98e3a39 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Mon, 18 Jan 2010 11:46:34 +0300
Subject: [PATCH] build: don't fail if only modules in subdirs of extensions are enabled

In case only modules that are built in subdirectories of extensions are
enabled (and thus nothing is build in extensions directory itself)
installation fails with the error (only build_ACCOUNT=y in mconfig):

install -pm0755
"/vt/portage/tmp/portage/net-firewall/xtables-addons-1.21/image///usr/local/libexec/xtables";
install: missing destination file operand after
`/vt/portage/tmp/portage/net-firewall/xtables-addons-1.21/image///usr/local/libexec/xtables'
Try `install --help' for more information.
make[3]: *** [install] Error 1

This patch fixes that.
---
 Makefile.iptrules.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.iptrules.in b/Makefile.iptrules.in
index 8be21fc..85e736c 100644
--- a/Makefile.iptrules.in
+++ b/Makefile.iptrules.in
@@ -47,7 +47,7 @@ all: ${targets}
 install: ${targets}
 	@for i in ${subdirs_list}; do ${MAKE} -C $$i $@; done;
 	install -dm0755 "${DESTDIR}/${xtlibdir}";
-	install -pm0755 $^ "${DESTDIR}/${xtlibdir}";
+	@for i in $^; do install -pm0755 $$i "${DESTDIR}/${xtlibdir}"; done;
 
 clean:
 	@for i in ${subdirs_list}; do ${MAKE} -C $$i $@; done;
-- 
1.6.4.4


--=-uw6Bm1haU2jQN6ZrjSHR--

