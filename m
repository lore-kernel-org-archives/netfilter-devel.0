From: Jay Shah <jay.shah1@rockwellcollins.com>
Subject: [PATCH 1/1] iptables: patch to correct linker flag sequence
Date: Wed, 29 Nov 2017 00:10:54 -0600
Message-ID: <1511935854-13005-1-git-send-email-jay.shah1@rockwellcollins.com>
Cc: jay.shah1@rockwellcollins.com,
        Yogesh Prasad <yogesh.prasad@rockwellcollins.com>,
        Matt Weber <matthew.weber@rockwellcollins.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ch3vs04.rockwellcollins.com ([205.175.226.52]:15003 "EHLO
        ch3vs04.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751005AbdK2GWB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Nov 2017 01:22:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Yogesh Prasad <yogesh.prasad@rockwellcollins.com>

Description
This patch will correct the sequence of -pie and -shared options.
 When used together, -pie should be provided to the linker before
 -shared. If -pie is provided after -shared, the linker throws an
 error shown below as example.

-------------------------------------------------------------------------
/host/lib/gcc/powerpc-buildroot-linux-gnu/6.4.0/../../../..
/powerpc-buildroot-linux-gnu/bin/ld: BFD (GNU Binutils) 2.28.1
 assertion fail elf32-ppc.c:8923
collect2: error: ld returned 1 exit status
        + ./libxt_SYNPROXY.man
make[4]: *** [libxt_TCPOPTSTRIP.so] Error 1
        + ./libip6t_mh.man
/host/powerpc-buildroot-linux-gnu/sysroot/usr/lib/Scrt1.o:(.data+0x4):
 undefined reference to `main'
/host/lib/gcc/powerpc-buildroot-linux-gnu      + ./libxt_TCPMSS.man
/6.4.0/../../../../powerpc-buildroot-linux-gnu/bin/ld:
 BFD (GNU Binutils) 2.28.1 assertion fail elf32-ppc.c:8923
collect2: error: ld returned 1 exit status
-------------------------------------------------------------------------

Signed-off-by: Yogesh Prasad <yogesh.prasad@rockwellcollins.com>
Signed-off-by: Matt Weber <matthew.weber@rockwellcollins.com>
---
 extensions/GNUmakefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index b7a8a83..bee666e 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -101,7 +101,7 @@ init%.o: init%.c
 #	Shared libraries
 #
 lib%.so: lib%.oo
-	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
+	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} ${LDFLAGS} -shared -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
 
 lib%.oo: ${srcdir}/lib%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
-- 
1.9.1

