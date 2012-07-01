From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: restore -version-info
Date: Sun, 1 Jul 2012 20:36:19 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207011953290.21627@frira.zrqbmnf.qr>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <1341082043-26584-1-git-send-email-jengelh@inai.de> <1341082043-26584-2-git-send-email-jengelh@inai.de> <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu> <alpine.LNX.2.01.1207010013340.4459@frira.zrqbmnf.qr>
 <alpine.DEB.2.00.1207010029300.1245@blackhole.kfki.hu> <alpine.LNX.2.01.1207010048210.6863@frira.zrqbmnf.qr> <alpine.DEB.2.00.1207011409470.2289@blackhole.kfki.hu> <alpine.LNX.2.01.1207011754110.17716@frira.zrqbmnf.qr>
 <alpine.DEB.2.00.1207011838590.3212@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:56183 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab2GASgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:36:21 -0400
In-Reply-To: <alpine.DEB.2.00.1207011838590.3212@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2012-07-01 19:20, Jozsef Kadlecsik wrote:
>[...] 
>> * therefore the patch makes a clean restart,
>>   using -version-info 3:0:0, to continue using .so.3
>>   starting from ipset-6.13 until the next *real*
>>   incompatible change.
>
>What is still unclear for me, why a clean restart is required. Looking 
>into "libtool", as I see, "-version-number 3:0:1" and "-version-info 
>3:0:1" produces the same result.

They don't. The libtool manual goes on attempting to explain
"-version-number" with C:R:A, though it could have been a lot easier
to just say "it copies the values as-is to the file suffix".


---8<---
location git://git.inai.de/ipset (updated)

parent 7c7b022a18ea2bae11d889b345caef87f3bf145e (v6.13)
commit 2b145f0794de6f56eaded0a6403be995be98c93b
Author: Jan Engelhardt <jengelh@inai.de>
Date:   Sat Jun 30 20:39:27 2012 +0200

build: restore -version-info

Commit v6.13~7 accidentally swapped "-version-info" with
"-version-number". Because "-version-number" takes the values
"FIRST:AGE:REV", which is different from "-version-info
CURRENT:REV:AGE", libipset.so.3 was emitted.

Restore using "-version-info" and continue to use 3 as the "FIRST"
interface (instead of 2), because it was declared that way in
ipset-6.13.

Also note that the version names in libipset.map generally are not
supposed to follow SO versions, but the program version):
IPSET_6.13 {...}.
---
 Make_global.am  |    2 +-
 lib/Makefile.am |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 4a8f61a..e9f9afd 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -69,7 +69,7 @@
 # interface. 
 
 #            curr:rev:age
-LIBVERSION = 3:0:1
+LIBVERSION = 3:1:0
 
 AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
 	-I/usr/local/include
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 392b5f9..fd853dd 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -19,7 +19,7 @@ lib_LTLIBRARIES = libipset.la
 
 include $(top_srcdir)/lib/Make_extra.am
 
-libipset_la_LDFLAGS = -Wl,--version-script=$(top_srcdir)/lib/libipset.map -version-number $(LIBVERSION)
+libipset_la_LDFLAGS = -Wl,--version-script=$(top_srcdir)/lib/libipset.map -version-info $(LIBVERSION)
 libipset_la_LIBADD  = ${libmnl_LIBS} $(IPSET_SETTYPE_STATIC_OBJECTS)
 libipset_la_SOURCES = \
 	data.c \
-- 
# Created with git-export-patch
