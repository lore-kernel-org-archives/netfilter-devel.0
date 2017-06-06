From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 2/4] conntrackd: make the daemon run in RT
 mode by default
Date: Tue, 06 Jun 2017 12:58:32 +0200
Message-ID: <149674671245.18546.17167682826049346258.stgit@nfdev2.cica.es>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40558 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751500AbdFFK6n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 06:58:43 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id A058D51F352
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 10:58:40 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id a5nAQ2MjuXsO for <netfilter-devel@vger.kernel.org>;
        Tue,  6 Jun 2017 12:58:34 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 2BE9E51F355
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 12:58:33 +0200 (CEST)
In-Reply-To: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In order to prevent netlink buffer overrun, conntrackd is recommended to run
at max priority.
Make conntrackd to use a RT (SHED_RR) scheduler by default at max priority.
This is common among other HA daemons. For example corosync uses SCHED_RR
by default.
This change should help ease the configuration of conntrackd.

Note that a sched priority that high makes the nice value useless, so deprecate
both options now.

The code is moved to the init() routine. In case of error setting the
scheduler, the system default will be used. Report a message to the user
and continue working.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 conntrackd.conf.5                |   46 +++-----------------------------------
 doc/helper/conntrackd.conf       |   21 -----------------
 doc/stats/conntrackd.conf        |   19 ----------------
 doc/sync/alarm/conntrackd.conf   |   21 -----------------
 doc/sync/ftfw/conntrackd.conf    |   21 -----------------
 doc/sync/notrack/conntrackd.conf |   21 -----------------
 include/conntrackd.h             |    5 ----
 src/main.c                       |   28 -----------------------
 src/read_config_yy.y             |   21 +++++------------
 src/run.c                        |   18 +++++++++++++++
 10 files changed, 28 insertions(+), 193 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 94de327..1e56a1f 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -480,14 +480,8 @@ By default runtime support is disabled.
 
 .TP
 .BI "Nice <value>"
-Set the \fBnice(1)\fP value of the daemon, this value goes from -20 (most
-favorable scheduling) to 19 (least favorable). Using a very low value reduces
-the chances to lose state-change events.
-
-Example: Nice -20
-
-Default is 0 but this example sets it to most favourable scheduling as
-this is generally a good idea.
+Deprecated. This option will be removed in the future.
+Conntrackd now uses by default a RT scheduler.
 
 .TP
 .BI "HashSize <value>"
@@ -731,29 +725,8 @@ Example:
 .fi
 
 .SS SCHEDULER
-Select a different scheduler for the daemon, you can select between \fBRR\fP
-and \fBFIFO\fP and the process priority.
-
-See \fBsched_setscheduler(2)\fP for more information. Using a RT scheduler
-reduces the chances to overrun the Netlink buffer.
-
-Example:
-.nf
-	Scheduler {
-		Type FIFO
-		Priority 99
-	}
-.fi
-
-.TP
-.BI "Type <type>"
-Supported values are \fBRR\fP or \fBFIFO\fP.
-
-.TP
-.BI "Priority <value>"
-Value of the scheduler priority.
-
-Minimum is 0, maximum is 99.
+Deprecated. This section will be removed in the future.
+Conntrackd now uses by default a RT scheduler.
 
 .SH STATS
 This top-level section indicates \fBconntrackd(8)\fP to work as a statistic
@@ -907,7 +880,6 @@ Stats {
 }
 General {
 	Systemd on
-	Nice -1
 	HashSize 8192
 	HashLimit 65535
 	Syslog on
@@ -973,11 +945,6 @@ Sync {
 }
 General {
 	Systemd on
-	Nice -20
-	Scheduler {
-		Type FIFO
-		Priority 99
-	}
 	HashSize 32768
 	HashLimit 131072
 	LogFile on
@@ -1036,11 +1003,6 @@ Sync {
 }
 General {
 	Systemd on
-	Nice -20
-	Scheduler {
-		Type FIFO
-		Priority 99
-	}
 	HashSize 32768
 	HashLimit 131072
 	LogFile on
diff --git a/doc/helper/conntrackd.conf b/doc/helper/conntrackd.conf
index 7eae8bc..abc4087 100644
--- a/doc/helper/conntrackd.conf
+++ b/doc/helper/conntrackd.conf
@@ -103,27 +103,6 @@ Helper {
 #
 General {
 	#
-	# Set the nice value of the daemon, this value goes from -20
-	# (most favorable scheduling) to 19 (least favorable). Using a
-	# very low value reduces the chances to lose state-change events.
-	# Default is 0 but this example file sets it to most favourable
-	# scheduling as this is generally a good idea. See man nice(1) for
-	# more information.
-	#
-	Nice -20
-
-	#
-	# Select a different scheduler for the daemon, you can select between
-	# RR and FIFO and the process priority (minimum is 0, maximum is 99).
-	# See man sched_setscheduler(2) for more information. Using a RT
-	# scheduler reduces the chances to overrun the Netlink buffer.
-	#
-	# Scheduler {
-	#	Type FIFO
-	#	Priority 99
-	# }
-
-	#
 	# Logfile: on (/var/log/conntrackd.log), off, or a filename
 	# Default: off
 	#
diff --git a/doc/stats/conntrackd.conf b/doc/stats/conntrackd.conf
index 6a9aec8..e62ad4b 100644
--- a/doc/stats/conntrackd.conf
+++ b/doc/stats/conntrackd.conf
@@ -11,25 +11,6 @@ General {
 	#Systemd on
 
 	#
-	# Set the nice value of the daemon. This value goes from -20
-	# (most favorable scheduling) to 19 (least favorable). Using a
-	# negative value reduces the chances to lose state-change events.
-	# Default is 0. See man nice(1) for more information.
-	#
-	Nice -1
-
-	# 
-	# Select a different scheduler for the daemon, you can select between
-	# RR and FIFO and the process priority (minimum is 0, maximum is 99).
-	# See man sched_setscheduler(2) for more information. Using a RT
-	# scheduler reduces the chances to overrun the Netlink buffer.
-	#
-	# Scheduler {
-	# 	Type FIFO
-	# 	Priority 99
-	# }
-
-	#
 	# Number of buckets in the caches: hash table
 	#
 	HashSize 8192
diff --git a/doc/sync/alarm/conntrackd.conf b/doc/sync/alarm/conntrackd.conf
index 225d1c9..f609310 100644
--- a/doc/sync/alarm/conntrackd.conf
+++ b/doc/sync/alarm/conntrackd.conf
@@ -226,27 +226,6 @@ General {
 	#Systemd on
 
 	#
-	# Set the nice value of the daemon, this value goes from -20
-	# (most favorable scheduling) to 19 (least favorable). Using a
-	# very low value reduces the chances to lose state-change events.
-	# Default is 0 but this example file sets it to most favourable
-	# scheduling as this is generally a good idea. See man nice(1) for
-	# more information.
-	#
-	Nice -20
-
-	#
-	# Select a different scheduler for the daemon, you can select between
-	# RR and FIFO and the process priority (minimum is 0, maximum is 99).
-	# See man sched_setscheduler(2) for more information. Using a RT
-	# scheduler reduces the chances to overrun the Netlink buffer.
-	#
-	# Scheduler {
-	#	Type FIFO
-	#	Priority 99
-	# }
-
-	#
 	# Number of buckets in the cache hashtable. The bigger it is,
 	# the closer it gets to O(1) at the cost of consuming more memory.
 	# Read some documents about tuning hashtables for further reference.
diff --git a/doc/sync/ftfw/conntrackd.conf b/doc/sync/ftfw/conntrackd.conf
index 228674c..f500637 100644
--- a/doc/sync/ftfw/conntrackd.conf
+++ b/doc/sync/ftfw/conntrackd.conf
@@ -249,27 +249,6 @@ General {
 	#Systemd on
 
 	#
-	# Set the nice value of the daemon, this value goes from -20
-	# (most favorable scheduling) to 19 (least favorable). Using a
-	# very low value reduces the chances to lose state-change events.
-	# Default is 0 but this example file sets it to most favourable
-	# scheduling as this is generally a good idea. See man nice(1) for
-	# more information.
-	#
-	Nice -20
-
-	#
-	# Select a different scheduler for the daemon, you can select between
-	# RR and FIFO and the process priority (minimum is 0, maximum is 99).
-	# See man sched_setscheduler(2) for more information. Using a RT
-	# scheduler reduces the chances to overrun the Netlink buffer.
-	#
-	# Scheduler {
-	#	Type FIFO
-	#	Priority 99
-	# }
-
-	#
 	# Number of buckets in the cache hashtable. The bigger it is,
 	# the closer it gets to O(1) at the cost of consuming more memory.
 	# Read some documents about tuning hashtables for further reference.
diff --git a/doc/sync/notrack/conntrackd.conf b/doc/sync/notrack/conntrackd.conf
index 3becd91..718668d 100644
--- a/doc/sync/notrack/conntrackd.conf
+++ b/doc/sync/notrack/conntrackd.conf
@@ -288,27 +288,6 @@ General {
 	#Systemd on
 
 	#
-	# Set the nice value of the daemon, this value goes from -20
-	# (most favorable scheduling) to 19 (least favorable). Using a
-	# very low value reduces the chances to lose state-change events.
-	# Default is 0 but this example file sets it to most favourable
-	# scheduling as this is generally a good idea. See man nice(1) for
-	# more information.
-	#
-	Nice -20
-
-	#
-	# Select a different scheduler for the daemon, you can select between
-	# RR and FIFO and the process priority (minimum is 0, maximum is 99).
-	# See man sched_setscheduler(2) for more information. Using a RT
-	# scheduler reduces the chances to overrun the Netlink buffer.
-	#
-	# Scheduler {
-	#	Type FIFO
-	#	Priority 99
-	# }
-
-	#
 	# Number of buckets in the cache hashtable. The bigger it is,
 	# the closer it gets to O(1) at the cost of consuming more memory.
 	# Read some documents about tuning hashtables for further reference.
diff --git a/include/conntrackd.h b/include/conntrackd.h
index 1a7ea66..1e11615 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -94,7 +94,6 @@ struct ct_conf {
 	int channel_type_global;
 	struct channel_conf channel[MULTICHANNEL_MAX];
 	struct local_conf local;	/* unix socket facilities */
-	int nice;
 	int limit;
 	int refresh;
 	int cache_timeout;		/* cache entries timeout */
@@ -129,10 +128,6 @@ struct ct_conf {
 		int commit_steps;
 	} general;
 	struct {
-		int type;
-		int prio;
-	} sched;
-	struct {
 		char logfile[FILENAME_MAXLEN];
 		int syslog_facility;
 		size_t buffer_size;
diff --git a/src/main.c b/src/main.c
index 4b6d17d..bab7772 100644
--- a/src/main.c
+++ b/src/main.c
@@ -31,7 +31,6 @@
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <sched.h>
 #include <limits.h>
 
 struct ct_general_state st;
@@ -112,15 +111,6 @@ set_action_by_table(int i, int argc, char *argv[],
 }
 
 static void
-set_nice_value(int nv)
-{
-	errno = 0;
-	if (nice(nv) == -1 && errno) /* warn only */
-		dlog(LOG_WARNING, "Cannot set nice level %d: %s",
-		     nv, strerror(errno));
-}
-
-static void
 do_chdir(const char *d)
 {
 	if (chdir(d))
@@ -374,24 +364,6 @@ int main(int argc, char *argv[])
 	close(ret);
 
 	/*
-	 * Setting process priority and scheduler
-	 */
-	set_nice_value(CONFIG(nice));
-
-	if (CONFIG(sched).type != SCHED_OTHER) {
-		struct sched_param schedparam = {
-			.sched_priority = CONFIG(sched).prio,
-		};
-
-		ret = sched_setscheduler(0, CONFIG(sched).type, &schedparam);
-		if (ret == -1) {
-			dlog(LOG_ERR, "scheduler configuration failed: %s",
-			     strerror(errno));
-			exit(EXIT_FAILURE);
-		}
-	}
-
-	/*
 	 * initialization process
 	 */
 
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 3bb7c5f..ef6b284 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -30,7 +30,6 @@
 #include "cidr.h"
 #include "helper.h"
 #include "stack.h"
-#include <sched.h>
 #include <dlfcn.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
@@ -963,7 +962,8 @@ netlink_events_reliable : T_NETLINK_EVENTS_RELIABLE T_OFF
 
 nice : T_NICE T_SIGNED_NUMBER
 {
-	conf.nice = $2;
+	dlog(LOG_WARNING, "deprecated nice configuration. "
+	     "Now conntrackd uses RT by default.");
 };
 
 scheduler : T_SCHEDULER '{' scheduler_options '}';
@@ -974,23 +974,14 @@ scheduler_options :
 
 scheduler_line : T_TYPE T_STRING
 {
-	if (strcasecmp($2, "rr") == 0) {
-		conf.sched.type = SCHED_RR;
-	} else if (strcasecmp($2, "fifo") == 0) {
-		conf.sched.type = SCHED_FIFO;
-	} else {
-		dlog(LOG_ERR, "unknown scheduler `%s'", $2);
-		exit(EXIT_FAILURE);
-	}
+	dlog(LOG_WARNING, "deprecated scheduler configuration. "
+	     "Now conntrackd uses RT by default.");
 };
 
 scheduler_line : T_PRIO T_NUMBER
 {
-	conf.sched.prio = $2;
-	if (conf.sched.prio < 0 || conf.sched.prio > 99) {
-		dlog(LOG_ERR, "`Priority' must be [0, 99]\n", $2);
-		exit(EXIT_FAILURE);
-	}
+	dlog(LOG_WARNING, "deprecated scheduler configuration. "
+	     "Now conntrackd uses RT by default.");
 };
 
 event_iterations_limit : T_EVENT_ITER_LIMIT T_NUMBER
diff --git a/src/run.c b/src/run.c
index 1fe6cba..5ad982a 100644
--- a/src/run.c
+++ b/src/run.c
@@ -32,6 +32,7 @@
 #include "internal.h"
 #include "systemd.h"
 
+#include <sched.h>
 #include <errno.h>
 #include <signal.h>
 #include <stdlib.h>
@@ -234,11 +235,28 @@ int evaluate(void)
 	return 0;
 }
 
+
+static void set_scheduler(void)
+{
+	int prio = sched_get_priority_max(SCHED_RR);
+	struct sched_param schedparam = {
+		.sched_priority = prio,
+	};
+
+	if (sched_setscheduler(0, SCHED_RR, &schedparam) < 0)
+		dlog(LOG_WARNING, "scheduler configuration failed: %s. "
+		     "Likely a bug in conntrackd, please report it. "
+		     "Continuing with system default scheduler.",
+		     strerror(errno));
+}
+
 int
 init(void)
 {
 	do_gettimeofday();
 
+	set_scheduler();
+
 	STATE(fds) = create_fds();
 	if (STATE(fds) == NULL) {
 		dlog(LOG_ERR, "can't create file descriptor pool");

