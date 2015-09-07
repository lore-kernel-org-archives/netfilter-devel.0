From: Imran Zaman <imran.zaman@intel.com>
Subject: [PATCH v1 1/1] fix: resource leakage when loading library using dlopen
Date: Mon,  7 Sep 2015 13:42:16 +0300
Message-ID: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>
Cc: Imran Zaman <imran.zaman@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:29724 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbbIGKgQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 06:36:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

dlclose is used to close the handle returned by
dlopen.

Signed-off-by: Imran Zaman <imran.zaman@intel.com>
---
 libxtables/xtables.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 5357d12..e684d27 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -561,6 +561,7 @@ static void *load_extension(const char *search_path, const char *af_prefix,
 	void *ptr = NULL;
 	struct stat sb;
 	char path[256];
+	void *handle = NULL;
 
 	do {
 		next = strchr(dir, ':');
@@ -579,7 +580,8 @@ static void *load_extension(const char *search_path, const char *af_prefix,
 					strerror(errno));
 				return NULL;
 			}
-			if (dlopen(path, RTLD_NOW) == NULL) {
+			handle = dlopen(path, RTLD_NOW);
+			if (handle == NULL) {
 				fprintf(stderr, "%s: %s\n", path, dlerror());
 				break;
 			}
@@ -590,6 +592,7 @@ static void *load_extension(const char *search_path, const char *af_prefix,
 				ptr = xtables_find_match(name,
 				      XTF_DONT_LOAD, NULL);
 
+			dlclose(handle);
 			if (ptr != NULL)
 				return ptr;
 
-- 
1.9.1

---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

