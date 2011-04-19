From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 2/5] Add --ipv4/-4 and --ipv6/-6 support to ip6?tables{,-restore}.
Date: Mon, 18 Apr 2011 18:23:50 -0700
Message-ID: <1303176233-14063-2-git-send-email-zenczykowski@gmail.com>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50715 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1DSBYU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:24:20 -0400
Received: by pzk9 with SMTP id 9so2374021pzk.19
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2011 18:24:19 -0700 (PDT)
In-Reply-To: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

This enables one to have a single configuration file for both ipv4 and =
ipv6
firewall rules.

Example:
  iptables-restore config
  ip6tables-restore config

Where the file 'config' contains:
  *filter
  :INPUT ACCEPT [0:0]
  :FORWARD ACCEPT [0:0]
  :OUTPUT ACCEPT [0:0]
  :ssh - [0:0]

  -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  -A INPUT -m state --state INVALID -j DROP
  -A INPUT -i lo -j ACCEPT
  -A INPUT -4 -p icmp -j ACCEPT
  -A INPUT -6 -p icmpv6 -j ACCEPT
  -A INPUT -p tcp --dport 22 -m state --state NEW -j ssh
  -A ssh -j ACCEPT

  COMMIT

Signed-off-by: Maciej Zenczykowski <maze@google.com>
---
 ip6tables.c |   16 +++++++++++++++-
 iptables.c  |   15 ++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index f9909f1..8d73641 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -124,6 +124,8 @@ static struct option original_opts[] =3D {
 	{.name =3D "modprobe",      .has_arg =3D 1, .val =3D 'M'},
 	{.name =3D "set-counters",  .has_arg =3D 1, .val =3D 'c'},
 	{.name =3D "goto",          .has_arg =3D 1, .val =3D 'g'},
+	{.name =3D "ipv4",          .has_arg =3D 0, .val =3D '4'},
+	{.name =3D "ipv6",          .has_arg =3D 0, .val =3D '6'},
 	{NULL},
 };
=20
@@ -248,6 +250,8 @@ exit_printhelp(const struct xtables_rule_match *mat=
ches)
 "				Change chain name, (moving any references)\n"
=20
 "Options:\n"
+"    --ipv4	-4		Error (line is ignored by ip6tables-restore)\n"
+"    --ipv6	-6		Nothing (line is ignored by iptables-restore)\n"
 "[!] --proto	-p proto	protocol: by number or name, eg. `tcp'\n"
 "[!] --source	-s address[/mask][,...]\n"
 "				source specification\n"
@@ -1439,7 +1443,7 @@ int do_command6(int argc, char *argv[], char **ta=
ble, struct ip6tc_handle **hand
=20
 	opts =3D xt_params->orig_opts;
 	while ((cs.c =3D getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:46=
",
 					   opts, NULL)) !=3D -1) {
 		switch (cs.c) {
 			/*
@@ -1756,6 +1760,16 @@ int do_command6(int argc, char *argv[], char **t=
able, struct ip6tc_handle **hand
 			cs.fw6.counters.bcnt =3D cnt;
 			break;
=20
+		case '4':
+			/* This is not the IPv4 iptables */
+			if (line !=3D -1) return 1; /* success: line ignored */
+			fprintf(stderr, "This is the IPv6 version of ip6tables.\n");
+			exit_tryhelp(2);
+
+		case '6':
+			/* This is indeed the IPv6 ip6tables */
+			break;
+
 		case 1: /* non option */
 			if (optarg[0] =3D=3D '!' && optarg[1] =3D=3D '\0') {
 				if (cs.invert)
diff --git a/iptables.c b/iptables.c
index 0441dce..523454d 100644
--- a/iptables.c
+++ b/iptables.c
@@ -123,6 +123,8 @@ static struct option original_opts[] =3D {
 	{.name =3D "modprobe",      .has_arg =3D 1, .val =3D 'M'},
 	{.name =3D "set-counters",  .has_arg =3D 1, .val =3D 'c'},
 	{.name =3D "goto",          .has_arg =3D 1, .val =3D 'g'},
+	{.name =3D "ipv4",          .has_arg =3D 0, .val =3D '4'},
+	{.name =3D "ipv6",          .has_arg =3D 0, .val =3D '6'},
 	{NULL},
 };
=20
@@ -261,6 +263,8 @@ exit_printhelp(const struct xtables_rule_match *mat=
ches)
 "				Change chain name, (moving any references)\n"
=20
 "Options:\n"
+"    --ipv4	-4		Nothing (line is ignored by ip6tables-restore)\n"
+"    --ipv6	-6		Error (line is ignored by iptables-restore)\n"
 "[!] --proto	-p proto	protocol: by number or name, eg. `tcp'\n"
 "[!] --source	-s address[/mask][...]\n"
 "				source specification\n"
@@ -1467,7 +1471,7 @@ int do_command4(int argc, char *argv[], char **ta=
ble, struct iptc_handle **handl
=20
 	opts =3D xt_params->orig_opts;
 	while ((cs.c =3D getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:"=
,
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:4=
6",
 					   opts, NULL)) !=3D -1) {
 		switch (cs.c) {
 			/*
@@ -1782,6 +1786,15 @@ int do_command4(int argc, char *argv[], char **t=
able, struct iptc_handle **handl
 			cs.fw.counters.bcnt =3D cnt;
 			break;
=20
+		case '4':
+			/* This is indeed the IPv4 iptables */
+			break;
+
+		case '6':
+			/* This is not the IPv6 ip6tables */
+			if (line !=3D -1) return 1; /* success: line ignored */
+			fprintf(stderr, "This is the IPv4 version of iptables.\n");
+			exit_tryhelp(2);
=20
 		case 1: /* non option */
 			if (optarg[0] =3D=3D '!' && optarg[1] =3D=3D '\0') {
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
