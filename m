From: Chris Boot <bootc@bootc.net>
Subject: [PATCH v2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 13:47:40 +0100
Message-ID: <1368362860-33843-1-git-send-email-bootc@bootc.net>
References: <518F761E.8050701@bootc.net>
Cc: Chris Boot <bootc@bootc.net>, Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:50715 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3ELMrx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 08:47:53 -0400
In-Reply-To: <518F761E.8050701@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The deamon currently does not have the ability to write a PID file to track its
process ID. This is very useful to an init script and to ensure there is only
one running instance. This patch implements this functionality.

Signed-off-by: Chris Boot <bootc@bootc.net>
---

Changes since v1:
 - Added documentation about the option to ulogd.8.
 - Move check for NULL ulogd_pidfile into main(), so it's more obvious that the
   code does nothing unless the --pidfile option is present.
 - Check for stale PID files and overwrite if that's the case, instead of
   bailing out.
 - Lock the pidfile with fcntl(); this is a good check to guard against running
   multiple instances with the same pidfile. (from atd)
 - Only unlink the pidfile at exit if we have created it. This prevents us
   removing another running ulogd process's pidfile if we exit because there is
   another running instance.

 src/ulogd.c |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ulogd.8     |    3 ++
 2 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 8a144e3..b835220 100644
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
@@ -78,11 +81,13 @@
 static FILE *logfile = NULL;		/* logfile pointer */
 static char *ulogd_logfile = NULL;
 static const char *ulogd_configfile = ULOGD_CONFIGFILE;
+static const char *ulogd_pidfile = NULL;
 static FILE syslog_dummy;
 
 static int info_mode = 0;
 
 static int verbose = 0;
+static int created_pidfile = 0;
 
 /* linked list for all registered plugins */
 static LLIST_HEAD(ulogd_plugins);
@@ -94,6 +99,7 @@ static LLIST_HEAD(ulogd_pi_stacks);
 static int load_plugin(const char *file);
 static int create_stack(const char *file);
 static int logfile_open(const char *name);
+static void cleanup_pidfile();
 
 static struct config_keyset ulogd_kset = {
 	.num_ces = 4,
@@ -457,6 +463,8 @@ void __ulogd_log(int level, char *file, int line, const char *format, ...)
 
 static void warn_and_exit(int daemonize)
 {
+	cleanup_pidfile();
+
 	if (!daemonize) {
 		if (logfile && !verbose) {
 			fprintf(stderr, "Fatal error, check logfile \"%s\""
@@ -1002,6 +1010,131 @@ static int parse_conffile(const char *section, struct config_keyset *ce)
 	return 1;
 }
 
+/*
+ * Apply F_WRLCK to fd using fcntl().
+ *
+ * This function is copied verbatim from atd's daemon.c file, published under
+ * the GPL2+ license with the following copyright statement:
+ * Copyright (C) 1996 Thomas Koenig
+ */
+static int lock_fd(int fd)
+{
+	struct flock lock;
+
+	lock.l_type = F_WRLCK;
+	lock.l_whence = SEEK_SET;
+	lock.l_start = 0;
+	lock.l_len = 0;
+
+	return fcntl(fd, F_SETLK, &lock);
+}
+
+/*
+ * Manage ulogd's pidfile.
+ *
+ * This function is based on atd's daemon.c:daemon_setup() function, published
+ * under the GPL2+ license with the following copyright statement:
+ * Copyright (C) 1996 Thomas Koenig
+ */
+static int write_pidfile()
+{
+	int fd;
+	FILE *fp;
+	pid_t pid = -1;
+
+	fd = open(ulogd_pidfile, O_RDWR | O_CREAT | O_EXCL, 0644);
+	if (fd < 0) {
+		if (errno != EEXIST) {
+			ulogd_log(ULOGD_ERROR, "cannot open %s: %d\n",
+					ulogd_pidfile, errno);
+			return -1;
+		}
+
+		fd = open(ulogd_pidfile, O_RDWR);
+		if (fd < 0) {
+			ulogd_log(ULOGD_ERROR, "cannot open %s: %d\n",
+					ulogd_pidfile, errno);
+			return -1;
+		}
+
+		fp = fdopen(fd, "rw");
+		if (fp == NULL) {
+			ulogd_log(ULOGD_ERROR, "cannot fdopen %s: %d\n",
+					ulogd_pidfile, errno);
+			return -1;
+		}
+
+		if ((fscanf(fp, "%d", &pid) != 1) || (pid == getpid())
+				|| (lock_fd(fd) == 0)) {
+			ulogd_log(ULOGD_NOTICE,
+				"removing stale pidfile for pid %d\n", pid);
+
+			if (unlink(ulogd_pidfile) < 0) {
+				ulogd_log(ULOGD_ERROR, "cannot unlink %s: %d\n",
+						ulogd_pidfile, errno);
+				return -1;
+			}
+		} else {
+			ulogd_log(ULOGD_FATAL,
+				"another ulogd already running with pid %d\n",
+				pid);
+			return -1;
+		}
+
+		fclose(fp);
+		unlink(ulogd_pidfile);
+
+		fd = open(ulogd_pidfile, O_RDWR | O_CREAT | O_EXCL, 0644);
+
+		if (fd < 0) {
+			ulogd_log(ULOGD_ERROR,
+				"cannot open %s (2nd time round): %d\n",
+				ulogd_pidfile, errno);
+			return -1;
+		}
+	}
+
+	if (lock_fd(fd) < 0) {
+		ulogd_log(ULOGD_ERROR, "cannot lock %s: %d\n", ulogd_pidfile,
+				errno);
+		return -1;
+	}
+
+	fp = fdopen(fd, "w");
+	if (fp == NULL) {
+		ulogd_log(ULOGD_ERROR, "cannot fdopen %s: %d\n", ulogd_pidfile,
+				errno);
+		return -1;
+	}
+
+	fprintf(fp, "%d\n", getpid());
+	fflush(fp);
+
+	if (ftruncate(fileno(fp), ftell(fp)) < 0)
+		ulogd_log(ULOGD_NOTICE, "cannot ftruncate %s: %d\n",
+				ulogd_pidfile, errno);
+
+	/*
+	 * We do NOT close fd, since we want to keep the lock. However, we don't
+	 * want to keep the file descriptor in case of an exec().
+	 */
+	fcntl(fd, F_SETFD, FD_CLOEXEC);
+
+	created_pidfile = 1;
+
+	return 0;
+}
+
+static void cleanup_pidfile()
+{
+	if (!ulogd_pidfile || !created_pidfile)
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
@@ -1080,6 +1213,8 @@ static void sigterm_handler(int signal)
 
 	config_stop();
 
+	cleanup_pidfile();
+
 	exit(0);
 }
 
@@ -1121,6 +1256,7 @@ static void print_usage(void)
 	printf("\t-v --verbose\tOutput info on standard output\n");
 	printf("\t-l --loglevel\tSet log level\n");
 	printf("\t-c --configfile\tUse alternative Configfile\n");
+	printf("\t-p --pidfile\tRecord ulogd PID in file\n");
 	printf("\t-u --uid\tChange UID/GID\n");
 	printf("\t-i --info\tDisplay infos about plugin\n");
 }
@@ -1134,6 +1270,7 @@ static struct option opts[] = {
 	{ "info", 1, NULL, 'i' },
 	{ "verbose", 0, NULL, 'v' },
 	{ "loglevel", 1, NULL, 'l' },
+	{ "pidfile", 1, NULL, 'p' },
 	{NULL, 0, NULL, 0}
 };
 
@@ -1150,7 +1287,7 @@ int main(int argc, char* argv[])
 
 	ulogd_logfile = strdup(ULOGD_LOGFILE_DEFAULT);
 
-	while ((argch = getopt_long(argc, argv, "c:dvl:h::Vu:i:", opts, NULL)) != -1) {
+	while ((argch = getopt_long(argc, argv, "c:p:dvl:h::Vu:i:", opts, NULL)) != -1) {
 		switch (argch) {
 		default:
 		case '?':
@@ -1179,6 +1316,9 @@ int main(int argc, char* argv[])
 		case 'c':
 			ulogd_configfile = optarg;
 			break;
+		case 'p':
+			ulogd_pidfile = optarg;
+			break;
 		case 'u':
 			change_uid = 1;
 			user = strdup(optarg);
@@ -1280,6 +1420,11 @@ int main(int argc, char* argv[])
 		setsid();
 	}
 
+	if (ulogd_pidfile) {
+		if (write_pidfile() < 0)
+			warn_and_exit(daemonize);
+	}
+
 	signal(SIGTERM, &sigterm_handler);
 	signal(SIGINT, &sigterm_handler);
 	signal(SIGHUP, &signal_handler);
diff --git a/ulogd.8 b/ulogd.8
index 9cbad7c..9d16aeb 100644
--- a/ulogd.8
+++ b/ulogd.8
@@ -57,6 +57,9 @@ change UID/GID
 .TP
 .B -i <pluginpath>, --info <pluginpath>
 display infos about plugin
+.TP
+.B -p <filename>, --pidfile <filename>
+record the ulogd process ID to the given file name
 .SH FILES
 .I /etc/ulogd.conf
 .br
-- 
1.7.10.4

