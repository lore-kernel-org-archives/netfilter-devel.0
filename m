From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/17] libxtables: flag invalid uses of XTOPT_PUT
Date: Mon,  9 May 2011 21:54:59 +0200
Message-ID: <1304970912-11520-6-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49342 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1EITzV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:21 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtoptions.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/xtoptions.c b/xtoptions.c
index f8031bb..29d05d5 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -708,7 +708,8 @@ void xtables_option_metavalidate(const char *name,
 				name, entry->id);
 		if (!(entry->flags & XTOPT_PUT))
 			continue;
-		if (entry->type >= ARRAY_SIZE(xtopt_psize))
+		if (entry->type >= ARRAY_SIZE(xtopt_psize) ||
+		    xtopt_psize[entry->type] == 0)
 			xt_params->exit_err(OTHER_PROBLEM,
 				"%s: entry type of option \"--%s\" cannot be "
 				"combined with XTOPT_PUT\n",
-- 
1.7.1

