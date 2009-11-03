From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] style: reduce indent in xtables_check_inverse
Date: Tue,  3 Nov 2009 21:58:18 +0100
Message-ID: <1257281901-5063-2-git-send-email-jengelh@medozas.de>
References: <1257281901-5063-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50740 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZKCU6T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:58:19 -0500
In-Reply-To: <1257281901-5063-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/xtables.c b/xtables.c
index bda49f8..35a87e8 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1645,25 +1645,25 @@ void xtables_save_string(const char *value)
 int xtables_check_inverse(const char option[], int *invert,
 			  int *my_optind, int argc)
 {
-	if (option && strcmp(option, "!") == 0) {
-		fprintf(stderr, "Using intrapositioned negation "
-		        "(`--option ! this`) is deprecated in favor of "
-		        "extrapositioned (`! --option this`).\n");
+	if (option == NULL || strcmp(option, "!") != 0)
+		return false;
 
-		if (*invert)
-			xt_params->exit_err(PARAMETER_PROBLEM,
-				   "Multiple `!' flags not allowed");
-		*invert = true;
-		if (my_optind != NULL) {
-			++*my_optind;
-			if (argc && *my_optind > argc)
-				xt_params->exit_err(PARAMETER_PROBLEM,
-					   "no argument following `!'");
-		}
+	fprintf(stderr, "Using intrapositioned negation "
+	        "(`--option ! this`) is deprecated in favor of "
+	        "extrapositioned (`! --option this`).\n");
 
-		return true;
+	if (*invert)
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			   "Multiple `!' flags not allowed");
+	*invert = true;
+	if (my_optind != NULL) {
+		++*my_optind;
+		if (argc && *my_optind > argc)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				   "no argument following `!'");
 	}
-	return false;
+
+	return true;
 }
 
 const struct xtables_pprot xtables_chain_protos[] = {
-- 
1.6.5.2

