From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 01/17] man pages: allow underscores in match and target names
Date: Thu, 31 Mar 2011 21:27:17 -0700
Message-ID: <1301632053-3694-1-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1750866Ab1DAE1y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:27:54 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so3069298iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:27:54 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 extensions/GNUmakefile.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 74a058c..b96bd11 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -155,8 +155,8 @@ initext6.c: .initext6.dd
 #
 #	Manual pages
 #
-ex_matches =3D $(sort $(shell echo $(1) | LC_ALL=3DPOSIX grep -Eo '\b[=
[:alnum:]]+\b'))
-ex_targets =3D $(sort $(shell echo $(1) | LC_ALL=3DPOSIX grep -Eo '\b[=
[:alnum:]]+\b'))
+ex_matches =3D $(sort $(shell echo $(1) | LC_ALL=3DPOSIX grep -Eo '\b[=
[:alnum:]_]+\b'))
+ex_targets =3D $(sort $(shell echo $(1) | LC_ALL=3DPOSIX grep -Eo '\b[=
[:alnum:]_]+\b'))
 man_run    =3D \
 	${AM_VERBOSE_GEN} \
 	for ext in $(1); do \
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
