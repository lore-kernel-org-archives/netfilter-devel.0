From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/6] libxtables: inline and remove unused OPTION_OFFSET macro
Date: Sat, 21 Feb 2009 04:18:00 +0100
Message-ID: <1235186284-31661-3-git-send-email-jengelh@medozas.de>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37806 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZBUDSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:18:06 -0500
In-Reply-To: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    1 -
 xtables.c            |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index b5f1af2..c4d2b92 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -235,7 +235,6 @@ int xtables_check_inverse(const char option[], int *invert,
 	int *my_optind, int argc);
 extern struct xtables_globals *xt_params;
 #define exit_error xt_params->exit_err
-#define OPTION_OFFSET 256
 
 extern void xtables_param_act(unsigned int, const char *, ...);
 
diff --git a/xtables.c b/xtables.c
index 50cfced..f305673 100644
--- a/xtables.c
+++ b/xtables.c
@@ -96,7 +96,7 @@ struct option *xtables_merge_options(struct option *oldopts,
 	for (num_old = 0; oldopts[num_old].name; num_old++) ;
 	for (num_new = 0; newopts[num_new].name; num_new++) ;
 
-	xt_params->option_offset += OPTION_OFFSET;
+	xt_params->option_offset += 256;
 	*option_offset = xt_params->option_offset;
 
 	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
-- 
1.6.1.3

