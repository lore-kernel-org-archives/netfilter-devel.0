From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/3] conf: add flag to allow option setup tuning
Date: Sat, 19 Jan 2013 10:50:34 +0100
Message-ID: <1358589035-1275-3-git-send-email-eric@regit.org>
References: <1358589035-1275-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37663 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3ASJvR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:51:17 -0500
In-Reply-To: <1358589035-1275-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a flag to the config_entry structure to be able to
tune setup. First usage is to ask config parser not to update a key
if it has been already set.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/ulogd/conffile.h |    4 ++++
 src/conffile.c           |    3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/ulogd/conffile.h b/include/ulogd/conffile.h
index 7431243..aa35809 100644
--- a/include/ulogd/conffile.h
+++ b/include/ulogd/conffile.h
@@ -41,11 +41,15 @@ enum {
 #define CONFIG_OPT_MANDATORY	0x0001
 #define CONFIG_OPT_MULTI	0x0002
 
+/* valid flag part */
+#define CONFIG_FLAG_VAL_PROTECTED	(1<<0)
+
 struct config_entry {
 	char key[CONFIG_KEY_LEN];	/* name of config directive */
 	u_int8_t type;			/* type; see above */
 	u_int8_t options;		/* options; see above  */
 	u_int8_t hit;			/* found? */
+	u_int8_t flag;			/* tune setup of option */
 	union {
 		char string[CONFIG_VAL_STRING_LEN];
 		int value;
diff --git a/src/conffile.c b/src/conffile.c
index b27187e..8dbd726 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -167,7 +167,8 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 		for (i = 0; i < kset->num_ces; i++) {
 			struct config_entry *ce = &kset->ces[i];
 			pr_debug("parse main loop, key: %s\n", ce->key);
-			if (strcmp(ce->key, (char *) &wordbuf)) {
+			if ((strcmp(ce->key, (char *) &wordbuf)) ||
+			     ce->flag & CONFIG_FLAG_VAL_PROTECTED) {
 				continue;
 			}
 
-- 
1.7.10.4

