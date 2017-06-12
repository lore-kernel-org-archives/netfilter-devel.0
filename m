From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH v2] conntrackd: make the daemon run in RT
 mode by default
Date: Mon, 12 Jun 2017 10:34:35 +0200
Message-ID: <149725643738.6842.5325404856389402790.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59309 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751942AbdFLIep (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2017 04:34:45 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id EDBDD51F33F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2017 08:34:42 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mLnbSQul2crM for <netfilter-devel@vger.kernel.org>;
        Mon, 12 Jun 2017 10:34:36 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 45BD151F33C
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2017 10:34:36 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In order to prevent netlink buffer overrun, conntrackd is recommended to run
at max priority.
Make conntrackd to use a RT (SHED_RR) scheduler by default at max priority.
This is common among other HA daemons. For example corosync uses SCHED_RR
by default.
The scheduler configuration option is kept in order to allow admins to perform
fine-tuning, but it is deleted from example configuration files.

Note that this default sched priority is so high that it makes the nice value
useless, so deprecate the nice configuration. Anyway the nice value can be set
externally at runtime using nice/renice.

The code is moved to the init() routine. In case of error setting the
scheduler, the system default will be used. Report a message to the user
and continue working.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
v2: refresh manpages, keep scheduler configuration options while deprecating
    nice

 conntrackd.conf.5                |   35 ++++++++++++-----------------------
 doc/helper/conntrackd.conf       |   21 ---------------------
 doc/stats/conntrackd.conf        |   19 -------------------
 doc/sync/alarm/conntrackd.conf   |   21 ---------------------
 doc/sync/ftfw/conntrackd.conf    |   21 ---------------------
 doc/sync/notrack/conntrackd.conf |   21 ---------------------
 include/conntrackd.h             |    1 -
 src/main.c                       |   28 ----------------------------
 src/read_config_yy.y             |    3 ++-
 src/run.c                        |   25 +++++++++++++++++++++++++
 10 files changed, 39 insertions(+), 156 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index a395e14..2ce6aa3 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -22,7 +22,7 @@
 .\" <http://www.gnu.org/licenses/>.
 .\" %%%LICENSE_END
 .\"
-.TH CONNTRACKD.CONF 5 "May 09, 2017"
+.TH CONNTRACKD.CONF 5 "June 09, 2017"
 
 .SH NAME
 conntrackd.conf \- configuration file for conntrackd daemon
@@ -480,14 +480,10 @@ By default runtime support is disabled.
 
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
+Deprecated. Conntrackd ignores this option and it will be removed in the
+future. Please note that you can run \fBnice(1)\fP and \fBrenice(1)\fP
+externally. Also note that \fBconntrackd(8)\fP now uses by default a RT
+scheduler.
 
 .TP
 .BI "HashSize <value>"
@@ -731,8 +727,9 @@ Example:
 Select a different scheduler for the daemon, you can select between \fBRR\fP
 and \fBFIFO\fP and the process priority.
 
-See \fBsched_setscheduler(2)\fP for more information. Using a RT scheduler
-reduces the chances to overrun the Netlink buffer.
+Using a RT scheduler reduces the chances to overrun the Netlink buffer and
+\fBconntrackd(8)\fP uses by default \fBRR\fP unless \fBFIFO\fP is selected.
+See \fBsched_setscheduler(2)\fP for more information.
 
 Example:
 .nf
@@ -746,12 +743,15 @@ Example:
 .BI "Type <type>"
 Supported values are \fBRR\fP or \fBFIFO\fP.
 
+Default: RR
+
 .TP
 .BI "Priority <value>"
 Value of the scheduler priority.
-
 Minimum is 0, maximum is 99.
 
+Default: 99 (as returned by \fBsched_get_priority_max(2)\fP for \fBSCHED_RR\fP)
+
 .SH STATS
 This top-level section indicates \fBconntrackd(8)\fP to work as a statistic
 collector for the nf_conntrack linux kernel subsystem.
@@ -904,7 +904,6 @@ Stats {
 }
 General {
 	Systemd on
-	Nice -1
 	HashSize 8192
 	HashLimit 65535
 	Syslog on
@@ -969,11 +968,6 @@ Sync {
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
@@ -1031,11 +1025,6 @@ Sync {
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
index 1746bfd..4148544 100644
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
index 99453ee..ba957a1 100644
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
index e25c30e..831be15 100644
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
index bcbf631..9da0fb6 100644
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
index c1ad0b4..600fc89 100644
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
index 1a7ea66..ece7025 100644
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
diff --git a/src/main.c b/src/main.c
index 0418e30..3b19160 100644
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
index 30a8bd4..32cca3c 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -967,7 +967,8 @@ netlink_events_reliable : T_NETLINK_EVENTS_RELIABLE T_OFF
 
 nice : T_NICE T_SIGNED_NUMBER
 {
-	conf.nice = $2;
+	dlog(LOG_WARNING, "deprecated nice configuration, ignoring. The "
+	     "nice value can be set externally with nice(1) and renice(1).");
 };
 
 scheduler : T_SCHEDULER '{' scheduler_options '}';
diff --git a/src/run.c b/src/run.c
index 1fe6cba..f11a532 100644
--- a/src/run.c
+++ b/src/run.c
@@ -32,6 +32,7 @@
 #include "internal.h"
 #include "systemd.h"
 
+#include <sched.h>
 #include <errno.h>
 #include <signal.h>
 #include <stdlib.h>
@@ -234,11 +235,35 @@ int evaluate(void)
 	return 0;
 }
 
+
+static void set_scheduler(void)
+{
+	struct sched_param schedparam;
+	int sched_type;
+
+	if (CONFIG(sched).type == SCHED_OTHER) {
+		/* default */
+		schedparam.sched_priority = sched_get_priority_max(SCHED_RR);
+		sched_type = SCHED_RR;
+	} else {
+		schedparam.sched_priority = CONFIG(sched).prio;
+		sched_type = CONFIG(sched).type;
+	}
+
+	if (sched_setscheduler(0, sched_type, &schedparam) < 0)
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

