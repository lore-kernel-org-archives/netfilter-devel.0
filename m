From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 08/17] v4: rename for_each_chain() to for_each_chain4()
Date: Thu, 31 Mar 2011 21:27:24 -0700
Message-ID: <1301632053-3694-8-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1750807Ab1DAE2X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:23 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:23 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 include/iptables.h |    2 +-
 iptables-restore.c |    4 ++--
 iptables.c         |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/iptables.h b/include/iptables.h
index 84211c3..76cc8d6 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -13,7 +13,7 @@ extern int delete_chain(const ipt_chainlabel chain, i=
nt verbose,
 			struct iptc_handle *handle);
 extern int flush_entries(const ipt_chainlabel chain, int verbose,=20
 			struct iptc_handle *handle);
-extern int for_each_chain(int (*fn)(const ipt_chainlabel, int, struct =
iptc_handle *),
+extern int for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct=
 iptc_handle *),
 		int verbose, int builtinstoo, struct iptc_handle *handle);
 extern void print_rule(const struct ipt_entry *e,
 		struct iptc_handle *handle, const char *chain, int counters);
diff --git a/iptables-restore.c b/iptables-restore.c
index 34a8156..d3b7124 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -233,12 +233,12 @@ main(int argc, char *argv[])
 			if (noflush =3D=3D 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-				for_each_chain(flush_entries, verbose, 1,
+				for_each_chain4(flush_entries, verbose, 1,
 						handle);
=20
 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
-				for_each_chain(delete_chain, verbose, 0,
+				for_each_chain4(delete_chain, verbose, 0,
 						handle);
 			}
=20
diff --git a/iptables.c b/iptables.c
index cff4a7b..b7cedd2 100644
--- a/iptables.c
+++ b/iptables.c
@@ -862,7 +862,7 @@ check_entry(const ipt_chainlabel chain, struct ipt_=
entry *fw,
 }
=20
 int
-for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle=
 *),
+for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct iptc_handl=
e *),
 	       int verbose, int builtinstoo, struct iptc_handle *handle)
 {
         int ret =3D 1;
@@ -902,7 +902,7 @@ flush_entries(const ipt_chainlabel chain, int verbo=
se,
 	      struct iptc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain(flush_entries, verbose, 1, handle);
+		return for_each_chain4(flush_entries, verbose, 1, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Flushing chain `%s'\n", chain);
@@ -914,7 +914,7 @@ zero_entries(const ipt_chainlabel chain, int verbos=
e,
 	     struct iptc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain(zero_entries, verbose, 1, handle);
+		return for_each_chain4(zero_entries, verbose, 1, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Zeroing chain `%s'\n", chain);
@@ -926,7 +926,7 @@ delete_chain(const ipt_chainlabel chain, int verbos=
e,
 	     struct iptc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain(delete_chain, verbose, 0, handle);
+		return for_each_chain4(delete_chain, verbose, 0, handle);
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
