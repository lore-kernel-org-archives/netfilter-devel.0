From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 11/17] v6: rename flush_entries() to flush_entries6()
Date: Thu, 31 Mar 2011 21:27:27 -0700
Message-ID: <1301632053-3694-11-git-send-email-zenczykowski@gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51270 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab1DAE22 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:28 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so3069298iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:28 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 include/ip6tables.h |    2 +-
 ip6tables-restore.c |    2 +-
 ip6tables.c         |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index e9a0f4e..672faed 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -11,7 +11,7 @@ extern int do_command6(int argc, char *argv[], char *=
*table,
 		       struct ip6tc_handle **handle);
=20
 extern int for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struc=
t ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *h=
andle);
-extern int flush_entries(const ip6t_chainlabel chain, int verbose, str=
uct ip6tc_handle *handle);
+extern int flush_entries6(const ip6t_chainlabel chain, int verbose, st=
ruct ip6tc_handle *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, stru=
ct ip6tc_handle *handle);
 void print_rule(const struct ip6t_entry *e, struct ip6tc_handle *h, co=
nst char *chain, int counters);
=20
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index a4e3707..3b50a54 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -226,7 +226,7 @@ int main(int argc, char *argv[])
 			if (noflush =3D=3D 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-				for_each_chain6(flush_entries, verbose, 1,
+				for_each_chain6(flush_entries6, verbose, 1,
 						handle);
=20
 				DEBUGP("Deleting all user-defined chains "
diff --git a/ip6tables.c b/ip6tables.c
index 6774586..abcf0ca 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -895,11 +895,11 @@ for_each_chain6(int (*fn)(const ip6t_chainlabel, =
int, struct ip6tc_handle *),
 }
=20
 int
-flush_entries(const ip6t_chainlabel chain, int verbose,
+flush_entries6(const ip6t_chainlabel chain, int verbose,
 	      struct ip6tc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain6(flush_entries, verbose, 1, handle);
+		return for_each_chain6(flush_entries6, verbose, 1, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Flushing chain `%s'\n", chain);
@@ -1937,7 +1937,7 @@ int do_command6(int argc, char *argv[], char **ta=
ble, struct ip6tc_handle **hand
 				   *handle);
 		break;
 	case CMD_FLUSH:
-		ret =3D flush_entries(chain, cs.options&OPT_VERBOSE, *handle);
+		ret =3D flush_entries6(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_ZERO:
 		ret =3D zero_entries(chain, cs.options&OPT_VERBOSE, *handle);
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
