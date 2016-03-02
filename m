From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH nft 1/1] scanner: add support for include directories
Date: Wed,  2 Mar 2016 14:11:30 +0200
Message-ID: <1456920690-14477-2-git-send-email-ismo.puustinen@intel.com>
References: <1456920690-14477-1-git-send-email-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:12087 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbcCBMLy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:11:54 -0500
In-Reply-To: <1456920690-14477-1-git-send-email-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a string after "include" keyword points to a directory instead of a
file, consider the directory to contain only nft rule files and try to
load them all. This helps with a use case where services drop their own
firewall configuration files into a directory and nft needs to include
those without knowing the exact file names.

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 src/main.c    |  4 ++--
 src/scanner.l | 73 +++++++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 61 insertions(+), 16 deletions(-)

diff --git a/src/main.c b/src/main.c
index 7bbcfc4..395bde2 100644
--- a/src/main.c
+++ b/src/main.c
@@ -36,8 +36,8 @@ unsigned int handle_output;
 unsigned int debug_level;
 #endif
 
-const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
-static unsigned int num_include_paths = 1;
+const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH, "." };
+static unsigned int num_include_paths = 2;
 
 enum opt_vals {
 	OPT_HELP		= 'h',
diff --git a/src/scanner.l b/src/scanner.l
index a0dee47..58ecd71 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -10,6 +10,8 @@
 
 %{
 
+#include <dirent.h>
+#include <libgen.h>
 #include <limits.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
@@ -620,26 +622,69 @@ int scanner_include_file(void *scanner, const char *filename,
 
 	f = NULL;
 	for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
+		DIR *directory = NULL;
+
 		if (include_paths[i] == NULL)
 			break;
 		snprintf(buf, sizeof(buf), "%s/%s", include_paths[i], filename);
-		f = fopen(buf, "r");
-		if (f != NULL)
+
+		directory = opendir(buf);
+
+		if (directory == NULL && errno != ENOTDIR) {
+			/* Could not access the directory or file. */
+			continue;
+		}
+		else if (directory != NULL) {
+			struct dirent *de;
+
+			/* If the path is a directory, assume that all files there need
+			 * to be included. */
+			while ((de = readdir(directory))) {
+				char dirbuf[PATH_MAX];
+
+				snprintf(dirbuf, sizeof(dirbuf), "%s/%s", buf, de->d_name);
+
+				if (strcmp(de->d_name, ".") == 0 || strcmp(de->d_name, "..") == 0)
+					continue;
+
+				f = fopen(dirbuf, "r");
+
+				if (f == NULL) {
+					erec = error(loc, "Could not open file \"%s\": %s\n",
+							filename, strerror(errno));
+					closedir(directory);
+					goto err;
+				}
+				name = de->d_name;
+
+				erec = scanner_push_file(scanner, name, f, loc);
+				if (erec != NULL) {
+					closedir(directory);
+					goto err;
+				}
+			}
+
+			closedir(directory);
 			break;
-	}
-	if (f == NULL) {
-		f = fopen(filename, "r");
-		if (f == NULL) {
-			erec = error(loc, "Could not open file \"%s\": %s\n",
-				     filename, strerror(errno));
-			goto err;
 		}
-		name = filename;
-	}
+		else {
+			/* A simple include file. */
+			f = fopen(buf, "r");
+			if (f == NULL) {
+				erec = error(loc, "Could not open file \"%s\": %s\n",
+						filename, strerror(errno));
+				goto err;
+			}
 
-	erec = scanner_push_file(scanner, name, f, loc);
-	if (erec != NULL)
-		goto err;
+			if (strcmp(".", dirname(buf)) == 0)
+				name = filename;
+
+			erec = scanner_push_file(scanner, name, f, loc);
+			if (erec != NULL)
+				goto err;
+			break;
+		}
+	}
 	return 0;
 
 err:
-- 
2.5.0

