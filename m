From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 06/17] v6: rename init_extensions() to init_extensions6()
Date: Thu, 31 Mar 2011 21:27:22 -0700
Message-ID: <1301632053-3694-6-git-send-email-zenczykowski@gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60885 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1DAEhO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:37:14 -0400
Received: by iwn34 with SMTP id 34so3089038iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:37:13 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 extensions/GNUmakefile.in |    4 ++--
 include/xtables.h.in      |    1 +
 ip6tables-restore.c       |    2 +-
 ip6tables-save.c          |    2 +-
 ip6tables-standalone.c    |    2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 84688d3..1419d76 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -143,8 +143,8 @@ initext6.c: .initext6.dd
 	for i in ${initext6_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
-	echo "void init_extensions(void);" >>$@; \
-	echo "void init_extensions(void)" >>$@; \
+	echo "void init_extensions6(void);" >>$@; \
+	echo "void init_extensions6(void)" >>$@; \
 	echo "{" >>$@; \
 	for i in ${initext6_func}; do \
 		echo " ""lib$${i}_init();" >>$@; \
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 6abb279..bb0a40c 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -286,6 +286,7 @@ extern void xtables_save_string(const char *value);
 #	endif
 	extern void init_extensions(void);
 	extern void init_extensions4(void);
+	extern void init_extensions6(void);
 #else
 #	define _init __attribute__((constructor)) _INIT
 #endif
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 10c3acf..48ff98c 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -137,7 +137,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
+	init_extensions6();
 #endif
=20
 	while ((c =3D getopt_long(argc, argv, "bcvthnM:", options, NULL)) !=3D=
 -1) {
diff --git a/ip6tables-save.c b/ip6tables-save.c
index c3b8ec0..1a5e3c8 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -149,7 +149,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
+	init_extensions6();
 #endif
=20
 	while ((c =3D getopt_long(argc, argv, "bcdt:", options, NULL)) !=3D -=
1) {
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 8661bd9..7d34684 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -59,7 +59,7 @@ main(int argc, char *argv[])
 	}
=20
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
+	init_extensions6();
 #endif
=20
 	ret =3D do_command6(argc, argv, &table, &handle);
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
