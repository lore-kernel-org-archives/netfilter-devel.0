From: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Subject: [PATCH 1/2] harmonize log file defaults with ulogd.conf
Date: Fri, 10 Mar 2017 22:04:25 +0200
Message-ID: <20170310200426.15543-1-kaarle.ritvanen@datakunkku.fi>
Cc: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from welho-filter1.welho.com ([83.102.41.23]:48590 "EHLO
        welho-filter1.welho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755480AbdCJUEk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 15:04:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 doc/ulogd.sgml               | 4 ++--
 output/ulogd_output_GPRINT.c | 2 +-
 output/ulogd_output_LOGEMU.c | 2 +-
 output/ulogd_output_NACCT.c  | 2 +-
 output/ulogd_output_OPRINT.c | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
index 65a63cf..de799f4 100644
--- a/doc/ulogd.sgml
+++ b/doc/ulogd.sgml
@@ -422,7 +422,7 @@ to a file.  The only useful application is debugging.
 <descrip>
 <tag>dumpfile</tag>
 The filename where it should log to. The default is
-<tt>/var/log/ulogd.pktlog</tt>
+<tt>/var/log/ulogd_oprint.log</tt>
 </descrip>
 
 <sect2>ulogd_output_LOGEMU.so
@@ -433,7 +433,7 @@ as possible. Logging is done to a seperate textfile instead of syslog, though.
 The module defines the following configuration directives:
 <descrip>
 <tag>file</tag>The filename where it should log to. The default is
-<tt>/var/log/ulogd.syslogemu</tt>
+<tt>/var/log/ulogd_syslogemu.log</tt>
 <tag>sync</tag>Set this to 1 if you want to have your logfile written
 synchronously. This may reduce performance, but makes your log-lines appear
 immediately.  The default is <tt>0</tt>
diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index 4f49c34..bc7aa34 100644
--- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -31,7 +31,7 @@
 #include <ulogd/conffile.h>
 
 #ifndef ULOGD_GPRINT_DEFAULT
-#define ULOGD_GPRINT_DEFAULT	"/var/log/ulogd.gprint"
+#define ULOGD_GPRINT_DEFAULT	"/var/log/ulogd_gprint.log"
 #endif
 
 struct gprint_priv {
diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index bb27209..cfcfab7 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -37,7 +37,7 @@
 #endif
 
 #ifndef ULOGD_LOGEMU_DEFAULT
-#define ULOGD_LOGEMU_DEFAULT	"/var/log/ulogd.syslogemu"
+#define ULOGD_LOGEMU_DEFAULT	"/var/log/ulogd_syslogemu.log"
 #endif
 
 #ifndef ULOGD_LOGEMU_SYNC_DEFAULT
diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index 9de8a73..d369c7a 100644
--- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -29,7 +29,7 @@
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
 
-#define NACCT_FILE_DEFAULT	"/var/log/nacctdata.log"
+#define NACCT_FILE_DEFAULT	"/var/log/ulogd_nacct.log"
 
 /* config accessors (lazy me...) */
 #define NACCT_CFG_FILE(pi)	((pi)->config_kset->ces[0].u.string)
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index e390c84..6fde445 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -28,7 +28,7 @@
 #include <ulogd/conffile.h>
 
 #ifndef ULOGD_OPRINT_DEFAULT
-#define ULOGD_OPRINT_DEFAULT	"/var/log/ulogd.pktlog"
+#define ULOGD_OPRINT_DEFAULT	"/var/log/ulogd_oprint.log"
 #endif
 
 #define NIPQUAD(addr) \
-- 
2.9.3

