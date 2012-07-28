From: Jan Engelhardt <jengelh@inai.de>
Subject: =?UTF-8?q?=5BPATCH=207/7=5D=20libxt=5F*limit=3A=20avoid=20division=20by=20zero?=
Date: Sat, 28 Jul 2012 19:21:09 +0200
Message-ID: <1343496069-5442-8-git-send-email-jengelh@inai.de>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:34348 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab2G1RVR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:21:17 -0400
In-Reply-To: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was possible to specify -A mychain -m hashlimit --hashlimit
600059/minute; this would convert to r->avg=3D0, which subsequently
causes a division by zero when printing with -S mychain.

1. Avoid division by zero in print_rate by printing infinity
   instead.
2. Rewrite the test in parse_rate to properly reject too high rates.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_hashlimit.c |   17 ++++++++++++-----
 extensions/libxt_limit.c     |   17 ++++++++++++-----
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.=
c
index 37a3148..831345b 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -10,6 +10,7 @@
  *=20
  * Error corections by nmalykh@bilim.com (22.01.2005)
  */
+#include <math.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -250,12 +251,13 @@ int parse_rate(const char *rate, uint32_t *val, s=
truct hashlimit_mt_udata *ud)
 	if (!r)
 		return 0;
=20
-	/* This would get mapped to infinite (1/day is minimum they
-           can specify, so we're ok at that end). */
-	if (r / ud->mult > XT_HASHLIMIT_SCALE)
-		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
-
 	*val =3D XT_HASHLIMIT_SCALE * ud->mult / r;
+	if (*val =3D=3D 0)
+		/*
+		 * The rate maps to infinity. (1/day is the minimum they can
+		 * specify, so we are ok at that end).
+		 */
+		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
 	return 1;
 }
=20
@@ -434,6 +436,11 @@ static uint32_t print_rate(uint32_t period)
 {
 	unsigned int i;
=20
+	if (period =3D=3D 0) {
+		printf(" %f", INFINITY);
+		return 0;
+	}
+
 	for (i =3D 1; i < ARRAY_SIZE(rates); ++i)
 		if (period > rates[i].mult
             || rates[i].mult/period < rates[i].mult%period)
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index b15b02f..023500c 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -3,6 +3,7 @@
  * J=C3=A9r=C3=B4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
  * Herv=C3=A9 Eychenne    <rv@wallfire.org>
  */
+#include <math.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -64,12 +65,13 @@ int parse_rate(const char *rate, uint32_t *val)
 	if (!r)
 		return 0;
=20
-	/* This would get mapped to infinite (1/day is minimum they
-           can specify, so we're ok at that end). */
-	if (r / mult > XT_LIMIT_SCALE)
-		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
-
 	*val =3D XT_LIMIT_SCALE * mult / r;
+	if (*val =3D=3D 0)
+		/*
+		 * The rate maps to infinity. (1/day is the minimum they can
+		 * specify, so we are ok at that end).
+		 */
+		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
 	return 1;
 }
=20
@@ -118,6 +120,11 @@ static void print_rate(uint32_t period)
 {
 	unsigned int i;
=20
+	if (period =3D=3D 0) {
+		printf(" %f", INFINITY);
+		return;
+	}
+
 	for (i =3D 1; i < ARRAY_SIZE(rates); ++i)
 		if (period > rates[i].mult
             || rates[i].mult/period < rates[i].mult%period)
--=20
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
