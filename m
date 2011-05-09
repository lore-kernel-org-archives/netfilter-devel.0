From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/13] libxtables: output name of extension on rev detect failure
Date: Mon,  9 May 2011 11:37:04 +0200
Message-ID: <1304933832-16412-7-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51673 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1EIJhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:22 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/xtables.c b/xtables.c
index 235e2b2..9016102 100644
--- a/xtables.c
+++ b/xtables.c
@@ -674,10 +674,10 @@ static int compatible_revision(const char *name, uint8_t revision, int opt)
 		if (errno == EPERM) {
 			/* revision 0 is always supported. */
 			if (revision != 0)
-				fprintf(stderr, "Could not determine whether "
+				fprintf(stderr, "%s: Could not determine whether "
 						"revision %u is supported, "
 						"assuming it is.\n",
-					revision);
+					name, revision);
 			return 1;
 		}
 		fprintf(stderr, "Could not open socket to kernel: %s\n",
-- 
1.7.1

