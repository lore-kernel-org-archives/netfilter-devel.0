From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 02/17] mark newly opened fds as FD_CLOEXEC (close on exec)
Date: Thu, 31 Mar 2011 21:27:18 -0700
Message-ID: <1301632053-3694-2-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1750807Ab1DAE2N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:13 -0400
Received: by iwn34 with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:12 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

(This is iptables-1.4.3.1-cloexec.patch from RedHat iptables.src.rpm)

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 extensions/libipt_realm.c |    2 +-
 ip6tables-restore.c       |    2 +-
 ip6tables-save.c          |    2 +-
 iptables-restore.c        |    2 +-
 iptables-save.c           |    2 +-
 iptables-xml.c            |    2 +-
 xtables.c                 |   11 +++++++++++
 7 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index a250570..17b1754 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -49,7 +49,7 @@ static void load_realms(void)
 	int id;
 	struct realmname *oldnm =3D NULL, *newnm =3D NULL;
=20
-	fil =3D fopen(rfnm, "r");
+	fil =3D fopen(rfnm, "re");
 	if (!fil) {
 		rdberr =3D 1;
 		return;
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index e9a130f..10c3acf 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -168,7 +168,7 @@ int main(int argc, char *argv[])
 	}
=20
 	if (optind =3D=3D argc - 1) {
-		in =3D fopen(argv[optind], "r");
+		in =3D fopen(argv[optind], "re");
 		if (!in) {
 			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
 				strerror(errno));
diff --git a/ip6tables-save.c b/ip6tables-save.c
index dc189e9..c3b8ec0 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -41,7 +41,7 @@ static int for_each_table(int (*func)(const char *tab=
lename))
 	FILE *procfile =3D NULL;
 	char tablename[IP6T_TABLE_MAXNAMELEN+1];
=20
-	procfile =3D fopen("/proc/net/ip6_tables_names", "r");
+	procfile =3D fopen("/proc/net/ip6_tables_names", "re");
 	if (!procfile)
 		return ret;
=20
diff --git a/iptables-restore.c b/iptables-restore.c
index 31ce52b..c2cc58c 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -174,7 +174,7 @@ main(int argc, char *argv[])
 	}
=20
 	if (optind =3D=3D argc - 1) {
-		in =3D fopen(argv[optind], "r");
+		in =3D fopen(argv[optind], "re");
 		if (!in) {
 			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
 				strerror(errno));
diff --git a/iptables-save.c b/iptables-save.c
index 3bcf422..3e3ec43 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -39,7 +39,7 @@ static int for_each_table(int (*func)(const char *tab=
lename))
 	FILE *procfile =3D NULL;
 	char tablename[IPT_TABLE_MAXNAMELEN+1];
=20
-	procfile =3D fopen("/proc/net/ip_tables_names", "r");
+	procfile =3D fopen("/proc/net/ip_tables_names", "re");
 	if (!procfile)
 		return ret;
=20
diff --git a/iptables-xml.c b/iptables-xml.c
index 8d67056..57c7486 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -651,7 +651,7 @@ main(int argc, char *argv[])
 	}
=20
 	if (optind =3D=3D argc - 1) {
-		in =3D fopen(argv[optind], "r");
+		in =3D fopen(argv[optind], "re");
 		if (!in) {
 			fprintf(stderr, "Can't open %s: %s", argv[optind],
 				strerror(errno));
diff --git a/xtables.c b/xtables.c
index 2f00e39..352963f 100644
--- a/xtables.c
+++ b/xtables.c
@@ -300,6 +300,11 @@ static char *get_modprobe(void)
 	procfile =3D open(PROC_SYS_MODPROBE, O_RDONLY);
 	if (procfile < 0)
 		return NULL;
+	if (fcntl(procfile, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
+		fprintf(stderr, "Could not set close on exec: %s\n",
+			strerror(errno));
+		exit(1);
+	}
=20
 	ret =3D malloc(PROCFILE_BUFSIZ);
 	if (ret) {
@@ -697,6 +702,12 @@ static int compatible_revision(const char *name, u=
int8_t revision, int opt)
 		exit(1);
 	}
=20
+	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
+		fprintf(stderr, "Could not set close on exec: %s\n",
+			strerror(errno));
+		exit(1);
+	}
+
 	xtables_load_ko(xtables_modprobe_program, true);
=20
 	strcpy(rev.name, name);
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
