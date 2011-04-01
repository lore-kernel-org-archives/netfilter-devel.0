From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 05/17] v4: rename init_extensions() to init_extensions4()
Date: Thu, 31 Mar 2011 21:27:21 -0700
Message-ID: <1301632053-3694-5-git-send-email-zenczykowski@gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42303 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DAE2R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:17 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:17 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 extensions/GNUmakefile.in |    4 ++--
 include/xtables.h.in      |    1 +
 iptables-restore.c        |    2 +-
 iptables-save.c           |    2 +-
 iptables-standalone.c     |    2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index b96bd11..84688d3 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -127,8 +127,8 @@ initext4.c: .initext4.dd
 	for i in ${initext_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
-	echo "void init_extensions(void);" >>$@; \
-	echo "void init_extensions(void)" >>$@; \
+	echo "void init_extensions4(void);" >>$@; \
+	echo "void init_extensions4(void)" >>$@; \
 	echo "{" >>$@; \
 	for i in ${initext_func}; do \
 		echo  " ""lib$${i}_init();" >>$@; \
diff --git a/include/xtables.h.in b/include/xtables.h.in
index c3d34af..6abb279 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -285,6 +285,7 @@ extern void xtables_save_string(const char *value);
 #		define _init _INIT
 #	endif
 	extern void init_extensions(void);
+	extern void init_extensions4(void);
 #else
 #	define _init __attribute__((constructor)) _INIT
 #endif
diff --git a/iptables-restore.c b/iptables-restore.c
index c2cc58c..34a8156 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -140,7 +140,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
+	init_extensions4();
 #endif
=20
 	while ((c =3D getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) !=
=3D -1) {
diff --git a/iptables-save.c b/iptables-save.c
index 3e3ec43..a0aa5d8 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -149,7 +149,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
+	init_extensions4();
 #endif
=20
 	while ((c =3D getopt_long(argc, argv, "bcdt:", options, NULL)) !=3D -=
1) {
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 1f60e31..38dd2c2 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -59,7 +59,7 @@ main(int argc, char *argv[])
 				exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
+	init_extensions4();
 #endif
=20
 	ret =3D do_command(argc, argv, &table, &handle);
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
