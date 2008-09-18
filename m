From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] ipset: Fix multiple compiler warnings
Date: Thu, 18 Sep 2008 15:13:56 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0809181511450.22510@titan.stealer.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-967258400-1402956182-1221743636=:22510"
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:53918 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYIRNOH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:14:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---967258400-1402956182-1221743636=:22510
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
 ipset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- ipset.orig/ipset.c
+++ ipset/ipset.c
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
---967258400-1402956182-1221743636=:22510--
