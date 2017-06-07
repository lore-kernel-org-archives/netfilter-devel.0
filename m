From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH 1/3] scanner: add files in include dirs in alphabetical order.
Date: Wed,  7 Jun 2017 11:35:57 +0300
Message-ID: <20170607083559.10051-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14579 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751647AbdFGIiJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 04:38:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This means that if you have a directory structure like this

    /foo
    /foo/02_rules.nft
    /foo/01_rules.nft

where *.nft files in directory /foo are nft scripts, then an include
statement in another nft script like this

    include "/foo/"

guarantees that "01_rules.nft" is loaded before "02_rules.nft".

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 src/scanner.l | 102 ++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 27 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index fe65e0c..4050cba 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -13,10 +13,12 @@
 #include <dirent.h>
 #include <libgen.h>
 #include <limits.h>
+#include <unistd.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
+#include <sys/stat.h>
 
 #include <nftables.h>
 #include <erec.h>
@@ -668,14 +670,39 @@ int scanner_read_file(void *scanner, const char *filename,
 	return include_file(scanner, filename, loc);
 }
 
+static int directoryfilter(const struct dirent *de)
+{
+	if (strcmp(de->d_name, ".") == 0 ||
+			strcmp(de->d_name, "..") == 0)
+		return 0;
+
+	/* Accept other filenames. If we want to enable filtering based on
+	 * filename suffix (*.nft), this would be the place to do it.
+	 */
+
+	return 1;
+}
+
+static void free_scandir_des(struct dirent **des, int n_des)
+{
+	int i;
+
+	for (i = 0; i < n_des; i++) {
+		free(des[i]);
+	}
+
+	free(des);
+}
+
 static int include_directory(void *scanner, const char *dirname,
-			     DIR *directory, const struct location *loc)
+			     const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
+	struct dirent **des = NULL;
 	struct error_record *erec;
-	struct dirent *de;
+	int ret, n_des = 0, i;
+	char dirbuf[PATH_MAX];
 	FILE *f;
-	int ret;
 
 	if (!dirname[0] || dirname[strlen(dirname)-1] != '/') {
 		erec = error(loc, "Include directory name \"%s\" does not end in '/'",
@@ -684,23 +711,32 @@ static int include_directory(void *scanner, const char *dirname,
 	}
 
 	/* If the path is a directory, assume that all files there need
-	 * to be included.
+	 * to be included. Sort the file list in alphabetical order.
 	 */
-	while ((de = readdir(directory))) {
-		char dirbuf[PATH_MAX];
+	n_des = scandir(dirname, &des, directoryfilter, alphasort);
+	if (n_des < 0) {
+		erec = error(loc, "Failed to scan directory contents for \"%s\"",
+			     dirname);
+		goto err;
+	}
+	else if (n_des == 0) {
+		/* nothing to do */
+		free(des);
+		return 0;
+	}
 
+	/* We need to push the files in reverse order, so that they will be
+	 * popped in the correct order.
+	 */
+	for (i = n_des-1; i >= 0; i--) {
 		ret = snprintf(dirbuf, sizeof(dirbuf), "%s/%s", dirname,
-			       de->d_name);
+			       des[i]->d_name);
 		if (ret < 0 || ret >= PATH_MAX) {
 			erec = error(loc, "Too long file path \"%s/%s\"\n",
-				     dirname, de->d_name);
+				     dirname, des[i]->d_name);
 			goto err;
 		}
 
-		if (strcmp(de->d_name, ".") == 0 ||
-		    strcmp(de->d_name, "..") == 0)
-			continue;
-
 		f = fopen(dirbuf, "r");
 		if (f == NULL) {
 			erec = error(loc, "Could not open file \"%s\": %s\n",
@@ -708,12 +744,14 @@ static int include_directory(void *scanner, const char *dirname,
 			goto err;
 		}
 
-		erec = scanner_push_file(scanner, de->d_name, f, loc);
+		erec = scanner_push_file(scanner, des[i]->d_name, f, loc);
 		if (erec != NULL)
 			goto err;
 	}
+	free_scandir_des(des, n_des);
 	return 0;
 err:
+	free_scandir_des(des, n_des);
 	erec_queue(erec, state->msgs);
 	return -1;
 }
@@ -721,27 +759,37 @@ err:
 static int include_dentry(void *scanner, const char *filename,
 			  const struct location *loc)
 {
-	DIR *directory;
+	struct parser_state *state = yyget_extra(scanner);
+	struct error_record *erec;
+	struct stat st;
 	int ret;
 
-	/* The file can be either a simple file or a directory which
-	 * contains files.
-	 */
-	directory = opendir(filename);
-	if (directory == NULL &&
-	    errno != ENOTDIR) {
-		/* Could not access the directory or file, keep on searching.
+	/* stat the file */
+	ret = stat(filename, &st);
+
+	if (ret == -1 && errno == ENOENT)
+		/* Could not find the directory or file, keep on searching.
 		 * Return value '1' indicates to the caller that we should still
 		 * search in the next include directory.
 		 */
-		ret = 1;
-	} else if (directory != NULL) {
-		ret = include_directory(scanner, filename, directory, loc);
-		closedir(directory);
-	} else {
-		ret = include_file(scanner, filename, loc);
+		return 1;
+	else if (ret == 0) {
+		if (S_ISDIR(st.st_mode))
+			return include_directory(scanner, filename, loc);
+		else if (S_ISREG(st.st_mode))
+			return include_file(scanner, filename, loc);
+		else {
+			errno = EINVAL;
+			ret = -1;
+		}
 	}
 
+	/* Process error for failed stat and cases where the file is not a
+	 * directory or (a link to) a regular file.
+	 */
+	erec = error(loc, "Failed to access file \"%s\": %s\n",
+			filename, strerror(errno));
+	erec_queue(erec, state->msgs);
 	return ret;
 }
 
-- 
2.9.4

