From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 15/17] v6: rename print_rule() to print_rule6()
Date: Thu, 31 Mar 2011 21:27:31 -0700
Message-ID: <1301632053-3694-15-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1750936Ab1DAE2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:35 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:35 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 include/ip6tables.h |    2 +-
 ip6tables-save.c    |    2 +-
 ip6tables.c         |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 48633b7..e976361 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -13,7 +13,7 @@ extern int do_command6(int argc, char *argv[], char *=
*table,
 extern int for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struc=
t ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *h=
andle);
 extern int flush_entries6(const ip6t_chainlabel chain, int verbose, st=
ruct ip6tc_handle *handle);
 extern int delete_chain6(const ip6t_chainlabel chain, int verbose, str=
uct ip6tc_handle *handle);
-void print_rule(const struct ip6t_entry *e, struct ip6tc_handle *h, co=
nst char *chain, int counters);
+void print_rule6(const struct ip6t_entry *e, struct ip6tc_handle *h, c=
onst char *chain, int counters);
=20
 extern struct xtables_globals ip6tables_globals;
=20
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 1a5e3c8..d9ecc62 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -109,7 +109,7 @@ static int do_output(const char *tablename)
 			/* Dump out rules */
 			e =3D ip6tc_first_rule(chain, h);
 			while(e) {
-				print_rule(e, h, chain, show_counters);
+				print_rule6(e, h, chain, show_counters);
 				e =3D ip6tc_next_rule(e, h);
 			}
 		}
diff --git a/ip6tables.c b/ip6tables.c
index a8ea551..83d8aed 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1083,7 +1083,7 @@ static void print_ip(const char *prefix, const st=
ruct in6_addr *ip,
=20
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
-void print_rule(const struct ip6t_entry *e,
+void print_rule6(const struct ip6t_entry *e,
 		       struct ip6tc_handle *h, const char *chain, int counters)
 {
 	const struct ip6t_entry_target *t;
@@ -1215,7 +1215,7 @@ list_rules(const ip6t_chainlabel chain, int rulen=
um, int counters,
 		while(e) {
 			num++;
 			if (!rulenum || num =3D=3D rulenum)
-			    print_rule(e, handle, this, counters);
+			    print_rule6(e, handle, this, counters);
 			e =3D ip6tc_next_rule(e, handle);
 		}
 		found =3D 1;
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
