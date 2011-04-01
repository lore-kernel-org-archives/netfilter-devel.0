From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 10/17] v4: rename flush_entries() to flush_entries4()
Date: Thu, 31 Mar 2011 21:27:26 -0700
Message-ID: <1301632053-3694-10-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1751590Ab1DAE21 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:27 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so3069298iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:26 -0700 (PDT)
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
index 76cc8d6..a2ed9d6 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -11,7 +11,7 @@ extern int do_command(int argc, char *argv[], char **=
table,
 		      struct iptc_handle **handle);
 extern int delete_chain(const ipt_chainlabel chain, int verbose,
 			struct iptc_handle *handle);
-extern int flush_entries(const ipt_chainlabel chain, int verbose,=20
+extern int flush_entries4(const ipt_chainlabel chain, int verbose,=20
 			struct iptc_handle *handle);
 extern int for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct=
 iptc_handle *),
 		int verbose, int builtinstoo, struct iptc_handle *handle);
diff --git a/iptables-restore.c b/iptables-restore.c
index d3b7124..1bdce8a 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -233,7 +233,7 @@ main(int argc, char *argv[])
 			if (noflush =3D=3D 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-				for_each_chain4(flush_entries, verbose, 1,
+				for_each_chain4(flush_entries4, verbose, 1,
 						handle);
=20
 				DEBUGP("Deleting all user-defined chains "
diff --git a/iptables.c b/iptables.c
index b7cedd2..3987b67 100644
--- a/iptables.c
+++ b/iptables.c
@@ -898,11 +898,11 @@ for_each_chain4(int (*fn)(const ipt_chainlabel, i=
nt, struct iptc_handle *),
 }
=20
 int
-flush_entries(const ipt_chainlabel chain, int verbose,
+flush_entries4(const ipt_chainlabel chain, int verbose,
 	      struct iptc_handle *handle)
 {
 	if (!chain)
-		return for_each_chain4(flush_entries, verbose, 1, handle);
+		return for_each_chain4(flush_entries4, verbose, 1, handle);
=20
 	if (verbose)
 		fprintf(stdout, "Flushing chain `%s'\n", chain);
@@ -1975,7 +1975,7 @@ int do_command(int argc, char *argv[], char **tab=
le, struct iptc_handle **handle
 				   *handle);
 		break;
 	case CMD_FLUSH:
-		ret =3D flush_entries(chain, cs.options&OPT_VERBOSE, *handle);
+		ret =3D flush_entries4(chain, cs.options&OPT_VERBOSE, *handle);
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
