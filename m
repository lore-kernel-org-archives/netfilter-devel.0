From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 4/8] iptables: use C99 lists for struct options
Date: Sun, 13 Apr 2008 10:25:50 +0200
Message-ID: <7e115b3078d0fdeab365664b0098b6690735ac53.1208075035.git.jengelh@computergmbh.de>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?utf-8?q?G=C3=A1sp=C3=A1r=20Lajos?= <swifty@freemail.hu>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36089 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYDMIZ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:25:56 -0400
In-Reply-To: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
References: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: G=C3=A1sp=C3=A1r Lajos <swifty@freemail.hu>

---
 ip6tables-restore.c |   18 ++++++------
 ip6tables-save.c    |   12 ++++----
 ip6tables.c         |   60 ++++++++++++++++++++--------------------
 iptables-restore.c  |   20 +++++++-------
 iptables-save.c     |   12 ++++----
 iptables.c          |   64 +++++++++++++++++++++---------------------
 6 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 2c3e95d..c2703dc 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -29,15 +29,15 @@
 static int binary =3D 0, counters =3D 0, verbose =3D 0, noflush =3D 0;
=20
 /* Keeping track of external matches and targets.  */
-static struct option options[] =3D {
-	{ "binary", 0, 0, 'b' },
-	{ "counters", 0, 0, 'c' },
-	{ "verbose", 0, 0, 'v' },
-	{ "test", 0, 0, 't' },
-	{ "help", 0, 0, 'h' },
-	{ "noflush", 0, 0, 'n'},
-	{ "modprobe", 1, 0, 'M'},
-	{ 0 }
+static const struct option options[] =3D {
+	{.name =3D "binary",   .has_arg =3D false, .val =3D 'b'},
+	{.name =3D "counters", .has_arg =3D false, .val =3D 'c'},
+	{.name =3D "verbose",  .has_arg =3D false, .val =3D 'v'},
+	{.name =3D "test",     .has_arg =3D false, .val =3D 't'},
+	{.name =3D "help",     .has_arg =3D false, .val =3D 'h'},
+	{.name =3D "noflush",  .has_arg =3D false, .val =3D 'n'},
+	{.name =3D "modprobe", .has_arg =3D true,  .val =3D 'M'},
+	{NULL},
 };
=20
 static void print_usage(const char *name, const char *version) __attri=
bute__((noreturn));
diff --git a/ip6tables-save.c b/ip6tables-save.c
index e440887..6e2fea5 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -24,12 +24,12 @@
=20
 static int show_binary =3D 0, show_counters =3D 0;
=20
-static struct option options[] =3D {
-	{ "binary", 0, 0, 'b' },
-	{ "counters", 0, 0, 'c' },
-	{ "dump", 0, 0, 'd' },
-	{ "table", 1, 0, 't' },
-	{ 0 }
+static const struct option options[] =3D {
+	{.name =3D "binary",   .has_arg =3D false, .val =3D 'b'},
+	{.name =3D "counters", .has_arg =3D false, .val =3D 'c'},
+	{.name =3D "dump",     .has_arg =3D false, .val =3D 'd'},
+	{.name =3D "table",    .has_arg =3D true,  .val =3D 't'},
+	{NULL},
 };
=20
=20
diff --git a/ip6tables.c b/ip6tables.c
index c7d4a4f..908700e 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -101,36 +101,36 @@ static const char optflags[NUMBER_OF_OPT]
 =3D { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c'};
=20
 static struct option original_opts[] =3D {
-	{ "append", 1, 0, 'A' },
-	{ "delete", 1, 0,  'D' },
-	{ "insert", 1, 0,  'I' },
-	{ "replace", 1, 0,  'R' },
-	{ "list", 2, 0,  'L' },
-	{ "flush", 2, 0,  'F' },
-	{ "zero", 2, 0,  'Z' },
-	{ "new-chain", 1, 0,  'N' },
-	{ "delete-chain", 2, 0,  'X' },
-	{ "rename-chain", 1, 0,  'E' },
-	{ "policy", 1, 0,  'P' },
-	{ "source", 1, 0, 's' },
-	{ "destination", 1, 0,  'd' },
-	{ "src", 1, 0,  's' }, /* synonym */
-	{ "dst", 1, 0,  'd' }, /* synonym */
-	{ "protocol", 1, 0,  'p' },
-	{ "in-interface", 1, 0, 'i' },
-	{ "jump", 1, 0, 'j' },
-	{ "table", 1, 0, 't' },
-	{ "match", 1, 0, 'm' },
-	{ "numeric", 0, 0, 'n' },
-	{ "out-interface", 1, 0, 'o' },
-	{ "verbose", 0, 0, 'v' },
-	{ "exact", 0, 0, 'x' },
-	{ "version", 0, 0, 'V' },
-	{ "help", 2, 0, 'h' },
-	{ "line-numbers", 0, 0, '0' },
-	{ "modprobe", 1, 0, 'M' },
-	{ "set-counters", 1, 0, 'c' },
-	{ 0 }
+	{.name =3D "append",        .has_arg =3D 1, .val =3D 'A'},
+	{.name =3D "delete",        .has_arg =3D 1, .val =3D 'D'},
+	{.name =3D "insert",        .has_arg =3D 1, .val =3D 'I'},
+	{.name =3D "replace",       .has_arg =3D 1, .val =3D 'R'},
+	{.name =3D "list",          .has_arg =3D 2, .val =3D 'L'},
+	{.name =3D "flush",         .has_arg =3D 2, .val =3D 'F'},
+	{.name =3D "zero",          .has_arg =3D 2, .val =3D 'Z'},
+	{.name =3D "new-chain",     .has_arg =3D 1, .val =3D 'N'},
+	{.name =3D "delete-chain",  .has_arg =3D 2, .val =3D 'X'},
+	{.name =3D "rename-chain",  .has_arg =3D 1, .val =3D 'E'},
+	{.name =3D "policy",        .has_arg =3D 1, .val =3D 'P'},
+	{.name =3D "source",        .has_arg =3D 1, .val =3D 's'},
+	{.name =3D "destination",   .has_arg =3D 1, .val =3D 'd'},
+	{.name =3D "src",           .has_arg =3D 1, .val =3D 's'}, /* synonym=
 */
+	{.name =3D "dst",           .has_arg =3D 1, .val =3D 'd'}, /* synonym=
 */
+	{.name =3D "protocol",      .has_arg =3D 1, .val =3D 'p'},
+	{.name =3D "in-interface",  .has_arg =3D 1, .val =3D 'i'},
+	{.name =3D "jump",          .has_arg =3D 1, .val =3D 'j'},
+	{.name =3D "table",         .has_arg =3D 1, .val =3D 't'},
+	{.name =3D "match",         .has_arg =3D 1, .val =3D 'm'},
+	{.name =3D "numeric",       .has_arg =3D 0, .val =3D 'n'},
+	{.name =3D "out-interface", .has_arg =3D 1, .val =3D 'o'},
+	{.name =3D "verbose",       .has_arg =3D 0, .val =3D 'v'},
+	{.name =3D "exact",         .has_arg =3D 0, .val =3D 'x'},
+	{.name =3D "version",       .has_arg =3D 0, .val =3D 'V'},
+	{.name =3D "help",          .has_arg =3D 2, .val =3D 'h'},
+	{.name =3D "line-numbers",  .has_arg =3D 0, .val =3D '0'},
+	{.name =3D "modprobe",      .has_arg =3D 1, .val =3D 'M'},
+	{.name =3D "set-counters",  .has_arg =3D 1, .val =3D 'c'},
+	{NULL},
 };
=20
 /* we need this for ip6tables-restore. ip6tables-restore.c sets line t=
o the
diff --git a/iptables-restore.c b/iptables-restore.c
index f556fa5..ecf7b2d 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -26,16 +26,16 @@
 static int binary =3D 0, counters =3D 0, verbose =3D 0, noflush =3D 0;
=20
 /* Keeping track of external matches and targets.  */
-static struct option options[] =3D {
-	{ "binary", 0, 0, 'b' },
-	{ "counters", 0, 0, 'c' },
-	{ "verbose", 0, 0, 'v' },
-	{ "test", 0, 0, 't' },
-	{ "help", 0, 0, 'h' },
-	{ "noflush", 0, 0, 'n'},
-	{ "modprobe", 1, 0, 'M'},
-	{ "table", 1, 0, 'T'},
-	{ 0 }
+static const struct option options[] =3D {
+	{.name =3D "binary",   .has_arg =3D false, .val =3D 'b'},
+	{.name =3D "counters", .has_arg =3D false, .val =3D 'c'},
+	{.name =3D "verbose",  .has_arg =3D false, .val =3D 'v'},
+	{.name =3D "test",     .has_arg =3D false, .val =3D 't'},
+	{.name =3D "help",     .has_arg =3D false, .val =3D 'h'},
+	{.name =3D "noflush",  .has_arg =3D false, .val =3D 'n'},
+	{.name =3D "modprobe", .has_arg =3D true,  .val =3D 'M'},
+	{.name =3D "table",    .has_arg =3D true,  .val =3D 'T'},
+	{NULL},
 };
=20
 static void print_usage(const char *name, const char *version) __attri=
bute__((noreturn));
diff --git a/iptables-save.c b/iptables-save.c
index 1ce2090..4272202 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -23,12 +23,12 @@
=20
 static int show_binary =3D 0, show_counters =3D 0;
=20
-static struct option options[] =3D {
-	{ "binary", 0, 0, 'b' },
-	{ "counters", 0, 0, 'c' },
-	{ "dump", 0, 0, 'd' },
-	{ "table", 1, 0, 't' },
-	{ 0 }
+static const struct option options[] =3D {
+	{.name =3D "binary",   .has_arg =3D false, .val =3D 'b'},
+	{.name =3D "counters", .has_arg =3D false, .val =3D 'c'},
+	{.name =3D "dump",     .has_arg =3D false, .val =3D 'd'},
+	{.name =3D "table",    .has_arg =3D true,  .val =3D 't'},
+	{NULL},
 };
=20
 #define IP_PARTS_NATIVE(n)			\
diff --git a/iptables.c b/iptables.c
index 7cc2448..0300027 100644
--- a/iptables.c
+++ b/iptables.c
@@ -99,38 +99,38 @@ static const char optflags[NUMBER_OF_OPT]
 =3D { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', 'f', '0', 'c'};
=20
 static struct option original_opts[] =3D {
-	{ "append", 1, NULL, 'A' },
-	{ "delete", 1, NULL,  'D' },
-	{ "insert", 1, NULL,  'I' },
-	{ "replace", 1, NULL,  'R' },
-	{ "list", 2, NULL,  'L' },
-	{ "flush", 2, NULL,  'F' },
-	{ "zero", 2, NULL,  'Z' },
-	{ "new-chain", 1, NULL,  'N' },
-	{ "delete-chain", 2, NULL,  'X' },
-	{ "rename-chain", 1, NULL,  'E' },
-	{ "policy", 1, NULL,  'P' },
-	{ "source", 1, NULL, 's' },
-	{ "destination", 1, NULL,  'd' },
-	{ "src", 1, NULL,  's' }, /* synonym */
-	{ "dst", 1, NULL,  'd' }, /* synonym */
-	{ "protocol", 1, NULL,  'p' },
-	{ "in-interface", 1, NULL, 'i' },
-	{ "jump", 1, NULL, 'j' },
-	{ "table", 1, NULL, 't' },
-	{ "match", 1, NULL, 'm' },
-	{ "numeric", 0, NULL, 'n' },
-	{ "out-interface", 1, NULL, 'o' },
-	{ "verbose", 0, NULL, 'v' },
-	{ "exact", 0, NULL, 'x' },
-	{ "fragments", 0, NULL, 'f' },
-	{ "version", 0, NULL, 'V' },
-	{ "help", 2, NULL, 'h' },
-	{ "line-numbers", 0, NULL, '0' },
-	{ "modprobe", 1, NULL, 'M' },
-	{ "set-counters", 1, NULL, 'c' },
-	{ "goto", 1, NULL, 'g' },
-	{ }
+	{.name =3D "append",        .has_arg =3D 1, .val =3D 'A'},
+	{.name =3D "delete",        .has_arg =3D 1, .val =3D 'D'},
+	{.name =3D "insert",        .has_arg =3D 1, .val =3D 'I'},
+	{.name =3D "replace",       .has_arg =3D 1, .val =3D 'R'},
+	{.name =3D "list",          .has_arg =3D 2, .val =3D 'L'},
+	{.name =3D "flush",         .has_arg =3D 2, .val =3D 'F'},
+	{.name =3D "zero",          .has_arg =3D 2, .val =3D 'Z'},
+	{.name =3D "new-chain",     .has_arg =3D 1, .val =3D 'N'},
+	{.name =3D "delete-chain",  .has_arg =3D 2, .val =3D 'X'},
+	{.name =3D "rename-chain",  .has_arg =3D 1, .val =3D 'E'},
+	{.name =3D "policy",        .has_arg =3D 1, .val =3D 'P'},
+	{.name =3D "source",        .has_arg =3D 1, .val =3D 's'},
+	{.name =3D "destination",   .has_arg =3D 1, .val =3D 'd'},
+	{.name =3D "src",           .has_arg =3D 1, .val =3D 's'}, /* synonym=
 */
+	{.name =3D "dst",           .has_arg =3D 1, .val =3D 'd'}, /* synonym=
 */
+	{.name =3D "protocol",      .has_arg =3D 1, .val =3D 'p'},
+	{.name =3D "in-interface",  .has_arg =3D 1, .val =3D 'i'},
+	{.name =3D "jump",          .has_arg =3D 1, .val =3D 'j'},
+	{.name =3D "table",         .has_arg =3D 1, .val =3D 't'},
+	{.name =3D "match",         .has_arg =3D 1, .val =3D 'm'},
+	{.name =3D "numeric",       .has_arg =3D 0, .val =3D 'n'},
+	{.name =3D "out-interface", .has_arg =3D 1, .val =3D 'o'},
+	{.name =3D "verbose",       .has_arg =3D 0, .val =3D 'v'},
+	{.name =3D "exact",         .has_arg =3D 0, .val =3D 'x'},
+	{.name =3D "fragments",     .has_arg =3D 0, .val =3D 'f'},
+	{.name =3D "version",       .has_arg =3D 0, .val =3D 'V'},
+	{.name =3D "help",          .has_arg =3D 2, .val =3D 'h'},
+	{.name =3D "line-numbers",  .has_arg =3D 0, .val =3D '0'},
+	{.name =3D "modprobe",      .has_arg =3D 1, .val =3D 'M'},
+	{.name =3D "set-counters",  .has_arg =3D 1, .val =3D 'c'},
+	{.name =3D "goto",          .has_arg =3D 1, .val =3D 'g'},
+	{NULL},
 };
=20
 /* we need this for iptables-restore.  iptables-restore.c sets line to=
 the
--=20
1.5.5.rc3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
