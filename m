From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] build: use _DEFAULT_SOURCE for newer glibc
Date: Tue, 18 Aug 2015 18:07:38 -0400
Message-ID: <1439935658-17834-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:58275 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbbHRWHo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 18:07:44 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 7E7FC340914
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2015 22:07:43 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since _BSD_SOURCE is deprecated with newer glibc versions, we get build
warnings when using only that define.  Add the newer _DEFAULT_SOURCE to
quiet things down.

=46or example, we currently see:
In file included from /usr/include/math.h:26:0,
                 from libxt_hashlimit.c:15:
/usr/include/features.h:148:3: warning:
 # warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_S=
OURCE"

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 extensions/libxt_hashlimit.c | 1 +
 extensions/libxt_limit.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.=
c
index c5b8d77..cbe06bb 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -10,6 +10,7 @@
  *=20
  * Error corections by nmalykh@bilim.com (22.01.2005)
  */
+#define _DEFAULT_SOURCE 1
 #define _BSD_SOURCE 1
 #define _ISOC99_SOURCE 1
 #include <math.h>
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index f75ef2f..dd8885a 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -3,6 +3,7 @@
  * J=C3=A9r=C3=B4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
  * Herv=C3=A9 Eychenne    <rv@wallfire.org>
  */
+#define _DEFAULT_SOURCE 1
 #define _BSD_SOURCE 1
 #define _ISOC99_SOURCE 1
 #include <math.h>
--=20
2.4.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
