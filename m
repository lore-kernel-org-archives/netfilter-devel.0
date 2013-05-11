From: Chris Boot <bootc@bootc.net>
Subject: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sat, 11 May 2013 18:01:53 +0100
Message-ID: <1368291713-40132-3-git-send-email-bootc@bootc.net>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
Cc: Chris Boot <bootc@bootc.net>, Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:46402 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab3EKRKn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 13:10:43 -0400
In-Reply-To: <1368291713-40132-1-git-send-email-bootc@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The deamon currently does not have the ability to write a PID file to track its
process ID. This is very useful to an init script and to ensure there is only
one running instance. This patch implements this functionality.

Signed-off-by: Chris Boot <bootc@bootc.net>
---
 src/ulogd.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 8a144e3..982663f 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -4,6 +4,7 @@
  *
  * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
  * (C) 2013 by Eric Leblond <eric@regit.org>
+ * (C) 2013 Chris Boot <bootc@bootc.net>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 
@@ -55,12 +56,14 @@
 #include <signal.h>
 #include <dlfcn.h>
 #include <sys/types.h>
+#include <fcntl.h>
 #include <dirent.h>
 #include <getopt.h>
 #include <pwd.h>
 #include <grp.h>
 #include <syslog.h>
 #include <sys/time.h>
+#include <sys/stat.h>
 #include <ulogd/conffile.h>
 #include <ulogd/ulogd.h>
 #ifdef DEBUG
@@ -78,6 +81,7 @@
 static FILE *logfile = NULL;		/* logfile pointer */
 static char *ulogd_logfile = NULL;
 static const char *ulogd_configfile = ULOGD_CONFIGFILE;
+static const char *ulogd_pidfile = NULL;
 static FILE syslog_dummy;
 
 static int info_mode = 0;
@@ -94,6 +98,7 @@ static LLIST_HEAD(ulogd_pi_stacks);
 static int load_plugin(const char *file);
 static int create_stack(const char *file);
 static int logfile_open(const char *name);
+static void cleanup_pidfile();
 
 static struct config_keyset ulogd_kset = {
 	.num_ces = 4,
@@ -457,6 +462,8 @@ void __ulogd_log(int level, char *file, int line, const char *format, ...)
 
 static void warn_and_exit(int daemonize)
 {
+	cleanup_pidfile();
+
 	if (!daemonize) {
 		if (logfile && !verbose) {
 			fprintf(stderr, "Fatal error, check logfile \"%s\""
@@ -1002,6 +1009,62 @@ static int parse_conffile(const char *section, struct config_keyset *ce)
 	return 1;
 }
 
+static int write_pidfile()
+{
+	struct stat pid_st;
+	int pid_fp;
+	char pidtext[16];
+	int len;
+
+	if (!ulogd_pidfile)
+		return 0;
+
+	if (stat(ulogd_pidfile, &pid_st) == 0 || errno != ENOENT) {
+		ulogd_log(ULOGD_FATAL, "PID file %s exists, not starting\n",
+				ulogd_pidfile);
+		return -1;
+	}
+
+	pid_fp = open(ulogd_pidfile, O_WRONLY | O_CREAT | O_EXCL, 0644);
+	if (pid_fp < 0) {
+		ulogd_log(ULOGD_FATAL, "PID file %s could not be opened: %d\n",
+				ulogd_pidfile, errno);
+		return -1;
+	}
+
+	if (ftruncate(pid_fp, 0) != 0) {
+		close(pid_fp);
+		unlink(ulogd_pidfile);
+		ulogd_log(ULOGD_FATAL, "PID file %s could not be truncated: %d\n",
+				ulogd_pidfile, errno);
+		return -1;
+	}
+
+	len = snprintf(pidtext, sizeof(pidtext), "%ld\n", (long)getpid());
+
+	if (write(pid_fp, pidtext, len) != len) {
+		close(pid_fp);
+		unlink(ulogd_pidfile);
+		ulogd_log(ULOGD_FATAL, "PID file %s could not be written: %d\n",
+				ulogd_pidfile, errno);
+		return -1;
+	}
+
+	/* deliberately leave PID file open */
+
+	return 0;
+}
+
+static void cleanup_pidfile()
+{
+	if (!ulogd_pidfile)
+		return;
+
+	if (unlink(ulogd_pidfile) != 0)
+		ulogd_log(ULOGD_ERROR, "PID file %s could not be deleted: %d\n",
+				ulogd_pidfile, errno);
+}
+
 static void deliver_signal_pluginstances(int signal)
 {
 	struct ulogd_pluginstance_stack *stack;
@@ -1080,6 +1143,8 @@ static void sigterm_handler(int signal)
 
 	config_stop();
 
+	cleanup_pidfile();
+
 	exit(0);
 }
 
@@ -1121,6 +1186,7 @@ static void print_usage(void)
 	printf("\t-v --verbose\tOutput info on standard output\n");
 	printf("\t-l --loglevel\tSet log level\n");
 	printf("\t-c --configfile\tUse alternative Configfile\n");
+	printf("\t-p --pidfile\tRecord ulogd PID in file\n");
 	printf("\t-u --uid\tChange UID/GID\n");
 	printf("\t-i --info\tDisplay infos about plugin\n");
 }
@@ -1134,6 +1200,7 @@ static struct option opts[] = {
 	{ "info", 1, NULL, 'i' },
 	{ "verbose", 0, NULL, 'v' },
 	{ "loglevel", 1, NULL, 'l' },
+	{ "pidfile", 1, NULL, 'p' },
 	{NULL, 0, NULL, 0}
 };
 
@@ -1150,7 +1217,7 @@ int main(int argc, char* argv[])
 
 	ulogd_logfile = strdup(ULOGD_LOGFILE_DEFAULT);
 
-	while ((argch = getopt_long(argc, argv, "c:dvl:h::Vu:i:", opts, NULL)) != -1) {
+	while ((argch = getopt_long(argc, argv, "c:p:dvl:h::Vu:i:", opts, NULL)) != -1) {
 		switch (argch) {
 		default:
 		case '?':
@@ -1179,6 +1246,9 @@ int main(int argc, char* argv[])
 		case 'c':
 			ulogd_configfile = optarg;
 			break;
+		case 'p':
+			ulogd_pidfile = optarg;
+			break;
 		case 'u':
 			change_uid = 1;
 			user = strdup(optarg);
@@ -1280,6 +1350,9 @@ int main(int argc, char* argv[])
 		setsid();
 	}
 
+	if (write_pidfile() < 0)
+		warn_and_exit(daemonize);
+
 	signal(SIGTERM, &sigterm_handler);
 	signal(SIGINT, &sigterm_handler);
 	signal(SIGHUP, &signal_handler);
-- 
1.7.10.4

