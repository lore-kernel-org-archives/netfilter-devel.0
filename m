From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 12/17] v4: rename delete_chain() to delete_chain4()
Date: Thu, 31 Mar 2011 21:27:28 -0700
Message-ID: <1301632053-3694-12-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1751399Ab1DAE2a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:30 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so3069298iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:30 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 include/iptables.h |    2 +-
 iptables-restore.c |    2 +-
 iptables.c         |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/iptables.h b/include/iptables.h
index a2ed9d6..4e9ae19 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -9,7 +9,7 @@
 /* Your shared library should call one of these. */
 extern int do_command(int argc, char *argv[], char **table,
 		      struct iptc_handle **handle);
-extern int delete_chain(const ipt_chainlabel chain, int verbose,
+extern int delete_chain4(const ipt_chainlabel chain, int verbose,
 			struct iptc_handle *handle);
 extern int flush_entries4(const ipt_chainlabel chain, int verbose,=20
 			struct iptc_handle *handle);
diff --git a/iptables-restore.c b/iptables-restore.c
index 1bdce8a..6163a92 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -238,7 +238,7 @@ main(int argc, char *argv[])
=20
 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
-				for_each_chain4(delete_chain, verbose, 0,
+				for_each_chain4(delete_chain4, verbose, 0,
 						handle);
 			}
=20
diff --git a/iptables.c b/iptables.c
index 3987b67..5af832e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -922,11 +922,11 @@ zero_entries(const ipt_chainlabel chain, int verb=
ose,
 }
=20
 int
-delete_chain(const ipt_chainlabel chain, int verbose,
+delete_chain4(const ipt_chainlabel chain, int verbose,
 	     struct iptc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain4(delete_chain, verbose, 0, handle);
+		return for_each_chain4(delete_chain4, verbose, 0, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Deleting chain `%s'\n", chain);
@@ -2016,7 +2016,7 @@ int do_command(int argc, char *argv[], char **tab=
le, struct iptc_handle **handle
 		ret =3D iptc_create_chain(chain, *handle);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret =3D delete_chain(chain, cs.options&OPT_VERBOSE, *handle);
+		ret =3D delete_chain4(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_RENAME_CHAIN:
 		ret =3D iptc_rename_chain(chain, newname,	*handle);
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
