From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/13] xtables: reorder num_old substraction for clarity
Date: Sat,  8 Jan 2011 16:20:07 +0100
Message-ID: <1294500015-10691-7-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32894 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1AHPUW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:22 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When going over this again, I noticed we happen to malloc too much.
That is no problem, but I felt moving the num_old adjustment upwards
makes things more clear, and also addresses the allocation.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/xtables.c b/xtables.c
index 566b5c3..b630901 100644
--- a/xtables.c
+++ b/xtables.c
@@ -95,6 +95,13 @@ struct option *xtables_merge_options(struct option *orig_opts,
 		for (num_old = 0; oldopts[num_old].name; num_old++) ;
 	for (num_new = 0; newopts[num_new].name; num_new++) ;
 
+	/*
+	 * Since @oldopts also has @orig_opts already (and does so at the
+	 * start), skip these entries.
+	 */
+	oldopts += num_oold;
+	num_old -= num_oold;
+
 	merge = malloc(sizeof(*mp) * (num_oold + num_old + num_new + 1));
 	if (merge == NULL)
 		return NULL;
@@ -103,10 +110,6 @@ struct option *xtables_merge_options(struct option *orig_opts,
 	memcpy(merge, orig_opts, sizeof(*mp) * num_oold);
 	mp = merge + num_oold;
 
-	/* Since @opts also has @orig_opts already, skip the entries */
-	oldopts += num_oold;
-	num_old -= num_oold;
-
 	/* Second, the new options */
 	xt_params->option_offset += 256;
 	*option_offset = xt_params->option_offset;
-- 
1.7.1

