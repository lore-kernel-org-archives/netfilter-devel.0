From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH v2] log: print messages to stdout/sderr if
 running in console mode
Date: Fri, 28 Oct 2016 08:57:08 +0200
Message-ID: <147763774551.12311.7353846218834006990.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59468 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935293AbcJ1G5F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 02:57:05 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 3BA4B51F2CD
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 06:57:02 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mR_aAHJKXw4s for <netfilter-devel@vger.kernel.org>;
        Fri, 28 Oct 2016 08:56:56 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 8DBC451F28A
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 08:56:56 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If conntrackd is running in console mode (i.e. in foreground)
then we can print the log messages to stdout/stderr.

This eases the workflow for admins, since we condensate more info into
the same terminal output.

Example:

% sudo conntrackd -C /etc/conntrackd.conf
WARNING: XXXX is an invalid interface
[Thu Oct 27 13:57:09 2016] (pid=7581) [notice] disabling internal cache
[Thu Oct 27 13:57:09 2016] (pid=7581) [notice] disabling external cache
[Thu Oct 27 13:57:09 2016] (pid=7581) [ERROR] can't open channel socket: No such device
[Thu Oct 27 13:57:09 2016] (pid=7581) [ERROR] initialization failed
ERROR: conntrackd cannot start, please check the logfile for more info

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---

v2: fix va_list arguments usage by using pointers where needed.

 include/conntrackd.h |    1 +
 src/log.c            |   67 +++++++++++++++++++++++++++++++++++---------------
 src/main.c           |    1 +
 3 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/include/conntrackd.h b/include/conntrackd.h
index f8b11a7..8406c54 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -110,6 +110,7 @@ struct ct_conf {
 	int filter_from_kernelspace;
 	int event_iterations_limit;
 	int systemd;
+	int running_mode;
 	struct {
 		int error_queue_length;
 	} channelc;
diff --git a/src/log.c b/src/log.c
index d4de111..0796ba9 100644
--- a/src/log.c
+++ b/src/log.c
@@ -60,41 +60,68 @@ int init_log(void)
 	return 0;
 }
 
-void dlog(int priority, const char *format, ...)
- {
-	FILE *fd = STATE(log);
+static void logline_put(FILE *fd, int priority, const char *format,
+			va_list *args)
+{
 	time_t t;
 	char *buf;
 	const char *prio;
+
+	t = time(NULL);
+	buf = ctime(&t);
+	buf[strlen(buf)-1]='\0';
+
+	switch (priority) {
+	case LOG_INFO:
+		prio = "info";
+		break;
+	case LOG_NOTICE:
+		prio = "notice";
+		break;
+	case LOG_WARNING:
+		prio = "warning";
+		break;
+	case LOG_ERR:
+		prio = "ERROR";
+		break;
+	default:
+		prio = "?";
+		break;
+	}
+
+	fprintf(fd, "[%s] (pid=%d) [%s] ", buf, getpid(), prio);
+	vfprintf(fd, format, *args);
+	fprintf(fd, "\n");
+	fflush(fd);
+}
+
+void dlog(int priority, const char *format, ...)
+{
+	FILE *fd = STATE(log);
+	FILE *console_out;
  	va_list args;
- 
-	if (fd) {
-		t = time(NULL);
-		buf = ctime(&t);
-		buf[strlen(buf)-1]='\0';
+
+	if (CONFIG(running_mode) != DAEMON) {
 		switch (priority) {
 		case LOG_INFO:
-			prio = "info";
-			break;
 		case LOG_NOTICE:
-			prio = "notice";
+			console_out = stdout;
 			break;
 		case LOG_WARNING:
-			prio = "warning";
-			break;
 		case LOG_ERR:
-			prio = "ERROR";
-			break;
 		default:
-			prio = "?";
+			console_out = stderr;
 			break;
 		}
 		va_start(args, format);
-		fprintf(fd, "[%s] (pid=%d) [%s] ", buf, getpid(), prio);
-		vfprintf(fd, format, args);
+		logline_put(console_out, priority, format, &args);
+		va_end(args);
+	}
+
+	if (fd) {
+		va_start(args, format);
+		logline_put(fd, priority, format, &args);
 		va_end(args);
-		fprintf(fd, "\n");
-		fflush(fd);
 	}
 
 	if (CONFIG(syslog_facility) != -1) {
diff --git a/src/main.c b/src/main.c
index 2be9b2f..0319b5c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -150,6 +150,7 @@ int main(int argc, char *argv[])
 		switch(argv[i][1]) {
 		case 'd':
 			set_operation_mode(&type, DAEMON, argv);
+			CONFIG(running_mode) = DAEMON;
 			break;
 		case 'c':
 			set_operation_mode(&type, REQUEST, argv);

