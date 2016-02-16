From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd] conntrackd: Disable systemd support by default
Date: Tue, 16 Feb 2016 20:09:45 +0100
Message-ID: <1455649785-10958-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46940 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbcBPTJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 14:09:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 836F66DFDD
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 20:09:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 72B0D1B3066
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 20:09:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 543371B3D57
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 20:09:49 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By default, conntrackd is compiled with no built-in systemd support.
This patch updates the default runtime behaviour to be consistent
with what ./configure provides by default.

Thus, users should explicitly indicate "Systemd On" in their configuration
file to enable this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 conntrackd.conf.5                | 4 ++--
 doc/stats/conntrackd.conf        | 4 ++--
 doc/sync/alarm/conntrackd.conf   | 4 ++--
 doc/sync/ftfw/conntrackd.conf    | 4 ++--
 doc/sync/notrack/conntrackd.conf | 4 ++--
 src/read_config_yy.y             | 4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index 4781825..ed387b9 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -457,9 +457,9 @@ Obviusly, this requires the init systemd of your system to be \fBsystemd(1)\fP.
 
 Note: \fBsystemd(1)\fP watchdog is supported as well.
 
-Example: Systemd off
+Example: Systemd on
 
-By default runtime support is activated.
+By default runtime support is disabled.
 
 .TP
 .BI "Nice <value>"
diff --git a/doc/stats/conntrackd.conf b/doc/stats/conntrackd.conf
index b1cca07..6a9aec8 100644
--- a/doc/stats/conntrackd.conf
+++ b/doc/stats/conntrackd.conf
@@ -6,9 +6,9 @@ General {
 	# Enable systemd support. If conntrackd is compiled with the proper
 	# configuration, you can use a systemd service unit of Type=notify
 	# and use conntrackd with systemd watchdog as well.
-	# Default is: on
+	# Default is: off
 	#
-	#Systemd off
+	#Systemd on
 
 	#
 	# Set the nice value of the daemon. This value goes from -20
diff --git a/doc/sync/alarm/conntrackd.conf b/doc/sync/alarm/conntrackd.conf
index 39deb47..225d1c9 100644
--- a/doc/sync/alarm/conntrackd.conf
+++ b/doc/sync/alarm/conntrackd.conf
@@ -221,9 +221,9 @@ General {
 	# Enable systemd support. If conntrackd is compiled with the proper
 	# configuration, you can use a systemd service unit of Type=notify
 	# and use conntrackd with systemd watchdog as well.
-	# Default is: on
+	# Default is: off
 	#
-	#Systemd off
+	#Systemd on
 
 	#
 	# Set the nice value of the daemon, this value goes from -20
diff --git a/doc/sync/ftfw/conntrackd.conf b/doc/sync/ftfw/conntrackd.conf
index 60d7d97..228674c 100644
--- a/doc/sync/ftfw/conntrackd.conf
+++ b/doc/sync/ftfw/conntrackd.conf
@@ -244,9 +244,9 @@ General {
 	# Enable systemd support. If conntrackd is compiled with the proper
 	# configuration, you can use a systemd service unit of Type=notify
 	# and use conntrackd with systemd watchdog as well.
-	# Default is: on
+	# Default is: off
 	#
-	#Systemd off
+	#Systemd on
 
 	#
 	# Set the nice value of the daemon, this value goes from -20
diff --git a/doc/sync/notrack/conntrackd.conf b/doc/sync/notrack/conntrackd.conf
index b9d42ba..3becd91 100644
--- a/doc/sync/notrack/conntrackd.conf
+++ b/doc/sync/notrack/conntrackd.conf
@@ -283,9 +283,9 @@ General {
 	# Enable systemd support. If conntrackd is compiled with the proper
 	# configuration, you can use a systemd service unit of Type=notify
 	# and use conntrackd with systemd watchdog as well.
-	# Default is: on
+	# Default is: off
 	#
-	#Systemd off
+	#Systemd on
 
 	#
 	# Set the nice value of the daemon, this value goes from -20
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 58ad2d0..6052390 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -1864,8 +1864,8 @@ init_config(char *filename)
 	CONFIG(stats).syslog_facility = -1;
 	CONFIG(netlink).subsys_id = -1;
 
-	/* enable systemd by default */
-	CONFIG(systemd) = 1;
+	/* disable systemd by default */
+	CONFIG(systemd) = 0;
 
 	/* Initialize list of user-space helpers */
 	INIT_LIST_HEAD(&CONFIG(cthelper).list);
-- 
2.1.4

