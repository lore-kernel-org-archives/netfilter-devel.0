From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 13/17] v6: rename delete_chain() to delete_chain6()
Date: Thu, 31 Mar 2011 21:27:29 -0700
Message-ID: <1301632053-3694-13-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1751399Ab1DAE2c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:32 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:32 -0700 (PDT)
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
index 672faed..48633b7 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -12,7 +12,7 @@ extern int do_command6(int argc, char *argv[], char *=
*table,
=20
 extern int for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struc=
t ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *h=
andle);
 extern int flush_entries6(const ip6t_chainlabel chain, int verbose, st=
ruct ip6tc_handle *handle);
-extern int delete_chain(const ip6t_chainlabel chain, int verbose, stru=
ct ip6tc_handle *handle);
+extern int delete_chain6(const ip6t_chainlabel chain, int verbose, str=
uct ip6tc_handle *handle);
 void print_rule(const struct ip6t_entry *e, struct ip6tc_handle *h, co=
nst char *chain, int counters);
=20
 extern struct xtables_globals ip6tables_globals;
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 3b50a54..5531d6e 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -231,7 +231,7 @@ int main(int argc, char *argv[])
=20
 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
-				for_each_chain6(delete_chain, verbose, 0,
+				for_each_chain6(delete_chain6, verbose, 0,
 						handle);
 			}
=20
diff --git a/ip6tables.c b/ip6tables.c
index abcf0ca..a8ea551 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -919,11 +919,11 @@ zero_entries(const ip6t_chainlabel chain, int ver=
bose,
 }
=20
 int
-delete_chain(const ip6t_chainlabel chain, int verbose,
+delete_chain6(const ip6t_chainlabel chain, int verbose,
 	     struct ip6tc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain6(delete_chain, verbose, 0, handle);
+		return for_each_chain6(delete_chain6, verbose, 0, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Deleting chain `%s'\n", chain);
@@ -1978,7 +1978,7 @@ int do_command6(int argc, char *argv[], char **ta=
ble, struct ip6tc_handle **hand
 		ret =3D ip6tc_create_chain(chain, *handle);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret =3D delete_chain(chain, cs.options&OPT_VERBOSE, *handle);
+		ret =3D delete_chain6(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_RENAME_CHAIN:
 		ret =3D ip6tc_rename_chain(chain, newname,	*handle);
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
