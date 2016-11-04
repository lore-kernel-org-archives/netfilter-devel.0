From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 3/3] conntrackd: replace fprintf calls with
 dlog()
Date: Fri, 04 Nov 2016 11:37:12 +0100
Message-ID: <147825583278.31164.3354068117626763133.stgit@nfdev2.cica.es>
References: <147825582201.31164.6123720868667079634.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53283 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1761246AbcKDKhK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Nov 2016 06:37:10 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 02B1951F301
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Nov 2016 10:37:07 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id g-kYZtLKm5-2 for <netfilter-devel@vger.kernel.org>;
        Fri,  4 Nov 2016 11:37:01 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id EA5F051F2D0
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Nov 2016 11:37:00 +0100 (CET)
In-Reply-To: <147825582201.31164.6123720868667079634.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Review fprintf() and perror() calls and replace them with proper logs,
since it now supports being called anytime during runtime.

While at it, several messages are fixed, deleting \n, adjusting
coding style and some typos.
Also, the 'conntrackd cannot start, please review your configuration' is
printed before closing the log engine.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/ctnl.c            |    4 +--
 src/filter.c          |    4 +--
 src/main.c            |   67 +++++++++++++++++++++++--------------------------
 src/read_config_lex.l |   13 +++++-----
 src/sync-mode.c       |    4 +--
 src/systemd.c         |    4 +--
 6 files changed, 46 insertions(+), 50 deletions(-)

diff --git a/src/ctnl.c b/src/ctnl.c
index 10b5f4c..9d5dcb8 100644
--- a/src/ctnl.c
+++ b/src/ctnl.c
@@ -404,8 +404,8 @@ int ctnl_init(void)
 	else if (CONFIG(flags) & CTD_SYNC_MODE)
 		STATE(mode) = &sync_mode;
 	else {
-		fprintf(stderr, "WARNING: No running mode specified. "
-				"Defaulting to statistics mode.\n");
+		dlog(LOG_WARNING, "No running mode specified. "
+		     "Defaulting to statistics mode.");
 		CONFIG(flags) |= CTD_STATS_MODE;
 		STATE(mode) = &stats_mode;
 	}
diff --git a/src/filter.c b/src/filter.c
index 1ae2cc5..00a5e96 100644
--- a/src/filter.c
+++ b/src/filter.c
@@ -138,7 +138,7 @@ static struct ct_filter *__filter_alloc(struct ct_filter *filter)
 	if (!STATE(us_filter)) {
 		STATE(us_filter) = ct_filter_create();
 		if (!STATE(us_filter)) {
-			fprintf(stderr, "Can't create ignore pool!\n");
+			dlog(LOG_ERR, "Can't create ignore pool!");
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -479,7 +479,7 @@ static struct exp_filter *exp_filter_alloc(void)
 	if (STATE(exp_filter) == NULL) {
 		STATE(exp_filter) = exp_filter_create();
 		if (STATE(exp_filter) == NULL) {
-			fprintf(stderr, "Can't init expectation filtering!\n");
+			dlog(LOG_ERR, "Can't init expectation filtering!");
 			return NULL;
 		}
 	}
diff --git a/src/main.c b/src/main.c
index 0319b5c..febeaa9 100644
--- a/src/main.c
+++ b/src/main.c
@@ -86,7 +86,7 @@ set_operation_mode(int *current, int want, char *argv[])
 	}
 	if (*current != want) {
 		show_usage(argv[0]);
-		fprintf(stderr, "\nError: Invalid parameters\n");
+		dlog(LOG_ERR, "Invalid parameters");
 		exit(EXIT_FAILURE);
 	}
 }
@@ -115,16 +115,16 @@ set_nice_value(int nv)
 {
 	errno = 0;
 	if (nice(nv) == -1 && errno) /* warn only */
-		fprintf(stderr, "Cannot set nice level %d: %s\n",
-			nv, strerror(errno));
+		dlog(LOG_WARNING, "Cannot set nice level %d: %s",
+		     nv, strerror(errno));
 }
 
 static void
 do_chdir(const char *d)
 {
 	if (chdir(d))
-		fprintf(stderr, "Cannot change current directory to %s: %s\n",
-			d, strerror(errno));
+		dlog(LOG_WARNING, "Cannot change current directory to %s: %s",
+		     d, strerror(errno));
 }
 
 int main(int argc, char *argv[])
@@ -137,12 +137,12 @@ int main(int argc, char *argv[])
 
 	/* Check kernel version: it must be >= 2.6.18 */
 	if (uname(&u) == -1) {
-		fprintf(stderr, "Can't retrieve kernel version via uname()\n");
+		dlog(LOG_ERR, "Can't retrieve kernel version via uname()");
 		exit(EXIT_FAILURE);
 	}
 	sscanf(u.release, "%d.%d.%d", &version, &major, &minor);
 	if (version < 2 && major < 6 && minor < 18) {
-		fprintf(stderr, "Linux kernel version must be >= 2.6.18\n");
+		dlog(LOG_ERR, "Linux kernel version must be >= 2.6.18");
 		exit(EXIT_FAILURE);
 	}
 
@@ -177,15 +177,14 @@ int main(int argc, char *argv[])
 				strncpy(config_file, argv[i], PATH_MAX);
 				if (strlen(argv[i]) >= PATH_MAX){
 					config_file[PATH_MAX-1]='\0';
-					fprintf(stderr, "Path to config file "
-						        "to long. Cutting it "
-							"down to %d characters",
-							PATH_MAX);
+					dlog(LOG_WARNING, "Path to config file"
+					     " to long. Cutting it down to %d"
+					     " characters", PATH_MAX);
 				}
 				break;
 			}
 			show_usage(argv[0]);
-			fprintf(stderr, "Missing config filename\n");
+			dlog(LOG_ERR, "Missing config filename");
 			break;
 		case 'F':
 			set_operation_mode(&type, REQUEST, argv);
@@ -206,10 +205,8 @@ int main(int argc, char *argv[])
 					action = CT_FLUSH_EXT_CACHE;
 					i++;
 				} else {
-					fprintf(stderr, "ERROR: unknown "
-							"parameter `%s' for "
-							"option `-f'\n",
-							argv[i+1]);
+					dlog(LOG_ERR, "unknown parameter `%s' "
+					     "for option `-f'", argv[i + 1]);
 					exit(EXIT_FAILURE);
 				}
 			} else {
@@ -254,9 +251,9 @@ int main(int argc, char *argv[])
 					i++;
 				} else if (strncmp(argv[i+1], "multicast",
 						 strlen(argv[i+1])) == 0) {
-					fprintf(stderr, "WARNING: use `link' "
-						"instead of `multicast' as "
-						"parameter.\n");
+					dlog(LOG_WARNING, "use `link' "
+					     "instead of `multicast' as "
+					     "parameter.");
 					action = STATS_LINK;
 					i++;
 				} else if (strncmp(argv[i+1], "link",
@@ -284,10 +281,8 @@ int main(int argc, char *argv[])
 					action = EXP_STATS;
 					i++;
 				} else {
-					fprintf(stderr, "ERROR: unknown "
-							"parameter `%s' for "
-							"option `-s'\n",
-							argv[i+1]);
+					dlog(LOG_ERR, "unknown parameter `%s' "
+					     "for option `-s'", argv[i + 1]);
 					exit(EXIT_FAILURE);
 				}
 			} else {
@@ -296,8 +291,7 @@ int main(int argc, char *argv[])
 			}
 			break;
 		case 'S':
-			fprintf(stderr, "WARNING: -S option is obsolete. "
-					"Ignoring.\n");
+			dlog(LOG_WARNING,"-S option is obsolete. Ignoring.");
 			break;
 		case 'n':
 			set_operation_mode(&type, REQUEST, argv);
@@ -314,7 +308,7 @@ int main(int argc, char *argv[])
 				action = EXP_DUMP_EXT_XML;
 			else {
 				show_usage(argv[0]);
-				fprintf(stderr, "Error: Invalid parameters\n");
+				dlog(LOG_ERR,  "Invalid parameters");
 				exit(EXIT_FAILURE);
 
 			}
@@ -327,7 +321,7 @@ int main(int argc, char *argv[])
 			exit(EXIT_SUCCESS);
 		default:
 			show_usage(argv[0]);
-			fprintf(stderr, "Unknown option: %s\n", argv[i]);
+			dlog(LOG_ERR, "Unknown option: %s", argv[i]);
 			return 0;
 			break;
 		}
@@ -339,14 +333,14 @@ int main(int argc, char *argv[])
 	umask(0177);
 
 	if ((ret = init_config(config_file)) == -1) {
-		fprintf(stderr, "can't open config file `%s'\n", config_file);
+		dlog(LOG_ERR, "can't open config file `%s'", config_file);
 		exit(EXIT_FAILURE);
 	}
 
 	if (type == REQUEST) {
 		if (do_local_request(action, &conf.local, local_step) == -1) {
-			fprintf(stderr, "can't connect: is conntrackd "
-					"running? appropriate permissions?\n");
+			dlog(LOG_ERR, "can't connect: is conntrackd "
+			     "running? appropriate permissions?");
 			exit(EXIT_FAILURE);
 		}
 		exit(EXIT_SUCCESS);
@@ -363,8 +357,8 @@ int main(int argc, char *argv[])
 	 */
 	ret = open(CONFIG(lockfile), O_CREAT | O_EXCL | O_TRUNC, 0600);
 	if (ret == -1) {
-		fprintf(stderr, "lockfile `%s' exists, perhaps conntrackd "
-			        "already running?\n", CONFIG(lockfile));
+		dlog(LOG_ERR, "lockfile `%s' exists, perhaps conntrackd"
+		     " already running?", CONFIG(lockfile));
 		exit(EXIT_FAILURE);
 	}
 	close(ret);
@@ -381,7 +375,8 @@ int main(int argc, char *argv[])
 
 		ret = sched_setscheduler(0, CONFIG(sched).type, &schedparam);
 		if (ret == -1) {
-			perror("sched");
+			dlog(LOG_ERR, "scheduler configuration failed: %s",
+			     strerror(errno));
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -391,9 +386,9 @@ int main(int argc, char *argv[])
 	 */
 
 	if (init() == -1) {
+		dlog(LOG_ERR, "conntrackd cannot start, please review your "
+		     "configuration");
 		close_log();
-		fprintf(stderr, "ERROR: conntrackd cannot start, please "
-				"check the logfile for more info\n");
 		unlink(CONFIG(lockfile));
 		exit(EXIT_FAILURE);
 	}
@@ -408,7 +403,7 @@ int main(int argc, char *argv[])
 		pid_t pid;
 
 		if ((pid = fork()) == -1) {
-			perror("fork has failed: ");
+			dlog(LOG_ERR, "fork has failed: %s", strerror(errno));
 			exit(EXIT_FAILURE);
 		} else if (pid) {
 			sd_ct_mainpid(pid);
diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index 2404058..5f2de7d 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -21,6 +21,7 @@
 
 #include <string.h>
 
+#include "conntrackd.h"
 #include "read_config_yy.h"
 %}
 
@@ -158,14 +159,14 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 {ip6}			{ yylval.string = strdup(yytext); return T_IP; }
 {path}			{ yylval.string = strdup(yytext); return T_PATH_VAL; }
 {alarm}			{ return T_ALARM; }
-{persistent}		{ fprintf(stderr, "\nWARNING: Now `persistent' mode "
-				  "is called `alarm'. Please, update "
-				  "your conntrackd.conf file.\n");
+{persistent}		{ dlog(LOG_WARNING, "Now `persistent' mode "
+			       "is called `alarm'. Please, update "
+				"your conntrackd.conf file.");
 			  return T_ALARM; }
 {ftfw}			{ return T_FTFW; }
-{nack}			{ fprintf(stderr, "\nWARNING: Now `nack' mode "
-				  "is called `ftfw'. Please, update "
-				  "your conntrackd.conf file.\n");
+{nack}			{ dlog(LOG_WARNING, "Now `nack' mode "
+			       "is called `ftfw'. Please, update "
+			       "your conntrackd.conf file.\n");
 			  return T_FTFW; }
 {notrack}		{ return T_NOTRACK; }
 {string}		{ yylval.string = strdup(yytext); return T_STRING; }
diff --git a/src/sync-mode.c b/src/sync-mode.c
index 8fe65f1..082e2ce 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -377,8 +377,8 @@ static int init_sync(void)
 	else if (CONFIG(flags) & CTD_SYNC_NOTRACK)
 		STATE_SYNC(sync) = &sync_notrack;
 	else {
-		fprintf(stderr, "WARNING: No synchronization mode specified. "
-				"Defaulting to FT-FW mode.\n");
+		dlog(LOG_WARNING, "No synchronization mode specified. "
+		     "Defaulting to FT-FW mode.");
 		CONFIG(flags) |= CTD_SYNC_FTFW;
 		STATE_SYNC(sync) = &sync_ftfw;
 	}
diff --git a/src/systemd.c b/src/systemd.c
index 4eb880c..2c5daaf 100644
--- a/src/systemd.c
+++ b/src/systemd.c
@@ -42,8 +42,8 @@ void sd_ct_watchdog_init(void)
 
 	ret = sd_watchdog_enabled(0, &sd_watchdog_interval);
 	if (ret < 0) {
-		fprintf(stderr, "WARNING: failed to get watchdog details from"
-				" systemd: %s\n", strerror(-ret));
+		dlog(LOG_WARNING, "failed to get watchdog details from "
+		     "systemd: %s", strerror(-ret));
 		return;
 	} else if (ret == 0) {
 		/* no watchdog required */

