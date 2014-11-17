From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat-experimental5 PATCH] iptables/xtables-eb.c: delete
 extra 'policy' printf
Date: Mon, 17 Nov 2014 12:09:33 +0100
Message-ID: <20141117110933.971.34720.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42107 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751778AbaKQLJt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:09:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This message doesn't exist in the original ebtables tool.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/xtables-eb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 99d930e..917bca2 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -670,7 +670,6 @@ handle_P:
 				for (i = 0; i < NUM_STANDARD_TARGETS; i++)
 					if (!strcmp(argv[optind], ebt_standard_targets[i])) {
 						policy = argv[optind];
-						printf("policy: %s\n", policy);
 						if (-i-1 == EBT_CONTINUE)
 							xtables_error(PARAMETER_PROBLEM,
 								      "Wrong policy '%s'",

