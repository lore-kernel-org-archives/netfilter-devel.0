From: Felix Janda <felix.janda@posteo.de>
Subject: [ulogd2 PATCHv2] ulogd: Use /dev/null as dummy logfile when logging
 to syslog
Date: Sat, 16 May 2015 17:43:23 +0200
Message-ID: <20150516154040.GA3782@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:38961 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbbEPPnx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 11:43:53 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id 961AB25A211F
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 17:43:52 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3lprVw2fBxzFpW3
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 17:43:52 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes compilation error with musl libc:

ulogd.c:86:13: error: storage size of 'syslog_dummy' isn't known
 static FILE syslog_dummy;

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 src/ulogd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index e7cde39..958c30a 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -83,7 +83,7 @@ static char *ulogd_logfile = NULL;
 static const char *ulogd_configfile = ULOGD_CONFIGFILE;
 static const char *ulogd_pidfile = NULL;
 static int ulogd_pidfile_fd = -1;
-static FILE syslog_dummy;
+static FILE *syslog_dummy;
 
 static int info_mode = 0;
 
@@ -427,7 +427,7 @@ void __ulogd_log(int level, char *file, int line, const char *format, ...)
 	if (level < loglevel_ce.u.value)
 		return;
 
-	if (logfile == &syslog_dummy) {
+	if (logfile == syslog_dummy) {
 		/* FIXME: this omits the 'file' string */
 		va_start(ap, format);
 		vsyslog(ulogd2syslog_level(level), format, ap);
@@ -950,7 +950,7 @@ static int logfile_open(const char *name)
 		logfile = stdout;
 	} else if (!strcmp(name, "syslog")) {
 		openlog("ulogd", LOG_PID, LOG_DAEMON);
-		logfile = &syslog_dummy;
+		logfile = syslog_dummy = fopen("/dev/null", "w");
 	} else {
 		logfile = fopen(ulogd_logfile, "a");
 		if (!logfile) {
@@ -1240,7 +1240,7 @@ static void sigterm_handler(int signal)
 	unload_plugins();
 #endif
 
-	if (logfile != NULL  && logfile != stdout && logfile != &syslog_dummy) {
+	if (logfile != NULL  && logfile != stdout) {
 		fclose(logfile);
 		logfile = NULL;
 	}
@@ -1262,7 +1262,7 @@ static void signal_handler(int signal)
 	switch (signal) {
 	case SIGHUP:
 		/* reopen logfile */
-		if (logfile != stdout && logfile != &syslog_dummy) {
+		if (logfile != stdout && logfile != syslog_dummy) {
 			fclose(logfile);
 			logfile = fopen(ulogd_logfile, "a");
  			if (!logfile) {
-- 
2.3.6
