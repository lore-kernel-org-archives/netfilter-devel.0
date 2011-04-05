From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH] move 'int line' definition from ip6?tables.c into xtables.c
Date: Mon,  4 Apr 2011 22:43:36 -0700
Message-ID: <1301982216-32294-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56207 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1DEFoQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2011 01:44:16 -0400
Received: by yxs7 with SMTP id 7so11874yxs.19
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Apr 2011 22:44:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej Zenczykowski <maze@google.com>
---
 ip6tables.c |    6 ------
 iptables.c  |    6 ------
 xtables.c   |    6 ++++++
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 15508d6..ea9a7abf 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -127,12 +127,6 @@ static struct option original_opts[] =3D {
 	{NULL},
 };
=20
-/* we need this for ip6tables-restore. ip6tables-restore.c sets line t=
o the
- * current line of the input file, in order to give a more precise err=
or
- * message. ip6tables itself doesn't need this, so it is initialized t=
o the
- * magic number of -1 */
-int line =3D -1;
-
 void ip6tables_exit_error(enum xtables_exittype status, const char *ms=
g, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ip6tables_globals =3D {
 	.option_offset =3D 0,
diff --git a/iptables.c b/iptables.c
index 0995d6f..cf27227 100644
--- a/iptables.c
+++ b/iptables.c
@@ -126,12 +126,6 @@ static struct option original_opts[] =3D {
 	{NULL},
 };
=20
-/* we need this for iptables-restore.  iptables-restore.c sets line to=
 the
- * current line of the input file, in order  to give a more precise er=
ror
- * message.  iptables itself doesn't need this, so it is initialized t=
o the
- * magic number of -1 */
-int line =3D -1;
-
 void iptables_exit_error(enum xtables_exittype status, const char *msg=
, ...) __attribute__((noreturn, format(printf,2,3)));
=20
 struct xtables_globals iptables_globals =3D {
diff --git a/xtables.c b/xtables.c
index 4c708b8..339a25b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -57,6 +57,12 @@
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
=20
+/* we need this for ip6?tables-restore.  ip6?tables-restore.c sets lin=
e to the
+ * current line of the input file, in order  to give a more precise er=
ror
+ * message.  ip6?tables itself doesn't need this, so it is initialized=
 to the
+ * magic number of -1 */
+int line =3D -1;
+
 void basic_exit_err(enum xtables_exittype status, const char *msg, ...=
) __attribute__((noreturn, format(printf,2,3)));
=20
 struct xtables_globals *xt_params =3D NULL;
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
