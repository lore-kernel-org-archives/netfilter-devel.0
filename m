From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 02/17] mark newly opened fds as FD_CLOEXEC (close on
 exec)
Date: Fri, 1 Apr 2011 11:31:32 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104011130430.10168@obet.zrqbmnf.qr>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com> <1301632053-3694-2-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57226 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab1DAJbe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 05:31:34 -0400
In-Reply-To: <1301632053-3694-2-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-04-01 06:27, Maciej =C5=BBenczykowski wrote:

>From: Maciej =C5=BBenczykowski <maze@google.com>
>
>(This is iptables-1.4.3.1-cloexec.patch from RedHat iptables.src.rpm)

Redhat still has not given a reason as to why this is needed.


>@@ -49,7 +49,7 @@ static void load_realms(void)
> 	int id;
> 	struct realmname *oldnm =3D NULL, *newnm =3D NULL;
>=20
>-	fil =3D fopen(rfnm, "r");
>+	fil =3D fopen(rfnm, "re");
> 	if (!fil) {
> 		rdberr =3D 1;
> 		return;
>diff --git a/ip6tables-restore.c b/ip6tables-restore.c
>index e9a130f..10c3acf 100644
>--- a/ip6tables-restore.c
>+++ b/ip6tables-restore.c
>@@ -168,7 +168,7 @@ int main(int argc, char *argv[])
> 	}
>=20
> 	if (optind =3D=3D argc - 1) {
>-		in =3D fopen(argv[optind], "r");
>+		in =3D fopen(argv[optind], "re");
> 		if (!in) {
> 			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
> 				strerror(errno));
>diff --git a/ip6tables-save.c b/ip6tables-save.c
>index dc189e9..c3b8ec0 100644
>--- a/ip6tables-save.c
>+++ b/ip6tables-save.c
>@@ -41,7 +41,7 @@ static int for_each_table(int (*func)(const char *ta=
blename))
> 	FILE *procfile =3D NULL;
> 	char tablename[IP6T_TABLE_MAXNAMELEN+1];
>=20
>-	procfile =3D fopen("/proc/net/ip6_tables_names", "r");
>+	procfile =3D fopen("/proc/net/ip6_tables_names", "re");
> 	if (!procfile)
> 		return ret;
>=20
>diff --git a/iptables-restore.c b/iptables-restore.c
>index 31ce52b..c2cc58c 100644
>--- a/iptables-restore.c
>+++ b/iptables-restore.c
>@@ -174,7 +174,7 @@ main(int argc, char *argv[])
> 	}
>=20
> 	if (optind =3D=3D argc - 1) {
>-		in =3D fopen(argv[optind], "r");
>+		in =3D fopen(argv[optind], "re");
> 		if (!in) {
> 			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
> 				strerror(errno));
>diff --git a/iptables-save.c b/iptables-save.c
>index 3bcf422..3e3ec43 100644
>--- a/iptables-save.c
>+++ b/iptables-save.c
>@@ -39,7 +39,7 @@ static int for_each_table(int (*func)(const char *ta=
blename))
> 	FILE *procfile =3D NULL;
> 	char tablename[IPT_TABLE_MAXNAMELEN+1];
>=20
>-	procfile =3D fopen("/proc/net/ip_tables_names", "r");
>+	procfile =3D fopen("/proc/net/ip_tables_names", "re");
> 	if (!procfile)
> 		return ret;
>=20
>diff --git a/iptables-xml.c b/iptables-xml.c
>index 8d67056..57c7486 100644
>--- a/iptables-xml.c
>+++ b/iptables-xml.c
>@@ -651,7 +651,7 @@ main(int argc, char *argv[])
> 	}
>=20
> 	if (optind =3D=3D argc - 1) {
>-		in =3D fopen(argv[optind], "r");
>+		in =3D fopen(argv[optind], "re");
> 		if (!in) {
> 			fprintf(stderr, "Can't open %s: %s", argv[optind],
> 				strerror(errno));
>diff --git a/xtables.c b/xtables.c
>index 2f00e39..352963f 100644
>--- a/xtables.c
>+++ b/xtables.c
>@@ -300,6 +300,11 @@ static char *get_modprobe(void)
> 	procfile =3D open(PROC_SYS_MODPROBE, O_RDONLY);
> 	if (procfile < 0)
> 		return NULL;
>+	if (fcntl(procfile, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
>+		fprintf(stderr, "Could not set close on exec: %s\n",
>+			strerror(errno));
>+		exit(1);
>+	}
>=20
> 	ret =3D malloc(PROCFILE_BUFSIZ);
> 	if (ret) {
>@@ -697,6 +702,12 @@ static int compatible_revision(const char *name, =
uint8_t revision, int opt)
> 		exit(1);
> 	}
>=20
>+	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
>+		fprintf(stderr, "Could not set close on exec: %s\n",
>+			strerror(errno));
>+		exit(1);
>+	}
>+
> 	xtables_load_ko(xtables_modprobe_program, true);
>=20
> 	strcpy(rev.name, name);
>--=20
>1.7.3.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-de=
vel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
