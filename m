From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/7] libxt_u32: enclose argument in quotes
Date: Mon, 31 Jan 2011 03:12:48 +0100
Message-ID: <1296439973-16089-4-git-send-email-jengelh@medozas.de>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45272 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AaCM7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:12:59 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise ip6tables-save piped to ip6tables-restore can cause a parse
error when the expression list is empty.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_u32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 054a5b2..378de0c 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -45,6 +45,7 @@ static void u32_dump(const struct xt_u32 *data)
 	const struct xt_u32_test *ct;
 	unsigned int testind, i;
 
+	putchar('\"');
 	for (testind = 0; testind < data->ntests; ++testind) {
 		ct = &data->tests[testind];
 
@@ -81,7 +82,7 @@ static void u32_dump(const struct xt_u32 *data)
 				       ct->value[i].max);
 		}
 	}
-	printf(" ");
+	printf("\" ");
 }
 
 /* string_to_number() is not quite what we need here ... */
-- 
1.7.1

