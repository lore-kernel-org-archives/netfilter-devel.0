From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: [patch] iptables out-of-tree build directory
Date: Mon, 12 May 2008 01:15:21 +0200
Message-ID: <1210547721.23433.33.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-TnC3A4Xe2IKj7yJ/4/nl"
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:43335 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbYEKXa1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2008 19:30:27 -0400
Received: from henriknordstrom.net (183.159.216.81.static.tb.siw.siwnet.net [81.216.159.183])
	by vps1.henriknordstrom.net (8.13.8/8.13.8/Debian-3) with ESMTP id m4BNFMij009853
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 01:15:22 +0200
Received: from henrik ([127.0.0.1])
	(authenticated bits=0)
	by henriknordstrom.net (8.12.11.20060308/8.12.8) with ESMTP id m4BNFMoP010441
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 01:15:22 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-TnC3A4Xe2IKj7yJ/4/nl
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The attached patch fixes iptables out-of-tree compiles which otherwise
failed in extensions/ complaining about not finding xtables.h


mkdir build
cd build
../iptables/configure
make

Regards
Henrik

--=-TnC3A4Xe2IKj7yJ/4/nl
Content-Disposition: attachment; filename=out_of_tree_build.patch
Content-Type: text/x-patch; name=out_of_tree_build.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: extensions/GNUmakefile.in
===================================================================
--- extensions/GNUmakefile.in	(revision 7519)
+++ extensions/GNUmakefile.in	(working copy)
@@ -16,7 +16,7 @@
 regular_CFLAGS := @regular_CFLAGS@
 kinclude_CFLAGS := @kinclude_CFLAGS@
 
-AM_CFLAGS      := ${regular_CFLAGS} -I${top_srcdir}/include ${kinclude_CFLAGS}
+AM_CFLAGS      := ${regular_CFLAGS} -I${top_srcdir}/include -I../include ${kinclude_CFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
 ifeq (${V},)

--=-TnC3A4Xe2IKj7yJ/4/nl--

