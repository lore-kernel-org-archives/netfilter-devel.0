From: Eric Leblond <eric@regit.org>
Subject: [PATCH 3/3] Add -l option to set log level from command line
Date: Sat, 19 Jan 2013 10:50:35 +0100
Message-ID: <1358589035-1275-4-git-send-email-eric@regit.org>
References: <1358589035-1275-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37664 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3ASJvR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:51:17 -0500
In-Reply-To: <1358589035-1275-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a '-l' option which can be used to setup ulogd
loglevel. Command line option has precedence on the configuration
file one.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/ulogd.c   |   15 +++++++++++++--
 ulogd.conf.in |    4 ++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 344d330..5693572 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1112,6 +1112,7 @@ static void print_usage(void)
 	printf("\t-V --version\tPrint version information\n");
 	printf("\t-d --daemon\tDaemonize (fork into background)\n");
 	printf("\t-v --verbose\tOutput info on standard output\n");
+	printf("\t-l --loglevel\tSet log level\n");
 	printf("\t-c --configfile\tUse alternative Configfile\n");
 	printf("\t-u --uid\tChange UID/GID\n");
 	printf("\t-i --info\tDisplay infos about plugin\n");
@@ -1125,6 +1126,7 @@ static struct option opts[] = {
 	{ "uid", 1, NULL, 'u' },
 	{ "info", 1, NULL, 'i' },
 	{ "verbose", 0, NULL, 'v' },
+	{ "loglevel", 1, NULL, 'l' },
 	{NULL, 0, NULL, 0}
 };
 
@@ -1137,10 +1139,11 @@ int main(int argc, char* argv[])
 	struct passwd *pw;
 	uid_t uid = 0;
 	gid_t gid = 0;
+	int loglevel = 0;
 
 	ulogd_logfile = strdup(ULOGD_LOGFILE_DEFAULT);
 
-	while ((argch = getopt_long(argc, argv, "c:dvh::Vu:i:", opts, NULL)) != -1) {
+	while ((argch = getopt_long(argc, argv, "c:dvl:h::Vu:i:", opts, NULL)) != -1) {
 		switch (argch) {
 		default:
 		case '?':
@@ -1189,9 +1192,17 @@ int main(int argc, char* argv[])
 		case 'v':
 			verbose = 1;
 			break;
+		case 'l':
+			loglevel = atoi(optarg);
+			break;
 		}
 	}
 
+	/* command line has precedence on config file */
+	if (loglevel)
+		loglevel_ce.u.value = loglevel;
+		loglevel_ce.flag |= CONFIG_FLAG_VAL_PROTECTED;
+
 	if (daemonize && verbose) {
 		verbose = 0;
 		ulogd_log(ULOGD_ERROR,
@@ -1204,7 +1215,7 @@ int main(int argc, char* argv[])
 			  ulogd_configfile);
 		warn_and_exit(daemonize);
 	}
-	
+
 	/* parse config file */
 	if (parse_conffile("global", &ulogd_kset)) {
 		ulogd_log(ULOGD_FATAL, "parse_conffile\n");
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 783cb2b..d5db77b 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -11,8 +11,8 @@
 # logfile for status messages
 logfile="/var/log/ulogd.log"
 
-# loglevel: debug(1), info(3), notice(5), error(7) or fatal(8)
-loglevel=1
+# loglevel: debug(1), info(3), notice(5), error(7) or fatal(8) (default 5)
+# loglevel=1
 
 ######################################################################
 # PLUGIN OPTIONS
-- 
1.7.10.4

