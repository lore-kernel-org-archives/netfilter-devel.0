From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 07/17] xtables.h: init_extensions() no longer exists.
Date: Thu, 31 Mar 2011 21:27:23 -0700
Message-ID: <1301632053-3694-7-git-send-email-zenczykowski@gmail.com>
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
	with ESMTP id S1750807Ab1DAE2V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:28:21 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3083966iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:28:21 -0700 (PDT)
In-Reply-To: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 include/xtables.h.in |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index bb0a40c..c71839e 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -284,7 +284,6 @@ extern void xtables_save_string(const char *value);
 #		undef _init
 #		define _init _INIT
 #	endif
-	extern void init_extensions(void);
 	extern void init_extensions4(void);
 	extern void init_extensions6(void);
 #else
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
