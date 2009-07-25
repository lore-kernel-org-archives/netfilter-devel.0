From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] build: fix struct size mismatch
Date: Sat, 25 Jul 2009 22:22:41 +0200
Message-ID: <1248553363-26903-4-git-send-email-jengelh@medozas.de>
References: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55094 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZGYUWs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:22:48 -0400
In-Reply-To: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mixing code compiled with and without -DNO_SHARED_LIBS is fine as
long as the structs have the same layout. This patch prevents a
potential (currently non-triggerable) "ip6tables: target (null)<123>
is missing a version" error.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 222e2a9..7468302 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -90,9 +90,7 @@ struct xtables_match
 	unsigned int option_offset;
 	struct xt_entry_match *m;
 	unsigned int mflags;
-#ifdef NO_SHARED_LIBS
 	unsigned int loaded; /* simulate loading so options are merged properly */
-#endif
 };
 
 struct xtables_target
@@ -152,9 +150,7 @@ struct xtables_target
 	struct xt_entry_target *t;
 	unsigned int tflags;
 	unsigned int used;
-#ifdef NO_SHARED_LIBS
 	unsigned int loaded; /* simulate loading so options are merged properly */
-#endif
 };
 
 struct xtables_rule_match {
-- 
1.6.3.3

