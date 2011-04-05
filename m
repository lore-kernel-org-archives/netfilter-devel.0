From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH] convert ip6?tables-multi to actually use their own header files
Date: Mon,  4 Apr 2011 22:44:23 -0700
Message-ID: <1301982263-32339-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45059 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1DEFog (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2011 01:44:36 -0400
Received: by iyb14 with SMTP id 14so35309iyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Apr 2011 22:44:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej Zenczykowski <maze@google.com>
---
 ip6tables-multi.c |    5 +----
 iptables-multi.c  |    6 +-----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/ip6tables-multi.c b/ip6tables-multi.c
index 7e6603f..40ce37b 100644
--- a/ip6tables-multi.c
+++ b/ip6tables-multi.c
@@ -2,10 +2,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include "xshared.h"
-
-int ip6tables_main(int argc, char **argv);
-int ip6tables_save_main(int argc, char **argv);
-int ip6tables_restore_main(int argc, char **argv);
+#include "ip6tables-multi.h"
=20
 static const struct subcommand multi6_subcommands[] =3D {
 	{"ip6tables",         ip6tables_main},
diff --git a/iptables-multi.c b/iptables-multi.c
index 754b587..14579e0 100644
--- a/iptables-multi.c
+++ b/iptables-multi.c
@@ -2,11 +2,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include "xshared.h"
-
-int iptables_main(int argc, char **argv);
-int iptables_save_main(int argc, char **argv);
-int iptables_restore_main(int argc, char **argv);
-int iptables_xml_main(int argc, char **argv);
+#include "iptables-multi.h"
=20
 static const struct subcommand multi4_subcommands[] =3D {
 	{"iptables",         iptables_main},
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
