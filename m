From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 17/17] v6: rename do_command() to do_command6()
Date: Thu, 31 Mar 2011 21:27:33 -0700
Message-ID: <1301632053-3694-17-git-send-email-zenczykowski@gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1DAEbk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:31:40 -0400
Received: by iyb14 with SMTP id 14so3071582iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:31:39 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

(actually only applies to two comments, since the
function has long been called do_command6)

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 ip6tables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 83d8aed..15508d6 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1407,11 +1407,11 @@ int do_command6(int argc, char *argv[], char **=
table, struct ip6tc_handle **hand
 	cs.jumpto =3D "";
 	cs.argv =3D argv;
=20
-	/* re-set optind to 0 in case do_command gets called
+	/* re-set optind to 0 in case do_command6 gets called
 	 * a second time */
 	optind =3D 0;
=20
-	/* clear mflags in case do_command gets called a second time
+	/* clear mflags in case do_command6 gets called a second time
 	 * (we clear the global list of all matches for security)*/
 	for (m =3D xtables_matches; m; m =3D m->next)
 		m->mflags =3D 0;
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
