From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [ulogd2 PATCH] ulogd: use a RT scheduler by default
Date: Thu, 07 Sep 2017 13:36:53 +0200
Message-ID: <150478421358.15825.13845813307098453243.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38829 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754943AbdIGLhD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2017 07:37:03 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id B32FC51F36C
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2017 11:37:00 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7Kt3xUDlx6ht for <netfilter-devel@vger.kernel.org>;
        Thu,  7 Sep 2017 13:36:55 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [150.214.8.221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 04E7A51F368
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2017 13:36:54 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is common that ulogd runs in scenarios where a lot of packets are to be logged.
If there are more packets than ulogd can handle, users can start seing log
messages like this:

 ulogd[556]: We are losing events. Please, consider using the clauses \
 `netlink_socket_buffer_size' and `netlink_socket_buffer_maxsize'

Which means that Netlink buffer overrun have happened.
There are several approaches to prevent this situation:

 * in the ruleset, limit the amount of packet queued for log
 * in the ruleset, instruct the kernel to use a queue-threshold
 * from userspace, increment Netlink buffer sizes
 * from userspace, configure ulogd to run as high priority process

The first 3 method can be configured by users at runtime.
This patch deals with the last method. SCHED_RR is configured by default,
with no associated configuration parameter for users, since I believe
this is common enough, and should produce no harm.

A similar approach is used in the conntrackd daemon.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 src/ulogd.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/src/ulogd.c b/src/ulogd.c
index b85d0ee..684444f 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -64,6 +64,7 @@
 #include <syslog.h>
 #include <sys/time.h>
 #include <sys/stat.h>
+#include <sched.h>
 #include <ulogd/conffile.h>
 #include <ulogd/ulogd.h>
 #ifdef DEBUG
@@ -1395,6 +1396,19 @@ static void signal_handler_task(int signal)
 	deliver_signal_pluginstances(signal);
 }
 
+static void set_scheduler(void)
+{
+	struct sched_param schedparam;
+	int sched_type;
+
+	schedparam.sched_priority = sched_get_priority_max(SCHED_RR);
+	sched_type = SCHED_RR;
+
+	if (sched_setscheduler(0, sched_type, &schedparam) < 0)
+		fprintf(stderr, "WARNING: scheduler configuration failed:"
+			" %s\n", strerror(errno));
+}
+
 static void print_usage(void)
 {
 	printf("ulogd Version %s\n", VERSION);
@@ -1589,6 +1603,7 @@ int main(int argc, char* argv[])
 	signal(SIGALRM, &signal_handler);
 	signal(SIGUSR1, &signal_handler);
 	signal(SIGUSR2, &signal_handler);
+	set_scheduler();
 
 	ulogd_log(ULOGD_INFO, 
 		  "initialization finished, entering main loop\n");

