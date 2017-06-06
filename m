From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH v3 1/2] scanner: add support for include directories
Date: Tue,  6 Jun 2017 14:50:09 +0300
Message-ID: <20170606115010.26437-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17282 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751412AbdFFLuR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 07:50:17 -0400
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
 src/scanner.l | 135 +++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 110 insertions(+), 25 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index c2c008d..1beadb1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -10,6 +10,8 @@
 
 %{
 
+#include <dirent.h>
+#include <libgen.h>
 #include <limits.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
@@ -637,8 +639,8 @@ static struct error_record *scanner_push_file(void *scanner, const char *filenam
 	return NULL;
 }
 
-int scanner_read_file(void *scanner, const char *filename,
-		      const struct location *loc)
+static int include_file(void *scanner, const char *filename,
+			const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct error_record *erec;
@@ -655,12 +657,92 @@ int scanner_read_file(void *scanner, const char *filename,
 	if (erec != NULL)
 		goto err;
 	return 0;
+err:
+	erec_queue(erec, state->msgs);
+	return -1;
+}
 
+int scanner_read_file(void *scanner, const char *filename,
+		      const struct location *loc)
+{
+	return include_file(scanner, filename, loc);
+}
+
+static int include_directory(void *scanner, const char *dirname,
+			     DIR *directory, const struct location *loc)
+{
+	struct parser_state *state = yyget_extra(scanner);
+	struct error_record *erec;
+	struct dirent *de;
+	FILE *f;
+	int ret;
+
+	if (!dirname[0] || dirname[strlen(dirname)-1] != '/') {
+		erec = error(loc, "Include directory name \"%s\" does not end in '/'",
+				dirname);
+		goto err;
+	}
+
+	/* If the path is a directory, assume that all files there need
+	 * to be included.
+	 */
+	while ((de = readdir(directory))) {
+		char dirbuf[PATH_MAX];
+
+		ret = snprintf(dirbuf, sizeof(dirbuf), "%s/%s", dirname, de->d_name);
+		if (ret < 0 || ret >= PATH_MAX) {
+			erec = error(loc, "Too long file path \"%s/%s\"\n",
+					dirname, de->d_name);
+			goto err;
+		}
+
+		if (strcmp(de->d_name, ".") == 0 || strcmp(de->d_name, "..") == 0)
+			continue;
+
+		f = fopen(dirbuf, "r");
+		if (f == NULL) {
+			erec = error(loc, "Could not open file \"%s\": %s\n",
+					dirbuf, strerror(errno));
+			goto err;
+		}
+
+		erec = scanner_push_file(scanner, de->d_name, f, loc);
+		if (erec != NULL)
+			goto err;
+	}
+	return 0;
 err:
 	erec_queue(erec, state->msgs);
 	return -1;
 }
 
+static int include_dentry(void *scanner, const char *filename,
+			  const struct location *loc)
+{
+	DIR *directory;
+	int ret;
+
+	/* The file can be either a simple file or a directory which
+	 * contains files.
+	 */
+
+	directory = opendir(filename);
+
+	if (directory == NULL && errno != ENOTDIR)
+		/* Could not access the directory or file, keep on searching.
+		 * Return value '1' indicates to the caller that we should still
+		 * search in the next include directory.
+		 */
+		ret = 1;
+	else if (directory != NULL) {
+		ret = include_directory(scanner, filename, directory, loc);
+		closedir(directory);
+	} else
+		ret = include_file(scanner, filename, loc);
+
+	return ret;
+}
+
 static bool search_in_include_path(const char *filename)
 {
 	return (strncmp(filename, "./", strlen("./")) != 0 &&
@@ -671,40 +753,43 @@ static bool search_in_include_path(const char *filename)
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
-			snprintf(buf, sizeof(buf), "%s/%s",
-				 include_paths[i], filename);
-			f = fopen(buf, "r");
-			if (f != NULL)
-				break;
+			ret = snprintf(buf, sizeof(buf), "%s/%s",
+				include_paths[i], filename);
+			if (ret < 0 || ret >= PATH_MAX) {
+				erec = error(loc, "Too long file path \"%s/%s\"\n",
+					include_paths[i], filename);
+				erec_queue(erec, state->msgs);
+				return -1;
+			}
+
+			ret = include_dentry(scanner, buf, loc);
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
+		ret = include_dentry(scanner, filename, loc);
+		if (ret == 0)
+			return 0;
+		else if (ret != 1)
+			return -1;
+		/* else fall through to "not found" processing */
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

