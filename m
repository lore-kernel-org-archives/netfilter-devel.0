From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 16/17] v4: rename do_command() to do_command4()
Date: Thu, 31 Mar 2011 21:27:32 -0700
Message-ID: <1301632053-3694-16-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1750936Ab1DAE2h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:37 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:37 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 include/iptables.h    |    2 +-
 iptables-restore.c    |    4 ++--
 iptables-standalone.c |    2 +-
 iptables-xml.c        |    2 +-
 iptables.c            |    6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/iptables.h b/include/iptables.h
index 204c92e..65b3290 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -7,7 +7,7 @@
 #include <iptables/internal.h>
=20
 /* Your shared library should call one of these. */
-extern int do_command(int argc, char *argv[], char **table,
+extern int do_command4(int argc, char *argv[], char **table,
 		      struct iptc_handle **handle);
 extern int delete_chain4(const ipt_chainlabel chain, int verbose,
 			struct iptc_handle *handle);
diff --git a/iptables-restore.c b/iptables-restore.c
index 6163a92..e4f0604 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -438,13 +438,13 @@ main(int argc, char *argv[])
 				}
 			}
=20
-			DEBUGP("calling do_command(%u, argv, &%s, handle):\n",
+			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
 				newargc, curtable);
=20
 			for (a =3D 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
=20
-			ret =3D do_command(newargc, newargv,
+			ret =3D do_command4(newargc, newargv,
 					 &newargv[2], &handle);
=20
 			free_argv();
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 38dd2c2..b085946 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -62,7 +62,7 @@ main(int argc, char *argv[])
 	init_extensions4();
 #endif
=20
-	ret =3D do_command(argc, argv, &table, &handle);
+	ret =3D do_command4(argc, argv, &table, &handle);
 	if (ret) {
 		ret =3D iptc_commit(handle);
 		iptc_free(handle);
diff --git a/iptables-xml.c b/iptables-xml.c
index 57c7486..dc3cd4f 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -844,7 +844,7 @@ main(int argc, char *argv[])
 				}
 			}
=20
-			DEBUGP("calling do_command(%u, argv, &%s, handle):\n",
+			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
 			       newargc, curTable);
=20
 			for (a =3D 0; a < newargc; a++)
diff --git a/iptables.c b/iptables.c
index b7c9498..0995d6f 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1413,7 +1413,7 @@ static void command_match(struct iptables_command=
_state *cs)
 	}
 }
=20
-int do_command(int argc, char *argv[], char **table, struct iptc_handl=
e **handle)
+int do_command4(int argc, char *argv[], char **table, struct iptc_hand=
le **handle)
 {
 	struct iptables_command_state cs;
 	struct ipt_entry *e =3D NULL;
@@ -1437,11 +1437,11 @@ int do_command(int argc, char *argv[], char **t=
able, struct iptc_handle **handle
 	cs.jumpto =3D "";
 	cs.argv =3D argv;
=20
-	/* re-set optind to 0 in case do_command gets called
+	/* re-set optind to 0 in case do_command4 gets called
 	 * a second time */
 	optind =3D 0;
=20
-	/* clear mflags in case do_command gets called a second time
+	/* clear mflags in case do_command4 gets called a second time
 	 * (we clear the global list of all matches for security)*/
 	for (m =3D xtables_matches; m; m =3D m->next)
 		m->mflags =3D 0;
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
