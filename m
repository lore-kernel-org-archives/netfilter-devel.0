From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] xtables: deactivate intrapositional support
Date: Fri, 30 Oct 2009 09:39:27 +0100
Message-ID: <1256891969-18437-3-git-send-email-jengelh@medozas.de>
References: <1256891969-18437-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46761 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305AbZJ3Ijc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:39:32 -0400
In-Reply-To: <1256891969-18437-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In going to fix NF bug #611, "argv" would be needed in
xtables_check_inverse to set "optarg" to the right spot in case of an
intrapositional negation. Adding argv to the parameter list would
cause an API change, which I would like to avoid because it is
planned to be thrown out anyway.

So deactive intrapositional support now already, but leave the error
message (which has already been there for two releases). Slightly
adjust it, because some users have been wondering whether iptables
or they are at "fault".

References: http://bugzilla.netfilter.org/show_bug.cgi?id=611

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/xtables.c b/xtables.c
index 35a87e8..aaca09b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1648,21 +1648,10 @@ int xtables_check_inverse(const char option[], int *invert,
 	if (option == NULL || strcmp(option, "!") != 0)
 		return false;
 
-	fprintf(stderr, "Using intrapositioned negation "
-	        "(`--option ! this`) is deprecated in favor of "
-	        "extrapositioned (`! --option this`).\n");
-
-	if (*invert)
-		xt_params->exit_err(PARAMETER_PROBLEM,
-			   "Multiple `!' flags not allowed");
-	*invert = true;
-	if (my_optind != NULL) {
-		++*my_optind;
-		if (argc && *my_optind > argc)
-			xt_params->exit_err(PARAMETER_PROBLEM,
-				   "no argument following `!'");
-	}
-
+	xtables_error(PARAMETER_PROBLEM, "Using intrapositioned negation "
+	        "(`--option ! this`) is disabled in favor of "
+	        "extrapositioned (`! --option this`).\n"
+	        "(= Please fix your ruleset.)\n");
 	return true;
 }
 
-- 
1.6.5.1

