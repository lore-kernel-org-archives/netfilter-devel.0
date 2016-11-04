From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 1/3] log: introduce a mechanism to know if
 log was initialized
Date: Fri, 04 Nov 2016 11:37:02 +0100
Message-ID: <147825582201.31164.6123720868667079634.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53276 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1761085AbcKDKhB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Nov 2016 06:37:01 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id C341D51F304
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Nov 2016 10:36:55 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RWzstOfZB771 for <netfilter-devel@vger.kernel.org>;
        Fri,  4 Nov 2016 11:36:50 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 6D70151F2D0
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Nov 2016 11:36:50 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will allow to call dlog() function from all the points in the
execution at runtime.

If the log was not initialized, then we just fprintf and return.

By now, we can't init the log engine earlier because we require config
from the user, so there is a egg-chicken problem.
This means that we can't log parsing messages to logfiles but only to
stderr/stdout.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 include/conntrackd.h |    1 +
 src/log.c            |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/conntrackd.h b/include/conntrackd.h
index 8406c54..f995f4b 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -147,6 +147,7 @@ struct ct_general_state {
 	sigset_t 			block;
 	FILE 				*log;
 	FILE				*stats_log;
+	int				log_init;
 	struct local_server		local;
 	struct ct_mode 			*mode;
 	struct ct_filter		*us_filter;
diff --git a/src/log.c b/src/log.c
index 0796ba9..6deccfa 100644
--- a/src/log.c
+++ b/src/log.c
@@ -57,6 +57,8 @@ int init_log(void)
 	    CONFIG(stats).syslog_facility != -1)
 		openlog(PACKAGE, LOG_PID, CONFIG(syslog_facility));
 
+	STATE(log_init) = 1;
+
 	return 0;
 }
 
@@ -101,7 +103,7 @@ void dlog(int priority, const char *format, ...)
 	FILE *console_out;
  	va_list args;
 
-	if (CONFIG(running_mode) != DAEMON) {
+	if (CONFIG(running_mode) != DAEMON || STATE(log_init) == 0) {
 		switch (priority) {
 		case LOG_INFO:
 		case LOG_NOTICE:
@@ -118,6 +120,9 @@ void dlog(int priority, const char *format, ...)
 		va_end(args);
 	}
 
+	if (STATE(log_init) == 0)
+		return;
+
 	if (fd) {
 		va_start(args, format);
 		logline_put(fd, priority, format, &args);
@@ -211,6 +216,8 @@ void dlog_exp(FILE *fd, struct nf_expect *exp, unsigned int type)
 
 void close_log(void)
 {
+	STATE(log_init) = 0;
+
 	if (STATE(log) != NULL)
 		fclose(STATE(log));
 

