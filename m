From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Mon, 7 Jul 2008 11:28:31 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807071052130.28765@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0807050050510.4142@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58393 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYGGJ2d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:28:33 -0400
In-Reply-To: <Pine.LNX.4.64.0807050050510.4142@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On sometime, Jozsef Kadlecsik wrote:
>
>As xtables-addons works with kernel 2.6.18.5 or above I cannot depend=20
>on it. Even supporting 2.4 kernels is still required - and if there's =
a=20
>single user who needs it, I do support the 2.4 series in ipset.

I seem to be the first one to even try <=3D 2.6.21.

  CC [M]  /home/jengelh/Coding/xtables/xtables-addons/extensions/ipset/=
ip_set_macipmap.o
In file included from /home/jengelh/Coding/xtables/xtables-addons/exten=
sions/ipset/ip_set_macipmap.c:26:
/home/jengelh/Coding/xtables/xtables-addons/extensions/ipset/ip_set_mal=
loc.h:8: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99, =E2=
=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=
=99 before =E2=80=98init_max_page_size=E2=80=99
In file included from /home/jengelh/Coding/xtables/xtables-addons/exten=
sions/ipset/ip_set_macipmap.c:26:
/home/jengelh/Coding/xtables/xtables-addons/extensions/ipset/ip_set_mal=
loc.h: In function =E2=80=98harray_malloc=E2=80=99:
/home/jengelh/Coding/xtables/xtables-addons/extensions/ipset/ip_set_mal=
loc.h:87: warning: implicit declaration of function =E2=80=98init_max_p=
age_size=E2=80=99
make[5]: *** [/home/jengelh/Coding/xtables/xtables-addons/extensions/ip=
set/ip_set_macipmap.o] Error 1
make[4]: *** [/home/jengelh/Coding/xtables/xtables-addons/extensions/ip=
set] Error 2
make[3]: *** [_module_/home/jengelh/Coding/xtables/xtables-addons/exten=
sions] Error 2
make[3]: Leaving directory `/lo/linux18'
make[2]: *** [modules] Error 2
make[2]: Leaving directory `/home/jengelh/Coding/xtables/xtables-addons=
/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/jengelh/Coding/xtables/xtables-addons=
'
make: *** [all] Error 2



commit 35783b5c51d079439b737053e2ab88c2eb9ccea7
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jul 7 11:07:15 2008 +0200

    ipset: fixup compile errors with 2.6.18.x and 2.6.20 warnings
---
 extensions/ipset/ip_set_iptree.c    |    2 +-
 extensions/ipset/ip_set_iptreemap.c |    2 +-
 extensions/ipset/ip_set_malloc.h    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/ipset/ip_set_iptree.c b/extensions/ipset/ip_set=
_iptree.c
index 82ed54b..5170294 100644
--- a/extensions/ipset/ip_set_iptree.c
+++ b/extensions/ipset/ip_set_iptree.c
@@ -35,7 +35,7 @@ static int limit =3D MAX_RANGE;
  * to delete the gc timer at destroying/flushing a set */
 #define IPTREE_DESTROY_SLEEP	100
=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,21)
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,20)
 static struct kmem_cache *branch_cachep;
 static struct kmem_cache *leaf_cachep;
 #else
diff --git a/extensions/ipset/ip_set_iptreemap.c b/extensions/ipset/ip_=
set_iptreemap.c
index 4c4cc97..bc102fc 100644
--- a/extensions/ipset/ip_set_iptreemap.c
+++ b/extensions/ipset/ip_set_iptreemap.c
@@ -30,7 +30,7 @@
 #define IPTREEMAP_DEFAULT_GC_TIME (5 * 60)
 #define IPTREEMAP_DESTROY_SLEEP (100)
=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,21)
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,20)
 static struct kmem_cache *cachep_b;
 static struct kmem_cache *cachep_c;
 static struct kmem_cache *cachep_d;
diff --git a/extensions/ipset/ip_set_malloc.h b/extensions/ipset/ip_set=
_malloc.h
index 30701f4..ddf6389 100644
--- a/extensions/ipset/ip_set_malloc.h
+++ b/extensions/ipset/ip_set_malloc.h
@@ -5,7 +5,7 @@
=20
 static size_t max_malloc_size =3D 0, max_page_size =3D 0;
=20
-static inline bool init_max_page_size(void)
+static inline unsigned int init_max_page_size(void)
 {
 	size_t page_size =3D 0;
 =09
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
