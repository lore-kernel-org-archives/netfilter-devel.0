From: Eric Leblond <eric@regit.org>
Subject: [PATCH 3/7] Use access to ensure readability of config gile
Date: Mon, 18 Feb 2013 09:37:44 +0100
Message-ID: <1361176668-22661-4-git-send-email-eric@regit.org>
References: <1361176668-22661-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48541 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3BRIie (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:38:34 -0500
In-Reply-To: <1361176668-22661-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a call to access to check the readability of the
configuration file.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/conffile.c |   11 ++++++++++-
 src/ulogd.c    |    2 +-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/conffile.c b/src/conffile.c
index dd0ed8f..616d7a9 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -16,9 +16,11 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+
 #include <ulogd/ulogd.h>
 #include <ulogd/common.h>
 #include <ulogd/conffile.h>
+#include <unistd.h>
 
 
 /* points to config entry with error */
@@ -89,10 +91,17 @@ static char *get_word(char *line, char *not, char *buf)
 /* register config file with us */
 int config_register_file(const char *file)
 {
-	/* FIXME: stat of file */
 	if (fname)
 		return 1;
 
+	if (access(file, R_OK) != 0) {
+		ulogd_log(ULOGD_ERROR,
+			 "unable to read configfile \"%s\": %s\n",
+			 file,
+			 strerror(errno));
+		return 1;
+	}
+
 	pr_debug("%s: registered config file '%s'\n", __func__, file);
 
 	fname = (char *) malloc(strlen(file)+1);
diff --git a/src/ulogd.c b/src/ulogd.c
index c7617d9..f8c8ed0 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1216,7 +1216,7 @@ int main(int argc, char* argv[])
 
 	/* parse config file */
 	if (parse_conffile("global", &ulogd_kset)) {
-		ulogd_log(ULOGD_FATAL, "parse_conffile\n");
+		ulogd_log(ULOGD_FATAL, "unable to parse config file\n");
 		warn_and_exit(daemonize);
 	}
 
-- 
1.7.10.4

