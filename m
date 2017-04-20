From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH] conntrackd: request resync at startup
Date: Thu, 20 Apr 2017 19:21:06 +0200
Message-ID: <149270883020.981.11533592085958035807.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53628 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1765567AbdDTRVP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 13:21:15 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 1482651F35C
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 17:21:13 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bzPI5lSyjMPL for <netfilter-devel@vger.kernel.org>;
        Thu, 20 Apr 2017 19:21:06 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id D1E5C51F358
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 19:21:06 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a node goes to live, ask the other for resync at startup.
This has to be done usually by hand, but I guess is an operation common
enough to add some bits to ease people life here.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---

NOTE: this patch belongs to the previous series, but I forgot to include it

 conntrackd.conf.5     |   18 +++++++++++++++++-
 include/conntrackd.h  |    1 +
 include/resync.h      |    1 +
 src/main.c            |    2 ++
 src/read_config_lex.l |    1 +
 src/read_config_yy.y  |   14 +++++++++++++-
 src/resync.c          |    8 ++++++++
 7 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 6ac0fb6..b757661 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -22,7 +22,7 @@
 .\" <http://www.gnu.org/licenses/>.
 .\" %%%LICENSE_END
 .\"
-.TH CONNTRACKD.CONF 5 "Oct 18, 2016"
+.TH CONNTRACKD.CONF 5 "Apr 20, 2017"
 
 .SH NAME
 conntrackd.conf \- configuration file for conntrackd daemon
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
@@ -215,6 +227,10 @@ Same as in \fBFTFW\fP mode.
 .BI "PurgeTimeout <seconds>"
 Same as in \fBFTFW\fP mode.
 
+.TP
+.BI "StartupResync <on|off>"
+Same as in \fBFTFW\fP mode.
+
 .SS MULTICAST
 
 This section indicates to \fBconntrackd(8)\fP to use multicast as transport
diff --git a/include/conntrackd.h b/include/conntrackd.h
index 4cfb373..6d2d293 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -112,6 +112,7 @@ struct ct_conf {
 	int systemd;
 	int running_mode;
 	int request_resync;
+	int startup_resync;
 	struct {
 		int error_queue_length;
 	} channelc;
diff --git a/include/resync.h b/include/resync.h
index 75cd7dd..8423858 100644
--- a/include/resync.h
+++ b/include/resync.h
@@ -4,5 +4,6 @@
 void resync_req(void);
 void resync_send(int (*do_cache_to_tx)(void *data1, void *data2));
 void resync_run_init(void);
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
index 664b818..46db263 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -137,6 +137,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "ExpectTimeout"			{ return T_HELPER_EXPECT_TIMEOUT; }
 "Systemd"			{ return T_SYSTEMD; }
 "RequestResync"			{ return T_REQUEST_RESYNC; }
+"StartupResync"			{ return T_STARTUP_RESYNC; }
 
 {is_on}			{ return T_ON; }
 {is_off}		{ return T_OFF; }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 0509bd3..2b5e72a 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -81,7 +81,7 @@ enum {
 %token T_OPTIONS T_TCP_WINDOW_TRACKING T_EXPECT_SYNC
 %token T_HELPER T_HELPER_QUEUE_NUM T_HELPER_QUEUE_LEN T_HELPER_POLICY
 %token T_HELPER_EXPECT_TIMEOUT T_HELPER_EXPECT_MAX
-%token T_SYSTEMD T_REQUEST_RESYNC
+%token T_SYSTEMD T_REQUEST_RESYNC T_STARTUP_RESYNC
 
 %token <string> T_IP T_PATH_VAL
 %token <val> T_NUMBER
@@ -768,6 +768,7 @@ sync_mode_ftfw_line: resend_queue_size
 		   | purge
 		   | window_size
 		   | disable_external_cache
+		   | startup_resync
 		   ;
 
 sync_mode_notrack_list:
@@ -778,6 +779,7 @@ sync_mode_notrack_line: timeout
 		      | disable_internal_cache
 		      | disable_external_cache
 		      | request_resync
+		      | startup_resync
 		      ;
 
 disable_internal_cache: T_DISABLE_INTERNAL_CACHE T_ON
@@ -810,6 +812,16 @@ request_resync: T_REQUEST_RESYNC T_NUMBER
 	conf.request_resync = $2;
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
index 4310d6b..28e978b 100644
--- a/src/resync.c
+++ b/src/resync.c
@@ -59,3 +59,11 @@ void resync_run_init(void)
 	init_alarm(&resync_run_alarm, NULL,  resync_run);
 	add_alarm(&resync_run_alarm, CONFIG(request_resync), 0);
 }
+
+void resync_at_startup(void)
+{
+	if (CONFIG(startup_resync) == 0)
+		return;
+
+	resync_req();
+}

