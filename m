From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 2/2] conntrackd: request resync at startup
Date: Tue, 09 May 2017 09:41:15 +0200
Message-ID: <149431567553.23472.560268360348133271.stgit@nfdev2.cica.es>
References: <149431567027.23472.7461747418695885217.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39550 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751614AbdEIHlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 03:41:25 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 99D6651F503
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2017 07:41:22 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cgXzPfqCVvSA for <netfilter-devel@vger.kernel.org>;
        Tue,  9 May 2017 09:41:16 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 3D0CE51F555
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2017 09:41:16 +0200 (CEST)
In-Reply-To: <149431567027.23472.7461747418695885217.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a node goes to live, ask the other for resync at startup.
This has to be done usually by hand, but I guess is an operation common
enough to add some bits to ease people life here.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 conntrackd.conf.5     |   25 +++++++++++++++++++++----
 include/conntrackd.h  |    1 +
 include/resync.h      |    1 +
 src/main.c            |    2 ++
 src/read_config_lex.l |    1 +
 src/read_config_yy.y  |   14 +++++++++++++-
 src/resync.c          |    8 ++++++++
 7 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 4a4f2e2..94de327 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -22,7 +22,7 @@
 .\" <http://www.gnu.org/licenses/>.
 .\" %%%LICENSE_END
 .\"
-.TH CONNTRACKD.CONF 5 "Oct 18, 2016"
+.TH CONNTRACKD.CONF 5 "May 09, 2017"
 
 .SH NAME
 conntrackd.conf \- configuration file for conntrackd daemon
@@ -78,8 +78,8 @@ This mode is based on a reliable protocol that performs message tracking.
 Thus, the protocol can recover from message loss, re-ordering and corruption.
 
 In this synchronization mode you may configure \fBResendQueueSize\fP,
-\fBCommitTimeout\fP, \fBPurgeTimeout\fP, \fBACKWindowSize\fP and
-\fBDisableExternalCache\fP.
+\fBCommitTimeout\fP, \fBPurgeTimeout\fP, \fBACKWindowSize\fP ,
+\fBDisableExternalCache\fP and \fBStartupResync\fP.
 
 .TP
 .BI "ResendQueueSize <value>"
@@ -146,6 +146,18 @@ enabling this option!
 
 By default, this clause is set off.
 
+.TP
+.BI "StartupResync <on|off>"
+Order conntrackd to request a complete conntrack table resync against the other
+node at startup. A single request will be made.
+
+This is useful to get in sync with another node which has been running while we
+were down.
+
+Example: StartupResync on
+
+By default, this clause is set off.
+
 .SS Mode ALARM
 
 This mode is spamming. It is based on a alarm-based protocol that periodically
@@ -185,7 +197,8 @@ ie. unreliable protocol. This protocol sends and receives the state information
 without performing any specific checking.
 
 In this synchronization mode you may configure \fBDisableInternalCache\fP,
-\fBDisableExternalCache\fP, \fBCommitTimeout\fP and \fBPurgeTimeout\fP.
+\fBDisableExternalCache\fP, \fBCommitTimeout\fP, \fBPurgeTimeout\fP and
+\fBStartupResync\fP.
 
 .TP
 .BI "DisableInternalCache <on|off>"
@@ -206,6 +219,10 @@ Same as in \fBFTFW\fP mode.
 .BI "PurgeTimeout <seconds>"
 Same as in \fBFTFW\fP mode.
 
+.TP
+.BI "StartupResync <on|off>"
+Same as in \fBFTFW\fP mode.
+
 .SS MULTICAST
 
 This section indicates to \fBconntrackd(8)\fP to use multicast as transport
diff --git a/include/conntrackd.h b/include/conntrackd.h
index 27e43db..1a7ea66 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -111,6 +111,7 @@ struct ct_conf {
 	int event_iterations_limit;
 	int systemd;
 	int running_mode;
+	int startup_resync;
 	struct {
 		int error_queue_length;
 	} channelc;
diff --git a/include/resync.h b/include/resync.h
index 5986600..827e38a 100644
--- a/include/resync.h
+++ b/include/resync.h
@@ -3,5 +3,6 @@
 
 void resync_req(void);
 void resync_send(int (*do_cache_to_tx)(void *data1, void *data2));
+void resync_at_startup(void);
 
 #endif /*_RESYNC_H_ */
diff --git a/src/main.c b/src/main.c
index 1a57cf8..fb20f1d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -21,6 +21,7 @@
 #include "log.h"
 #include "helper.h"
 #include "systemd.h"
+#include "resync.h"
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -431,6 +432,7 @@ int main(int argc, char *argv[])
 		dlog(LOG_NOTICE, "-- starting in console mode --");
 
 	sd_ct_init();
+	resync_at_startup();
 
 	/*
 	 * run main process
diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index a378269..120bc00 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -136,6 +136,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "ExpectMax"			{ return T_HELPER_EXPECT_MAX; }
 "ExpectTimeout"			{ return T_HELPER_EXPECT_TIMEOUT; }
 "Systemd"			{ return T_SYSTEMD; }
+"StartupResync"			{ return T_STARTUP_RESYNC; }
 
 {is_on}			{ return T_ON; }
 {is_off}		{ return T_OFF; }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 2c08d4e..3bb7c5f 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -81,7 +81,7 @@ enum {
 %token T_OPTIONS T_TCP_WINDOW_TRACKING T_EXPECT_SYNC
 %token T_HELPER T_HELPER_QUEUE_NUM T_HELPER_QUEUE_LEN T_HELPER_POLICY
 %token T_HELPER_EXPECT_TIMEOUT T_HELPER_EXPECT_MAX
-%token T_SYSTEMD
+%token T_SYSTEMD T_STARTUP_RESYNC
 
 %token <string> T_IP T_PATH_VAL
 %token <val> T_NUMBER
@@ -768,6 +768,7 @@ sync_mode_ftfw_line: resend_queue_size
 		   | purge
 		   | window_size
 		   | disable_external_cache
+		   | startup_resync
 		   ;
 
 sync_mode_notrack_list:
@@ -777,6 +778,7 @@ sync_mode_notrack_line: timeout
 		      | purge
 		      | disable_internal_cache
 		      | disable_external_cache
+		      | startup_resync
 		      ;
 
 disable_internal_cache: T_DISABLE_INTERNAL_CACHE T_ON
@@ -804,6 +806,16 @@ resend_queue_size: T_RESEND_QUEUE_SIZE T_NUMBER
 	conf.resend_queue_size = $2;
 };
 
+startup_resync: T_STARTUP_RESYNC T_ON
+{
+	conf.startup_resync = 1;
+};
+
+startup_resync: T_STARTUP_RESYNC T_OFF
+{
+	conf.startup_resync = 0;
+};
+
 window_size: T_WINDOWSIZE T_NUMBER
 {
 	conf.window_size = $2;
diff --git a/src/resync.c b/src/resync.c
index dbb2b6f..5394245 100644
--- a/src/resync.c
+++ b/src/resync.c
@@ -38,3 +38,11 @@ void resync_send(int (*do_cache_to_tx)(void *data1, void *data2))
 	cache_iterate(STATE(mode)->internal->exp.data,
 		      NULL, do_cache_to_tx);
 }
+
+void resync_at_startup(void)
+{
+	if (CONFIG(startup_resync) == 0)
+		return;
+
+	resync_req();
+}

