From: heitzenberger@astaro.com
Subject: [ULOGD 06/15] Conffile cleanup, use common pr_debug()
Date: Sat, 02 Feb 2008 21:48:32 +0100
Message-ID: <20080202205108.009892441@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-39.dex002.intermedia.net ([64.78.21.124]:46505 "EHLO
	dhost002-39.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932769AbYBBUvZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-config-changes.diff

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/src/conffile.c
===================================================================
--- ulogd-netfilter.orig/src/conffile.c
+++ ulogd-netfilter/src/conffile.c
@@ -17,17 +17,10 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/common.h>
 #include <ulogd/conffile.h>
 
-#ifdef DEBUG_CONF
-#define DEBUGC(format, args...) fprintf(stderr, format, ## args)
-#else
-#define DEBUGC(format, args...)
-#endif
 
 /* points to config entry with error */
 struct config_entry *config_errce = NULL;
@@ -101,6 +94,8 @@ int config_register_file(const char *fil
 	if (fname)
 		return 1;
 
+	pr_debug("%s: registered config file '%s'\n", __func__, file);
+
 	fname = (char *) malloc(strlen(file)+1);
 	if (!fname)
 		return -ERROOM;
@@ -121,12 +116,12 @@ int config_parse_file(const char *sectio
 	char linebuf[LINE_LEN+1];
 	char *line = linebuf;
 
+	pr_debug("%s: section='%s' file='%s'\n", __func__, section, fname);
+
 	cfile = fopen(fname, "r");
 	if (!cfile)
 		return -ERROPEN;
 
-	DEBUGC("parsing section [%s]\n", section);
-
 	/* Search for correct section */
 	while (fgets(line, LINE_LEN, cfile)) {
 		char wordbuf[LINE_LEN];
@@ -137,7 +132,7 @@ int config_parse_file(const char *sectio
 
 		if (!(wordend = get_word(line, " \t\n[]", (char *) wordbuf)))
 			continue;
-		DEBUGC("word: \"%s\"\n", wordbuf);
+		pr_debug("word: \"%s\"\n", wordbuf);
 		if (!strcmp(wordbuf, section)) {
 			found = 1;
 			break;
@@ -156,7 +151,7 @@ int config_parse_file(const char *sectio
 		char wordbuf[LINE_LEN];
 		char *wordend;
 		
-		DEBUGC("line read: %s\n", line);
+		pr_debug("line read: %s\n", line);
 		if (*line == '#')
 			continue;
 
@@ -164,14 +159,14 @@ int config_parse_file(const char *sectio
 			continue;
 
 		if (wordbuf[0] == '[' ) {
-			DEBUGC("Next section '%s' encountered\n", wordbuf);
+			pr_debug("Next section '%s' encountered\n", wordbuf);
 			break;
 		}
 
-		DEBUGC("parse_file: entering main loop\n");
+		pr_debug("parse_file: entering main loop\n");
 		for (i = 0; i < kset->num_ces; i++) {
 			struct config_entry *ce = &kset->ces[i];
-			DEBUGC("parse main loop, key: %s\n", ce->key);
+			pr_debug("parse main loop, key: %s\n", ce->key);
 			if (strcmp(ce->key, (char *) &wordbuf)) {
 				continue;
 			}
@@ -181,7 +176,7 @@ int config_parse_file(const char *sectio
 
 			if (ce->hit && !(ce->options & CONFIG_OPT_MULTI))
 			{
-				DEBUGC("->ce-hit and option not multi!\n");
+				pr_debug("->ce-hit and option not multi!\n");
 				config_errce = ce;
 				err = -ERRMULT;
 				goto cpf_error;
@@ -205,15 +200,15 @@ int config_parse_file(const char *sectio
 			}
 			break;
 		}
-		DEBUGC("parse_file: exiting main loop\n");
+		pr_debug("parse_file: exiting main loop\n");
 	}
 
 
 	for (i = 0; i < kset->num_ces; i++) {
 		struct config_entry *ce = &kset->ces[i];
-		DEBUGC("ce post loop, ce=%s\n", ce->key);
+		pr_debug("ce post loop, ce=%s\n", ce->key);
 		if ((ce->options & CONFIG_OPT_MANDATORY) && (ce->hit == 0)) {
-			DEBUGC("Mandatory config directive \"%s\" not found\n",
+			pr_debug("Mandatory config directive \"%s\" not found\n",
 				ce->key);
 			config_errce = ce;
 			err = -ERRMAND;

-- 
