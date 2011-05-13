From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/12] libxtables: avoid running into .also checks when option not used
Date: Fri, 13 May 2011 02:47:28 +0200
Message-ID: <1305247657-29158-5-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54324 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1EMAtW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:22 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a particular option was not specified, it should not be subject to
.also checks in xtables_option_fcheck2 either.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtoptions.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/xtoptions.c b/xtoptions.c
index 8d54dd8..9e19250 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -949,6 +949,9 @@ void xtables_options_fcheck(const char *name, unsigned int xflags,
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				"%s: option \"--%s\" must be specified\n",
 				name, entry->name);
+		if (!(xflags & (1 << entry->id)))
+			/* Not required, not specified, thus skip. */
+			continue;
 
 		for (i = 0; i < CHAR_BIT * sizeof(entry->id); ++i) {
 			if (entry->id == i)
-- 
1.7.1

