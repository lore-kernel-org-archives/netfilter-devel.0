From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCHv2] ipset: Fix multiple compiler warnings
Date: Thu, 18 Sep 2008 15:30:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0809181528400.22510@titan.stealer.net>
References: <alpine.LNX.2.00.0809181511450.22510@titan.stealer.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-967258400-699067006-1221744647=:22510"
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:42615 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYIRNa4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:30:56 -0400
In-Reply-To: <alpine.LNX.2.00.0809181511450.22510@titan.stealer.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---967258400-699067006-1221744647=:22510
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE

This fixes the following warnings:

ipset.c: In function =A1kernel_getfrom_handleerrno=A2:
ipset.c:434: warning: passing argument 2 of =A1wrapped_getsockopt=A2 from i=
ncompatible pointer type
ipset.c: In function =A1load_set_list=A2:
ipset.c:1085: warning: passing argument 3 of =A1kernel_getfrom_handleerrno=
=A2 from incompatible pointer type
ipset.c: In function =A1try_save_sets=A2:
ipset.c:1237: warning: passing argument 3 of =A1kernel_getfrom_handleerrno=
=A2 from incompatible pointer type
ipset.c: In function =A1set_restore=A2:
ipset.c:1513: warning: passing argument 3 of =A1kernel_getfrom_handleerrno=
=A2 from incompatible pointer type
ipset.c: In function =A1try_list_sets=A2:
ipset.c:1811: warning: passing argument 3 of =A1kernel_getfrom_handleerrno=
=A2 from incompatible pointer type

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 ipset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

There's another size_t, that should be socklen_t. This one doesn't=20
generate a warning, but let's be consistent.

--- ipset.orig/ipset.c
+++ ipset/ipset.c
@@ -421,7 +421,7 @@
 =09return 0; /* all ok */
 }
=20
-static void kernel_sendto(unsigned cmd, void *data, size_t size)
+static void kernel_sendto(unsigned cmd, void *data, socklen_t size)
 {
 =09int res =3D wrapped_setsockopt(data, size);
=20
@@ -429,7 +429,7 @@
 =09=09kernel_error(cmd, errno);
 }
=20
-static int kernel_getfrom_handleerrno(unsigned cmd, void *data, size_t * s=
ize)
+static int kernel_getfrom_handleerrno(unsigned cmd, void *data, socklen_t =
*size)
 {
 =09int res =3D wrapped_getsockopt(data, size);
=20
---967258400-699067006-1221744647=:22510--
