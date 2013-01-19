From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/3] ulogd: add -v option to display message on stderr.
Date: Sat, 19 Jan 2013 10:50:33 +0100
Message-ID: <1358589035-1275-2-git-send-email-eric@regit.org>
References: <1358589035-1275-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37662 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3ASJvR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:51:17 -0500
In-Reply-To: <1358589035-1275-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If can be painful to have to check the logfile, so this patch adds
a '-v' option which display logs message to stderr.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/ulogd.c |   41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index c821bbf..344d330 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -83,6 +83,8 @@ static FILE syslog_dummy;
 
 static int info_mode = 0;
 
+static int verbose = 0;
+
 /* linked list for all registered plugins */
 static LLIST_HEAD(ulogd_plugins);
 /* linked list for all plugins handle */
@@ -430,31 +432,42 @@ void __ulogd_log(int level, char *file, int line, const char *format, ...)
 		else
 			outfd = stderr;
 
-		va_start(ap, format);
-
 		tm = time(NULL);
 		timestr = ctime(&tm);
 		timestr[strlen(timestr)-1] = '\0';
 		fprintf(outfd, "%s <%1.1d> %s:%d ", timestr, level, file, line);
+		if (verbose)
+			fprintf(stderr, "%s <%1.1d> %s:%d ", timestr, level, file, line);
+
 
+		va_start(ap, format);
 		vfprintf(outfd, format, ap);
 		va_end(ap);
-
 		/* flush glibc's buffer */
 		fflush(outfd);
+
+		if (verbose) {
+			va_start(ap, format);
+			vfprintf(stderr, format, ap);
+			va_end(ap);
+			fflush(stderr);
+		}
+
 	}
 }
 
 static void warn_and_exit(int daemonize)
 {
 	if (!daemonize) {
-		if (logfile)
-			fprintf(stderr, "Fatal error, check logfile \"%s\".\n",
+		if (logfile && !verbose) {
+			fprintf(stderr, "Fatal error, check logfile \"%s\""
+				" or use '-v' flag.\n",
 				ulogd_logfile);
-		else
+
+		} else
 			fprintf(stderr, "Fatal error.\n");
 	}
-	exit(1);
+exit(1);
 }
 
 /* clean results (set all values to 0 and free pointers) */
@@ -1098,6 +1111,7 @@ static void print_usage(void)
 	printf("\t-h --help\tThis help page\n");
 	printf("\t-V --version\tPrint version information\n");
 	printf("\t-d --daemon\tDaemonize (fork into background)\n");
+	printf("\t-v --verbose\tOutput info on standard output\n");
 	printf("\t-c --configfile\tUse alternative Configfile\n");
 	printf("\t-u --uid\tChange UID/GID\n");
 	printf("\t-i --info\tDisplay infos about plugin\n");
@@ -1110,6 +1124,7 @@ static struct option opts[] = {
 	{ "configfile", 1, NULL, 'c'},
 	{ "uid", 1, NULL, 'u' },
 	{ "info", 1, NULL, 'i' },
+	{ "verbose", 0, NULL, 'v' },
 	{NULL, 0, NULL, 0}
 };
 
@@ -1125,7 +1140,7 @@ int main(int argc, char* argv[])
 
 	ulogd_logfile = strdup(ULOGD_LOGFILE_DEFAULT);
 
-	while ((argch = getopt_long(argc, argv, "c:dh::Vu:i:", opts, NULL)) != -1) {
+	while ((argch = getopt_long(argc, argv, "c:dvh::Vu:i:", opts, NULL)) != -1) {
 		switch (argch) {
 		default:
 		case '?':
@@ -1171,9 +1186,19 @@ int main(int argc, char* argv[])
 			load_plugin(optarg);
 			exit(0);
 			break;
+		case 'v':
+			verbose = 1;
+			break;
 		}
 	}
 
+	if (daemonize && verbose) {
+		verbose = 0;
+		ulogd_log(ULOGD_ERROR,
+		          "suppressing verbose output (not compatible"
+			  " with daemon mode).\n");
+	}
+
 	if (config_register_file(ulogd_configfile)) {
 		ulogd_log(ULOGD_FATAL, "error registering configfile \"%s\"\n",
 			  ulogd_configfile);
-- 
1.7.10.4

