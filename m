From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/24] Fixed incorrect call to find_match on loading a target
Date: Sun,  6 Apr 2008 17:27:07 +0200
Message-ID: <2ac07162dc76c39ad5c07991fad42ed13e54567b.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56477 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbYDFP1Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:25 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 xtables.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/xtables.c b/xtables.c
index 0405e3e..b26b416 100644
--- a/xtables.c
+++ b/xtables.c
@@ -306,7 +306,7 @@ void parse_interface(const char *arg, char *vianame, unsigned char *mask)
 }
 
 static void *load_extension(const char *search_path, const char *prefix,
-    const char *name)
+    const char *name, bool is_target)
 {
 	const char *dir = search_path, *next;
 	void *ptr = NULL;
@@ -320,22 +320,30 @@ static void *load_extension(const char *search_path, const char *prefix,
 		snprintf(path, sizeof(path), "%.*s/libxt_%s.so",
 		         next - dir, dir, name);
 
-		if (dlopen(path, RTLD_NOW) != NULL)
+		if (dlopen(path, RTLD_NOW) != NULL) {
 			/* Found library.  If it didn't register itself,
 			   maybe they specified target as match. */
-			ptr = find_match(name, DONT_LOAD, NULL);
-		else if (stat(path, &sb) == 0)
+			if (is_target)
+				ptr = find_target(name, DONT_LOAD);
+			else
+				ptr = find_match(name, DONT_LOAD, NULL);
+		} else if (stat(path, &sb) == 0) {
 			fprintf(stderr, "%s: %s\n", path, dlerror());
+		}
 
 		if (ptr != NULL)
 			return ptr;
 
 		snprintf(path, sizeof(path), "%.*s/%s%s.so",
 		         next - dir, dir, prefix, name);
-		if (dlopen(path, RTLD_NOW) != NULL)
-			ptr = find_match(name, DONT_LOAD, NULL);
-		else if (stat(path, &sb) == 0)
+		if (dlopen(path, RTLD_NOW) != NULL) {
+			if (is_target)
+				ptr = find_target(name, DONT_LOAD);
+			else
+				ptr = find_match(name, DONT_LOAD, NULL);
+		} else if (stat(path, &sb) == 0) {
 			fprintf(stderr, "%s: %s\n", path, dlerror());
+		}
 
 		if (ptr != NULL)
 			return ptr;
@@ -381,7 +389,7 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
-		ptr = load_extension(lib_dir, afinfo.libprefix, name);
+		ptr = load_extension(lib_dir, afinfo.libprefix, name, false);
 
 		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
@@ -440,7 +448,7 @@ struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
-		ptr = load_extension(lib_dir, afinfo.libprefix, name);
+		ptr = load_extension(lib_dir, afinfo.libprefix, name, true);
 
 		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
-- 
1.5.5.rc3

