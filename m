From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH 1/2] scanner: support for wildcards in include statements.
Date: Tue, 27 Jun 2017 15:14:58 +0300
Message-ID: <20170627121459.32608-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:40728 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752128AbdF0MPE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2017 08:15:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use glob() to find paths in include statements. The rules are these:

  1. If no files can be found in the pattern with wildcards, do not
     return an error.
  2. Do not match any files beginning with '.'.
  3. Do not handle include directories anymore. For example, the
     statement:
       include "foo/"
     would now need to be rewritten:
       include "foo/*"

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 src/scanner.l | 225 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 104 insertions(+), 121 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index f220e59..ea00c5e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -10,15 +10,12 @@
 
 %{
 
-#include <dirent.h>
-#include <libgen.h>
 #include <limits.h>
-#include <unistd.h>
+#include <glob.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
-#include <sys/stat.h>
 
 #include <nftables.h>
 #include <erec.h>
@@ -664,128 +661,105 @@ err:
 	return -1;
 }
 
-int scanner_read_file(void *scanner, const char *filename,
-		      const struct location *loc)
+static int include_glob(void *scanner, const char *pattern,
+			const struct location *loc)
 {
-	return include_file(scanner, filename, loc);
-}
+	struct parser_state *state = yyget_extra(scanner);
+	struct error_record *erec = NULL;
+	bool wildcard = false;
+	glob_t glob_data;
+	unsigned int i;
+	int flags = 0;
+	int ret;
+	char *p;
+
+	/* This function can return four meaningful values:
+	 *
+	 *  -1 means that there was an error.
+	 *   0 means that a single non-wildcard match was done.
+	 *   1 means that there are no wildcards in the pattern and the
+	 *     search can continue.
+	 *   2 means that there are wildcards in the pattern and the search
+	 *     can continue.
+	 *
+	 * The diffrence is needed, because there is a semantic difference
+	 * between patterns with wildcards and no wildcards. Not finding a
+	 * non-wildcard file is an error but not finding any matches for a
+	 * wildcard pattern is not. */
+
+	/* There shouldn't be a need to use escape characters in include paths. */
+	flags |= GLOB_NOESCAPE;
+
+	/* Mark directories so we can filter them out (also links). */
+	flags |= GLOB_MARK;
+
+	/* If there is no match, glob() doesn't set GLOB_MAGCHAR even if there are
+	 * wildcard characters in the pattern. We need to look for (luckily well-known
+	 * and not likely to change) magic characters ourselves. In a perfect world,
+	 * we could use glob() itself to figure out if there are wildcards in the
+	 * pattern. */
+
+	p = (char *) pattern;
+	while (*p) {
+		if (*p == '*' || *p == '?' || *p == '[') {
+			wildcard = true;
+			break;
+		}
+		p++;
+	}
 
-static int directoryfilter(const struct dirent *de)
-{
-	if (strcmp(de->d_name, ".") == 0 ||
-	    strcmp(de->d_name, "..") == 0)
-		return 0;
+	ret = glob(pattern, flags, NULL, &glob_data);
 
-	/* Accept other filenames. If we want to enable filtering based on
-	 * filename suffix (*.nft), this would be the place to do it.
-	 */
-	return 1;
-}
+	if (ret == 0) {
+		char *path;
+		int len;
 
-static void free_scandir_des(struct dirent **des, int n_des)
-{
-	int i;
+		/* reverse alphabetical order due to stack */
+		for (i = glob_data.gl_pathc; i > 0; i--) {
 
-	for (i = 0; i < n_des; i++)
-		free(des[i]);
+			path = glob_data.gl_pathv[i-1];
 
-	free(des);
-}
+			/* ignore directories */
+			len = strlen(path);
+			if (len == 0 || path[len-1] == '/')
+				continue;
 
-static int include_directory(void *scanner, const char *dirname,
-			     const struct location *loc)
-{
-	struct parser_state *state = yyget_extra(scanner);
-	struct dirent **des = NULL;
-	struct error_record *erec;
-	int ret, n_des = 0, i;
-	char dirbuf[PATH_MAX];
-	FILE *f;
+			ret = include_file(scanner, path, loc);
+			if (ret != 0)
+				goto err;
+		}
 
-	if (!dirname[0] || dirname[strlen(dirname)-1] != '/') {
-		erec = error(loc, "Include directory name \"%s\" does not end in '/'",
-			     dirname);
-		goto err;
-	}
+		globfree(&glob_data);
 
-	/* If the path is a directory, assume that all files there need
-	 * to be included. Sort the file list in alphabetical order.
-	 */
-	n_des = scandir(dirname, &des, directoryfilter, alphasort);
-	if (n_des < 0) {
-		erec = error(loc, "Failed to scan directory contents for \"%s\"",
-			     dirname);
-		goto err;
-	} else if (n_des == 0) {
-		/* nothing to do */
-		free(des);
-		return 0;
+		/* If no wildcards and we found the file, stop the search (with 0).
+		 * In case of wildcards we need to still continue the search,
+		 * because other matches might be in other include directories. We
+		 * handled the case with a non-wildcard pattern and no matches
+		 * already before. */
+		 return wildcard ? 2 : 0;
 	}
+	else if (ret == GLOB_NOMATCH) {
+		globfree(&glob_data);
 
-	/* We need to push the files in reverse order, so that they will be
-	 * popped in the correct order.
-	 */
-	for (i = n_des - 1; i >= 0; i--) {
-		ret = snprintf(dirbuf, sizeof(dirbuf), "%s/%s", dirname,
-			       des[i]->d_name);
-		if (ret < 0 || ret >= PATH_MAX) {
-			erec = error(loc, "Too long file path \"%s/%s\"\n",
-				     dirname, des[i]->d_name);
-			goto err;
-		}
+		/* We need to tell the caller whether wildcards were used in case of no
+		 * match, because the semantics for handling the cases are different. */
+		return wildcard ? 2 : 1;
+	}
 
-		f = fopen(dirbuf, "r");
-		if (f == NULL) {
-			erec = error(loc, "Could not open file \"%s\": %s\n",
-				     dirbuf, strerror(errno));
-			goto err;
-		}
+	erec = error(loc, "Failed to glob the pattern %s", pattern);
 
-		erec = scanner_push_file(scanner, des[i]->d_name, f, loc);
-		if (erec != NULL)
-			goto err;
-	}
-	free_scandir_des(des, n_des);
-	return 0;
+	/* intentional fall through */
 err:
-	free_scandir_des(des, n_des);
-	erec_queue(erec, state->msgs);
+	if (erec)
+		erec_queue(erec, state->msgs);
+	globfree(&glob_data);
 	return -1;
 }
 
-static int include_dentry(void *scanner, const char *filename,
-			  const struct location *loc)
+int scanner_read_file(void *scanner, const char *filename,
+		      const struct location *loc)
 {
-	struct parser_state *state = yyget_extra(scanner);
-	struct error_record *erec;
-	struct stat st;
-	int ret;
-
-	ret = stat(filename, &st);
-	if (ret == -1 && errno == ENOENT) {
-		/* Could not find the directory or file, keep on searching.
-		 * Return value '1' indicates to the caller that we should still
-		 * search in the next include directory.
-		 */
-		return 1;
-	} else if (ret == 0) {
-		if (S_ISDIR(st.st_mode))
-			return include_directory(scanner, filename, loc);
-		else if (S_ISREG(st.st_mode))
-			return include_file(scanner, filename, loc);
-		else {
-			errno = EINVAL;
-			ret = -1;
-		}
-	}
-
-	/* Process error for failed stat and cases where the file is not a
-	 * directory or (a link to) a regular file.
-	 */
-	erec = error(loc, "Failed to access file \"%s\": %s\n",
-			filename, strerror(errno));
-	erec_queue(erec, state->msgs);
-	return ret;
+	return include_file(scanner, filename, loc);
 }
 
 static bool search_in_include_path(const char *filename)
@@ -802,7 +776,7 @@ int scanner_include_file(void *scanner, const char *filename,
 	struct error_record *erec;
 	char buf[PATH_MAX];
 	unsigned int i;
-	int ret;
+	int ret = -1;
 
 	if (search_in_include_path(filename)) {
 		for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
@@ -817,23 +791,32 @@ int scanner_include_file(void *scanner, const char *filename,
 				return -1;
 			}
 
-			ret = include_dentry(scanner, buf, loc);
+			ret = include_glob(scanner, buf, loc);
+
+			if (ret == -1)
+			  /* error was already handled */
+			  return -1;
 			if (ret == 0)
+				/* no wildcards and file was processed -- break early */
 				return 0;
-			else if (ret != 1)
-				/* error has been processed already */
-				return -1;
+			/* else 1 (no wildcards) or 2 (wildcards) -- keep searching */
 		}
-	} else {
-		ret = include_dentry(scanner, filename, loc);
-		if (ret == 0)
-			return 0;
-		else if (ret != 1)
-			return -1;
-		/* else fall through to "not found" processing */
 	}
+	else
+		/* an absolute path (starts with '/') */
+		ret = include_glob(scanner, filename, loc);
+
+	/* handle the case where no file was found */
+
+	if (ret == -1)
+		return -1;
+	else if (ret == 0 || ret == 2)
+		return 0;
+
+	/* 1 means an error, because there are no more include directories to
+	 * search, and the pattern does not have wildcard characters. */
 
-	erec = error(loc, "Did not find \"%s\"\n", filename);
+	erec = error(loc, "File not found: %s", filename);
 	erec_queue(erec, state->msgs);
 	return -1;
 }
-- 
2.9.4

