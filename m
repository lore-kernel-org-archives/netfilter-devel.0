From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH v2 1/2] scanner: add support for include directories
Date: Mon,  5 Jun 2017 18:12:32 +0300
Message-ID: <20170605151233.1689-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41403 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751162AbdFEPMi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 11:12:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a string after "include" keyword points to a directory instead of a
file, consider the directory to contain only nft rule files and try to
load them all. This helps with a use case where services drop their own
firewall configuration files into a directory and nft needs to include
those without knowing the exact file names.

File loading order from the include directory is not specified, so the
files inside an include directory should not depend on each other.

Fixes(Bug 1154 - Allow include statement to operate on directories and/or wildcards).

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 src/scanner.l | 116 +++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 95 insertions(+), 21 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index c2c008d..19e12bc 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -10,6 +10,8 @@
 
 %{
 
+#include <dirent.h>
+#include <libgen.h>
 #include <limits.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
@@ -661,6 +663,82 @@ err:
 	return -1;
 }
 
+static int find_and_add_include_file(void *scanner, const char *filename,
+			 const struct location *loc)
+{
+	DIR *directory = NULL;
+	FILE *f = NULL;
+	struct error_record *erec;
+	struct parser_state *state = yyget_extra(scanner);
+
+	/* The file can be either a simple file or a directory which
+	 * contains files. If it is a directory, assume that all files there
+	 * should be included. */
+
+	directory = opendir(filename);
+
+	if (directory == NULL && errno != ENOTDIR)
+		/* Could not access the directory or file, keep on searching. */
+		return 1;
+	else if (directory != NULL) {
+		/* A directory. */
+		struct dirent *de;
+
+		if (!filename[0] || filename[strlen(filename)-1] != '/') {
+			erec = error(loc, "Include directory name \"%s\" does not end in '/'",
+					filename);
+			goto err;
+		}
+
+		/* If the path is a directory, assume that all files there need
+		 * to be included. */
+		while ((de = readdir(directory))) {
+			char dirbuf[PATH_MAX];
+
+			snprintf(dirbuf, sizeof(dirbuf), "%s/%s", filename, de->d_name);
+
+			if (strcmp(de->d_name, ".") == 0 || strcmp(de->d_name, "..") == 0)
+				continue;
+
+			f = fopen(dirbuf, "r");
+
+			if (f == NULL) {
+				erec = error(loc, "Could not open file \"%s\": %s\n",
+						dirbuf, strerror(errno));
+				goto err;
+			}
+
+			erec = scanner_push_file(scanner, de->d_name, f, loc);
+			if (erec != NULL)
+				goto err;
+		}
+
+		closedir(directory);
+	}
+	else {
+		/* A simple include file. */
+		f = fopen(filename, "r");
+		if (f == NULL) {
+			erec = error(loc, "Could not open file \"%s\": %s\n",
+					filename, strerror(errno));
+			goto err;
+		}
+		erec = scanner_push_file(scanner, filename, f, loc);
+		if (erec != NULL)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	erec_queue(erec, state->msgs);
+
+	if (directory)
+		closedir(directory);
+
+	return -1;
+}
+
 static bool search_in_include_path(const char *filename)
 {
 	return (strncmp(filename, "./", strlen("./")) != 0 &&
@@ -671,40 +749,36 @@ static bool search_in_include_path(const char *filename)
 int scanner_include_file(void *scanner, const char *filename,
 			 const struct location *loc)
 {
-	struct parser_state *state = yyget_extra(scanner);
-	struct error_record *erec;
 	char buf[PATH_MAX];
-	const char *name = buf;
 	unsigned int i;
-	FILE *f;
+	int ret;
+	struct error_record *erec;
+	struct parser_state *state = yyget_extra(scanner);
 
-	f = NULL;
 	if (search_in_include_path(filename)) {
 		for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
 			if (include_paths[i] == NULL)
 				break;
 			snprintf(buf, sizeof(buf), "%s/%s",
 				 include_paths[i], filename);
-			f = fopen(buf, "r");
-			if (f != NULL)
-				break;
+
+			ret = find_and_add_include_file(scanner, buf, loc);
+			if (ret == 0)
+				return 0;
+			else if (ret != 1)
+				/* error has been processed already */
+				return -1;
 		}
-	} else {
-		f = fopen(filename, "r");
-		name = filename;
 	}
-	if (f == NULL) {
-		erec = error(loc, "Could not open file \"%s\": %s",
-			     filename, strerror(errno));
-		goto err;
+	else {
+		ret = find_and_add_include_file(scanner, filename, loc);
+		if (ret == 0)
+			return 0;
+		else if (ret != 1)
+		    return -1;
 	}
 
-	erec = scanner_push_file(scanner, name, f, loc);
-	if (erec != NULL)
-		goto err;
-	return 0;
-
-err:
+	erec = error(loc, "Did not find \"%s\"\n", filename);
 	erec_queue(erec, state->msgs);
 	return -1;
 }
-- 
2.9.4

