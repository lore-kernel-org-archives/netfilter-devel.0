From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 4/4] conntrackd: introduce RequestResync
 option
Date: Thu, 20 Apr 2017 18:40:50 +0200
Message-ID: <149270645062.7706.5972097191176024465.stgit@nfdev2.cica.es>
References: <149270643473.7706.16087221625455760877.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54542 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1033311AbdDTRsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 13:48:05 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 3D01751F357
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 16:40:57 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GS2uxvxjCa24 for <netfilter-devel@vger.kernel.org>;
        Thu, 20 Apr 2017 18:40:51 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 526B851F355
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 18:40:51 +0200 (CEST)
In-Reply-To: <149270643473.7706.16087221625455760877.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In some environments where both nodes of a cluster share all the conntracks,
after an initial or manual resync, the conntrack information diverges from
node to node.

I have observed that this is not due to syncronization problems, given the
link between the nodes is very stable and stats show no issues.
So, this could be due to every node of the cluster seing slighly different
traffic and flow updates, perhaps different tiemouts being applied to
the conntracks in every node.
A manual resync (using conntrackd -n) resolves these issues inmediately.

This new configuration option tells conntrackd to request a resync
with the other node, similar to what could happen manually using
the 'conntrackd -n' command.

By now this option is only valid in NOTRACK sync mode.

Example configuration:

[...]
Sync {
        Mode NOTRACK {
                DisableInternalCache on
                DisableExternalCache on
                RequestResync 30
        }
        TCP {
                IPv4_address 127.0.0.1
                IPv4_Destination_Address 127.0.0.1
                Port 3780
                Interface eth0
                SndSocketBuffer 1249280
                RcvSocketBuffer 1249280
                Checksum on
        }
        Options {
                TCPWindowTracking Off
                ExpectationSync On
        }
}
[...]

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 conntrackd.conf.5     |    9 +++++++++
 include/conntrackd.h  |    1 +
 include/resync.h      |    1 +
 src/read_config_lex.l |    1 +
 src/read_config_yy.y  |    8 +++++++-
 src/resync.c          |   21 +++++++++++++++++++++
 src/run.c             |    3 +++
 7 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 4a4f2e2..6ac0fb6 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -195,6 +195,15 @@ messages are directly sent through the dedicated link.
 This option is set off by default.
 
 .TP
+.BI "RequestResync <seconds>"
+Request the other node a complete resync. This should help resolve
+synchronization more easily if they happen in your environment.
+
+Example: RequestResync 60
+
+This option is set off by default.
+
+.TP
 .BI "DisableExternalCache <on|off>"
 Same as in \fBFTFW\fP mode.
 
diff --git a/include/conntrackd.h b/include/conntrackd.h
index 27e43db..4cfb373 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -111,6 +111,7 @@ struct ct_conf {
 	int event_iterations_limit;
 	int systemd;
 	int running_mode;
+	int request_resync;
 	struct {
 		int error_queue_length;
 	} channelc;
diff --git a/include/resync.h b/include/resync.h
index 5986600..75cd7dd 100644
--- a/include/resync.h
+++ b/include/resync.h
@@ -3,5 +3,6 @@
 
 void resync_req(void);
 void resync_send(int (*do_cache_to_tx)(void *data1, void *data2));
+void resync_run_init(void);
 
 #endif /*_RESYNC_H_ */
diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index a378269..664b818 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -136,6 +136,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "ExpectMax"			{ return T_HELPER_EXPECT_MAX; }
 "ExpectTimeout"			{ return T_HELPER_EXPECT_TIMEOUT; }
 "Systemd"			{ return T_SYSTEMD; }
+"RequestResync"			{ return T_REQUEST_RESYNC; }
 
 {is_on}			{ return T_ON; }
 {is_off}		{ return T_OFF; }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 2c08d4e..0509bd3 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -81,7 +81,7 @@ enum {
 %token T_OPTIONS T_TCP_WINDOW_TRACKING T_EXPECT_SYNC
 %token T_HELPER T_HELPER_QUEUE_NUM T_HELPER_QUEUE_LEN T_HELPER_POLICY
 %token T_HELPER_EXPECT_TIMEOUT T_HELPER_EXPECT_MAX
-%token T_SYSTEMD
+%token T_SYSTEMD T_REQUEST_RESYNC
 
 %token <string> T_IP T_PATH_VAL
 %token <val> T_NUMBER
@@ -777,6 +777,7 @@ sync_mode_notrack_line: timeout
 		      | purge
 		      | disable_internal_cache
 		      | disable_external_cache
+		      | request_resync
 		      ;
 
 disable_internal_cache: T_DISABLE_INTERNAL_CACHE T_ON
@@ -804,6 +805,11 @@ resend_queue_size: T_RESEND_QUEUE_SIZE T_NUMBER
 	conf.resend_queue_size = $2;
 };
 
+request_resync: T_REQUEST_RESYNC T_NUMBER
+{
+	conf.request_resync = $2;
+};
+
 window_size: T_WINDOWSIZE T_NUMBER
 {
 	conf.window_size = $2;
diff --git a/src/resync.c b/src/resync.c
index dbb2b6f..4310d6b 100644
--- a/src/resync.c
+++ b/src/resync.c
@@ -23,6 +23,9 @@
 #include "queue_tx.h"
 #include "resync.h"
 #include "cache.h"
+#include "alarm.h"
+
+static struct alarm_block	resync_run_alarm;
 
 void resync_req(void)
 {
@@ -38,3 +41,21 @@ void resync_send(int (*do_cache_to_tx)(void *data1, void *data2))
 	cache_iterate(STATE(mode)->internal->exp.data,
 		      NULL, do_cache_to_tx);
 }
+
+static void resync_run(struct alarm_block *a, void *data)
+{
+	resync_req();
+	add_alarm(&resync_run_alarm, CONFIG(request_resync), 0);
+}
+
+void resync_run_init(void)
+{
+	if (CONFIG(request_resync) == 0)
+		return;
+
+	dlog(LOG_NOTICE, "setting up atomatic resync requests every %d "
+	     "seconds", CONFIG(request_resync));
+
+	init_alarm(&resync_run_alarm, NULL,  resync_run);
+	add_alarm(&resync_run_alarm, CONFIG(request_resync), 0);
+}
diff --git a/src/run.c b/src/run.c
index 1fe6cba..4ff2186 100644
--- a/src/run.c
+++ b/src/run.c
@@ -31,6 +31,7 @@
 #include "date.h"
 #include "internal.h"
 #include "systemd.h"
+#include "resync.h"
 
 #include <errno.h>
 #include <signal.h>
@@ -284,6 +285,8 @@ init(void)
 #endif
 	time(&STATE(stats).daemon_start_time);
 
+	resync_run_init();
+
 	dlog(LOG_NOTICE, "initialization completed");
 
 	return 0;

