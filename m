From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [libnftnl PATCH 1/1] Correctly define the header 'Requires:' in the file 'libnftnl.pc'.
Date: Thu, 13 Nov 2014 13:09:05 +0100
Message-ID: <1415880545-19831-1-git-send-email-giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:60872 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932419AbaKMMJP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:09:15 -0500
Received: from mail-in-20-z2.arcor-online.net (mail-in-20-z2.arcor-online.net [151.189.8.85])
	by mx.arcor.de (Postfix) with ESMTP id 5A8EE3AE183
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2014 13:09:13 +0100 (CET)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net [151.189.21.42])
	by mail-in-20-z2.arcor-online.net (Postfix) with ESMTP id 597926FA12D
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2014 13:09:13 +0100 (CET)
Received: from itng-giorgio.wgast.mobotix.net (wwl-pub.mobotixserver.de [213.183.84.172])
	(Authenticated sender: giorgio.nicole@arcor.de)
	by mail-in-02.arcor-online.net (Postfix) with ESMTPA id 3F7DB303FD
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2014 13:09:13 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'libnftnl' unconditionally requires 'libmnl' and eventually requires
'mxml' and/or 'jansson' in case XML or JASON parsing was configured.

Without a correctly defined 'Requires:' header failures can happen
while linking a program against 'libnftnl', expecially while cross compiling.

Here the output of a 'make V=1 all' in a cross compiled (for ARM)
'nftable' project:

# make V=1 all
...
arm-926ejs-linux-gnueabi-gcc -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute -Wcast-align -Wundef -Wbad-function-cast -O2 -msoft-float -mabi=aapcs-linux -march=armv5te -mtune=arm926ej-s -mcpu=arm926ej-s -w  -L/tmp/pkg_root/lib -o nft main.o rule.o statement.o datatype.o expression.o evaluate.o proto.o payload.o exthdr.o meta.o ct.o netlink.o netlink_linearize.o netlink_delinearize.o segtree.o rbtree.o gmputil.o utils.o erec.o mnl.o scanner.o parser_bison.o  -L/tmp/pkg_root/lib -lmnl  -L/tmp/pkg_root/lib -lnftnl  -lgmp
arm-926ejs-linux-gnueabi/bin/ld: warning: libjansson.so.4, needed by /tmp/pkg_root/lib/libnftnl.so, not found (try using -rpath or -rpath-link)
/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_integer_value'
/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_delete'
/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_string_value'
/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_array_get'
/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_loadf'
/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_loadb'
/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_array_size'
/tmp/pkg_root/lib/libnftnl.so: undefined reference to `json_object_get'
collect2: ld returned 1 exit status
Makefile:396: recipe for target 'nft' failed
make[6]: *** [nft] Error 1
#

Signed-off-by: Giorgio Dal Molin <giorgio.nicole@arcor.de>
---
 configure.ac   | 5 +++++
 libnftnl.pc.in | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 55b28ab..ff29200 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,19 +39,24 @@ case "$host" in
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
+NFTNL_PC_DEPS=libmnl
 regular_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
 AS_IF([test "x$with_xml_parsing" = "xyes"], [
 	regular_CPPFLAGS="$regular_CPPFLAGS -DXML_PARSING"
+	NFTNL_PC_DEPS+=" mxml"
 ])
 
 AS_IF([test "x$with_json_parsing" = "xyes"], [
 	regular_CPPFLAGS="$regular_CPPFLAGS -DJSON_PARSING"
+	NFTNL_PC_DEPS+=" jansson"
 ])
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wshadow -Wstrict-prototypes \
 	-Wformat=2 -pipe"
+
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([regular_CFLAGS])
+AC_SUBST([NFTNL_PC_DEPS])
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libnftnl/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile tests/Makefile libnftnl.pc doxygen.cfg])
 AC_OUTPUT
 
diff --git a/libnftnl.pc.in b/libnftnl.pc.in
index fd5cc6a..39c66f9 100644
--- a/libnftnl.pc.in
+++ b/libnftnl.pc.in
@@ -9,7 +9,7 @@ Name: libnftnl
 Description: Netfilter nf_tables infrastructure library
 URL: http://netfilter.org/projects/libnftnl/
 Version: @VERSION@
-Requires:
+Requires: @NFTNL_PC_DEPS@
 Conflicts:
 Libs: -L${libdir} -lnftnl
 Cflags: -I${includedir}
-- 
2.1.3

