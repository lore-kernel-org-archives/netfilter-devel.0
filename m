From: pablo@netfilter.org
Subject: [PATCH 1/4] iptables: remove unused leftover definitions
Date: Thu, 27 Dec 2012 01:19:19 +0100
Message-ID: <1356567561-3205-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39950 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2L0ATc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:19:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/iptables.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/iptables/iptables.c b/iptables/iptables.c
index f765cf9..760cb16 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -186,22 +186,6 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 #define prog_name iptables_globals.program_name
 #define prog_vers iptables_globals.program_version
 
-/* Primitive headers... */
-/* defined in netinet/in.h */
-#if 0
-#ifndef IPPROTO_ESP
-#define IPPROTO_ESP 50
-#endif
-#ifndef IPPROTO_AH
-#define IPPROTO_AH 51
-#endif
-#endif
-
-enum {
-	IPT_DOTTED_ADDR = 0,
-	IPT_DOTTED_MASK
-};
-
 static void __attribute__((noreturn))
 exit_tryhelp(int status)
 {
-- 
1.7.10.4

