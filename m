From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: resolve compile abort in libxt_limit on RHEL5
Date: Wed, 10 Oct 2012 12:35:14 +0200
Message-ID: <1349865314-27640-3-git-send-email-jengelh@inai.de>
References: <1349865314-27640-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57232 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2JJKfR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:35:17 -0400
In-Reply-To: <1349865314-27640-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

	libxt_limit.c: In function 'print_rate':
	libxt_limit.c:124: error: 'INFINITY' undeclared (first use in
	this function)

The default mode of glibc-2.15's <features.h> sets
"-D_POSIX_C_SOURCE=3D200809L", and therefore "-D_ISOC99_SOURCE". Howeve=
r,
on =C3=BEe olde RHEL 5's glibc-2.5, it only has "-D_POSIX_C_SOURCE=3D20=
0112L".

Explicitly draw in the definition of INFINITY by always defining
_ISOC99_SOURCE. By doing this, we are moving off of the default set, so
_BSD_SOURCE also needs to be explicitly set to get at IFNAMSIZ that is
used in xt_hashlimit.h.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_hashlimit.c |    2 ++
 extensions/libxt_limit.c     |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.=
c
index 831345b..c5b8d77 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -10,6 +10,8 @@
  *=20
  * Error corections by nmalykh@bilim.com (22.01.2005)
  */
+#define _BSD_SOURCE 1
+#define _ISOC99_SOURCE 1
 #include <math.h>
 #include <stdbool.h>
 #include <stdint.h>
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 023500c..f75ef2f 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -3,6 +3,8 @@
  * J=C3=A9r=C3=B4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
  * Herv=C3=A9 Eychenne    <rv@wallfire.org>
  */
+#define _BSD_SOURCE 1
+#define _ISOC99_SOURCE 1
 #include <math.h>
 #include <stdio.h>
 #include <string.h>
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
