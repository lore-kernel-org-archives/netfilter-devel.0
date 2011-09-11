From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/9] libiptc: remove unused HOOK_DROPPING thing
Date: Sun, 11 Sep 2011 17:35:52 +0200
Message-ID: <1315755359-7012-4-git-send-email-jengelh@medozas.de>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51845 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab1IKPgF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:36:05 -0400
In-Reply-To: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc/libip4tc.c |   12 ------------
 libiptc/libiptc.c  |    3 ---
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index cf66709..3b0c15a 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -36,9 +36,6 @@ typedef unsigned int socklen_t;
 #define HOOK_FORWARD		NF_IP_FORWARD
 #define HOOK_LOCAL_OUT		NF_IP_LOCAL_OUT
 #define HOOK_POST_ROUTING	NF_IP_POST_ROUTING
-#ifdef NF_IP_DROPPING
-#define HOOK_DROPPING		NF_IP_DROPPING
-#endif
 
 #define STRUCT_ENTRY_TARGET	struct ipt_entry_target
 #define STRUCT_ENTRY		struct ipt_entry
@@ -426,15 +423,6 @@ do_check(struct iptc_handle *h, unsigned int line)
 		assert(h->info.hook_entry[NF_IP_LOCAL_OUT] == n);
 
 		user_offset = h->info.hook_entry[NF_IP_LOCAL_OUT];
-
-#ifdef NF_IP_DROPPING
-	} else if (strcmp(h->info.name, "drop") == 0) {
-		assert(h->info.valid_hooks == (1 << NF_IP_DROPPING));
-
-		/* Hook should be first */
-		assert(h->info.hook_entry[NF_IP_DROPPING] == 0);
-		user_offset = 0;
-#endif
 	} else {
 		fprintf(stderr, "Unknown table `%s'\n", h->info.name);
 		abort();
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 2214077..0a29a69 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -61,9 +61,6 @@ static const char *hooknames[] = {
 	[HOOK_FORWARD]		= "FORWARD",
 	[HOOK_LOCAL_OUT]	= "OUTPUT",
 	[HOOK_POST_ROUTING]	= "POSTROUTING",
-#ifdef HOOK_DROPPING
-	[HOOK_DROPPING]		= "DROPPING"
-#endif
 };
 
 /* Convenience structures */
-- 
1.7.3.4

