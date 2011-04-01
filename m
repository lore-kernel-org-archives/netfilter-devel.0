From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 09/17] v6: rename for_each_chain() to for_each_chain6()
Date: Thu, 31 Mar 2011 21:27:25 -0700
Message-ID: <1301632053-3694-9-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1750807Ab1DAE2Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:25 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so3069298iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:24 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 include/ip6tables.h |    2 +-
 ip6tables-restore.c |    4 ++--
 ip6tables.c         |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index ca0f9a0..e9a0f4e 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -10,7 +10,7 @@
 extern int do_command6(int argc, char *argv[], char **table,
 		       struct ip6tc_handle **handle);
=20
-extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct=
 ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *ha=
ndle);
+extern int for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struc=
t ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *h=
andle);
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, str=
uct ip6tc_handle *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, stru=
ct ip6tc_handle *handle);
 void print_rule(const struct ip6t_entry *e, struct ip6tc_handle *h, co=
nst char *chain, int counters);
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 48ff98c..a4e3707 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -226,12 +226,12 @@ int main(int argc, char *argv[])
 			if (noflush =3D=3D 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-				for_each_chain(flush_entries, verbose, 1,
+				for_each_chain6(flush_entries, verbose, 1,
 						handle);
=20
 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
-				for_each_chain(delete_chain, verbose, 0,
+				for_each_chain6(delete_chain, verbose, 0,
 						handle);
 			}
=20
diff --git a/ip6tables.c b/ip6tables.c
index 96a0fdc..6774586 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -859,7 +859,7 @@ check_entry(const ip6t_chainlabel chain, struct ip6=
t_entry *fw,
 }
=20
 int
-for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_hand=
le *),
+for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_han=
dle *),
 	       int verbose, int builtinstoo, struct ip6tc_handle *handle)
 {
 	int ret =3D 1;
@@ -899,7 +899,7 @@ flush_entries(const ip6t_chainlabel chain, int verb=
ose,
 	      struct ip6tc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain(flush_entries, verbose, 1, handle);
+		return for_each_chain6(flush_entries, verbose, 1, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Flushing chain `%s'\n", chain);
@@ -911,7 +911,7 @@ zero_entries(const ip6t_chainlabel chain, int verbo=
se,
 	     struct ip6tc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain(zero_entries, verbose, 1, handle);
+		return for_each_chain6(zero_entries, verbose, 1, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Zeroing chain `%s'\n", chain);
@@ -923,7 +923,7 @@ delete_chain(const ip6t_chainlabel chain, int verbo=
se,
 	     struct ip6tc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain(delete_chain, verbose, 0, handle);
+		return for_each_chain6(delete_chain, verbose, 0, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Deleting chain `%s'\n", chain);
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
