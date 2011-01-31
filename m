From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/7] iptables: improve error reporting with extension loading troubles
Date: Mon, 31 Jan 2011 03:12:47 +0100
Message-ID: <1296439973-16089-3-git-send-email-jengelh@medozas.de>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45267 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AaCM6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:12:58 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip6tables v1.4.8: Could not load match "osf":
/usr/lib/xtables/libip6t_osf.so: cannot open shared object file: No
such file or directory

Given that libxt_osf.so exists, a better error is now emitted.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=637
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |   55 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/xtables.c b/xtables.c
index eec1733..0036299 100644
--- a/xtables.c
+++ b/xtables.c
@@ -492,9 +492,11 @@ void xtables_parse_interface(const char *arg, char *vianame,
 }
 
 #ifndef NO_SHARED_LIBS
-static void *load_extension(const char *search_path, const char *prefix,
+static void *load_extension(const char *search_path, const char *af_prefix,
     const char *name, bool is_target)
 {
+	const char *all_prefixes[] = {"libxt_", af_prefix, NULL};
+	const char **prefix;
 	const char *dir = search_path, *next;
 	void *ptr = NULL;
 	struct stat sb;
@@ -504,39 +506,38 @@ static void *load_extension(const char *search_path, const char *prefix,
 		next = strchr(dir, ':');
 		if (next == NULL)
 			next = dir + strlen(dir);
-		snprintf(path, sizeof(path), "%.*s/libxt_%s.so",
-		         (unsigned int)(next - dir), dir, name);
 
-		if (dlopen(path, RTLD_NOW) != NULL) {
-			/* Found library.  If it didn't register itself,
-			   maybe they specified target as match. */
-			if (is_target)
-				ptr = xtables_find_target(name, XTF_DONT_LOAD);
-			else
-				ptr = xtables_find_match(name,
-				      XTF_DONT_LOAD, NULL);
-		} else if (stat(path, &sb) == 0) {
-			fprintf(stderr, "%s: %s\n", path, dlerror());
-		}
+		for (prefix = all_prefixes; *prefix != NULL; ++prefix) {
+			snprintf(path, sizeof(path), "%.*s/%s%s.so",
+			         (unsigned int)(next - dir), dir,
+			         *prefix, name);
 
-		if (ptr != NULL)
-			return ptr;
+			if (stat(path, &sb) != 0) {
+				if (errno == ENOENT)
+					continue;
+				fprintf(stderr, "%s: %s\n", path,
+					strerror(errno));
+				return NULL;
+			}
+			if (dlopen(path, RTLD_NOW) == NULL) {
+				fprintf(stderr, "%s: %s\n", path, dlerror());
+				break;
+			}
 
-		snprintf(path, sizeof(path), "%.*s/%s%s.so",
-		         (unsigned int)(next - dir), dir, prefix, name);
-		if (dlopen(path, RTLD_NOW) != NULL) {
 			if (is_target)
 				ptr = xtables_find_target(name, XTF_DONT_LOAD);
 			else
 				ptr = xtables_find_match(name,
 				      XTF_DONT_LOAD, NULL);
-		} else if (stat(path, &sb) == 0) {
-			fprintf(stderr, "%s: %s\n", path, dlerror());
-		}
 
-		if (ptr != NULL)
-			return ptr;
+			if (ptr != NULL)
+				return ptr;
 
+			fprintf(stderr, "%s: no \"%s\" extension found for "
+				"this protocol\n", path, name);
+			errno = ENOENT;
+			return NULL;
+		}
 		dir = next + 1;
 	} while (*next != '\0');
 
@@ -591,7 +592,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				   "Couldn't load match `%s':%s\n",
-				   name, dlerror());
+				   name, strerror(errno));
 	}
 #else
 	if (ptr && !ptr->loaded) {
@@ -651,7 +652,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				   "Couldn't load target `%s':%s\n",
-				   name, dlerror());
+				   name, strerror(errno));
 	}
 #else
 	if (ptr && !ptr->loaded) {
-- 
1.7.1

